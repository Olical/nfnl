-- [nfnl] Compiled from fnl/nfnl/config.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local str = autoload("nfnl.string")
local fennel = autoload("nfnl.fennel")
local notify = autoload("nfnl.notify")
local config_file_name = ".nfnl.fnl"
local function find(dir)
  local found = fs.findfile(config_file_name, (dir .. ";"))
  if found then
    return fs["full-path"](found)
  else
    return nil
  end
end
local function path_dirs(_3_)
  local _arg_4_ = _3_
  local rtp_patterns = _arg_4_["rtp-patterns"]
  local runtimepath = _arg_4_["runtimepath"]
  local base_dirs = _arg_4_["base-dirs"]
  local function _5_(path)
    local function _6_(_241)
      return string.find(path, _241)
    end
    return core.some(_6_, rtp_patterns)
  end
  return core.distinct(core.concat(base_dirs, core.filter(_5_, str.split(runtimepath, ","))))
end
local function default(opts)
  local root_dir = (core.get(opts, "root-dir") or fs.basename(find(vim.fn.getcwd())) or vim.fn.getcwd())
  local dirs = path_dirs({runtimepath = vim.o.runtimepath, ["rtp-patterns"] = core.get(opts, "rtp-patterns", {(fs["path-sep"]() .. "nfnl$")}), ["base-dirs"] = {root_dir}})
  local function _7_(root_dir0)
    return core.map(fs["join-path"], {{root_dir0, "?.fnl"}, {root_dir0, "?", "init.fnl"}, {root_dir0, "fnl", "?.fnl"}, {root_dir0, "fnl", "?", "init.fnl"}})
  end
  local function _8_(root_dir0)
    return core.map(fs["join-path"], {{root_dir0, "?.fnl"}, {root_dir0, "?", "init-macros.fnl"}, {root_dir0, "?", "init.fnl"}, {root_dir0, "fnl", "?.fnl"}, {root_dir0, "fnl", "?", "init-macros.fnl"}, {root_dir0, "fnl", "?", "init.fnl"}})
  end
  return {["compiler-options"] = {["error-pinpoint"] = false}, ["fennel-path"] = str.join(";", core.mapcat(_7_, dirs)), ["fennel-macro-path"] = str.join(";", core.mapcat(_8_, dirs)), ["source-file-patterns"] = {"*.fnl", fs["join-path"]({"**", "*.fnl"})}, ["fnl-path->lua-path"] = fs["fnl-path->lua-path"]}
end
local function cfg_fn(t, opts)
  local default_cfg = default(opts)
  local function _9_(path)
    return core["get-in"](t, path, core["get-in"](default_cfg, path))
  end
  return _9_
end
local function config_file_path_3f(path)
  return (config_file_name == fs.filename(path))
end
local function find_and_load(dir)
  local function _10_()
    local config_file_path = find(dir)
    if config_file_path then
      local root_dir = fs.basename(config_file_path)
      local config_source = vim.secure.read(config_file_path)
      local ok, config = nil, nil
      if core["nil?"](config_source) then
        ok, config = false, (config_file_path .. " is not trusted, refusing to compile.")
      elseif (str["blank?"](config_source) or ("{}" == str.trim(config_source))) then
        ok, config = true, {}
      else
        ok, config = pcall(fennel.eval, config_source, {filename = config_file_path})
      end
      if ok then
        return {config = config, ["root-dir"] = root_dir, cfg = cfg_fn(config, {["root-dir"] = root_dir})}
      else
        return notify.error(config)
      end
    else
      return nil
    end
  end
  return (_10_() or {})
end
return {["cfg-fn"] = cfg_fn, find = find, ["find-and-load"] = find_and_load, ["config-file-path?"] = config_file_path_3f, default = default, ["path-dirs"] = path_dirs}
