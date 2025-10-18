-- [nfnl] fnl/spec/nfnl/macros_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_.describe
local it = _local_1_.it
local assert = require("luassert.assert")
local function _2_()
  local function _3_()
    local function _4_()
      local foo = "ok"
      if foo then
        return foo
      else
        return "nope"
      end
    end
    assert.equals("ok", _4_())
    local function _6_()
      local foo = false
      if foo then
        return "first"
      else
        return "nope"
      end
    end
    assert.equals("nope", _6_())
    local function _9_()
      local value_5_auto = {a = 1}
      local _let_8_ = (value_5_auto or {})
      local a = _let_8_.a
      if value_5_auto then
        return "yes"
      else
        return "no"
      end
    end
    assert.equals("yes", _9_())
    local function _12_()
      local value_5_auto = nil
      local _let_11_ = (value_5_auto or {})
      local a = _let_11_.a
      if value_5_auto then
        return "yes"
      else
        return "no"
      end
    end
    return assert.equals("no", _12_())
  end
  return it("works like if + let", _3_)
end
describe("if-let", _2_)
local function _14_()
  local function _15_()
    local function _16_()
      local foo = "ok"
      if foo then
        return foo
      else
        return nil
      end
    end
    assert.equals("ok", _16_())
    local function _18_()
      local foo = false
      if foo then
        return "first"
      else
        return nil
      end
    end
    assert.equals(nil, _18_())
    local function _21_()
      local ok_3f, val
      local function _20_()
        return "yarp"
      end
      ok_3f, val = pcall(_20_)
      if ok_3f then
        return val
      else
        return nil
      end
    end
    assert.equals("yarp", _21_())
    local function _25_()
      local bind_23_, val
      local function _24_()
        return "yarp"
      end
      bind_23_, val = pcall(_24_)
      if bind_23_ then
        return val
      else
        return nil
      end
    end
    assert.equals("yarp", _25_())
    local function _28_()
      local ok_3f, val
      local function _27_()
        return error("narp")
      end
      ok_3f, val = pcall(_27_)
      if ok_3f then
        return val
      else
        return nil
      end
    end
    return assert.equals(nil, _28_())
  end
  return it("works like when + let", _15_)
end
return describe("when-let", _14_)
