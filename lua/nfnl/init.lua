-- [nfnl] Compiled from fnl/nfnl/init.fnl by https://github.com/Olical/nfnl, do not edit.
local autoload = require("nfnl.autoload")
local compile = autoload("nfnl.compile")
local config = autoload("nfnl.config")
local notify = autoload("nfnl.notify")
local callback = autoload("nfnl.callback")
local function setup()
  vim.api.nvim_create_autocmd({"Filetype"}, {group = vim.api.nvim_create_augroup("nfnl-setup", {}), pattern = "fennel", callback = callback["fennel-filetype-callback"]})
  if ("fennel" == vim.o.filetype) then
    return callback["fennel-filetype-callback"]({file = vim.fn.expand("%"), buf = vim.api.nvim_get_current_buf()})
  else
    return nil
  end
end
local function compile_all_files(dir)
  local dir0 = (dir or vim.fn.getcwd())
  local _let_2_ = config["find-and-load"](dir0)
  local config0 = _let_2_["config"]
  local root_dir = _let_2_["root-dir"]
  local cfg = _let_2_["cfg"]
  if config0 then
    return notify.info("Compilation complete.\n", compile["all-files"]({["root-dir"] = root_dir, cfg = cfg}))
  else
    return notify.warn("No .nfnl.fnl configuration found.")
  end
end
return {setup = setup, ["compile-all-files"] = compile_all_files}
