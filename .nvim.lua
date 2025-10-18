-- [nfnl] .nvim.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local reload = autoload("plenary.reload")
local notify = autoload("nfnl.notify")
vim.api.nvim_set_keymap("n", "<localleader>pt", "<Plug>PlenaryTestFile", {desc = "Run the current test file with plenary."})
vim.api.nvim_set_keymap("n", "<localleader>pT", "<cmd>PlenaryBustedDirectory lua/spec/<cr>", {desc = "Run all tests with plenary."})
local function _2_()
  notify.info("Reloading...")
  reload.reload_module("nfnl")
  require("nfnl")
  return notify.info("Done!")
end
return vim.api.nvim_set_keymap("n", "<localleader>pr", "", {desc = "Reload the nfnl modules.", callback = _2_})
