-- [nfnl] Compiled from fnl/spec/nfnl/e2e_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local before_each = _local_1_["before_each"]
local after_each = _local_1_["after_each"]
local assert = require("luassert.assert")
require("nfnl.config")
local core = require("nfnl.core")
local fs = require("nfnl.fs")
local nfnl = require("nfnl")
nfnl.setup({})
local temp_dir = vim.fn.tempname()
local fnl_dir = fs["join-path"]({temp_dir, "fnl"})
local lua_dir = fs["join-path"]({temp_dir, "lua"})
local config_path = fs["join-path"]({temp_dir, ".nfnl.fnl"})
local fnl_path = fs["join-path"]({fnl_dir, "foo.fnl"})
local lua_path = fs["join-path"]({lua_dir, "foo.lua"})
local function _2_()
  local initial_cwd = vim.fn.getcwd()
  local function _3_()
    fs.mkdirp(fnl_dir)
    return vim.cmd(("cd " .. temp_dir))
  end
  before_each(_3_)
  local function _4_()
    return vim.cmd(("cd " .. initial_cwd))
  end
  after_each(_4_)
  local function _5_()
    vim.cmd(("edit " .. fnl_path))
    vim.o.filetype = "fennel"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {"(print \"Hello, World!\")"})
    vim.cmd("write")
    return assert.is_nil(core.slurp(lua_path))
  end
  it("does nothing when there's no .nfnl.fnl configuration", _5_)
  local function _6_()
    core.spit(config_path, "{}")
    vim.cmd(("edit " .. config_path))
    vim.cmd("trust")
    vim.cmd(("edit " .. fnl_path))
    vim.o.filetype = "fennel"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {"(print \"Hello, World!\")"})
    vim.cmd("write")
    assert.are.equal(1, vim.fn.isdirectory(lua_dir))
    return assert.are.equal("-- [nfnl] Compiled from fnl/foo.fnl by https://github.com/Olical/nfnl, do not edit.\nreturn print(\"Hello, World!\")\n", core.slurp(lua_path))
  end
  return it("compiles when there's a trusted .nfnl.fnl configuration file", _6_)
end
return describe("e2e file compiling from a project dir", _2_)
