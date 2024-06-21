-- [nfnl] Compiled from fnl\spec\nfnl\fs_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local fs = require("nfnl.fs")
local function windows_3f()
  return (jit.os == "Windows")
end
local function _2_()
  local function _3_()
    assert.equals("foo", fs.basename(fs["join-path"]({"foo", "bar.fnl"})))
    assert.equals(fs["join-path"]({"foo", "bar"}), fs.basename(fs["join-path"]({"foo", "bar", "baz.fnl"})))
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
    if windows_3f() then
      return assert.equals("\\", fs["path-sep"]())
    else
      return assert.equals("/", fs["path-sep"]())
    end
  end
  return it("returns the OS path separator", _6_)
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
    assert.are.same({"foo", "bar", "baz"}, fs["split-path"](fs["correct-separators"]("foo/bar/baz")), z)
    return assert.are.same({"", "foo", "bar", "baz"}, fs["split-path"](fs["correct-separators"]("/foo/bar/baz")))
  end
  return it("splits a path into parts", _11_)
end
describe("split-path", _10_)
local function _12_()
  local function _13_()
    assert.equals("foo/bar/baz", fs["standardize-path"](fs["join-path"]({"foo", "bar", "baz"})))
    return assert.equals("/foo/bar/baz", fs["standardize-path"](fs["join-path"]({"", "foo", "bar", "baz"})))
  end
  return it("joins a path together", _13_)
end
describe("join-path", _12_)
local function _14_()
  local function _15_()
    assert.equals("foo/lua/bar", fs["standardize-path"](fs["replace-dirs"](fs["correct-separators"]("foo/fnl/bar"), "fnl", "lua")))
    assert.equals("/foo/lua/bar", fs["standardize-path"](fs["replace-dirs"](fs["correct-separators"]("/foo/fnl/bar"), "fnl", "lua")))
    return assert.equals("/foo/nfnl/bar", fs["standardize-path"](fs["replace-dirs"]("/foo/nfnl/bar", "fnl", "lua")))
  end
  return it("replaces directories in a path that match a string with another string", _15_)
end
describe("replace-dirs", _14_)
local function _16_()
  local function _17_()
    assert.equals("foo/bar/baz.fnl", fs["standardize-path"]("foo\\bar\\baz.fnl"))
    return assert.equals("foo/bar/baz.fnl", fs["standardize-path"]("foo/bar/baz.fnl"))
  end
  return it("replaces all path separators with forward slash", _17_)
end
describe("standardize-path", _16_)
local function _18_()
  local function _19_()
    if windows_3f() then
      assert.equals("foo\\bar\\baz.fnl", fs["correct-separators"]("foo/bar/baz.fnl"))
      return assert.equals("foo\\bar\\baz.fnl", fs["correct-separators"]("foo\\bar\\baz.fnl"))
    else
      assert.equals("foo/bar/baz.fnl", fs["correct-separators"]("foo/bar/baz.fnl"))
      return assert.equals("foo/bar/baz.fnl", fs["correct-separators"]("foo\\bar\\baz.fnl"))
    end
  end
  return it("", _19_)
end
return describe("correct-separators", _18_)
