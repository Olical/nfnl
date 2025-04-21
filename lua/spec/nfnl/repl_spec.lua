-- [nfnl] fnl/spec/nfnl/repl_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local core = require("nfnl.core")
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
  it("starts a REPL that we can confinually call with more code", _3_)
  local function _4_()
    do
      local r1 = repl.new()
      local r2 = repl.new()
      local code = "(fn a []) (fn b []) {: a : b}"
      local pat = "%[#<function: 0x%x+>%s+#<function: 0x%x+>%s+{:%w #<function: 0x%x+> :%w #<function: 0x%x+>}%]"
      assert.matches(pat, core["pr-str"](r1(code)))
      assert.matches(pat, core["pr-str"](r2(code)))
      assert.matches(pat, core["pr-str"](r1(code)))
      assert.matches(pat, core["pr-str"](r2(code)))
    end
    return nil
  end
  return it("can handle function references, tables and multiple REPLs", _4_)
end
return describe("repl", _2_)
