-- [nfnl] Compiled from fnl/nfnl/init.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local compile = autoload("nfnl.compile")
local config = autoload("nfnl.config")
local notify = autoload("nfnl.notify")
local callback = autoload("nfnl.callback")
if vim then
  if (0 == _G.vim.fn.has("nvim-0.9.0")) then
    error("nfnl requires Neovim > v0.9.0.")
  else
  end
  vim.api.nvim_create_autocmd({"Filetype"}, {group = vim.api.nvim_create_augroup("nfnl-setup", {}), pattern = "fennel", callback = callback["fennel-filetype-callback"]})
else
end
local function setup()
  return "A noop for now, may be used one day. You just need to load this module for the plugin to initialise for now."
end
local function compile_all_files(dir)
  local dir0 = (dir or vim.fn.getcwd())
  local _let_4_ = config["find-and-load"](dir0)
  local config0 = _let_4_["config"]
  local root_dir = _let_4_["root-dir"]
  local cfg = _let_4_["cfg"]
  if config0 then
    return notify.info("Compilation complete.\n", compile["all-files"]({["root-dir"] = root_dir, cfg = cfg}))
  else
    return notify.warn("No .nfnl.fnl configuration found.")
  end
end
return {setup = setup, ["compile-all-files"] = compile_all_files}
