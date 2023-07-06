(local autoload (require :nfnl.autoload))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local fennel (autoload :nfnl.fennel))
(local notify (autoload :nfnl.notify))

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

(fn into-file [{: root-dir : path : cfg : source}]
  (let [rel-file-name (path:sub (+ 2 (root-dir:len)))
        destination-path (fnl-path->lua-path path)

        (ok res)
        (pcall
          fennel.compileString
          source
          (core.merge
            {:filename path}
            (cfg [:compiler_options])))]
    (if ok
      (if (safe-target? destination-path)
        (do
          (fs.mkdirp (fs.basename destination-path))
          (core.spit
            destination-path
            (with-header rel-file-name res)))
        (notify.warn destination-path " was not compiled by nfnl. Delete it manually if you wish to compile into this file."))
      (notify.error res))))

{: into-file}
