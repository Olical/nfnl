(local {: autoload} (require :nfnl.module))
(local fennel (autoload :nfnl.fennel))

(fn rand [n]
  "Draw a random floating point number between 0 and `n`, where `n` is 1.0 if omitted.
  You must have a random seed set before running this: `(math.randomseed (os.time))`"
  (* (math.random) (or n 1)))

(fn nil? [x]
  "True if the value is equal to Lua `nil`."
  (= nil x))

(fn number? [x]
  "True if the value is of type 'number'."
  (= "number" (type x)))

(fn boolean? [x]
  "True if the value is of type 'boolean'."
  (= "boolean" (type x)))

(fn string? [x]
  "True if the value is of type 'string'."
  (= "string" (type x)))

(fn table? [x]
  "True if the value is of type 'table'."
  (= "table" (type x)))

(fn function? [value]
  "True if the value is of type 'function'."
  (= "function" (type value)))

(fn keys [t]
  "Get all keys of a table."
  (let [result []]
    (when t
      (each [k _ (pairs t)]
        (table.insert result k)))
    result))

(fn first [xs]
  "The first item of the sequential table."
  (when xs
    (. xs 1)))

(fn second [xs]
  "The second item of the sequential table."
  (when xs
    (. xs 2)))

(fn count [xs]
  "Count the items / characters in the input. Can handle tables, nil, strings and anything else that works with `(length xs)`."
  (if
    (table? xs) (let [maxn (table.maxn xs)]
                  ;; We only count the keys if maxn returns 0.
                  (if (= 0 maxn)
                    (table.maxn (keys xs))
                    maxn))
    (not xs) 0
    (length xs)))

(fn empty? [xs]
  "Returns true if the argument is empty, this includes empty strings, lists and nil."
  (= 0 (count xs)))

(fn sequential? [xs]
  "True if the value is a sequential table."
  (and (table? xs) (or (empty? xs) (= 1 (first (keys xs))))))

(fn kv-pairs [t]
  "Get all keys and values of a table zipped up in pairs."
  (let [result []]
    (when t
      (each [k v (pairs t)]
        (table.insert result [k v])))
    result))

(fn seq [x]
  "Sequential tables are just returned, associative tables are returned as [[k v]], strings are returned as sequential tables of characters and nil returns nil. Empty tables and strings also coerce to nil."
  (if
    (empty? x) nil
    (sequential? x) x
    (table? x) (kv-pairs x)

    (string? x)
    (let [acc []]
      (for [i 1 (count x)]
        (table.insert acc (x:sub i i)))
      (when (not (empty? acc))
        acc))

    nil))

(fn last [xs]
  "The last item of the sequential table."
  (when xs
    (. xs (count xs))))

(fn inc [n]
  "Increment n by 1."
  (+ n 1))

(fn dec [n]
  "Decrement n by 1."
  (- n 1))

(fn even? [n]
  "True if `n` is even."
  (= (% n 2) 0))

(fn odd? [n]
  "True if `n` is odd."
  (not (even? n)))

(fn vals [t]
  "Get all values of a table."
  (let [result []]
    (when t
      (each [_ v (pairs t)]
        (table.insert result v)))
    result))

(fn run! [f xs]
  "Execute the function (for side effects) for every xs."
  (when xs
    (let [nxs (count xs)]
      (when (> nxs 0)
        (for [i 1 nxs]
          (f (. xs i)))))))

(fn complement [f]
  "Takes a fn `f` and returns a fn that takes the same arguments as `f`, has
   the same effects, if any, and returns the opposite truth value."
  (fn [...]
    (not (f ...))))

(fn filter [f xs]
  "Filter xs down to a new sequential table containing every value that (f x) returned true for."
  (let [result []]
    (run!
      (fn [x]
        (when (f x)
          (table.insert result x)))
      xs)
    result))

(fn remove [f xs]
  "Opposite of filter, filter `xs` down to a new sequential table containing
   every value that `(f x)` returned falsy for."
  (filter (complement f) xs))

