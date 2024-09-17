(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local core (require :nfnl.core))
(local fs (require :nfnl.fs))

(describe
  "rand"
  (fn []
    (math.randomseed (os.time))

    (it "returns a number"
        (fn []
          (assert.is_number (core.rand))))

    (it "is not the same when called twice"
        (fn []
          (assert.are_not.equal (core.rand) (core.rand))))))

(describe
  "first"
  (fn []
    (it "gets the first value"
        (fn []
          (assert.equals 1 (core.first [1 2 3]))))

    (it "returns nil for empty lists or nil"
        (fn []
          (assert.is_nil (core.first nil))
          (assert.is_nil (core.first []))))))

(describe
  "last"
  (fn []
    (it "gets the last value"
        (fn []
          (assert.equals 3 (core.last [1 2 3]))))

    (it "returns nil for empty lists or nil"
        (fn []
          (assert.is_nil (core.last nil))
          (assert.is_nil (core.last []))))))

(describe
  "butlast"
  (fn []
    (it "returns empty results where appropriate"
        (fn []
          (assert.are.same [] (core.butlast nil))
          (assert.are.same [] (core.butlast []))
          (assert.are.same [] (core.butlast [1]))))

    (it "works when there's more than one item"
        (fn []
          (assert.are.same [1 2] (core.butlast [1 2 3]))))))

(describe
  "rest"
  (fn []
    (it "returns empty where appropriate"
        (fn []
          (assert.are.same [] (core.rest nil))
          (assert.are.same [] (core.rest []))
          (assert.are.same [] (core.rest [1]))))

    (it "returns the rest if there's more than one value"
        (fn []
          (assert.are.same [2 3] (core.rest [1 2 3]))))))

(describe
  "second"
  (fn []
    (it "returns nil when required"
        (fn []
          (assert.is_nil (core.second []))
          (assert.is_nil (core.second nil))
          (assert.is_nil (core.second [1 nil 3]))))

    (it "returns the second item if there is one"
        (fn []
          (assert.equals 2 (core.second [1 2 3]))))))

(describe
  "string?"
  (fn []
    (it "returns true for strings"
        (fn []
          (assert.is_true (core.string? "foo"))
          (assert.is_false (core.string? nil))
          (assert.is_false (core.string? 10))))))

(describe
  "nil?"
  (fn []
    (it "returns true for strings"
        (fn []
          (assert.is_false (core.nil? "foo"))
          (assert.is_true (core.nil? nil))
          (assert.is_false (core.nil? 10))))))

