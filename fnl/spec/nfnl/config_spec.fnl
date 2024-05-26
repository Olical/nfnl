(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local config (require :nfnl.config))
(local fs (require :nfnl.fs))
(local str (require :nfnl.string))

;; wraps str.ends-with? throws an error if false that explains it for the test suite
(fn assert-ends-with? [s end]
  (if (str.ends-with? s end)
    true
    (error (string.format "expected %s to end with %s" s end))))

(describe
  "default"
  (fn []
    (it "is a function that returns a table"
        (fn []
          (assert.equals :function (type config.default))
          (assert.equals :table (type (config.default {:root-dir "/tmp/foo"})))
          (assert-ends-with?
            (. (config.default {}) :root-dir)
            "/.nfnl.fnl")))))

(describe
  "cfg-fn"
  (fn []
    (it "builds a function that looks up values in a table falling back to defaults"
        (fn []
          (local opts {:root-dir "/tmp/foo"})
          (assert.is_string ((config.cfg-fn {} opts) [:fennel-macro-path]))
          (assert.is_nil ((config.cfg-fn {} opts) [:nope]))
          (assert.equals :yep ((config.cfg-fn {:nope :yep} opts) [:nope]))
          (assert.equals :yep ((config.cfg-fn {:fennel-macro-path :yep} opts) [:fennel-macro-path]))))))

(describe
  "config-file-path?"
  (fn []
    (it "returns true for config file paths"
        (fn []
          (assert.is_true (config.config-file-path? "./foo/.nfnl.fnl"))
          (assert.is_true (config.config-file-path? ".nfnl.fnl"))
          (assert.is_false (config.config-file-path? ".fnl.fnl"))))))

(describe
  "find-and-load"
  (fn []
    (it "loads the repo config file"
        (fn []
          (let [{: cfg : root-dir : config}
                (config.find-and-load ".")]
            (assert.are.same {:verbose true} config)
            (assert.equals (vim.fn.getcwd) root-dir)
            (assert.equals :function (type cfg)))))

    (it "returns an empty table if a config file isn't found"
        (fn []
          (assert.are.same {} (config.find-and-load "/some/made/up/dir"))))))

(fn sorted [xs]
  (table.sort xs)
  xs)

(describe
  "path-dirs"
  (fn []
    (it "builds path dirs from runtimepath, deduplicates the base-dirs"
        (fn []
          (assert.are.same
            ["/foo/bar/nfnl" "/foo/baz/my-proj"]
            (sorted
              (config.path-dirs
                {:runtimepath "/foo/bar/nfnl,/foo/bar/other-thing"
                 :rtp-patterns [(.. (fs.path-sep) "nfnl$")]
                 :base-dirs ["/foo/baz/my-proj"]})))

          (assert.are.same
            ["/foo/bar/nfnl" "/foo/baz/my-proj"]
            (sorted
              (config.path-dirs
                {:runtimepath "/foo/bar/nfnl,/foo/bar/other-thing"
                 :rtp-patterns [(.. (fs.path-sep) "nfnl$")]
                 :base-dirs ["/foo/baz/my-proj" "/foo/bar/nfnl"]})))))))