(fn map [f xs]
  "Map xs to a new sequential table by calling (f x) on each item."
  (let [result []]
    (run!
      (fn [x]
        (let [mapped (f x)]
          (table.insert
            result
            (if (= 0 (select "#" mapped))
              nil
              mapped))))
      xs)
    result))

(fn map-indexed [f xs]
  "Map xs to a new sequential table by calling (f [k v]) on each item. "
  (map f (kv-pairs xs)))

(fn identity [x]
  "Returns what you pass it."
  x)

(fn reduce [f init xs]
  "Reduce xs into a result by passing each subsequent value into the fn with
  the previous value as the first arg. Starting with init."
  (var result init)
  (run!
    (fn [x]
      (set result (f result x)))
    xs)
  result)

(fn some [f xs]
  "Return the first truthy result from (f x) or nil."
  (var result nil)
  (var n 1)
  (while (and (nil? result) (<= n (count xs)))
    (let [candidate (f (. xs n))]
      (when candidate
        (set result candidate))
      (set n (inc n))))
  result)

(fn butlast [xs]
  "Return every value from the sequential table except the last one."
  (let [total (count xs)]
    (->> (kv-pairs xs)
         (filter
           (fn [[n v]]
             (not= n total)))
         (map second))))

(fn rest [xs]
  "Return every value from the sequential table except the first one."
  (->> (kv-pairs xs)
       (filter
         (fn [[n v]]
           (not= n 1)))
       (map second)))

(fn concat [...]
  "Concatenates the sequential table arguments together."
  (let [result []]
    (run! (fn [xs]
            (run!
              (fn [x]
                (table.insert result x))
              xs))
          [...])
    result))

(fn mapcat [f xs]
  "The same as `map` but then `concat` all lists within the result together."
  (concat (unpack (map f xs))))

(fn pr-str [...]
  "Convert the input arguments to a string."
  (let [s (table.concat
            (map (fn [x]
                   (fennel.view x {:one-line true}))
                 [...])
            " ")]
    (if (or (nil? s) (= "" s))
      "nil"
      s)))

(fn str [...]
  "Concatenate the values into one string. Converting non-string values into
   strings where required."
  (->> [...]
       (map
         (fn [s]
           (if (string? s)
             s
             (pr-str s))))
       (reduce
         (fn [acc s]
           (.. acc s))
         "")))

(fn println [...]
  "Convert the input arguments to a string (if required) and print them."
  (->> [...]
       (map
         (fn [s]
           (if (string? s)
             s
             (pr-str s))))
       (map-indexed
         (fn [[i s]]
           (if (= 1 i)
             s
             (.. " " s))))
       (reduce
         (fn [acc s]
           (.. acc s))
         "")
       print))

(fn pr [...]
  "Print the arguments as data, strings will remain quoted."
  (println (pr-str ...)))

(fn slurp [path]
  "Read the file into a string."
  (when path
    (match (io.open path "r")
      (nil _msg) nil
      f (let [content (f:read "*all")]
          (f:close)
          content))))

(fn get [t k d]
  "Get the key `k` from table `t` while safely handling `nil`. If it's not
   found it will return the optional default value `d`."
  (let [res (when (table? t)
              (let [val (. t k)]
                (when (not (nil? val))
                  val)))]
    (if (nil? res)
      d
      res)))

(fn spit [path content opts]
  "Spit the string into the file. When opts.append is true, add to the file."
  (when path
    (match (io.open
             path
             (if (get opts :append)
               "a"
               "w"))
      (nil msg) (error (.. "Could not open file: " msg))
      f (do
          (f:write content)
          (f:close)
          nil))))

(fn merge! [base ...]
  "The same as `merge` above but will mutate the first argument, so all
   tables are merged into the first one."
  (reduce
    (fn [acc m]
      (when m
        (each [k v (pairs m)]
          (tset acc k v)))
      acc)
    (or base {})
    [...]))

