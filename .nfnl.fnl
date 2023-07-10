(local {: autoload} (require :nfnl.module))
(local reload (autoload :plenary.reload))
(local notify (autoload :nfnl.notify))

(vim.api.nvim_set_keymap
  :n "<localleader>pt" "<Plug>PlenaryTestFile" {:desc "Run the current test file with plenary."})

(vim.api.nvim_set_keymap
  :n "<localleader>pT" "<cmd>PlenaryBustedDirectory lua/spec/<cr>" {:desc "Run all tests with plenary."})

(vim.api.nvim_set_keymap
  :n "<localleader>pr" ""
  {:desc "Reload the nfnl modules."
   :callback (fn []
               (notify.info "Reloading...")
               (reload.reload_module "nfnl")
               (require :nfnl)
               (notify.info "Done!"))})

{}
