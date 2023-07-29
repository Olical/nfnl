(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local str (autoload :nfnl.string))

(fn basename [path]
  (vim.fn.fnamemodify path ":h"))

(fn filename [path]
  "Just the filename / tail of a path."
  (vim.fn.fnamemodify path ":t"))

(fn file-name-root [path]
  (vim.fn.fnamemodify path ":r"))

(fn full-path [path]
  (vim.fn.fnamemodify path ":p"))

(fn mkdirp [dir]
  (vim.fn.mkdir dir "p"))

(fn replace-extension [path ext]
  (.. (file-name-root path) (.. "." ext)))

(fn read-first-line [path]
  (let [f (io.open path)]
    (when (and f (not (core.string? f)))
      (let [line (f:read)]
        (f:close)
        line))))

(fn relglob [dir expr]
  "Glob all files under dir matching the expression and return the paths
  relative to the dir argument."
  (let [dir-len (+ 2 (string.len dir))]
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

(fn path-sep []
  ;; https://github.com/nvim-lua/plenary.nvim/blob/8bae2c1fadc9ed5bfcfb5ecbd0c0c4d7d40cb974/lua/plenary/path.lua#L20-L31
  (let [os (string.lower jit.os)]
    (if (or (= :linux os)
            (= :osx os)
            (= :bsd os))
      "/"
      "\\")))

(fn findfile [name path]
  "Wrapper around Neovim's findfile() that returns nil
  instead of an empty string."
  (let [res (vim.fn.findfile name path)]
    (when (not (core.empty? res))
      res)))

(fn split-path [path]
  (str.split path (path-sep)))

(fn join-path [parts]
  (str.join (path-sep) (core.concat parts)))

(fn replace-dirs [path from to]
  "Replaces directories in `path` that match `from` with `to`."
  (->> (split-path path)
       (core.map
         (fn [segment]
           (if (= from segment)
             to
             segment)))
       (join-path)))

(fn fnl-path->lua-path [fnl-path]
  (-> fnl-path
      (replace-extension "lua")
      (replace-dirs "fnl" "lua")))

{: basename
 : filename
 : file-name-root
 : full-path
 : mkdirp
 : replace-extension
 : relglob
 : glob-dir-newer?
 : path-sep
 : findfile
 : split-path
 : join-path
 : read-first-line
 : replace-dirs
 : fnl-path->lua-path}
