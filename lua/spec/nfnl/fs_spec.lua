-- [nfnl] Compiled from fnl\spec\nfnl\fs_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local fs = require("nfnl.fs")
local function windows()
  return (jit.os == "Windows")
end
local function _2_()
  local function _3_()
    assert.equals("foo", fs.basename("foo/bar.fnl"))
    assert.equals("foo/bar", fs.basename("foo/bar/baz.fnl"))
    return assert.equals(".", fs.basename("baz.fnl"))
  end
  it("removes the last segment of a path", _3_)
  local function _4_()
    return assert.is_nil(fs.basename(nil))
  end
  return it("happily lets nils flow back out", _4_)
end
describe("basename", _2_)
local function _5_()
  local function _6_()
    if windows() then
      return assert.equals("\\", fs["path-sep"]())
    else
      return assert.equals("/", fs["path-sep"]())
    end
  end
  return it("returns the OS path separator (test assumes Linux)", _6_)
end
describe("path-sep", _5_)
local function _8_()
  local function _9_()
    return assert.equals("foo.lua", fs["replace-extension"]("foo.fnl", "lua"))
  end
  return it("replaces extensions", _9_)
end
describe("replace-extension", _8_)
local function _10_()
  local function _11_()
    if windows() then
      assert.are.same({"foo", "bar", "baz"}, fs["split-path"]("foo\\bar\\baz"))
      return assert.are.same({"", "foo", "bar", "baz"}, fs["split-path"]("\\foo\\bar\\baz"))
    else
      assert.are.same({"foo", "bar", "baz"}, fs["split-path"]("foo/bar/baz"))
      return assert.are.same({"", "foo", "bar", "baz"}, fs["split-path"]("/foo/bar/baz"))
    end
  end
  return it("splits a path into parts", _11_)
end
describe("split-path", _10_)
local function _13_()
  local function _14_()
    if windows() then
      assert.equals("foo\\bar\\baz", fs["join-path"]({"foo", "bar", "baz"}))
      return assert.equals("\\foo\\bar\\baz", fs["join-path"]({"", "foo", "bar", "baz"}))
    else
      assert.equals("foo/bar/baz", fs["join-path"]({"foo", "bar", "baz"}))
      return assert.equals("/foo/bar/baz", fs["join-path"]({"", "foo", "bar", "baz"}))
    end
  end
  return it("joins a path together", _14_)
end
describe("join-path", _13_)
local function _16_()
  local function _17_()
    if windows() then
      assert.equals("foo\\lua\\bar", fs["replace-dirs"]("foo\\fnl\\bar", "fnl", "lua"))
      assert.equals("\\foo\\lua\\bar", fs["replace-dirs"]("\\foo\\fnl\\bar", "fnl", "lua"))
      return assert.equals("\\foo\\nfnl\\bar", fs["replace-dirs"]("\\foo\\nfnl\\bar", "fnl", "lua"))
    else
      assert.equals("foo/lua/bar", fs["replace-dirs"]("foo/fnl/bar", "fnl", "lua"))
      assert.equals("/foo/lua/bar", fs["replace-dirs"]("/foo/fnl/bar", "fnl", "lua"))
      return assert.equals("/foo/nfnl/bar", fs["replace-dirs"]("/foo/nfnl/bar", "fnl", "lua"))
    end
  end
  return it("replaces directories in a path that match a string with another string", _17_)
end
return describe("replace-dirs", _16_)
