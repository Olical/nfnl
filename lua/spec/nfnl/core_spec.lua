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
return describe("rest", _14_)
