(local autoload (require :nfnl.autoload))
(local core (autoload :nfnl.core))

(fn notify [level ...]
  (vim.api.nvim_notify
    (core.str ...)
    level
    {}))

(fn debug [...]
  (notify vim.log.levels.DEBUG ...))

(fn error [...]
  (notify vim.log.levels.ERROR ...))

(fn info [...]
  (notify vim.log.levels.INFO ...))

(fn trace [...]
  (notify vim.log.levels.TRACE ...))

(fn warn [...]
  (notify vim.log.levels.WARN ...))

{: debug
 : error
 : info
 : trace
 : warn}
