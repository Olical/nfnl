(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local str (autoload :nfnl.string))
(local fennel (autoload :nfnl.fennel))
(local notify (autoload :nfnl.notify))

(local config-file-name ".nfnl.fnl")

(fn find [dir]
  "Find the nearest .nfnl.fnl file to the given directory. Returns the absolute
  path to the found file or nil."
  (let [found (fs.findfile config-file-name (.. dir ";"))]
      (when found
        (fs.full-path found))))

(fn default [opts]
  "Returns the default configuration that you should base your custom
  configuration on top of. Feel free to call this with no arguments and merge
  your changes on top. If you wish, you can override opts.root-dir (which
  defaults to the dir of your .nfnl.fnl project root and the CWD as a backup)
  to whatever you need. The defaults with no arguments should be exactly what
  you need in most cases though.

  Make sure you update the README whenever you change the default
  configuration!"

  (let [;; Base this config's paths on...
        root-dir (or
                   ;; The given root-dir option.
                   (core.get opts :root-dir)

                   ;; The closest .nfnl.fnl file parent directory to the cwd.
                   (fs.basename (find (vim.fn.getcwd)))

                   ;; The cwd, just in case nothing else works.
                   (vim.fn.getcwd))]

    {:compiler-options {}
     :fennel-path (str.join
                    ";"
                    (core.map
                      fs.join-path
                      [[root-dir "?.fnl"]
                       [root-dir "?" "init.fnl"]
                       [root-dir "fnl" "?.fnl"]
                       [root-dir "fnl" "?" "init.fnl"]]))
     :fennel-macro-path (str.join
                          ";"
                          (core.map
                            fs.join-path
                            [[root-dir "?.fnl"]
                             [root-dir "?" "init-macros.fnl"]
                             [root-dir "?" "init.fnl"]
                             [root-dir "fnl" "?.fnl"]
                             [root-dir "fnl" "?" "init-macros.fnl"]
                             [root-dir "fnl" "?" "init.fnl"]]))
     :source-file-patterns ["*.fnl" (fs.join-path ["**" "*.fnl"])]
     :fnl-path->lua-path fs.fnl-path->lua-path}))

(fn cfg-fn [t opts]
  "Builds a cfg fetcher for the config table t. Returns a function that takes a
  path sequential table, it looks up the value from the config with core.get-in
  and falls back to a matching value in (default) if not found."

  (let [default-cfg (default opts)]
    (fn [path]
      (core.get-in
        t path
        (core.get-in default-cfg path)))))

(fn config-file-path? [path]
  (= config-file-name (fs.filename path)))

(fn find-and-load [dir]
  "Attempt to find and load the .nfnl.fnl config file relative to the given dir.
  Returns an empty table when there's issues or if there isn't a config file.
  If there's some valid config you'll get table containing config, cfg (fn) and
  root-dir back."

  (or
    (let [config-file-path (find dir)]
      (when config-file-path
        (let [root-dir (fs.basename config-file-path)
              config-source (vim.secure.read config-file-path)

              (ok config)
              (if
                (core.nil? config-source)
                (values false (.. config-file-path " is not trusted, refusing to compile."))

                (or (str.blank? config-source)
                    (= "{}" (str.trim config-source)))
                (values true {})

                (pcall
                  fennel.eval
                  config-source
                  {:filename config-file-path}))]
          (if ok
            {: config
             : root-dir
             :cfg (cfg-fn config {: root-dir})}
            (notify.error config)))))

    ;; Always default to an empty table for destructuring.
    {}))

{: cfg-fn
 : find
 : find-and-load
 : config-file-path?
 : default}
