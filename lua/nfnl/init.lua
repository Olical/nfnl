local autoload = require("nfnl.autoload")
local fennel = autoload("nfnl.fennel")
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local nvim = autoload("nfnl.nvim")
local function buf_write_post_callback(ev)
  local ok, res = pcall(fennel.compileString, nvim["get-buf-content-as-string"](ev.buf), {filename = ev.file})
  if ok then
    return core.spit(fs["replace-extension"](ev.file, "lua"), res)
  else
    return error(res)
  end
end
local default_config = {compile_on_write = true}
local function cfg_fn(t)
  local function _2_(path)
    return core["get-in"](t, path, core["get-in"](default_config, path))
  end
  return _2_
end
local function setup(config)
  local cfg = cfg_fn(config)
  if cfg({"compile_on_write"}) then
    local agid = vim.api.nvim_create_augroup("nfnl", {})
    return vim.api.nvim_create_autocmd({"BufWritePost"}, {group = agid, pattern = {"*.fnl"}, callback = buf_write_post_callback})
  else
    return nil
  end
end
--[[ (setup) ]]
return {setup = setup, ["default-config"] = default_config}