-- [nfnl] Compiled from fnl/nfnl/api.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local compile = autoload("nfnl.compile")
local config = autoload("nfnl.config")
local function compile_all_files(dir)
  local dir0 = (dir or vim.fn.getcwd())
  local _let_2_ = config["find-and-load"](dir0)
  local config0 = _let_2_["config"]
  local root_dir = _let_2_["root-dir"]
  local cfg = _let_2_["cfg"]
  if config0 then
    return compile["all-files"]({["root-dir"] = root_dir, cfg = cfg})
  else
    return nil
  end
end
return {["compile-all-files"] = compile_all_files}
