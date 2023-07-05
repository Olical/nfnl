(local autoload (require :nfnl.autoload))
(local str (autoload :nfnl.string))

(fn get-buf-content-as-string [buf]
  (->> (vim.api.nvim_buf_get_lines (or buf 0) 0 -1 false)
       (str.join "\n")))

{: get-buf-content-as-string}
