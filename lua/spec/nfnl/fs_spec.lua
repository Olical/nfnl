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
return describe("path-sep", _4_)
