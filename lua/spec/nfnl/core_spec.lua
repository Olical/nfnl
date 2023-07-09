-- [nfnl] Compiled from fnl/spec/nfnl/core_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local core = require("nfnl.core")
local function _2_()
  math.randomseed(os.time())
  local function _3_()
    return assert.is_number(core.rand())
  end
  it("returns a number", _3_)
  local function _4_()
    return assert.are_not.equal(core.rand(), core.rand())
  end
  return it("is not the same when called twice", _4_)
end
describe("rand", _2_)
local function _5_()
  local function _6_()
    return assert.equals(1, core.first({1, 2, 3}))
  end
  it("gets the first value", _6_)
  local function _7_()
    assert.is_nil(core.first(nil))
    return assert.is_nil(core.first({}))
  end
  return it("returns nil for empty lists or nil", _7_)
end
describe("first", _5_)
local function _8_()
  local function _9_()
    return assert.equals(3, core.last({1, 2, 3}))
  end
  it("gets the last value", _9_)
  local function _10_()
    assert.is_nil(core.last(nil))
    return assert.is_nil(core.last({}))
  end
  return it("returns nil for empty lists or nil", _10_)
end
describe("last", _8_)
local function _11_()
  local function _12_()
    assert.are.same({}, core.butlast(nil))
    assert.are.same({}, core.butlast({}))
    return assert.are.same({}, core.butlast({1}))
  end
  it("returns empty results where appropriate", _12_)
  local function _13_()
    return assert.are.same({1, 2}, core.butlast({1, 2, 3}))
  end
  return it("works when there's more than one item", _13_)
end
describe("butlast", _11_)
local function _14_()
  local function _15_()
    assert.are.same({}, core.rest(nil))
    assert.are.same({}, core.rest({}))
    return assert.are.same({}, core.rest({1}))
  end
  it("returns empty where appropriate", _15_)
  local function _16_()
    return assert.are.same({2, 3}, core.rest({1, 2, 3}))
  end
  return it("returns the rest if there's more than one value", _16_)
end
describe("rest", _14_)
local function _17_()
  local function _18_()
    assert.is_nil(core.second({}))
    assert.is_nil(core.second(nil))
    return assert.is_nil(core.second({1, nil, 3}))
  end
  it("returns nil when required", _18_)
  local function _19_()
    return assert.equals(2, core.second({1, 2, 3}))
  end
  return it("returns the second item if there is one", _19_)
end
describe("second", _17_)
local function _20_()
  local function _21_()
    assert.is_true(core["string?"]("foo"))
    assert.is_false(core["string?"](nil))
    return assert.is_false(core["string?"](10))
  end
  return it("returns true for strings", _21_)
end
describe("string?", _20_)
local function _22_()
  local function _23_()
    assert.is_false(core["nil?"]("foo"))
    assert.is_true(core["nil?"](nil))
    return assert.is_false(core["nil?"](10))
  end
  return it("returns true for strings", _23_)
end
describe("nil?", _22_)
local function _24_()
  local function _25_()
    local function _26_(_241)
      return ((_241 > 5) and _241)
    end
    return assert.is_nil(core.some(_26_, {1, 2, 3}))
  end
  it("returns nil when nothing matches", _25_)
  local function _27_()
    local function _28_(_241)
      return ((_241 > 2) and _241)
    end
    return assert.equals(3, core.some(_28_, {1, 2, 3}))
  end
  it("returns the first match", _27_)
  local function _29_()
    local function _30_(_241)
      return (_241 and (_241 > 2) and _241)
    end
    return assert.equals(3, core.some(_30_, {nil, 1, nil, 2, nil, 3, nil}))
  end
  return it("handles nils", _29_)
end
describe("some", _24_)
local function _31_()
  local function _32_()
    assert.equals(2, core.inc(1))
    return assert.equals(-4, core.inc(-5))
  end
  return it("increments numbers", _32_)
end
describe("inc", _31_)
local function _33_()
  local function _34_()
    assert.equals(1, core.dec(2))
    return assert.equals(-6, core.dec(-5))
  end
  return it("decrements numbers", _34_)
end
describe("dec", _33_)
local function _35_()
  local function _36_()
    assert.is_true(core["even?"](2))
    return assert.is_false(core["even?"](3))
  end
  return it("returns true for even numbers", _36_)
end
describe("even?", _35_)
local function _37_()
  local function _38_()
    assert.is_false(core["odd?"](2))
    return assert.is_true(core["odd?"](3))
  end
  return it("returns true for odd numbers", _38_)
end
describe("odd?", _37_)
local function sort(t)
  local function _39_(x, y)
    if ("table" == type(x)) then
      return (core.first(x) < core.first(y))
    else
      return (x < y)
    end
  end
  table.sort(t, _39_)
  return t
end
local function _41_()
  local function _42_()
    assert.are.same({}, core.keys(nil))
    assert.are.same({}, core.keys({}))
    return assert.are.same({"a", "b"}, sort(core.keys({a = 2, b = 3})))
  end
  return it("returns the keys of a map", _42_)
end
describe("keys", _41_)
local function _43_()
  local function _44_()
    assert.are.same({}, core.vals(nil))
    assert.are.same({}, core.vals({}))
    return assert.are.same({2, 3}, sort(core.vals({a = 2, b = 3})))
  end
  return it("returns the values of a map", _44_)
end
return describe("vals", _43_)
