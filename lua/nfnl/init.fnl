(local autoload (require :nfnl.autoload))
(local fennel (autoload :nfnl.fennel))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local str (autoload :nfnl.string))

(fn get-buf-content-as-string [buf]
  (str.join
    "\n"
    (vim.api.nvim_buf_get_lines (or buf 0) 0 -1 false)))

(fn buf-write-post-callback [ev]
  (let [(ok res) (pcall
                   fennel.compileString
                   (get-buf-content-as-string (. ev :buf))
                   {:filename (. ev :file)})]
    (if ok
      (core.spit (fs.replace-extension (. ev :file) "lua") res)
      (error res))))

(fn setup [opts]
  (local opts (or opts {}))

  (when (not= false (. opts :compile_on_write))
    (let [agid (vim.api.nvim_create_augroup "nfnl" {})]
      (vim.api.nvim_create_autocmd
        ["BufWritePost"]
        {:pattern ["*.fnl"]
         :callback buf-write-post-callback}))))

(comment
  (setup))

{: setup}
