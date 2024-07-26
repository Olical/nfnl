-- [nfnl] Compiled from fnl/spec/nfnl/config_spec.fnl by https://github.com/Olical/nfnl, do not edit.
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
    return assert.equals(fs.cwd(), config.default({})["root-dir"])
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
    return assert.equals(fs["join-path"](fs["full-path"]("."), ".nfnl.fnl"), fs["join-path"](".nfnl.fnl", config.find(".")))
  end
  return it("finds the nearest .nfnl file to the given path", _9_)
end
describe("find", _8_)
local function _10_()
  local function _11_()
    local _let_12_ = config["find-and-load"](".")
    local cfg = _let_12_["cfg"]
    local root_dir = _let_12_["root-dir"]
    local config0 = _let_12_["config"]
    assert.are.same({verbose = true}, config0)
    assert.equals(fs.cwd(), root_dir)
    return assert.equals("function", type(cfg))
  end
  it("loads the repo config file", _11_)
  local function _13_()
    return assert.are.same({}, config["find-and-load"]("/some/made/up/dir"))
  end
  return it("returns an empty table if a config file isn't found", _13_)
end
describe("find-and-load", _10_)
local function sorted(xs)
  table.sort(xs)
  return xs
end
local function _14_()
  local function _15_()
    assert.are.same({"/foo/bar/nfnl", "/foo/baz/my-proj"}, sorted(config["path-dirs"]({runtimepath = "/foo/bar/nfnl,/foo/bar/other-thing", ["rtp-patterns"] = {"/nfnl$"}, ["base-dirs"] = {"/foo/baz/my-proj"}})))
    return assert.are.same({"/foo/bar/nfnl", "/foo/baz/my-proj"}, sorted(config["path-dirs"]({runtimepath = "/foo/bar/nfnl,/foo/bar/other-thing", ["rtp-patterns"] = {"/nfnl$"}, ["base-dirs"] = {"/foo/baz/my-proj", "/foo/bar/nfnl"}})))
  end
  return it("builds path dirs from runtimepath, deduplicates the base-dirs", _15_)
end
return describe("path-dirs", _14_)
