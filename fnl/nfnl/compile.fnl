(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local fennel (autoload :nfnl.fennel))
(local notify (autoload :nfnl.notify))
(local config (autoload :nfnl.config))

(local mod {})

(local header-marker "[nfnl]")

(fn with-header [file src]
  (.. "-- " header-marker " Compiled from " file " by https://github.com/Olical/nfnl, do not edit.\n" src))

(fn safe-target? [path]
  "Reads the given file and checks if it contains our header marker on the
  first line. Returns true if it contains the marker, we're allowed to
  overwrite this file."
  (let [header (fs.read-first-line path)]
    (or (core.nil? header)
        (not (core.nil? (header:find header-marker 1 true))))))

(fn fnl-path->lua-path [fnl-path]
  (-> fnl-path
      (fs.replace-extension "lua")
      (fs.replace-dirs "fnl" "lua")))

(fn macro-source? [source]
  (string.find source "%s*;+%s*%[nfnl%-macro%]"))

(fn mod.into-string [{: root-dir : path : cfg : source : batch?}]
  (let [macro? (macro-source? source)]
    (if
      (and macro? batch?)
      {:status :macros-are-not-compiled
       :source-path path}

      macro?
      (mod.all-files {: root-dir : cfg})

      (config.config-file-path? path)
      {:status :nfnl-config-is-not-compiled
       :source-path path}

      (let [rel-file-name (path:sub (+ 2 (root-dir:len)))
            (ok res)
            (do
              (set fennel.path (cfg [:fennel-path]))
              (set fennel.macro-path (cfg [:fennel-macro-path]))
              (pcall
                fennel.compileString
                source
                (core.merge
                  {:filename path}
                  (cfg [:compiler-options]))))]
        (if ok
          {:status :ok
           :source-path path
           :result (.. (with-header rel-file-name res) "\n")}
          (do
            (when (not batch?)
              (notify.error res))
            {:status :compilation-error
             :error res
             :source-path path}))))))

(fn mod.into-file [{: _root-dir : _cfg : _source : path : batch? &as opts}]
  (let [destination-path (fnl-path->lua-path path)
        {: status : source-path : result &as res}
        (mod.into-string opts)]
    (if
      (not= :ok status)
      res

      (safe-target? destination-path)
      (do
        (fs.mkdirp (fs.basename destination-path))
        (core.spit destination-path result)
        {:status :ok
         : source-path
         : destination-path})

      (do
        (when (not batch?)
          (notify.warn destination-path " was not compiled by nfnl. Delete it manually if you wish to compile into this file."))
        {:status :destination-exists
         :source-path path
         : destination-path}))))

(fn mod.all-files [{: root-dir : cfg}]
  (->> (core.mapcat #(fs.relglob root-dir $) (cfg [:source-file-patterns]))
       (core.map fs.full-path)
       (core.map
         (fn [path]
           (mod.into-file
             {: root-dir
              : path
              : cfg
              :source (core.slurp path)
              :batch? true})))))

mod
