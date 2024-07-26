(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local fennel (autoload :nfnl.fennel))
(local notify (autoload :nfnl.notify))
(local config (autoload :nfnl.config))

(local mod {})

(local header-marker "[nfnl]")

(fn with-header [file src]
  (let [file (fs.standardize-path file)]  ;; Normalize the path for Windows
    (.. "-- " header-marker " Compiled from " file " by https://github.com/Olical/nfnl, do not edit.\n" src)))

(fn safe-target? [path]
  "Reads the given file and checks if it contains our header marker on the
  first line. Returns true if it contains the marker, we're allowed to
  overwrite this file."
  (let [header (fs.read-first-line path)]
    (or (core.nil? header)
        (not (core.nil? (header:find header-marker 1 true))))))

(fn macro-source? [source]
  (string.find source "%s*;+%s*%[nfnl%-macro%]"))

(fn valid-source-files [glob-fn {: root-dir : cfg}]
  "Return a list of all files we're allowed to compile. These are found by
  performing fs.relglob calls against each :source-file-patterns value from the
  configuration."
  (core.mapcat #(glob-fn root-dir $) (cfg [:source-file-patterns])))

(fn mod.into-string [{: root-dir : path : cfg : source : batch?
                      : file-exists-on-disk? &as opts}]
  (let [macro? (macro-source? source)]
    (if
      (and macro? batch?)
      {:status :macros-are-not-compiled
       :source-path path}

      macro?
      (do
        (core.clear-table! fennel.macro-loaded)
        (mod.all-files {: root-dir : cfg}))

      (config.config-file-path? path)
      {:status :nfnl-config-is-not-compiled
       :source-path path}

      (and (not= false file-exists-on-disk?)
           (not (core.some #(= path $) (valid-source-files fs.absglob opts))))
      {:status :path-is-not-in-source-file-patterns
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
          (do
            (when (cfg [:verbose])
              (notify.info "Successfully compiled: " path))
            {:status :ok
             :source-path path
             :result (.. (with-header rel-file-name res) "\n")})
          (do
            (when (not batch?)
              (notify.error res))
            {:status :compilation-error
             :error res
             :source-path path}))))))

(fn mod.into-file [{: _root-dir : cfg : _source : path : batch? &as opts}]
  (let [fnl-path->lua-path (cfg [:fnl-path->lua-path])
        destination-path (fnl-path->lua-path path)
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

(fn mod.all-files [{: root-dir : cfg &as opts}]
  (->> (valid-source-files fs.relglob opts)
       (core.map #(fs.join-path [root-dir $]))
       (core.map
         (fn [path]
           (mod.into-file
             {: root-dir
              : path
              : cfg
              :source (core.slurp path)
              :batch? true})))))

mod