(describe
  "some"
  (fn []
    (it "returns nil when nothing matches"
        (fn []
          (assert.is_nil (core.some #(and (> $1 5) $1) [1 2 3]))))

    (it "returns the first match"
        (fn []
          (assert.equals 3 (core.some #(and (> $1 2) $1) [1 2 3]))))

    (it "handles nils"
        (fn []
          (assert.equals 3 (core.some #(and $1 (> $1 2) $1) [nil 1 nil 2 nil 3 nil]))))))

(describe
  "inc"
  (fn []
    (it "increments numbers"
        (fn []
          (assert.equals 2 (core.inc 1))
          (assert.equals -4 (core.inc -5))))))

(describe
  "dec"
  (fn []
    (it "decrements numbers"
        (fn []
          (assert.equals 1 (core.dec 2))
          (assert.equals -6 (core.dec -5))))))

(describe
  "even?"
  (fn []
    (it "returns true for even numbers"
        (fn []
          (assert.is_true (core.even? 2))
          (assert.is_false (core.even? 3))))))

(describe
  "odd?"
  (fn []
    (it "returns true for odd numbers"
        (fn []
          (assert.is_false (core.odd? 2))
          (assert.is_true (core.odd? 3))))))

(fn sort-tables [t]
  (table.sort
    t
    (fn [x y]
      (if
        (and (= :table (type x)) (= :table (type y)))
        (< (core.first x) (core.first y))

        (not= (type x) (type y))
        (< (tostring x) (tostring y))

        (< x y))))
  t)

(describe
  "keys"
  (fn []
    (it "returns the keys of a map"
        (fn []
          (assert.are.same [] (core.keys nil))
          (assert.are.same [] (core.keys {}))
          (assert.are.same [:a :b] (sort-tables (core.keys {:a 2 :b 3})))))))

(describe
  "vals"
  (fn []
    (it "returns the values of a map"
        (fn []
          (assert.are.same [] (core.vals nil))
          (assert.are.same [] (core.vals {}))
          (assert.are.same [2 3] (sort-tables (core.vals {:a 2 :b 3})))))))

(describe
  "kv-pairs"
  (fn []
    (it "turns a map into key value pair tuples"
        (fn []
          (assert.are.same [] (core.kv-pairs nil))
          (assert.are.same [] (core.kv-pairs {}))
          (assert.are.same [[:a 1] [:b 2]] (sort-tables (core.kv-pairs {:a 1 :b 2})))
          (assert.are.same [[1 :a] [2 :b]] (sort-tables (core.kv-pairs [:a :b])))))))

(describe
  "pr-str"
  (fn []
    (it "prints a value into a string using Fennel's view function"
        (fn []
          (assert.equals "[1 2 3]" (core.pr-str [1 2 3]))
          (assert.equals "1 2 3" (core.pr-str 1 2 3))
          (assert.equals "nil" (core.pr-str nil))))))

(describe
  "str"
  (fn []
    (it "joins many things into one string, using pr-str on the arguments"
        (fn []
          (assert.equals "" (core.str))
          (assert.equals "" (core.str ""))
          (assert.equals "" (core.str nil))
          (assert.equals "abc" (core.str "abc"))
          (assert.equals "abc" (core.str "a" "b" "c"))
          (assert.equals "{:a \"abc\"}" (core.str {:a :abc}))
          (assert.equals "[1 2 3]abc" (core.str [1 2 3] "a" "bc"))))))

(describe
  "map"
  (fn []
    (it "maps a list to another list"
        (fn []
          (assert.are.same [2 3 4] (core.map core.inc [1 2 3]))))))

(describe
  "map-indexed"
  (fn []
    (it "maps a list to another list, providing the index to the map fn"
        (fn []
          (assert.are.same
            [[2 :a] [3 :b]]
            (core.map-indexed
              (fn [[k v]]
                [(core.inc k) v])
              [:a :b]))))))

(describe
  "complement"
  (fn []
    (it "inverts the boolean result of a function"
        (fn []
          (assert.is_true ((core.complement (fn [] false))))
          (assert.is_false ((core.complement (fn [] true))))))))

(describe
  "filter"
  (fn []
    (it "filters values out of a list"
        (fn []
          (assert.are.same [2 4 6] (core.filter #(= 0 (% $1 2)) [1 2 3 4 5 6]))
          (assert.are.same [] (core.filter #(= 0 (% $1 2)) nil))))))

(describe
  "remove"
  (fn []
    (it "removes matching items"
        (fn []
          (assert.are.same [1 3 5] (core.remove #(= 0 (% $1 2)) [1 2 3 4 5 6]))
          (assert.are.same [] (core.remove #(= 0 (% $1 2)) nil))))))

(describe
  "identity"
  (fn []
    (it "returns what you give it"
        (fn []
          (assert.equals :hello (core.identity :hello))
          (assert.is_nil (core.identity))))))

(describe
  "concat"
  (fn []
    (it "concatenates tables together"
        (fn []
          (let [orig [1 2 3]]
            (assert.are.same [1 2 3 4 5 6] (core.concat orig [4 5 6]))
            (assert.are.same [4 5 6 1 2 3] (core.concat [4 5 6] orig))
            (assert.are.same [1 2 3] orig))))))

(describe
  "mapcat"
  (fn []
    (it "maps and concats"
        (fn []
          (assert.are.same [1 :x 2 :x 3 :x] (core.mapcat (fn [n] [n :x]) [1 2 3]))))))

(describe
  "count"
  (fn []
    (it "counts various types"
        (fn []
          (assert.equals 3 (core.count [1 2 3]) "three values")
          (assert.equals 0 (core.count []) "empty")
          (assert.equals 0 (core.count nil) "nil")
          (assert.equals 0 (core.count nil) "no arg")
          (assert.equals 3 (core.count [1 nil 3]) "nil gap")
          (assert.equals 4 (core.count [nil nil nil :a]) "mostly nils")
          (assert.equals 3 (core.count "foo") "strings")
          (assert.equals 0 (core.count "") "empty strings")
          (assert.equals 2 (core.count {:a 1 :b 2}) "associative also works")))))

(describe
  "empty?"
  (fn []
    (it "checks if tables are empty"
        (fn []
          (assert.is_true (core.empty? []) "empty table")
          (assert.is_false (core.empty? [1]) "full table")
          (assert.is_true (core.empty? "") "empty string")
          (assert.is_false (core.empty? "a") "full string")))))

(describe
  "merge"
  (fn []
    (it "merges tables together in a pure way returning a new table"
        (fn []
          (assert.are.same {:a 1 :b 2} (core.merge {} {:a 1} {:b 2}) "simple maps")
          (assert.are.same {} (core.merge) "always start with an empty table")
          (assert.are.same {:a 1} (core.merge nil {:a 1}) "into nil")
          (assert.are.same {:a 1 :c 3} (core.merge {:a 1} nil {:c 3}) "nil in the middle")))))

(describe
  "merge!"
  (fn []
    (it "merges in a side effecting way into the first table"
        (fn []
          (let [result {:c 3}]
            (assert.are.same {:a 1 :b 2 :c 3} (core.merge! result {:a 1} {:b 2}) "simple maps")
            (assert.are.same {:a 1 :b 2 :c 3} result "the bang version side effects"))))))

(describe
  "select-keys"
  (fn []
    (it "pulls specific keys out of the table into a new one"
        (fn []
          (assert.are.same {} (core.select-keys nil [:a :b]) "no table")
          (assert.are.same {} (core.select-keys {} [:a :b]) "empty table")
          (assert.are.same {} (core.select-keys {:a 1 :b 2} nil) "no keys")
          (assert.are.same {} (core.select-keys nil nil) "nothing")
          (assert.are.same {:a 1 :c 3} (core.select-keys {:a 1 :b 2 :c 3} [:a :c]) "simple table and keys")))))

(describe
  "get"
  (fn []
    (it "pulls values out of tables"
        (fn []
          (assert.equals nil (core.get nil :a) "from nothing is nothing")
          (assert.equals nil (core.get {:a 1} nil) "nothing from something is nothing")
          (assert.equals 10 (core.get nil nil 10) "just a default returns a default")
          (assert.equals nil (core.get {:a 1} :b) "a missing key is nothing")
          (assert.equals 2 (core.get {:a 1} :b 2) "defaults replace missing")
          (assert.equals 1 (core.get {:a 1} :a) "results match")
          (assert.equals 1 (core.get {:a 1} :a 2) "results match (even with default)")
          (assert.equals :b (core.get [:a :b] 2) "sequential tables work too")))))

(describe
  "get-in"
  (fn []
    (it "works like get, but deeply using a path table"
        (fn []
          (assert.equals nil (core.get-in nil [:a]) "something from nil is nil")
          (assert.are.same {:a 1} (core.get-in {:a 1} []) "empty path is idempotent")
          (assert.equals 10 (core.get-in {:a {:b 10 :c 20}} [:a :b]) "two levels")
          (assert.equals 5 (core.get-in {:a {:b 10 :c 20}} [:a :d] 5) "default")))))

(describe
  "assoc"
  (fn []
    (it "puts values into tables"
        (fn []
          (assert.are.same {} (core.assoc nil nil nil) "3x nil is an empty map")
          (assert.are.same {} (core.assoc nil :a nil) "setting to nil is noop")
          (assert.are.same {} (core.assoc nil nil :a) "nil key is noop")
          (assert.are.same {:a 1} (core.assoc nil :a 1) "from nothing to one key")
          (assert.are.same [:a] (core.assoc nil 1 :a) "sequential")
          (assert.are.same {:a 1 :b 2} (core.assoc {:a 1} :b 2) "adding to existing")
          (assert.are.same {:a 1 :b 2 :c 3} (core.assoc {:a 1} :b 2 :c 3) "multi arg")
          (assert.are.same {:a 1 :b 2 :c 3 :d 4} (core.assoc {:a 1} :b 2 :c 3 :d 4) "more multi arg")
          (let [(ok? msg) (pcall #(core.assoc {:a 1} :b 2 :c))]
            (assert.is_false ok? "uneven args - ok?")
            (assert.equals "expects even number" (msg:match "expects even number") "uneven args - msg"))))))

(describe
  "assoc-in"
  (fn []
    (it "works like assoc but deeply with a path table"
        (fn []
          (assert.are.same {} (core.assoc-in nil nil nil) "empty as possible")
          (assert.are.same {} (core.assoc-in nil [] nil) "empty path, nothing else")
          (assert.are.same {} (core.assoc-in nil [] 2) "empty path and a value")
          (assert.are.same {:a 1} (core.assoc-in {:a 1} [] 2) "empty path, base table and a value")
          (assert.are.same {:a 1 :b 2} (core.assoc-in {:a 1} [:b] 2) "simple one path segment")
          (assert.are.same {:a 1 :b {:c 2}} (core.assoc-in {:a 1} [:b :c] 2) "two levels from base")
          (assert.are.same {:b {:c 2}} (core.assoc-in nil [:b :c] 2) "two levels from nothing")
          (assert.are.same {:a {:b [:c]}} (core.assoc-in nil [:a :b 1] :c) "mixing associative and sequential")))))

(describe
  "update"
  (fn []
    (it "updates a key with a function"
        (fn []
          (assert.are.same {:foo 2} (core.update {:foo 1} :foo core.inc) "increment a value")))))

(describe
  "update-in"
  (fn []
    (it "like update but nested with a path table"
        (fn []
          (assert.are.same
            {:foo {:bar 2}}
            (core.update-in {:foo {:bar 1}} [:foo :bar] core.inc)
            "increment a value")))))

(describe
  "constantly"
  (fn []
    (it "builds a function that always returns the same thing"
        (fn []
          (let [f (core.constantly :foo)]
            (assert.equals :foo (f))
            (assert.equals :foo (f :bar)))))))

(describe
  "spit / slurp"
  (fn []
    (local tmp-dir (vim.fn.tempname))
    (local tmp-path (fs.join-path [tmp-dir "foo.txt"]))
    (local expected-body "Hello, World!")
    (fs.mkdirp tmp-dir)

    (it "spits the contents into a file and can be read back with slurp"
        (fn []
          (core.spit tmp-path expected-body)
          (assert.equals expected-body (core.slurp tmp-path))))

    (it "returns nil if you slurp a nil or bad path"
        (fn []
          (assert.is_nil (core.slurp "nope does not exist"))
          (assert.is_nil (core.slurp nil))))

    (it "appends to a file if the :append option is set"
        (fn []
          (core.spit tmp-path "\nxyz" {:append true})
          (assert.equals (.. expected-body "\nxyz") (core.slurp tmp-path))))))

(describe
  "sort"
  (fn []
    (it "sorts tables without modifying the original"
        (fn []
          (assert.are.same [1 2 3] (core.sort [3 1 2]))))))

(describe
  "distinct"
  (fn []
    (it "does nothing to empty tables"
        (fn []
          (assert.are.same [] (core.distinct nil))
          (assert.are.same [] (core.distinct []))))

    (it "does nothing to already distinct lists"
        (fn []
          (assert.are.same [1 2 3] (sort-tables (core.distinct [1 2 3])))))

    (it "removes duplicates of any type"
        (fn []
          (assert.are.same [1 2 3] (sort-tables (core.distinct [1 2 2 3])))))

    (it "removes duplicates of any type"
        (fn []
          (assert.are.same [:a :b :c] (sort-tables (core.distinct [:a :b :c :c])))

          (let [t [1 2]]
            (assert.are.same [:a :c t] (sort-tables (core.distinct [:a t :c t :c]))))))))

(describe
  "clear-table!"
  (fn []
    (it "clears a table"
        (fn []
          (let [t {:a 1 :b 2}]
            (core.clear-table! t)
            (assert.are.same {} t))))))

(describe
  "sequential?"
  (fn []
    (it "returns true for sequential tables"
        (fn []
          (assert.is_true (core.sequential? [1 2 3]))
          (assert.is_true (core.sequential? []))
          (assert.is_false (core.sequential? {:a 1 :b 2}))
          (assert.is_false (core.sequential? nil))
          (assert.is_false (core.sequential? "foo"))
          nil))))

(describe
  "seq"
  (fn []
    (it "converts appropriately as the docstring says"
        (fn []
          (assert.are.same [1 2 3] (core.seq [1 2 3]))
          (assert.are.same nil (core.seq nil))
          (assert.are.same nil (core.seq {}))
          (assert.are.same nil (core.seq ""))
          (assert.are.same ["f" "o" "o" " " "b" "a" "r"] (core.seq "foo bar"))
          (assert.are.same nil (core.seq ""))
          (assert.are.same [[:a :b]] (core.seq {:a :b}))
          nil))))

(describe
  "take-while"
  (fn []
    (it "takes values while f is true"
        (fn []
          (assert.are.same [1 2 3] (core.take-while #(> $1 0) [1 2 3 -1 -2 -3]))
          (assert.are.same [] (core.take-while #(> $1 0) [-1 -2 -3]))
          (assert.are.same nil (core.take-while #(> $1 0) nil))
          (assert.are.same
            [[:hi :world]]
            (core.take-while #(= (. $1 1) :hi) {:hi :world}))
          nil))))

(describe
  "drop-while"
  (fn []
    (it "drops values while f is true"
        (fn []
          (assert.are.same [1 2 3] (core.drop-while #(< $1 0) [-1 -2 -3 1 2 3]))
          (assert.are.same [2 3] (core.drop-while #(< $1 2) [1 2 3]))
          (assert.are.same nil (core.drop-while #(> $1 0) nil))
          (assert.are.same [] (core.drop-while #(= (. $1 1) :hi) {:hi :world}))
          nil))))
