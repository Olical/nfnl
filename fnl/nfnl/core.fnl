(local {: autoload} (require :nfnl.module))
(local fennel (autoload :nfnl.fennel))

(fn rand [n]
  "Draw a random floating point number between 0 and `n`, where `n` is 1.0 if omitted.
  You must have a random seed set before running this: (math.randomseed (os.time))"
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

(fn first [xs]
  (when xs
    (. xs 1)))

(fn second [xs]
  (when xs
    (. xs 2)))

(fn last [xs]
  (when xs
    (. xs (count xs))))

(fn inc [n]
  "Increment n by 1."
  (+ n 1))

(fn dec [n]
  "Decrement n by 1."
  (- n 1))

(fn even? [n]
  (= (% n 2) 0))

(fn odd? [n]
  (not (even? n)))

(fn vals [t]
  "Get all values of a table."
  (let [result []]
    (when t
      (each [_ v (pairs t)]
        (table.insert result v)))
    result))

(fn kv-pairs [t]
  "Get all keys and values of a table zipped up in pairs."
  (let [result []]
    (when t
      (each [k v (pairs t)]
        (table.insert result [k v])))
    result))

(fn run! [f xs]
  "Execute the function (for side effects) for every xs."
  (when xs
    (let [nxs (count xs)]
      (when (> nxs 0)
        (for [i 1 nxs]
          (f (. xs i)))))))

(fn complement [f]
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
  (let [total (count xs)]
    (->> (kv-pairs xs)
         (filter
           (fn [[n v]]
             (not= n total)))
         (map second))))

(fn rest [xs]
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
  (concat (unpack (map f xs))))

(fn pr-str [...]
  (let [s (table.concat
            (map (fn [x]
                   (fennel.view x {:one-line true}))
                 [...])
            " ")]
    (if (or (nil? s) (= "" s))
      "nil"
      s)))

(fn str [...]
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
  (println (pr-str ...)))

(fn slurp [path]
  "Read the file into a string."
  (match (io.open path "r")
    (nil _msg) nil
    f (let [content (f:read "*all")]
        (f:close)
        content)))

(fn spit [path content opts]
  "Spit the string into the file. When opts.append is true, add to the file."
  (var mode "w")
  (when (and opts opts.append)
    (set mode "a"))
  (match (io.open path mode)
    (nil msg) (error (.. "Could not open file: " msg))
    f (do
        (f:write content)
        (f:close)
        nil)))

(fn merge! [base ...]
  (reduce
    (fn [acc m]
      (when m
        (each [k v (pairs m)]
          (tset acc k v)))
      acc)
    (or base {})
    [...]))

(fn merge [...]
  (merge! {} ...))

(fn select-keys [t ks]
  (if (and t ks)
    (reduce
      (fn [acc k]
        (when k
          (tset acc k (. t k)))
        acc)
      {}
      ks)
    {}))

(fn get [t k d]
  (let [res (when (table? t)
              (let [val (. t k)]
                (when (not (nil? val))
                  val)))]
    (if (nil? res)
      d
      res)))

(fn get-in [t ks d]
  (let [res (reduce
              (fn [acc k]
                (when (table? acc)
                  (get acc k)))
              t ks)]
    (if (nil? res)
      d
      res)))

(fn assoc [t ...]
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
  (assoc t k (f (get t k))))

(fn update-in [t ks f]
  (assoc-in t ks (f (get-in t ks))))

(fn constantly [v]
  (fn [] v))

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
 : constantly}
