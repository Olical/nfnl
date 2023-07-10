(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local {: autoload} (require :nfnl.module))

(describe
  "autoload"
  (fn []
    (it "loads modules when their properties are accessed"
        (fn []
          (local core (autoload :nfnl.core))
          (assert.equals 2 (core.inc 1))))))

