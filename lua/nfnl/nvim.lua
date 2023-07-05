local autoload = require("nfnl.autoload")
local str = autoload("nfnl.string")
local function get_buf_content_as_string(buf)
  return str.join("\n", vim.api.nvim_buf_get_lines((buf or 0), 0, -1, false))
end
return {["get-buf-content-as-string"] = get_buf_content_as_string}