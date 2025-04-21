-- [nfnl] fnl/spec/nfnl/callback_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local callback = require("nfnl.callback")
local function _2_()
  local function _3_()
    assert["false"](callback["supported-path?"](nil))
    return assert["false"](callback["supported-path?"](10))
  end
  it("rejects non-strings", _3_)
  local function _4_()
    assert["false"](callback["supported-path?"]("fugitive://foo/bar"))
    return assert["false"](callback["supported-path?"]("ddu-ff:/xyz/foo/bar"))
  end
  it("rejects fugitive or ddu-ff protcols", _4_)
  local function _5_()
    assert["true"](callback["supported-path?"]("/foo/bar/baz"))
    assert["true"](callback["supported-path?"]("./x/y/z.foo"))
    return assert["true"](callback["supported-path?"]("henlo.world"))
  end
  return it("allows all other strings", _5_)
end
return describe("supported-path?", _2_)
