-- [nfnl] Compiled from fnl/spec/nfnl/e2e_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local before_each = _local_1_["before_each"]
local after_each = _local_1_["after_each"]
local assert = require("luassert.assert")
local core = require("nfnl.core")
local fs = require("nfnl.fs")
local nfnl = require("nfnl")
nfnl.setup({})
local temp_dir = vim.fn.tempname()
local unrelated_temp_dir = vim.fn.tempname()
local fnl_dir = fs["join-path"]({temp_dir, "fnl"})
local lua_dir = fs["join-path"]({temp_dir, "lua"})
local config_path = fs["join-path"]({temp_dir, ".nfnl.fnl"})
local fnl_path = fs["join-path"]({fnl_dir, "foo.fnl"})
local macro_fnl_path = fs["join-path"]({fnl_dir, "bar.fnl"})
local macro_lua_path = fs["join-path"]({lua_dir, "bar.lua"})
local lua_path = fs["join-path"]({lua_dir, "foo.lua"})
fs.mkdirp(fnl_dir)
fs.mkdirp(unrelated_temp_dir)
local function delete_buf_file(path)
  pcall(vim.cmd, ("bwipeout! " .. path))
  return os.remove(path)
end
local function run_e2e_tests()
  core["run!"](delete_buf_file, {config_path, fnl_path, macro_fnl_path, lua_path})
  local function _2_()
    vim.cmd(("edit " .. fnl_path))
    vim.o.filetype = "fennel"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {"(print \"Hello, World!\")"})
    vim.cmd("write")
    return assert.is_nil(core.slurp(lua_path))
  end
  it("does nothing when there's no .nfnl.fnl configuration", _2_)
  local function _3_()
    vim.cmd(("edit " .. config_path))
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {"{}"})
    vim.cmd("write")
    if ("false" ~= vim.env.NFNL_USE_SECURE_READ) then
      vim.cmd("trust")
    else
    end
    vim.cmd(("edit " .. fnl_path))
    vim.o.filetype = "fennel"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {"(print \"Hello, World!\")"})
    vim.cmd("write")
    assert.are.equal(1, vim.fn.isdirectory(lua_dir))
    local lua_result = core.slurp(lua_path)
    print("Lua result:", lua_result)
    return assert.are.equal("-- [nfnl] Compiled from fnl/foo.fnl by https://github.com/Olical/nfnl, do not edit.\nreturn print(\"Hello, World!\")\n", lua_result)
  end
  it("compiles when there's a trusted .nfnl.fnl configuration file", _3_)
  local function _5_()
    vim.cmd(("edit " .. macro_fnl_path))
    vim.o.filetype = "fennel"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {(";; [nfnl" .. "-" .. "macro]"), "{:infix (fn [a op b] `(,op ,a ,b))}"})
    vim.cmd("write")
    vim.cmd(("edit " .. fnl_path))
    vim.o.filetype = "fennel"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {"(import-macros {: infix} :bar)", "(infix 10 + 20)"})
    vim.cmd("write")
    assert.is_nil(core.slurp(macro_lua_path))
    local lua_result = core.slurp(lua_path)
    print("Lua result:", lua_result)
    return assert.are.equal("-- [nfnl] Compiled from fnl/foo.fnl by https://github.com/Olical/nfnl, do not edit.\nreturn (10 + 20)\n", lua_result)
  end
  return it("can import-macros and use them, the macros aren't compiled", _5_)
end
local function _6_()
  local initial_cwd = nil
  local function _7_()
    initial_cwd = fs.cwd()
    return vim.api.nvim_set_current_dir(temp_dir)
  end
  before_each(_7_)
  local function _8_()
    return vim.api.nvim_set_current_dir(initial_cwd)
  end
  after_each(_8_)
  return run_e2e_tests()
end
describe("e2e file compiling from a project dir", _6_)
local function _9_()
  local initial_cwd = nil
  local function _10_()
    initial_cwd = fs.cwd()
    return vim.api.nvim_set_current_dir(unrelated_temp_dir)
  end
  before_each(_10_)
  local function _11_()
    return vim.api.nvim_set_current_dir(initial_cwd)
  end
  after_each(_11_)
  return run_e2e_tests()
end
return describe("e2e file compiling from outside project dir", _9_)
