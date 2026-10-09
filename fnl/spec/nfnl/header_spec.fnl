(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local header (require :nfnl.header))

(describe
  "tagged?"
  (fn []
    (it "accepts the header nfnl writes"
        (fn []
          (assert.is_true (header.tagged? (header.with-header "fnl/foo.fnl" "")))
          (assert.is_true (header.tagged? "-- [nfnl] fnl/foo.fnl"))))

    (it "rejects lines that mention the tag elsewhere"
        (fn []
          (assert.is_false (header.tagged? "-- The [nfnl] marker below shows the source."))
          (assert.is_false (header.tagged? "print(\"-- [nfnl] fnl/foo.fnl\")"))
          (assert.is_false (header.tagged? "--[nfnl] fnl/foo.fnl"))))

    (it "rejects missing lines"
        (fn []
          (assert.is_false (header.tagged? nil))))))

(describe
  "source-path"
  (fn []
    (it "finds the source path in a header"
        (fn []
          (assert.equals "fnl/foo.fnl" (header.source-path "-- [nfnl] fnl/foo.fnl"))))

    (it "ignores lines that only mention the tag"
        (fn []
          (assert.is_nil (header.source-path "-- See [nfnl] fnl/foo.fnl"))))))

(describe
  "read"
  (fn []
    (it "skips comments that mention the tag above the real header"
        (fn []
          (let [path (vim.fn.tempname)]
            (with-open [f (io.open path "w")]
              (f:write "#!/usr/bin/lua\n-- The [nfnl] marker below shows the source.\n-- [nfnl] fnl/foo.fnl\nreturn 1\n"))
            (let [(line prefix) (header.read path 5)]
              (assert.equals "-- [nfnl] fnl/foo.fnl" line)
              (assert.equals "#!/usr/bin/lua\n-- The [nfnl] marker below shows the source.\n" prefix))
            (os.remove path))))))
