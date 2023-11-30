(local {: autoload} (require :nfnl.module))
(local compile (autoload :nfnl.compile))
(local config (autoload :nfnl.config))
(local fs (autoload :nfnl.fs))

(local mod {})

(fn mod.compile-all-files [dir]
  "Compiles all files in the given dir (optional), defaulting to the current working directory. Returns a sequential table with each of the files compilation result.

  Will do nothing if you execute it on a directory that doesn't contain an nfnl configuration file."
  (let [dir (or dir (vim.fn.getcwd))
        {: config : root-dir : cfg} (config.find-and-load dir)]
    (when config
      (compile.all-files {: root-dir : cfg}))))

(fn mod.dofile [file]
  "Just like :luafile, takes a Fennel file path (optional, defaults to '%', runs it through expand) and executes it from disk. However! This doesn't compile the Fennel! It maps the Fennel path to the matching Lua file already in your file system and executes that with Lua's built in dofile. So you need to have already written your .fnl and had nfnl compile that to a .lua for this to work, it's just a convinience function for you to call directly or through the :nfnlfile command."
  (dofile (fs.fnl-path->lua-path (vim.fn.expand (or file "%")))))

mod
