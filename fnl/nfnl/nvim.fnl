(local {: autoload} (require :nfnl.module))
(local str (autoload :nfnl.string))

(fn get-buf-content-as-string [buf]
  (or
    (->> (vim.api.nvim_buf_get_lines (or buf 0) 0 -1 false)
         (str.join "\n"))
    ""))

{: get-buf-content-as-string}
