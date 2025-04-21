(local {: autoload : define} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local str (autoload :nfnl.string))

(local M (define :nfnl.fs))

(fn M.basename [path]
  "Remove the file part of the path."
  (when path
    (vim.fn.fnamemodify path ":h")))

(fn M.filename [path]
  "Just the filename / tail of a path."
  (when path
    (vim.fn.fnamemodify path ":t")))

(fn M.file-name-root [path]
  "Remove the suffix / extension of the file in a path."
  (when path
    (vim.fn.fnamemodify path ":r")))

(fn M.full-path [path]
  (when path
    (vim.fn.fnamemodify path ":p")))

(fn M.mkdirp [dir]
  (when dir
    (vim.fn.mkdir dir "p")))

(fn M.replace-extension [path ext]
  (when path
    (.. (M.file-name-root path) (.. "." ext))))

(fn M.read-first-line [path]
  (let [f (io.open path "r")]
    (when (and f (not (core.string? f)))
      (let [line (f:read "*line")]
        (f:close)
        line))))

(fn M.absglob [dir expr]
  "Glob all files under dir matching the expression and return the absolute paths."
  (vim.fn.globpath dir expr true true))

(fn M.relglob [dir expr]
  "Glob all files under dir matching the expression and return the paths
  relative to the dir argument."
  (let [dir-len (+ 2 (string.len dir))]
    (->> (M.absglob dir expr)
         (core.map #(string.sub $1 dir-len)))))

(fn M.glob-dir-newer? [a-dir b-dir expr b-dir-path-fn]
  "Returns true if a-dir has newer changes than b-dir. All paths from a-dir are mapped through b-dir-path-fn M.before comparing to b-dir."
  (var newer? false)
  (each [_ path (ipairs (M.relglob a-dir expr))]
    (when (> (vim.fn.getftime (.. a-dir path))
             (vim.fn.getftime (.. b-dir (b-dir-path-fn path))))
      (set newer? true)))
  newer?)

(fn M.path-sep []
  ;; https://github.com/nvim-lua/plenary.nvim/blob/8bae2c1fadc9ed5bfcfb5ecbd0c0c4d7d40cb974/lua/plenary/path.lua#L20-L31
  (let [os (string.lower jit.os)]
    (if (or (= :linux os)
            (= :osx os)
            (= :bsd os)
            (and (= 1 (vim.fn.exists "+shellshash"))
                 vim.o.shellslash))
      "/"
      "\\")))

(fn M.findfile [name path]
  "Wrapper around Neovim's findfile() that returns nil
  instead of an empty string."
  (let [res (vim.fn.findfile name path)]
    (when (not (core.empty? res))
      (M.full-path res))))

(fn M.split-path [path]
  (str.split path (M.path-sep)))

(fn M.join-path [parts]
  (str.join (M.path-sep) (core.concat parts)))

(fn M.replace-dirs [path from to]
  "Replaces directories in `path` that match `from` with `to`."
  (->> (M.split-path path)
       (core.map
         (fn [segment]
           (if (= from segment)
             to
             segment)))
       (M.join-path)))

(fn M.fnl-path->lua-path [fnl-path]
  (-> fnl-path
      (M.replace-extension "lua")
      (M.replace-dirs "fnl" "lua")))

(fn M.glob-matches? [dir expr path]
  "Return true if path matches the glob expression. The path should be absolute and the glob should be relative to dir."
  (let [regex (vim.regex (vim.fn.glob2regpat (M.join-path [dir expr])))]
    (regex:match_str path)))

(fn M.exists? [path]
  (when path
    (= "table" (type (vim.uv.fs_stat path)))))

M
