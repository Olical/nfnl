(local {: autoload : define} (require :nfnl.module))
(local fs (autoload :nfnl.fs))

(local M (define :nfnl.gc))

(fn M.find-orphan-lua-files []
  (fs.relglob "." "**/*.lua"))

M
