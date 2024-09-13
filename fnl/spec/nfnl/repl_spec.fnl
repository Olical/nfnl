(local {: describe : it} (require :plenary.busted))
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

          nil))))
