-- [nfnl] fnl/spec/nfnl/config_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local config = require("nfnl.config")
local fs = require("nfnl.fs")
local function _2_()
  local function _3_()
    assert.equals("function", type(config.default))
    assert.equals("table", type(config.default({["root-dir"] = "/tmp/foo"})))
    return assert.equals(vim.fn.getcwd(), config.default({})["root-dir"])
  end
  return it("is a function that returns a table", _3_)
end
describe("default", _2_)
local function _4_()
  local function _5_()
    local opts = {["root-dir"] = "/tmp/foo"}
    assert.is_string(config["cfg-fn"]({}, opts)({"fennel-macro-path"}))
    assert.is_nil(config["cfg-fn"]({}, opts)({"nope"}))
    assert.equals("yep", config["cfg-fn"]({nope = "yep"}, opts)({"nope"}))
    return assert.equals("yep", config["cfg-fn"]({["fennel-macro-path"] = "yep"}, opts)({"fennel-macro-path"}))
  end
  return it("builds a function that looks up values in a table falling back to defaults", _5_)
end
describe("cfg-fn", _4_)
local function _6_()
  local function _7_()
    assert.is_true(config["config-file-path?"]("./foo/.nfnl.fnl"))
    assert.is_true(config["config-file-path?"](".nfnl.fnl"))
    return assert.is_false(config["config-file-path?"](".fnl.fnl"))
  end
  return it("returns true for config file paths", _7_)
end
describe("config-file-path?", _6_)
local function _8_()
  local function _9_()
    local _let_10_ = config["find-and-load"](".")
    local cfg = _let_10_["cfg"]
    local root_dir = _let_10_["root-dir"]
    local config0 = _let_10_["config"]
    assert.are.same({verbose = true}, config0)
    assert.equals(vim.fn.getcwd(), root_dir)
    return assert.equals("function", type(cfg))
  end
  it("loads the repo config file", _9_)
  local function _11_()
    return assert.are.same({}, config["find-and-load"]("/some/made/up/dir"))
  end
  return it("returns an empty table if a config file isn't found", _11_)
end
describe("find-and-load", _8_)
local function sorted(xs)
  table.sort(xs)
  return xs
end
local function _12_()
  local function _13_()
    assert.are.same({"/foo/bar/nfnl", "/foo/baz/my-proj"}, sorted(config["path-dirs"]({runtimepath = "/foo/bar/nfnl,/foo/bar/other-thing", ["rtp-patterns"] = {(fs["path-sep"]() .. "nfnl$")}, ["base-dirs"] = {"/foo/baz/my-proj"}})))
    return assert.are.same({"/foo/bar/nfnl", "/foo/baz/my-proj"}, sorted(config["path-dirs"]({runtimepath = "/foo/bar/nfnl,/foo/bar/other-thing", ["rtp-patterns"] = {(fs["path-sep"]() .. "nfnl$")}, ["base-dirs"] = {"/foo/baz/my-proj", "/foo/bar/nfnl"}})))
  end
  return it("builds path dirs from runtimepath, deduplicates the base-dirs", _13_)
end
return describe("path-dirs", _12_)
