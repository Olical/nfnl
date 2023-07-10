-- [nfnl] Compiled from fnl/nfnl/compile.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local fennel = autoload("nfnl.fennel")
local notify = autoload("nfnl.notify")
local config = autoload("nfnl.config")
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
mod["into-string"] = function(_2_)
  local _arg_3_ = _2_
  local root_dir = _arg_3_["root-dir"]
  local path = _arg_3_["path"]
  local cfg = _arg_3_["cfg"]
  local source = _arg_3_["source"]
  local batch_3f = _arg_3_["batch?"]
  local macro_3f = macro_source_3f(source)
  if (macro_3f and batch_3f) then
    return {status = "macros-are-not-compiled", ["source-path"] = path}
  elseif macro_3f then
    return mod["all-files"]({["root-dir"] = root_dir, cfg = cfg})
  elseif config["config-file-path?"](path) then
    return {status = "nfnl-config-is-not-compiled", ["source-path"] = path}
  else
    local rel_file_name = path:sub((2 + root_dir:len()))
    local ok, res = nil, nil
    do
      fennel.path = cfg({"fennel-path"})
      fennel["macro-path"] = cfg({"fennel-macro-path"})
      ok, res = pcall(fennel.compileString, source, core.merge({filename = path}, cfg({"compiler-options"})))
    end
    if ok then
      return {status = "ok", ["source-path"] = path, result = (with_header(rel_file_name, res) .. "\n")}
    else
      if not batch_3f then
        notify.error(res)
      else
      end
      return {status = "compilation-error", error = res, ["source-path"] = path}
    end
  end
end
mod["into-file"] = function(_7_)
  local _arg_8_ = _7_
  local _root_dir = _arg_8_["_root-dir"]
  local _cfg = _arg_8_["_cfg"]
  local _source = _arg_8_["_source"]
  local path = _arg_8_["path"]
  local batch_3f = _arg_8_["batch?"]
  local opts = _arg_8_
  local destination_path = fnl_path__3elua_path(path)
  local _let_9_ = mod["into-string"](opts)
  local status = _let_9_["status"]
  local source_path = _let_9_["source-path"]
  local result = _let_9_["result"]
  local res = _let_9_
  if ("ok" ~= status) then
    return res
  elseif safe_target_3f(destination_path) then
    fs.mkdirp(fs.basename(destination_path))
    core.spit(destination_path, result)
    return {status = "ok", ["source-path"] = source_path, ["destination-path"] = destination_path}
  else
    if not batch_3f then
      notify.warn(destination_path, " was not compiled by nfnl. Delete it manually if you wish to compile into this file.")
    else
    end
    return {status = "destination-exists", ["source-path"] = path, ["destination-path"] = destination_path}
  end
end
mod["all-files"] = function(_12_)
  local _arg_13_ = _12_
  local root_dir = _arg_13_["root-dir"]
  local cfg = _arg_13_["cfg"]
  local function _14_(path)
    return mod["into-file"]({["root-dir"] = root_dir, path = path, cfg = cfg, source = core.slurp(path), ["batch?"] = true})
  end
  local function _15_(_241)
    return fs.relglob(root_dir, _241)
  end
  return core.map(_14_, core.map(fs["full-path"], core.mapcat(_15_, cfg({"source-file-patterns"}))))
end
return mod
