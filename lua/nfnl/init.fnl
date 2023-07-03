(local fennel (require :nfnl.fennel))

;; TODO Port Aniseed in properly.
(fn spit [path content]
  "Spit the string into the file."
  (match (io.open path "w")
    (nil msg) (error (.. "Could not open file: " msg))
    f (do
        (f:write content)
        (f:close)
        nil)))
;; --------

(fn fname-root [path]
  (vim.fn.fnamemodify path ":r"))

(fn get-buf-content [buf]
  (table.concat
    (vim.api.nvim_buf_get_lines buf 0 -1 false)
    "\n"))

(fn setup [opts]
  (let [agid (vim.api.nvim_create_augroup "nfnl" {})]
    (vim.api.nvim_create_autocmd
      ["BufWritePost"]
      {:pattern ["*.fnl"]
       :callback (fn [ev]
                   (let [(ok res) (pcall
                                    fennel.compileString
                                    (get-buf-content (. ev :buf))
                                    {:filename (. ev :file)})]
                     (if ok
                       (spit (.. (fname-root (. ev :file)) ".lua") res)
                       (error res))))})))

(comment
  (setup))

{: setup}
