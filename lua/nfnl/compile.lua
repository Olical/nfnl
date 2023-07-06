-- [nfnl] Compiled from fnl/nfnl/compile.fnl by https://github.com/Olical/nfnl, do not edit.
local autoload = require("nfnl.autoload")
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local fennel = autoload("nfnl.fennel")
local notify = autoload("nfnl.notify")
local mod = {}
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
local function macro_source_3f(source)
  return string.find(source, "%s*;+%s*%[nfnl%-macro%]")
end
mod["into-file"] = function(_1_)
  local _arg_2_ = _1_
  local root_dir = _arg_2_["root-dir"]
  local path = _arg_2_["path"]
  local cfg = _arg_2_["cfg"]
  local source = _arg_2_["source"]
  local batch_3f = _arg_2_["batch?"]
  local macro_3f = macro_source_3f(source)
  if (macro_3f and batch_3f) then
    return {status = "macros-are-not-compiled", ["source-path"] = path}
  elseif macro_3f then
    return mod["all-files"]({["root-dir"] = root_dir, cfg = cfg})
  else
    local rel_file_name = path:sub((2 + root_dir:len()))
    local destination_path = fnl_path__3elua_path(path)
    local ok, res = nil, nil
    do
      fennel.path = cfg({"fennel_path"})
      fennel["macro-path"] = cfg({"fennel_macro_path"})
      ok, res = pcall(fennel.compileString, source, core.merge({filename = path}, cfg({"compiler_options"})))
    end
    if ok then
      if safe_target_3f(destination_path) then
        fs.mkdirp(fs.basename(destination_path))
        core.spit(destination_path, (with_header(rel_file_name, res) .. "\n"))
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
end
mod["all-files"] = function(_6_)
  local _arg_7_ = _6_
  local root_dir = _arg_7_["root-dir"]
  local cfg = _arg_7_["cfg"]
  local function _8_(path)
    return mod["into-file"]({["root-dir"] = root_dir, path = path, cfg = cfg, source = core.slurp(path), ["batch?"] = true})
  end
  local function _9_(_241)
    return fs.relglob(root_dir, _241)
  end
  return core.map(_8_, core.map(fs["full-path"], core.mapcat(_9_, cfg({"source_file_patterns"}))))
end
return mod
