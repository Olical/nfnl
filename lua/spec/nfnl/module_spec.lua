-- [nfnl] fnl/spec/nfnl/module_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_.describe
local it = _local_1_.it
local assert = require("luassert.assert")
local _local_2_ = require("nfnl.module")
local autoload = _local_2_.autoload
local define = _local_2_.define
local function _3_()
  local function _4_()
    local core = autoload("nfnl.core")
    assert.equals(2, core.inc(1))
    return nil
  end
  return it("loads modules when their properties are accessed", _4_)
end
describe("autoload", _3_)
local function _5_()
  local function _6_()
    local m1 = define("nfnl.module")
    assert.equals(define, m1.define)
    local m2 = define("nfnl.module", {})
    assert.equals(define, m2.define)
    local m3 = define("nfnl.module.nope", {nope = true})
    assert.equals(nil, m3.define)
    assert.equals(true, m3.nope)
    return nil
  end
  return it("returns the loaded module if it's the same type as the base", _6_)
end
return describe("define", _5_)
