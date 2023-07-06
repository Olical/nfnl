-- [nfnl] Compiled from fnl/nfnl/compile.fnl by https://github.com/Olical/nfnl, do not edit.
local autoload = require("nfnl.autoload")
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local fennel = autoload("nfnl.fennel")
local notify = autoload("nfnl.notify")
local header_marker = "[nfnl]"
local function with_header(file, src)
  return ("-- " .. header_marker .. " Compiled from " .. file .. " by https://github.com/Olical/nfnl, do not edit.\n" .. src)
end
local function safe_target_3f(path)
  local header = fs["read-first-line"](path)
  return (core["nil?"](header) or not core["nil?"](header:find(header_marker, 1, true)))
end
local function fnl_path__3elua_path(fnl_path)
  return fs["replace-dirs"](fs["replace-extension"](fnl_path, "lua"), "fnl", "lua")
end
local function into_file(_1_)
  local _arg_2_ = _1_
  local root_dir = _arg_2_["root-dir"]
  local path = _arg_2_["path"]
  local cfg = _arg_2_["cfg"]
  local source = _arg_2_["source"]
  local rel_file_name = path:sub((2 + root_dir:len()))
  local destination_path = fnl_path__3elua_path(path)
  local ok, res = pcall(fennel.compileString, source, core.merge({filename = path}, cfg({"compiler_options"})))
  if ok then
    if safe_target_3f(destination_path) then
      fs.mkdirp(fs.basename(destination_path))
      return core.spit(destination_path, with_header(rel_file_name, res))
    else
      return notify.warn(destination_path, " was not compiled by nfnl. Delete it manually if you wish to compile into this file.")
    end
  else
    return notify.error(res)
  end
end
return {["into-file"] = into_file}