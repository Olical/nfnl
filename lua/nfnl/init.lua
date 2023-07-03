local fennel = require("nfnl.fennel")
local function spit(path, content)
  local _1_, _2_ = io.open(path, "w")
  if ((_1_ == nil) and (nil ~= _2_)) then
    local msg = _2_
    return error(("Could not open file: " .. msg))
  elseif (nil ~= _1_) then
    local f = _1_
    f:write(content)
    f:close()
    return nil
  else
    return nil
  end
end
local function fname_root(path)
  return vim.fn.fnamemodify(path, ":r")
end
local function get_buf_content(buf)
  return table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
end
local function setup(opts)
  local agid = vim.api.nvim_create_augroup("nfnl", {})
  local function _4_(ev)
    local ok, res = pcall(fennel.compileString, get_buf_content(ev.buf), {filename = ev.file})
    if ok then
      return spit((fname_root(ev.file) .. ".lua"), res)
    else
      return error(res)
    end
  end
  return vim.api.nvim_create_autocmd({"BufWritePost"}, {pattern = {"*.fnl"}, callback = _4_})
end
--[[ (setup) ]]
return {setup = setup}