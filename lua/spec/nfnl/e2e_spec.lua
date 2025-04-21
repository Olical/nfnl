-- [nfnl] fnl/spec/nfnl/e2e_spec.fnl
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
    vim.cmd("trust")
    vim.cmd(("edit " .. fnl_path))
    vim.o.filetype = "fennel"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {"(print \"Hello, World!\")"})
    vim.cmd("write")
    assert.are.equal(1, vim.fn.isdirectory(lua_dir))
    local lua_result = core.slurp(lua_path)
    print("Lua result:", lua_result)
    return assert.are.equal("-- [nfnl] fnl/foo.fnl\nreturn print(\"Hello, World!\")\n", lua_result)
  end
  it("compiles when there's a trusted .nfnl.fnl configuration file", _3_)
  local function _4_()
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
    return assert.are.equal("-- [nfnl] fnl/foo.fnl\nreturn (10 + 20)\n", lua_result)
  end
  return it("can import-macros and use them, the macros aren't compiled", _4_)
end
local function _5_()
  local initial_cwd = nil
  local function _6_()
    initial_cwd = vim.fn.getcwd()
    return vim.api.nvim_set_current_dir(temp_dir)
  end
  before_each(_6_)
  local function _7_()
    return vim.api.nvim_set_current_dir(initial_cwd)
  end
  after_each(_7_)
  return run_e2e_tests()
end
describe("e2e file compiling from a project dir", _5_)
local function _8_()
  local initial_cwd = nil
  local function _9_()
    initial_cwd = vim.fn.getcwd()
    return vim.api.nvim_set_current_dir(unrelated_temp_dir)
  end
  before_each(_9_)
  local function _10_()
    return vim.api.nvim_set_current_dir(initial_cwd)
  end
  after_each(_10_)
  return run_e2e_tests()
end
return describe("e2e file compiling from outside project dir", _8_)
