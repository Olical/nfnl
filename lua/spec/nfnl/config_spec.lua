-- [nfnl] Compiled from fnl/spec/nfnl/config_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local config = require("nfnl.config")
local fs = require("nfnl.fs")
local str = require("nfnl.string")
local function assert_ends_with_3f(s, _end)
  if str["ends-with?"](s, _end) then
    return true
  else
    return error(string.format("expected %s to end with %s", s, _end))
  end
end
local function _3_()
  local function _4_()
    assert.equals("function", type(config.default))
    assert.equals("table", type(config.default({["root-dir"] = "/tmp/foo"})))
    return assert_ends_with_3f((config.default({}))["root-dir"], "/.nfnl.fnl")
  end
  return it("is a function that returns a table", _4_)
end
describe("default", _3_)
local function _5_()
  local function _6_()
    local opts = {["root-dir"] = "/tmp/foo"}
    assert.is_string(config["cfg-fn"]({}, opts)({"fennel-macro-path"}))
    assert.is_nil(config["cfg-fn"]({}, opts)({"nope"}))
    assert.equals("yep", config["cfg-fn"]({nope = "yep"}, opts)({"nope"}))
    return assert.equals("yep", config["cfg-fn"]({["fennel-macro-path"] = "yep"}, opts)({"fennel-macro-path"}))
  end
  return it("builds a function that looks up values in a table falling back to defaults", _6_)
end
describe("cfg-fn", _5_)
local function _7_()
  local function _8_()
    assert.is_true(config["config-file-path?"]("./foo/.nfnl.fnl"))
    assert.is_true(config["config-file-path?"](".nfnl.fnl"))
    return assert.is_false(config["config-file-path?"](".fnl.fnl"))
  end
  return it("returns true for config file paths", _8_)
end
describe("config-file-path?", _7_)
local function _9_()
  local function _10_()
    local _let_11_ = config["find-and-load"](".")
    local cfg = _let_11_["cfg"]
    local root_dir = _let_11_["root-dir"]
    local config0 = _let_11_["config"]
    assert.are.same({verbose = true}, config0)
    assert.equals(vim.fn.getcwd(), root_dir)
    return assert.equals("function", type(cfg))
  end
  it("loads the repo config file", _10_)
  local function _12_()
    return assert.are.same({}, config["find-and-load"]("/some/made/up/dir"))
  end
  return it("returns an empty table if a config file isn't found", _12_)
end
describe("find-and-load", _9_)
local function sorted(xs)
  table.sort(xs)
  return xs
end
local function _13_()
  local function _14_()
    assert.are.same({"/foo/bar/nfnl", "/foo/baz/my-proj"}, sorted(config["path-dirs"]({runtimepath = "/foo/bar/nfnl,/foo/bar/other-thing", ["rtp-patterns"] = {(fs["path-sep"]() .. "nfnl$")}, ["base-dirs"] = {"/foo/baz/my-proj"}})))
    return assert.are.same({"/foo/bar/nfnl", "/foo/baz/my-proj"}, sorted(config["path-dirs"]({runtimepath = "/foo/bar/nfnl,/foo/bar/other-thing", ["rtp-patterns"] = {(fs["path-sep"]() .. "nfnl$")}, ["base-dirs"] = {"/foo/baz/my-proj", "/foo/bar/nfnl"}})))
  end
  return it("builds path dirs from runtimepath, deduplicates the base-dirs", _14_)
end
return describe("path-dirs", _13_)