(fn merge [...]
  "Merge the tables together, `nil` will be skipped safely so you can use
   `(when ...)` to conditionally include tables. Merges into a fresh table so
   no existing tables will be mutated."
  (merge! {} ...))

(fn select-keys [t ks]
  "Extract the keys listed in `ks` from `t` and return it as a new table."
  (if (and t ks)
    (reduce
      (fn [acc k]
        (when k
          (tset acc k (. t k)))
        acc)
      {}
      ks)
    {}))

(fn get-in [t ks d]
  "Get the key path `ks` from table `t` while safely handling `nil`. If it's
   not found it will return the optional default value `d`.

   `(get-in {:foo {:bar 10}} [:foo :bar]) // => 10`"
  (let [res (reduce
              (fn [acc k]
                (when (table? acc)
                  (get acc k)))
              t ks)]
    (if (nil? res)
      d
      res)))

(fn assoc [t ...]
  "Set the key `k` in table `t` to the value `v` while safely handling `nil`.

   Accepts more `k` and `v` pairs as after the initial pair. This allows you
   to assoc multiple values in one call.

   Returns the table `t` once it has been mutated."
  (let [[k v & xs] [...]
        rem (count xs)
        t (or t {})]

    (when (odd? rem)
      (error "assoc expects even number of arguments after table, found odd number"))

    (when (not (nil? k))
      (tset t k v))

    (when (> rem 0)
      (assoc t (unpack xs)))

    t))

(fn assoc-in [t ks v]
  "Set the key path `ks` in table `t` to the value `v` while safely handling `nil`.

   `(assoc-in {:foo {:bar 10}} [:foo :bar] 15) // => {:foo {:bar 15}}`"
  (let [path (butlast ks)
        final (last ks)
        t (or t {})]
    (assoc (reduce
             (fn [acc k]
               (let [step (get acc k)]
                 (if (nil? step)
                   (get (assoc acc k {}) k)
                   step)))
             t
             path)
           final
           v)
    t))

(fn update [t k f]
  "Replace the key `k` in table `t` by passing the current value through the
   function `f`. Returns the table after the key has been mutated."
  (assoc t k (f (get t k))))

(fn update-in [t ks f]
  "Same as `update` but replace the key path at `ks` with the result of
   passing the current value through the function `f`."
  (assoc-in t ks (f (get-in t ks))))

(fn constantly [v]
  "Returns a function that takes any number of arguments and returns `v`."
  (fn [] v))

(fn distinct [xs]
  "Takes a sequential table of values (xs) and returns a distinct sequential table with all duplicates removed."
  (->> xs
       (reduce
         (fn [acc x]
           (tset acc x true)
           acc)
         {})
       (keys)))

(fn sort [xs]
  "Copies the sequential table xs, sorts it and returns it."
  (let [copy (map identity xs)]
    (table.sort copy)
    copy))

(fn clear-table! [t]
  "Clear all keys from the table."
  (when t
    (each [k _ (pairs t)]
      (tset t k nil)))
  nil)

(fn take-while [f xs]
  (local xs (seq xs))
  (when xs
    (var acc [])
    (var done? false)
    (for [i 1 (count xs) 1]
      (let [v (. xs i)]
        (if (and (not done?) (f v))
          (table.insert acc v)
          (set done? true))))
    acc))

{: rand
 : nil?
 : number?
 : boolean?
 : string?
 : table?
 : function?
 : keys
 : count
 : empty?
 : first
 : second
 : last
 : inc
 : dec
 : even?
 : odd?
 : vals
 : kv-pairs
 : run!
 : complement
 : filter
 : remove
 : map
 : map-indexed
 : identity
 : reduce
 : some
 : butlast
 : rest
 : concat
 : mapcat
 : pr-str
 : str
 : println
 : pr
 : slurp
 : spit
 : merge!
 : merge
 : select-keys
 : get
 : get-in
 : assoc
 : assoc-in
 : update
 : update-in
 : constantly
 : distinct
 : sort
 : clear-table!
 : sequential?
 : seq
 : take-while}
