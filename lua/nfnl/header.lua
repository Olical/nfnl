-- [nfnl] fnl/nfnl/header.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local define = _local_1_["define"]
local core = autoload("nfnl.core")
local str = autoload("nfnl.string")
local M = define("nfnl.header")
local tag = "[nfnl]"
M["with-header"] = function(file, src)
  return ("-- " .. tag .. " " .. file .. "\n" .. src)
end
M["tagged?"] = function(s)
  return core["number?"](s:find(tag, 1, true))
end
M["source-path"] = function(s)
  if M["tagged?"](s) then
    return core.last(str.split(s, "%s+"))
  else
    return nil
  end
end
return M
