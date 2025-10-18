(local {: autoload : define} (require :nfnl.module))
(local core (autoload :nfnl.core))

(local M (define :nfnl.string))

(fn M.join [...]
  "(join xs) (join sep xs)
  Joins all items of a table together with an optional separator.
  Separator defaults to an empty string.
  Values that aren't a string or nil will go through nfnl.core/pr-str."
  (let [args [...]
        [sep xs] (if (= 2 (core.count args))
                   args
                   ["" (core.first args)])
        len (core.count xs)]

    (var result [])

    (when (> len 0)
      (for [i 1 len]
        (let [x (. xs i)]
          (-?>> (if
                  (= :string (type x)) x
                  (= nil x) x
                  (core.pr-str x))
                (table.insert result)))))

    (table.concat result sep)))

(fn M.split [s pat]
  "Split the given string into a sequential table using the pattern."
  (var done? false)
  (var acc [])
  (var index 1)
  (while (not done?)
    (let [(start end) (string.find s pat index)]
      (if (= :nil (type start))
        (do
          (table.insert acc (string.sub s index))
          (set done? true))
        (do
          (table.insert acc (string.sub s index (- start 1)))
          (set index (+ end 1))))))
  acc)

(fn M.blank? [s]
  "Check if the string is nil, empty or only whitespace."
  (or (core.empty? s)
      (not (string.find s "[^%s]"))))

(fn M.triml [s]
  "Removes whitespace from the left side of string."
  (string.gsub s "^%s*(.-)" "%1"))

(fn M.trimr [s]
  "Removes whitespace from the right side of string."
  (string.gsub s "(.-)%s*$" "%1"))

(fn M.trim [s]
  "Removes whitespace from both ends of string."
  (string.gsub s "^%s*(.-)%s*$" "%1"))

(fn M.ends-with? [s suffix]
  "Check if the string ends with suffix."
  (let [suffix-len (# suffix)
        s-len (# s)]
    (if (>= s-len suffix-len)
      (= suffix (string.sub s (- s-len suffix-len -1)))
      false)))

M
