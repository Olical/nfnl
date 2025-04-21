(local {: autoload : define} (require :nfnl.module))
(local core (autoload :nfnl.core))

(local M (define :nfnl.header))

(local tag "[nfnl]")

(fn M.with-header [file src]
  "Return the source with an nfnl header prepended."
  (.. "-- " tag " " file "\n" src))

(fn M.tagged? [s]
  "Is the line an nfnl tagged header line?"
  (core.string? (s:find tag 1 true)))

(fn M.source-path []
  "")

M
