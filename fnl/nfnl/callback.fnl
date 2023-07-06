(local autoload (require :nfnl.autoload))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local nvim (autoload :nfnl.nvim))
(local compile (autoload :nfnl.compile))
(local config (autoload :nfnl.config))

(fn fennel-buf-write-post-callback-fn [root-dir cfg]
  "Builds a function to be called on buf write. Adheres to the config passed
  into this outer function."

  (fn [ev]
    "Called when we write a Fennel file located under a directory containing a
    .nfnl.fnl file. It compiles the Fennel to Lua and writes it into another
    file according to the .nfnl.fnl file configuration."

    (compile.into-file
      {: root-dir
       : cfg
       :path (. ev :file)
       :source (nvim.get-buf-content-as-string (. ev :buf))})))

(fn fennel-filetype-callback [ev]
  "Called whenever we enter a Fennel file. It walks up the tree to find a
  .nfnl.fnl (which can contain configuration). If found, we initialise the
  compiler autocmd for the directory containing the .nfnl.fnl file.

  This allows us to edit multiple projects in different directories with
  different .nfnl.fnl configuration, wonderful!"

  (let [file-path (fs.full-path (. ev :file))
        file-dir (fs.basename file-path)
        {: config : root-dir : cfg} (config.find-and-load file-dir)]

    (when config
      (vim.api.nvim_create_autocmd
        ["BufWritePost"]
        {:group (vim.api.nvim_create_augroup (.. "nfnl-dir-" root-dir) {})
         :pattern (core.map #(fs.join-path [root-dir $]) (cfg [:source-file-patterns]))
         :callback (fennel-buf-write-post-callback-fn root-dir cfg)}))))

{: fennel-filetype-callback}
