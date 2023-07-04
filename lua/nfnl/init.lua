local autoload = require("nfnl.autoload")
local fennel = autoload("nfnl.fennel")
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local str = autoload("nfnl.string")
local function get_buf_content_as_string(buf)
  return str.join("\n", vim.api.nvim_buf_get_lines((buf or 0), 0, -1, false))
end
local function buf_write_post_callback(ev)
  local ok, res = pcall(fennel.compileString, get_buf_content_as_string(ev.buf), {filename = ev.file})
  if ok then
    return core.spit(fs["replace-extension"](ev.file, "lua"), res)
  else
    return error(res)
  end
end
local function setup(opts)
  local opts0 = (opts or {})
  if (false ~= (opts0).compile_on_write) then
    local agid = vim.api.nvim_create_augroup("nfnl", {})
    return vim.api.nvim_create_autocmd({"BufWritePost"}, {pattern = {"*.fnl"}, callback = buf_write_post_callback})
  else
    return nil
  end
end
--[[ (setup) ]]
return {setup = setup}