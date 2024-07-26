(local {: describe : it : before_each : after_each} (require :plenary.busted))
(local assert (require :luassert.assert))
(local core (require :nfnl.core))
(local fs (require :nfnl.fs))
(local nfnl (require :nfnl))

(nfnl.setup {})

;; These temp directories are auto deleted on Neovim exit.
(local temp-dir (vim.fs.normalize (vim.fn.tempname)))
(local unrelated-temp-dir (vim.fs.normalize (vim.fn.tempname)))

(local fnl-dir (fs.join-path [temp-dir "fnl"]))
(local lua-dir (fs.join-path [temp-dir "lua"]))
(local config-path (fs.join-path [temp-dir ".nfnl.fnl"]))
(local fnl-path (fs.join-path [fnl-dir "foo.fnl"]))
(local macro-fnl-path (fs.join-path [fnl-dir "bar.fnl"]))
(local macro-lua-path (fs.join-path [lua-dir "bar.lua"]))
(local lua-path (fs.join-path [lua-dir "foo.lua"]))

(fs.mkdirp fnl-dir)
(fs.mkdirp unrelated-temp-dir)

(fn delete-buf-file [path]
  (pcall vim.cmd (.. "bwipeout! " path))
  (os.remove path))

(fn run-e2e-tests []
  ;; Reset the files between each test run.
  (core.run! delete-buf-file [config-path fnl-path macro-fnl-path lua-path])

  (it "does nothing when there's no .nfnl.fnl configuration"
      (fn []
        (vim.cmd (.. "edit " fnl-path))
        (set vim.o.filetype "fennel")
        (vim.api.nvim_buf_set_lines 0 0 -1 false ["(print \"Hello, World!\")"])
        (vim.cmd "write")
        (assert.is_nil (core.slurp lua-path))))

  (it "compiles when there's a trusted .nfnl.fnl configuration file"
      (fn []
        (vim.cmd (.. "edit " config-path))
        (vim.api.nvim_buf_set_lines 0 0 -1 false ["{}"])
        (vim.cmd "write")
        (when (not= "false" vim.env.NFNL_USE_SECURE_READ)
          (vim.cmd "trust"))
        (vim.cmd (.. "edit " fnl-path))
        (set vim.o.filetype "fennel")
        (vim.api.nvim_buf_set_lines 0 0 -1 false ["(print \"Hello, World!\")"])
        (vim.cmd "write")
        (assert.are.equal 1 (vim.fn.isdirectory lua-dir))

        (local lua-result (core.slurp lua-path))
        (print "Lua result:" lua-result)

        (assert.are.equal
          "-- [nfnl] Compiled from fnl/foo.fnl by https://github.com/Olical/nfnl, do not edit.\nreturn print(\"Hello, World!\")\n"
          lua-result)))

  (it "can import-macros and use them, the macros aren't compiled"
      (fn []
        (vim.cmd (.. "edit " macro-fnl-path))
        (set vim.o.filetype "fennel")

        ;; We have to split up the macro marker otherwise this file gets marked as a macro file and won't compile.
        (vim.api.nvim_buf_set_lines 0 0 -1 false [(.. ";; [nfnl" "-" "macro]") "{:infix (fn [a op b] `(,op ,a ,b))}"])
        (vim.cmd "write")

        (vim.cmd (.. "edit " fnl-path))
        (set vim.o.filetype "fennel")
        (vim.api.nvim_buf_set_lines 0 0 -1 false ["(import-macros {: infix} :bar)" "(infix 10 + 20)"])
        (vim.cmd "write")

        (assert.is_nil (core.slurp macro-lua-path))

        (local lua-result (core.slurp lua-path))
        (print "Lua result:" lua-result)

        (assert.are.equal
          "-- [nfnl] Compiled from fnl/foo.fnl by https://github.com/Olical/nfnl, do not edit.\nreturn (10 + 20)\n"
          lua-result))))

(describe
  "e2e file compiling from a project dir"
  (fn []
    (var initial-cwd nil)

    (before_each
      (fn []
        (set initial-cwd (fs.cwd))
        (vim.api.nvim_set_current_dir temp-dir)))

    (after_each
      (fn []
        (vim.api.nvim_set_current_dir initial-cwd)))

    (run-e2e-tests)))

(describe
  "e2e file compiling from outside project dir"
  (fn []
    (var initial-cwd nil)

    (before_each
      (fn []
        (set initial-cwd (fs.cwd))
        (vim.api.nvim_set_current_dir unrelated-temp-dir)))

    (after_each
      (fn []
        (vim.api.nvim_set_current_dir initial-cwd)))

    (run-e2e-tests)))
