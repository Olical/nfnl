(local {: autoload} (require :nfnl.module))
(local callback (autoload :nfnl.callback))

(when vim
  (when (= 0 (_G.vim.fn.has "nvim-0.9.0"))
    (error "nfnl requires Neovim > v0.9.0."))

  (vim.api.nvim_create_autocmd
    ["Filetype"]
    {:group (vim.api.nvim_create_augroup "nfnl-setup" {})
     :pattern "fennel"
     :callback callback.fennel-filetype-callback})

  (when (= :fennel vim.o.filetype)
    (callback.fennel-filetype-callback
      {:file (vim.fn.expand "%")
       :buf (vim.api.nvim_get_current_buf)})))

(fn setup []
  "A noop for now, may be used one day. You just need to load this module for the plugin to initialise for now.")

{: setup}
