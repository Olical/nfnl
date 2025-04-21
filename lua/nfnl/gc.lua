-- [nfnl] fnl/nfnl/gc.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local define = _local_1_["define"]
local core = autoload("nfnl.core")
local str = autoload("nfnl.string")
local fs = autoload("nfnl.fs")
local M = define("nfnl.gc")
M["find-orphan-lua-files"] = function(_2_)
  local cfg = _2_["cfg"]
  local root_dir = _2_["root-dir"]
  local fnl_path__3elua_path = cfg({"fnl-path->lua-path"})
  local function _3_(path)
    local header = fs["read-first-line"](path)
    return (header and not core["nil?"](header:find("[nfnl]", 1, true)) and not vim.uv.fs_stat(core.last(str.split(path, "%s+"))))
  end
  local function _4_(fnl_pattern)
    local lua_pattern = fnl_path__3elua_path(fnl_pattern)
    return fs.absglob(root_dir, lua_pattern)
  end
  return core.filter(_3_, core.keys(core["->set"](core.mapcat(_4_, cfg({"source-file-patterns"})))))
end
--[[ (local config (require "nfnl.config")) (M.find-orphan-lua-files (config.find-and-load ".")) ]]
return M
