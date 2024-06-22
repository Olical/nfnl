(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local fs (require :nfnl.fs))

(fn windows? [] (= jit.os "Windows"))

(describe
  "basename"
  (fn []
    (it "removes the last segment of a path"
        (fn []
          (assert.equals "foo" (fs.basename (fs.join-path ["foo" "bar.fnl"])))
          (assert.equals (fs.join-path ["foo" "bar"]) (fs.basename (fs.join-path ["foo" "bar" "baz.fnl"])))
          (assert.equals "." (fs.basename "baz.fnl"))))

    (it "happily lets nils flow back out"
        (fn []
          (assert.is_nil (fs.basename nil))))))

(describe
  "path-sep"
  (fn []
    (it "returns the OS path separator"
        (fn []
            (if (windows?)
                (assert.equals "\\" (fs.path-sep))
                (assert.equals "/" (fs.path-sep)))))))

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
            (assert.are.same ["foo" "bar" "baz"] (fs.split-path (fs.correct-separators "foo/bar/baz"))z)
            (assert.are.same ["" "foo" "bar" "baz"] (fs.split-path (fs.correct-separators "/foo/bar/baz")))))))

(describe
  "join-path"
  (fn []
    (it "joins a path together"
        (fn []
            (assert.equals "foo/bar/baz" (fs.standardize-path (fs.join-path ["foo" "bar" "baz"])))
            (assert.equals "/foo/bar/baz" (fs.standardize-path (fs.join-path ["" "foo" "bar" "baz"])))))))

(describe
  "replace-dirs"
  (fn []
    (it "replaces directories in a path that match a string with another string"
        (fn []
            (assert.equals "foo/lua/bar" (fs.standardize-path (fs.replace-dirs (fs.correct-separators "foo/fnl/bar") "fnl" "lua")))
            (assert.equals "/foo/lua/bar" (fs.standardize-path (fs.replace-dirs (fs.correct-separators "/foo/fnl/bar") "fnl" "lua")))
            (assert.equals "/foo/nfnl/bar" (fs.standardize-path (fs.replace-dirs "/foo/nfnl/bar" "fnl" "lua")))))))

(describe
  "standardize-path"
  (fn []
    (it "replaces all path separators with forward slash"
        (fn []
          (assert.equals "foo/bar/baz.fnl" (fs.standardize-path "foo\\bar\\baz.fnl"))
          (assert.equals "foo/bar/baz.fnl" (fs.standardize-path "foo/bar/baz.fnl"))))))

(describe
  "correct-separators"
  (fn []
    (it ""
        (fn []
          (if (windows?)
              (do (assert.equals "foo\\bar\\baz.fnl" (fs.correct-separators "foo/bar/baz.fnl"))
                  (assert.equals "foo\\bar\\baz.fnl" (fs.correct-separators "foo\\bar\\baz.fnl")))
              (do (assert.equals "foo/bar/baz.fnl" (fs.correct-separators "foo/bar/baz.fnl"))
                  (assert.equals "foo/bar/baz.fnl" (fs.correct-separators "foo\\bar\\baz.fnl"))))))))
