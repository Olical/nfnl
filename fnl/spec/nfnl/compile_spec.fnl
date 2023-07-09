(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local compile (require :nfnl.compile))

; (describe
;   "rand"
;   (fn []
;     (math.randomseed (os.time))

;     (it "returns a number"
;         (fn []
;           (assert.is_number (core.rand))))

;     (it "is not the same when called twice"
;         (fn []
;           (assert.are_not.equal (core.rand) (core.rand))))))
