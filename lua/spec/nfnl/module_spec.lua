-- [nfnl] Compiled from fnl/spec/nfnl/module_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local _local_2_ = require("nfnl.module")
local autoload = _local_2_["autoload"]
local function _3_()
  local function _4_()
    local core = autoload("nfnl.core")
    return assert.equals(2, core.inc(1))
  end
  return it("loads modules when their properties are accessed", _4_)
end
return describe("autoload", _3_)
