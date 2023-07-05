(local autoload (require :nfnl.autoload))
(local fennel (autoload :nfnl.fennel))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local nvim (autoload :nfnl.nvim))
(local notify (autoload :nfnl.notify))

(local config-file-name ".nfnl")

(local default-config
  {;; Passed to fennel.compileString when your code is compiled.
   ;; See https://fennel-lang.org/api for more information.
   :compiler_options {}})

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

(fn fennel-buf-write-post-callback-fn [root-dir config]
  "Builds a function to be called on buf write. Adheres to the config passed
  into this outer function."

  (let [cfg (cfg-fn config)]
    (fn [ev]
      "Called when we write a Fennel file located under a directory containing a
      .nfnl file. It compiles the Fennel to Lua and writes it into another file
      according to the .nfnl file configuration."

      (let [file-name (. ev :file)
            rel-file-name (file-name:sub (+ 2 (root-dir:len)))
            destination-path (fs.replace-extension file-name "lua")

            (ok res)
            (pcall
              fennel.compileString
              (nvim.get-buf-content-as-string (. ev :buf))
              (core.merge
                (cfg [:compiler_options])
                {:filename file-name}))]
        (if ok
          (if (safe-target? destination-path)
            (core.spit
              destination-path
              (with-header rel-file-name res))
            (notify.warn destination-path " was not compiled by nfnl. Delete it manually if you wish to compile into this file."))
          (notify.error res))))))

(fn fennel-filetype-callback [ev]
  "Called whenever we enter a Fennel file. It walks up the tree to find a .nfnl
  (which can contain configuration). If found, we initialise the compiler
  autocmd for the directory containing the .nfnl file.

  This allows us to edit multiple projects in different directories with
  different .nfnl configuration, wonderful!"

  (let [cwd (vim.fn.getcwd)
        file-dir (fs.join-path [cwd (fs.basename (. ev :file))])
        rel-nfnl-path (fs.findfile config-file-name (.. file-dir ";"))]
    (when rel-nfnl-path
      (let [config-file-path (fs.join-path [cwd rel-nfnl-path])
            root-dir (fs.basename config-file-path)

            (ok config)
            (pcall
              fennel.eval
              (vim.secure.read config-file-path)
              {:filename config-file-path})]
        (if ok
          (vim.api.nvim_create_autocmd
            ["BufWritePost"]
            {:group (vim.api.nvim_create_augroup (.. "nfnl-dir-" root-dir) {})
             :pattern (fs.join-path [root-dir "*.fnl"])
             :callback (fennel-buf-write-post-callback-fn root-dir config)})
          (notify.error config))))))

(fn setup []
  "Called by the user or plugin manager at Neovim startup. Users may lazy load
  this plugin which means the Filetype autocmd already happened, so we have to
  check for that and manually invoke the callback for that case."

  (vim.api.nvim_create_autocmd
    ["Filetype"]
    {:group (vim.api.nvim_create_augroup "nfnl-setup" {})
     :pattern "fennel"
     :callback fennel-filetype-callback})

  (when (= :fennel vim.o.filetype)
    (fennel-filetype-callback
      {:file (vim.fn.expand "%")
       :buf (vim.api.nvim_get_current_buf)})))

(comment
  (setup))

{: setup
 : default-config}
