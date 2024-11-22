(local {: autoload} (require :nfnl.module))
(local callback (autoload :nfnl.callback))

(local minimum-neovim-version "0.9.0")

(when vim
  (when (= 0 (vim.fn.has (.. "nvim-" minimum-neovim-version)))
    (error (.. "nfnl requires Neovim > v" minimum-neovim-version)))

  (vim.api.nvim_create_autocmd
    ["Filetype"]
    {:group (vim.api.nvim_create_augroup "nfnl-setup" {})
     :pattern "fennel"
     :callback callback.fennel-filetype-callback})

  (when (= :fennel vim.o.filetype)
    (callback.fennel-filetype-callback
      {:file (vim.fn.expand "%")
       :buf (vim.api.nvim_get_current_buf)})))

(fn setup [opts]
  "Sets the vim.g.nfnl#... variables in a slightly more Lua friendly way."

  (when opts
    (set vim.g.nfnl#compile_on_write opts.compile_on_write)))

{: setup}
