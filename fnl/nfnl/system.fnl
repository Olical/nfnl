(local autoload (require :nfnl.autoload))
(local fennel (autoload :nfnl.fennel))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local nvim (autoload :nfnl.nvim))
(local str (autoload :nfnl.string))
(local notify (autoload :nfnl.notify))

(local config-file-name ".nfnl")

(local default-config
  {;; Passed to fennel.compileString when your code is compiled.
   ;; See https://fennel-lang.org/api for more information.
   :compiler_options {}

   ;; A list of glob patterns (autocmd pattern syntax) of files that
   ;; should be compiled. This is used as configuration for the BufWritePost
   ;; autocmd, so it'll only apply to buffers you're interested in.
   :source_file_patterns [(fs.join-path ["fnl" "**" "*.fnl"])]})

(fn cfg-fn [t]
  "Builds a cfg fetcher for the config table t. Returns a function that takes a
  path sequential table, it looks up the value from the config with core.get-in
  and falls back to a matching value in default-config if not found."

  (fn [path]
    (core.get-in
      t path
      (core.get-in default-config path))))

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

(fn fennel-buf-write-post-callback-fn [root-dir cfg]
  "Builds a function to be called on buf write. Adheres to the config passed
  into this outer function."

  (fn [ev]
    "Called when we write a Fennel file located under a directory containing a
    .nfnl file. It compiles the Fennel to Lua and writes it into another file
    according to the .nfnl file configuration."

    (let [file-name (. ev :file)
          rel-file-name (file-name:sub (+ 2 (root-dir:len)))
          destination-path (fnl-path->lua-path file-name)

          (ok res)
          (pcall
            fennel.compileString
            (nvim.get-buf-content-as-string (. ev :buf))
            (core.merge
              {:filename file-name}
              (cfg [:compiler_options])))]
      (if ok
        (if (safe-target? destination-path)
          (do
            (fs.mkdirp (fs.basename destination-path))
            (core.spit
              destination-path
              (with-header rel-file-name res)))
          (notify.warn destination-path " was not compiled by nfnl. Delete it manually if you wish to compile into this file."))
        (notify.error res)))))

(fn load-config [dir]
  "Attempt to find and load the .nfnl config file relative to the given dir.
  Returns an empty table when there's issues or if there isn't a config file.
  If there's some valid config you'll get {:config {...} :root-dir ...} back."

  (let [found (fs.findfile config-file-name (.. dir ";"))]
    (when found
      (let [config-file-path (fs.full-path found)
            root-dir (fs.basename config-file-path)
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
           : root-dir}
          (do
            (notify.error config)
            {}))))))

(fn fennel-filetype-callback [ev]
  "Called whenever we enter a Fennel file. It walks up the tree to find a .nfnl
  (which can contain configuration). If found, we initialise the compiler
  autocmd for the directory containing the .nfnl file.

  This allows us to edit multiple projects in different directories with
  different .nfnl configuration, wonderful!"

  (let [file-path (fs.full-path (. ev :file))
        file-dir (fs.basename file-path)
        {: config : root-dir} (load-config file-dir)]

    (when config
      (let [cfg (cfg-fn config)]
        (vim.api.nvim_create_autocmd
          ["BufWritePost"]
          {:group (vim.api.nvim_create_augroup (.. "nfnl-dir-" root-dir) {})
           :pattern (core.map #(fs.join-path [root-dir $]) (cfg [:source_file_patterns]))
           :callback (fennel-buf-write-post-callback-fn root-dir cfg)})))))

{: default-config
 : fennel-filetype-callback}
