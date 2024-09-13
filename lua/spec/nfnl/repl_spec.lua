-- [nfnl] Compiled from fnl/spec/nfnl/repl_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local repl = require("nfnl.repl")
local function _2_()
  local function _3_()
    local r = repl.new()
    assert.are.same({{10, 20}}, r("[10 20]"))
    assert.are.same({"foo", "bar"}, r(":foo :bar\n"))
    assert.are.same({"foo", "bar"}, r("(values :foo :bar)"))
    assert.are.same(nil, r())
    assert.are.same(nil, r(":foo"))
    return nil
  end
  return it("starts a REPL that we can confinually call with more code", _3_)
end
return describe("repl", _2_)
