(local autoload (require :nfnl.autoload))
(local system (autoload :nfnl.system))

(fn setup []
  "Called by the user or plugin manager at Neovim startup. Users may lazy load
  this plugin which means the Filetype autocmd already happened, so we have to
  check for that and manually invoke the callback for that case."

  (vim.api.nvim_create_autocmd
    ["Filetype"]
    {:group (vim.api.nvim_create_augroup "nfnl-setup" {})
     :pattern "fennel"
     :callback system.fennel-filetype-callback})

  (when (= :fennel vim.o.filetype)
    (system.fennel-filetype-callback
      {:file (vim.fn.expand "%")
       :buf (vim.api.nvim_get_current_buf)})))

{: setup
 :default-config system.default-config}
