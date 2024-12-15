(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local {: autoload : define} (require :nfnl.module))

(describe
  "autoload"
  (fn []
    (it "loads modules when their properties are accessed"
        (fn []
          (local core (autoload :nfnl.core))
          (assert.equals 2 (core.inc 1))

          nil))))

(describe
  "define"
  (fn []
    (it "returns the loaded module if it's the same type as the base"
        (fn []
          (local m2 (define :nfnl.module {}))
          (assert.equals define m2.define)

          (local m3 (define :nfnl.module.nope {:nope true}))
          (assert.equals nil m3.define)
          (assert.equals true m3.nope)

          nil))))
