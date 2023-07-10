(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local fs (require :nfnl.fs))

(describe
  "basename"
  (fn []
    (it "removes the last segment of a path"
        (fn []
          (assert.equals "foo" (fs.basename "foo/bar.fnl"))
          (assert.equals "foo/bar" (fs.basename "foo/bar/baz.fnl"))
          (assert.equals "." (fs.basename "baz.fnl"))))))

(describe
  "path-sep"
  (fn []
    (it "returns the OS path separator (test assumes Linux)"
        (fn []
          (assert.equals "/" (fs.path-sep))))))
