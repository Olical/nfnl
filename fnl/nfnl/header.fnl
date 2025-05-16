(local {: autoload : define} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local str (autoload :nfnl.string))

(local M (define :nfnl.header))

(local tag "[nfnl]")

(fn M.with-header [file src]
  "Return the source with an nfnl header prepended."
  (.. "-- " tag " " file "\n" src))

(fn M.tagged? [s]
  "Is the line an nfnl tagged header line?"
  (when s
    (core.number? (s:find tag 1 true))))

(fn M.source-path [s]
  (when (M.tagged? s)
    (core.some
      (fn [part]
        (and (str.ends-with? part ".fnl") part))
      (str.split s "%s+"))))

M
