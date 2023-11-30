(local {: autoload} (require :nfnl.module))
(local compile (autoload :nfnl.compile))
(local config (autoload :nfnl.config))

(fn compile-all-files [dir]
  "Compiles all files in the given dir (optional), defaulting to the current working directory. Returns a sequential table with each of the files compilation result.

  Will do nothing if you execute it on a directory that doesn't contain an nfnl configuration file."
  (let [dir (or dir (vim.fn.getcwd))
        {: config : root-dir : cfg} (config.find-and-load dir)]
    (when config
      (compile.all-files {: root-dir : cfg}))))

{: compile-all-files}
