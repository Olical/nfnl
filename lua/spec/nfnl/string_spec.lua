-- [nfnl] fnl/spec/nfnl/string_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local str = require("nfnl.string")
local function _2_()
  local function _3_()
    assert.equals("foo, bar, baz", str.join(", ", {"foo", "bar", "baz"}))
    assert.equals("foobarbaz", str.join({"foo", "bar", "baz"}))
    return assert.equals("foobar", str.join({"foo", nil, "bar"}), "handle nils correctly")
  end
  return it("joins things together", _3_)
end
describe("join", _2_)
local function _4_()
  local function _5_()
    assert.are.same({""}, str.split("", ","))
    assert.are.same({"foo"}, str.split("foo", ","))
    assert.are.same({"foo", "bar", "baz"}, str.split("foo,bar,baz", ","))
    assert.are.same({"foo", "", "bar"}, str.split("foo,,bar", ","))
    assert.are.same({"foo", "", "", "bar"}, str.split("foo,,,bar", ","))
    return assert.are.same({"foo", "baz"}, str.split("foobarbaz", "bar"))
  end
  return it("splits strings up", _5_)
end
describe("split", _4_)
local function _6_()
  local function _7_()
    assert.is_true(str["blank?"](nil))
    assert.is_true(str["blank?"](""))
    assert.is_true(str["blank?"](" "))
    assert.is_true(str["blank?"]("   "))
    assert.is_true(str["blank?"]("   \n \n  "))
    return assert.is_true(not str["blank?"]("   \n . \n  "))
  end
  return it("true if the string is nil or just whitespace", _7_)
end
describe("blank?", _6_)
local function _8_()
  local function _9_()
    assert.equals("", str.triml(""))
    assert.equals("foo", str.triml("foo"))
    assert.equals("foo", str.triml("    foo"))
    assert.equals("foo", str.triml("  \n  foo"))
    return assert.equals("foo  ", str.triml("  \n  foo  "))
  end
  return it("trims all whitespace from the left of the string", _9_)
end
describe("triml", _8_)
local function _10_()
  local function _11_()
    assert.equals("", str.trimr(""))
    assert.equals("foo", str.trimr("foo"))
    assert.equals("foo", str.trimr("foo    "))
    assert.equals("foo", str.trimr("foo  \n  "))
    return assert.equals("  foo", str.trimr("  foo  \n  "))
  end
  return it("trims all whitespace from the right of the string", _11_)
end
describe("trimr", _10_)
local function _12_()
  local function _13_()
    assert.equals("", str.trim(""))
    assert.equals("foo", str.trim("foo"))
    assert.equals("foo", str.trim(" \n foo \n \n    "), "basic")
    return assert.equals("", str.trim("           "), "just whitespace")
  end
  return it("trims all whitespace from start end end of a string", _13_)
end
describe("trim", _12_)
local function _14_()
  local function _15_()
    assert.is_true(str["ends-with?"]("foobarbaz", "baz"))
    assert.is_true(str["ends-with?"]("foobarbaz", "arbaz"))
    assert.is_true(str["ends-with?"]("foobarbaz", "foobarbaz"))
    assert.is_false(str["ends-with?"]("foobarbaz", "foo"))
    return assert.is_false(str["ends-with?"]("foobarbaz", "barbazz"))
  end
  return it("checks if a string ends with another string", _15_)
end
return describe("ends-with?", _14_)
