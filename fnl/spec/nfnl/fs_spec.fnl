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
          (assert.equals "." (fs.basename "baz.fnl"))))

    (it "happily lets nils flow back out"
        (fn []
          (assert.is_nil (fs.basename nil))))))

(describe
  "path-sep"
  (fn []
    (it "returns the OS path separator (test assumes Linux)"
        (fn []
          (assert.equals "/" (fs.path-sep))))))

(describe
  "replace-extension"
  (fn []
    (it "replaces extensions"
        (fn []
          (assert.equals "foo.lua" (fs.replace-extension "foo.fnl" "lua"))))))

(describe
  "split-path"
  (fn []
    (it "splits a path into parts"
        (fn []
          (assert.are.same ["foo" "bar" "baz"] (fs.split-path "foo/bar/baz"))
          (assert.are.same ["" "foo" "bar" "baz"] (fs.split-path "/foo/bar/baz"))))))

(describe
  "join-path"
  (fn []
    (it "joins a path together"
        (fn []
          (assert.equals "foo/bar/baz" (fs.join-path ["foo" "bar" "baz"]))
          (assert.equals "/foo/bar/baz" (fs.join-path ["" "foo" "bar" "baz"]))))))

(describe
  "replace-dirs"
  (fn []
    (it "replaces directories in a path that match a string with another string"
        (fn []
          (assert.equals "foo/lua/bar" (fs.replace-dirs "foo/fnl/bar" "fnl" "lua"))
          (assert.equals "/foo/lua/bar" (fs.replace-dirs "/foo/fnl/bar" "fnl" "lua"))
          (assert.equals "/foo/nfnl/bar" (fs.replace-dirs "/foo/nfnl/bar" "fnl" "lua"))))))
