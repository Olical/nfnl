-- [nfnl] fnl/nfnl/header.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local define = _local_1_["define"]
local core = autoload("nfnl.core")
local M = define("nfnl.header")
local tag = "[nfnl]"
M["with-header"] = function(file, src)
  return ("-- " .. tag .. " " .. file .. "\n" .. src)
end
M["tagged?"] = function(s)
  return core["string?"](s:find(tag, 1, true))
end
return M
