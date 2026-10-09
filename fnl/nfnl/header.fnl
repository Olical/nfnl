(local {: autoload : define} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local str (autoload :nfnl.string))

(local M (define :nfnl.header))

(local header-prefix "-- [nfnl]")

(fn M.with-header [file src]
  "Return the source with an nfnl header prepended."
  (.. header-prefix " " file "\n" src))

(fn M.tagged? [s]
  "Is the line an nfnl tagged header line? It must start with the exact prefix
  nfnl writes, so other comments that mention [nfnl] do not count."
  (and (= :string (type s))
       (str.starts-with? s (.. header-prefix " "))))

(fn M.read [path max-lines]
  "Search the first max-lines lines for an nfnl header. Returns the header and
  all preceding lines as a prefix (including their newlines). If no header is
  found, returns the first line, or nil for an empty or missing file.
  max-lines must be a positive integer."
  (assert (and (= :number (type max-lines))
               (>= max-lines 1) (= max-lines (math.floor max-lines)))
          "header-search-lines must be a positive integer")
  (let [f (io.open path "r")]
    (when f
      (let [first-line (f:read "*line")
            prefix []]
        (var line first-line)
        (var line-number 1)
        (while (and line (not (M.tagged? line)) (< line-number max-lines))
          (table.insert prefix (.. line "\n"))
          (set line (f:read "*line"))
          (set line-number (+ line-number 1)))
        (f:close)
        (if (M.tagged? line)
          (values line (table.concat prefix))
          first-line)))))

(fn M.source-path [s]
  (when (M.tagged? s)
    (core.some
      (fn [part]
        (and (str.ends-with? part ".fnl") part))
      (str.split s "%s+"))))

M
