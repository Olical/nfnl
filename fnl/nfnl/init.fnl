(local {: autoload} (require :nfnl.module))
(local compile (autoload :nfnl.compile))
(local config (autoload :nfnl.config))
(local notify (autoload :nfnl.notify))
(local callback (autoload :nfnl.callback))

(fn setup []
  "Called by the user or plugin manager at Neovim startup. Users may lazy load
  this plugin which means the Filetype autocmd already happened, so we have to
  check for that and manually invoke the callback for that case."

  (vim.api.nvim_create_autocmd
    ["Filetype"]
    {:group (vim.api.nvim_create_augroup "nfnl-setup" {})
     :pattern "fennel"
     :callback callback.fennel-filetype-callback})

  (when (= :fennel vim.o.filetype)
    (callback.fennel-filetype-callback
      {:file (vim.fn.expand "%")
       :buf (vim.api.nvim_get_current_buf)})))

(fn compile-all-files [dir]
  (local dir (or dir (vim.fn.getcwd)))
  (let [{: config : root-dir : cfg} (config.find-and-load dir)]
    (if config
      (notify.info "Compilation complete.\n" (compile.all-files {: root-dir : cfg}))
      (notify.warn "No .nfnl.fnl configuration found."))))

{: setup
 : compile-all-files}
