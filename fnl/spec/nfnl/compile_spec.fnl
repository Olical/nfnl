(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local config (require :nfnl.config))
(local compile (require :nfnl.compile))

(describe
  "into-string"
  (fn []
    (it "compiles good Fennel to Lua"
        (fn []
          (assert.are.same
            {:result "-- [nfnl] Compiled from bar.fnl by https://github.com/Olical/nfnl, do not edit.\nreturn (10 + 20)\n"
             :source-path "/tmp/foo/bar.fnl"
             :status "ok"}
            (compile.into-string
              {:root-dir "/tmp/foo"
               :path "/tmp/foo/bar.fnl"
               :cfg (config.cfg-fn {} {:root-dir "/tmp/foo"})
               :batch? true
               :file-exists-on-disk? false
               :source "(+ 10 20)"}))))

    (it "skips macro files"
        (fn []
          (assert.are.same
            {:source-path "/my/dir/foo.fnl"
             :status "macros-are-not-compiled"}
            (compile.into-string
              {:root-dir "/my/dir"
               :path "/my/dir/foo.fnl"
               :cfg (config.cfg-fn {} {:root-dir "/tmp/foo"})
               :batch? true
               :file-exists-on-disk? false
               :source (.. "; [nfnl" "-" "macro]\n(+ 10 20)")}))))

    (it "won't compile the .nfnl.fnl config file"
        (fn []
          (assert.are.same
            {:source-path "/my/dir/.nfnl.fnl"
             :status "nfnl-config-is-not-compiled"}
            (compile.into-string
              {:root-dir "/my/dir"
               :path "/my/dir/.nfnl.fnl"
               :cfg (config.cfg-fn {} {:root-dir "/tmp/foo"})
               :batch? true
               :file-exists-on-disk? false
               :source "(+ 10 20)"}))))

    (it "returns compilation errors"
        (fn []
          (assert.are.same
            {:error "/my/dir/foo.fnl:1:3: Compile error: tried to reference a special form without calling it\n\n10 / 20\n* Try making sure to use prefix operators, not infix.\n* Try wrapping the special in a function if you need it to be first class."
             :source-path "/my/dir/foo.fnl"
             :status "compilation-error"}
            (compile.into-string
              {:root-dir "/my/dir"
               :path "/my/dir/foo.fnl"
               :cfg (config.cfg-fn {} {:root-dir "/tmp/foo"})
               :batch? true
               :file-exists-on-disk? false
               :source "10 / 20"}))))))
