-- [nfnl] fnl/nfnl/header.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local define = _local_1_.define
local core = autoload("nfnl.core")
local str = autoload("nfnl.string")
local M = define("nfnl.header")
local header_prefix = "-- [nfnl]"
M["with-header"] = function(file, src)
  return (header_prefix .. " " .. file .. "\n" .. src)
end
M["tagged?"] = function(s)
  return (("string" == type(s)) and str["starts-with?"](s, (header_prefix .. " ")))
end
M.read = function(path, max_lines)
  assert((("number" == type(max_lines)) and (max_lines >= 1) and (max_lines == math.floor(max_lines))), "header-search-lines must be a positive integer")
  local f = io.open(path, "r")
  if f then
    local first_line = f:read("*line")
    local prefix = {}
    local line = first_line
    local line_number = 1
    while (line and not M["tagged?"](line) and (line_number < max_lines)) do
      table.insert(prefix, (line .. "\n"))
      line = f:read("*line")
      line_number = (line_number + 1)
    end
    f:close()
    if M["tagged?"](line) then
      return line, table.concat(prefix)
    else
      return first_line
    end
  else
    return nil
  end
end
M["source-path"] = function(s)
  if M["tagged?"](s) then
    local function _4_(part)
      return (str["ends-with?"](part, ".fnl") and part)
    end
    return core.some(_4_, str.split(s, "%s+"))
  else
    return nil
  end
end
return M
