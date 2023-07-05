-- [nfnl] Compiled from fnl/nfnl/init.fnl by https://github.com/Olical/nfnl, do not edit.
local autoload = require("nfnl.autoload")
local system = autoload("nfnl.system")
local function setup()
  vim.api.nvim_create_autocmd({"Filetype"}, {group = vim.api.nvim_create_augroup("nfnl-setup", {}), pattern = "fennel", callback = system["fennel-filetype-callback"]})
  if ("fennel" == vim.o.filetype) then
    return system["fennel-filetype-callback"]({file = vim.fn.expand("%"), buf = vim.api.nvim_get_current_buf()})
  else
    return nil
  end
end
return {setup = setup, ["default-config"] = system["default-config"]}