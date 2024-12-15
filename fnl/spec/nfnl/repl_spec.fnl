(local {: describe : it} (require :plenary.busted))
(local core (require :nfnl.core))
(local assert (require :luassert.assert))
(local repl (require :nfnl.repl))

(describe
  "repl"
  (fn []
    (it "starts a REPL that we can confinually call with more code"
        (fn []
          (local r (repl.new))
          (assert.are.same [[10 20]] (r "[10 20]"))

          (assert.are.same [:foo :bar] (r ":foo :bar\n"))
          (assert.are.same [:foo :bar] (r "(values :foo :bar)"))

          ;; A nil closes the REPL and returns nil.
          (assert.are.same nil (r))
          (assert.are.same nil (r ":foo"))

          nil))

    (it "can handle function references, tables and multiple REPLs"
        (fn []
          (let [r1 (repl.new)
                r2 (repl.new)
                code "(fn a []) (fn b []) {: a : b}"
                pat "%[#<function: 0x%x+>%s+#<function: 0x%x+>%s+{:%w #<function: 0x%x+> :%w #<function: 0x%x+>}%]"]
            (assert.matches pat (core.pr-str (r1 code)))
            (assert.matches pat (core.pr-str (r2 code)))
            (assert.matches pat (core.pr-str (r1 code)))
            (assert.matches pat (core.pr-str (r2 code))))

          nil))))
