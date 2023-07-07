-- [nfnl] Compiled from fnl/spec/nfnl/core_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local function bello(boo)
    return ("bello " .. boo)
  end
  local bounter = nil
  local function _2_()
    bounter = 0
    return nil
  end
  before_each(_2_)
  local function _3_()
    bounter = 100
    return assert.equals("bello Brian", bello("Brian"))
  end
  it("some test", _3_)
  local function _4_()
    return assert.equals(0, bounter)
  end
  return it("some other test", _4_)
end
return describe("some basics", _1_)
