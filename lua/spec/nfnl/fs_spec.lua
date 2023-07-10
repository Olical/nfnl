-- [nfnl] Compiled from fnl/spec/nfnl/fs_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local fs = require("nfnl.fs")
local function _2_()
  local function _3_()
    assert.equals("foo", fs.basename("foo/bar.fnl"))
    assert.equals("foo/bar", fs.basename("foo/bar/baz.fnl"))
    return assert.equals(".", fs.basename("baz.fnl"))
  end
  return it("removes the last segment of a path", _3_)
end
describe("basename", _2_)
local function _4_()
  local function _5_()
    return assert.equals("/", fs["path-sep"]())
  end
  return it("returns the OS path separator (test assumes Linux)", _5_)
end
describe("path-sep", _4_)
local function _6_()
  local function _7_()
    return assert.equals("foo.lua", fs["replace-extension"]("foo.fnl", "lua"))
  end
  return it("replaces extensions", _7_)
end
describe("replace-extension", _6_)
local function _8_()
  local function _9_()
    assert.are.same({"foo", "bar", "baz"}, fs["split-path"]("foo/bar/baz"))
    return assert.are.same({"", "foo", "bar", "baz"}, fs["split-path"]("/foo/bar/baz"))
  end
  return it("splits a path into parts", _9_)
end
describe("split-path", _8_)
local function _10_()
  local function _11_()
    assert.equals("foo/bar/baz", fs["join-path"]({"foo", "bar", "baz"}))
    return assert.equals("/foo/bar/baz", fs["join-path"]({"", "foo", "bar", "baz"}))
  end
  return it("joins a path together", _11_)
end
describe("join-path", _10_)
local function _12_()
  local function _13_()
    assert.equals("foo/lua/bar", fs["replace-dirs"]("foo/fnl/bar", "fnl", "lua"))
    assert.equals("/foo/lua/bar", fs["replace-dirs"]("/foo/fnl/bar", "fnl", "lua"))
    return assert.equals("/foo/nfnl/bar", fs["replace-dirs"]("/foo/nfnl/bar", "fnl", "lua"))
  end
  return it("replaces directories in a path that match a string with another string", _13_)
end
return describe("replace-dirs", _12_)
