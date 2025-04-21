-- [nfnl] fnl/nfnl/gc.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local define = _local_1_["define"]
local fs = autoload("nfnl.fs")
local M = define("nfnl.gc")
M["find-orphan-lua-files"] = function()
  return fs.relglob(".", "**/*.lua")
end
return M
