(local autoload (require :nfnl.autoload))
(local core (autoload :nfnl.core))

(fn basename [path]
  (vim.fn.fnamemodify path ":h"))

(fn file-name-root [path]
  (vim.fn.fnamemodify path ":r"))

(fn mkdirp [dir]
  (vim.fn.mkdir dir "p"))

(fn replace-extension [path ext]
  (.. (file-name-root path) (.. "." ext)))

(fn relglob [dir expr]
  "Glob all files under dir matching the expression and return the paths
  relative to the dir argument."
  (let [dir-len (core.inc (string.len dir))]
    (->> (vim.fn.globpath dir expr true true)
         (core.map #(string.sub $1 dir-len)))))

(fn glob-dir-newer? [a-dir b-dir expr b-dir-path-fn]
  "Returns true if a-dir has newer changes than b-dir. All paths from a-dir are mapped through b-dir-path-fn before comparing to b-dir."
  (var newer? false)
  (each [_ path (ipairs (relglob a-dir expr))]
    (when (> (vim.fn.getftime (.. a-dir path))
             (vim.fn.getftime (.. b-dir (b-dir-path-fn path))))
      (set newer? true)))
  newer?)

(local path-sep
  ;; https://github.com/nvim-lua/plenary.nvim/blob/8bae2c1fadc9ed5bfcfb5ecbd0c0c4d7d40cb974/lua/plenary/path.lua#L20-L31
  (let [os (string.lower jit.os)]
    (if (or (= :linux os)
            (= :osx os)
            (= :bsd os))
      "/"
      "\\")))

{: basename
 : file-name-root
 : mkdirp
 : replace-extension
 : relglob
 : glob-dir-newer?
 : path-sep}
