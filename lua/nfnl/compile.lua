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
      core.spit(destination_path, with_header(rel_file_name, res))
      return {status = "ok", ["source-path"] = path, ["destination-path"] = destination_path}
    else
      notify.warn(destination_path, " was not compiled by nfnl. Delete it manually if you wish to compile into this file.")
      return {status = "destination-exists", ["source-path"] = path, ["destination-path"] = destination_path}
    end
  else
    notify.error(res)
    return {status = "compilation-error", error = res, ["source-path"] = path, ["destination-path"] = destination_path}
  end
end
local function all_files(_5_)
  local _arg_6_ = _5_
  local root_dir = _arg_6_["root-dir"]
  local cfg = _arg_6_["cfg"]
  local function _7_(path)
    return into_file({["root-dir"] = root_dir, path = path, cfg = cfg, source = core.slurp(path)})
  end
  local function _8_(_241)
    return fs.relglob(root_dir, _241)
  end
  return core.map(_7_, core.map(fs["full-path"], core.mapcat(_8_, cfg({"source_file_patterns"}))))
end
return {["into-file"] = into_file, ["all-files"] = all_files}