-- [nfnl] Compiled from fnl/nfnl/init.fnl by https://github.com/Olical/nfnl, do not edit.
local autoload = require("nfnl.autoload")
local fennel = autoload("nfnl.fennel")
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local nvim = autoload("nfnl.nvim")
local notify = autoload("nfnl.notify")
local config_file_name = ".nfnl"
local default_config = {compiler_options = {}, source_file_patterns = {fs["join-path"]({"fnl", "**", "*.fnl"})}}
local function cfg_fn(t)
  local function _1_(path)
    return core["get-in"](t, path, core["get-in"](default_config, path))
  end
  return _1_
end
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
local function fennel_buf_write_post_callback_fn(root_dir, cfg)
  local function _2_(ev)
    local file_name = ev.file
    local rel_file_name = file_name:sub((2 + root_dir:len()))
    local destination_path = fnl_path__3elua_path(file_name)
    local ok, res = pcall(fennel.compileString, nvim["get-buf-content-as-string"](ev.buf), core.merge({filename = file_name}, cfg({"compiler_options"})))
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
  return _2_
end
local function fennel_filetype_callback(ev)
  local cwd = vim.fn.getcwd()
  local file_dir = fs["join-path"]({cwd, fs.basename(ev.file)})
  local rel_nfnl_path = fs.findfile(config_file_name, (file_dir .. ";"))
  if rel_nfnl_path then
    local config_file_path = fs["join-path"]({cwd, rel_nfnl_path})
    local root_dir = fs.basename(config_file_path)
    local ok, config = pcall(fennel.eval, vim.secure.read(config_file_path), {filename = config_file_path})
    if ok then
      local cfg = cfg_fn(config)
      local function _5_(_241)
        return fs["join-path"]({root_dir, _241})
      end
      return vim.api.nvim_create_autocmd({"BufWritePost"}, {group = vim.api.nvim_create_augroup(("nfnl-dir-" .. root_dir), {}), pattern = core.map(_5_, cfg({"source_file_patterns"})), callback = fennel_buf_write_post_callback_fn(root_dir, cfg)})
    else
      return notify.error(config)
    end
  else
    return nil
  end
end
local function setup()
  vim.api.nvim_create_autocmd({"Filetype"}, {group = vim.api.nvim_create_augroup("nfnl-setup", {}), pattern = "fennel", callback = fennel_filetype_callback})
  if ("fennel" == vim.o.filetype) then
    return fennel_filetype_callback({file = vim.fn.expand("%"), buf = vim.api.nvim_get_current_buf()})
  else
    return nil
  end
end
--[[ (setup) ]]
return {setup = setup, ["default-config"] = default_config}