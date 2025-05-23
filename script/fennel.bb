#!/usr/bin/env bb
;; vi: ft=clojure

(ns script.fennel
  (:require [clojure.string :as str]
            [clojure.set :as set]
            [babashka.cli :as cli]
            [babashka.fs :as fs]
            [babashka.process :as proc]))

(def cli-opts
  {:help {:alias :h
          :desc "Prints this help"}
   :compile {:alias :c
             :desc "Compile all changed Fennel files into their Lua counterparts (\"changed\" means newer modified time than their Lua counterpart)"}
   :dry {:alias :d
         :desc "When true, it won't actually modify any files"}
   :notify {:alias :n
            :desc "Use notify-send to display errors alongside printing to stderr"}
   :files {:alias :f
           :desc "Prints the Fennel files it would operate on and exits, useful for piping into entr for \"compile on change\" support"}
   :root {:alias :r
          :desc "Root directory to perform all operations under"
          :default "."}
   :prune {:alias :p
           :desc "Delete Lua files that lack a Fennel counterpart, prevents orphan Lua files from hanging around after a Fennel file deletion or rename, takes a list of globs that should not be included in the pruning (like `vendor/**.lua,my-cool.lua`)"}})

(defn compile-fennel-file
  "Compiles the given Fennel file into a Lua file. Can return an anomaly."
  [{:keys [src-path]}]
  (try
    (if src-path
      (let [{:keys [exit out err]}
            (proc/shell
             {:out :string
              :err :string
              :continue true}
             "lua" "script/fennel.lua" "--compile" src-path)]
        (if (zero? exit)
          out
          {:cognitect.anomalies/category :cognitect.anomalies/fault
           :cognitect.anomalies/message "Fennel process exited with a non-zero status code"
           ::exit exit
           ::err err}))
      {:cognitect.anomalies/category :cognitect.anomalies/incorrect
       :cognitect.anomalies/message "src-path must be a string"})
    (catch Exception e
      {:cognitect.anomalies/category :cognitect.anomalies/fault
       :cognitect.anomalies/message "Uncaught exception"
       ::exeption-map (Throwable->map e)})))

(comment
  (compile-fennel-file {:src-path "init.fnl"}))

(defn display-help! []
  (let [file-name (fs/relativize (fs/cwd) *file*)]
    (println (str "Usage: " file-name " [FLAG]"))
    (println)
    (println "Compile changed Fennel files into Lua, intended for use with Neovim configuration.")
    (println)
    (println "To run whenever you change a file you can combine this tool with entr https://eradman.com/entrproject/")
    (println)
    (println (str "Example: " file-name " --files | entr " file-name " --compile"))
    (println)
    (println (cli/format-opts {:spec cli-opts}))))

(comment
  (display-help!))

(defn notify! [summary msg]
  (proc/shell "notify-send" summary msg))

(defn last-modified-time-ms-safe
  "Will ALWAYS return a number. If there's an error it'll return a negative number."
  [path]
  (try
    (.toMillis (fs/last-modified-time path))
    (catch Exception _e
      -1)))

(defn fnl->lua-path [fnl-path]
  (str/replace (str (fs/strip-ext fnl-path) ".lua") #"^fnl/" "lua/"))

(defn compile-changed-fennel-files!
  "Find changed Fennel files that are newer than their Lua counterpart and compile them."
  [{:keys [root prune dry notify] :or {root "."}}]
  (let [glob #(map str (fs/glob root %))
        fnl-paths (glob "**.fnl")
        lua-paths (glob "**.lua")]

    (when prune
      (run!
       (fn [lua-path]
         (println "[delete]" lua-path)
         (when (not dry)
           (fs/delete lua-path)))
       (set/difference
        (set lua-paths)
        (set (map fnl->lua-path fnl-paths))
        (set (mapcat glob prune)))))

    (run!
     (fn [fnl-path]
       (let [lua-path (fnl->lua-path fnl-path)]
         (when (> (last-modified-time-ms-safe fnl-path)
                  (last-modified-time-ms-safe lua-path))
           (println "[compile]" fnl-path)
           (let [lua (compile-fennel-file {:src-path fnl-path})]
             (if-let [category (:cognitect.anomalies/category lua)]
               (binding [*out* *err*]
                 (if (= :cognitect.anomalies/fault category)
                   (do
                     (println (::err lua))
                     (when notify
                       (notify! (str fnl-path " compilation failed") (::err lua))))
                   (println "[error]" lua)))
               (when (not dry)
                 (spit lua-path (str "-- [nfnl] " fnl-path "\n" lua))))))))
     fnl-paths)))

(defn print-fennel-file-paths! [{:keys [root] :or {root "."}}]
  (run!
   println
   (map str (fs/glob root "**.fnl"))))

(defn main
  "Parse the input args and work out what to do."
  [args]
  (let [opts (update (cli/parse-opts args cli-opts) :prune
                     (fn [prune]
                       (cond
                         (string? prune) (str/split prune #",")
                         (true? prune) []
                         (false? prune) nil
                         :else prune)))]
    (cond
      (:help opts) (display-help!)
      (:files opts) (print-fennel-file-paths! opts)
      (:compile opts) (compile-changed-fennel-files! opts)
      :else (display-help!))))

(comment
  ;; Intended to be invoked through your editor REPL during development.
  (main ["--help"]))

;; Default entrypoint of the script.
(main *command-line-args*)
