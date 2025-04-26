-- [nfnl] fnl/spec/nfnl/macros/aniseed_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local _2amodule_2a
do
  local pkg_1_auto = require("package")
  pkg_1_auto.loaded["spec.nfnl.macros.aniseed-example"] = {}
  _2amodule_2a = pkg_1_auto.loaded["spec.nfnl.macros.aniseed-example"]
end
local private_val = "this is private"
local public_val
do
  _2amodule_2a["public-val"] = "this is public"
  public_val = _2amodule_2a["public-val"]
end
local function private_fn()
  return "this is private fn"
end
local public_fn
do
  local function public_fn0()
    return "this is public fn"
  end
  _2amodule_2a["public-fn"] = public_fn0
  public_fn = _2amodule_2a["public-fn"]
end
local private_once_val = (__fnl_global__private_2donce_2dval or "this is private once val")
local private_once_val0 = (private_once_val or "this is ignored")
local public_once_val
do
  _2amodule_2a["public-once-val"] = (_2amodule_2a["public-once-val"] or "this is public once val")
  public_once_val = _2amodule_2a["public-once-val"]
end
local public_once_val0
do
  _2amodule_2a["public-once-val"] = (_2amodule_2a["public-once-val"] or "this is ignored")
  public_once_val0 = _2amodule_2a["public-once-val"]
end
local mod = require("spec.nfnl.macros.aniseed-example")
local function _2_()
  local function _3_()
    assert.equals("this is private", private_val)
    return assert.equals(nil, mod["private-val"])
  end
  return it("defines private values", _3_)
end
describe("def-", _2_)
local function _4_()
  local function _5_()
    assert.equals("this is public", public_val)
    return assert.equals("this is public", mod["public-val"])
  end
  return it("defines public values", _5_)
end
describe("def", _4_)
local function _6_()
  local function _7_()
    assert.equals("this is private fn", private_fn())
    return assert.equals(nil, mod["private-fn"])
  end
  return it("defines private functions", _7_)
end
describe("defn-", _6_)
local function _8_()
  local function _9_()
    assert.equals("this is public fn", public_fn())
    return assert.equals("this is public fn", mod["public-fn"]())
  end
  return it("defines public functions", _9_)
end
describe("defn", _8_)
local function _10_()
  local function _11_()
    assert.equals("this is private once val", private_once_val0)
    return assert.equals(nil, mod["private-once-val"])
  end
  return it("defines private once values", _11_)
end
describe("defonce-", _10_)
local function _12_()
  local function _13_()
    assert.equals("this is public once val", public_once_val0)
    return assert.equals("this is public once val", mod["public-once-val"])
  end
  return it("defines public once values", _13_)
end
return describe("defonce", _12_)
