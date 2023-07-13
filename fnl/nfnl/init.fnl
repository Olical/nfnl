(local {: autoload} (require :nfnl.module))
(local compile (autoload :nfnl.compile))
(local config (autoload :nfnl.config))
(local notify (autoload :nfnl.notify))
(local callback (autoload :nfnl.callback))

(when vim
  (when (= 0 (_G.vim.fn.has "nvim-0.9.0"))
    (error "nfnl requires Neovim > v0.9.0."))

  (vim.api.nvim_create_autocmd
    ["Filetype"]
    {:group (vim.api.nvim_create_augroup "nfnl-setup" {})
     :pattern "fennel"
     :callback callback.fennel-filetype-callback}))

(fn setup []
  "A noop for now, may be used one day. You just need to load this module for the plugin to initialise for now.")

(fn compile-all-files [dir]
  "Compiles all files in the given directory, defaulting to the current working directory."

  (local dir (or dir (vim.fn.getcwd)))
  (let [{: config : root-dir : cfg} (config.find-and-load dir)]
    (if config
      (notify.info "Compilation complete.\n" (compile.all-files {: root-dir : cfg}))
      (notify.warn "No .nfnl.fnl configuration found."))))

{: setup
 : compile-all-files}
