(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local callback (require :nfnl.callback))

(describe
  "supported-path?"
  (fn []
    (it "rejects non-strings"
        (fn []
          (assert.false (callback.supported-path? nil))
          (assert.false (callback.supported-path? 10))))

    (it "rejects fugitive or ddu-ff protcols"
        (fn []
          (assert.false (callback.supported-path? "fugitive://foo/bar"))
          (assert.false (callback.supported-path? "ddu-ff:/xyz/foo/bar"))))

    (it "allows all other strings"
        (fn []
          (assert.true (callback.supported-path? "/foo/bar/baz"))
          (assert.true (callback.supported-path? "./x/y/z.foo"))
          (assert.true (callback.supported-path? "henlo.world"))))))
