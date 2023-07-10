-- [nfnl] Compiled from fnl/spec/nfnl/compile_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local config = require("nfnl.config")
local compile = require("nfnl.compile")
local function _2_()
  local function _3_()
    return assert.are.same({result = "-- [nfnl] Compiled from foo.fnl by https://github.com/Olical/nfnl, do not edit.\nreturn (10 + 20)\n", ["source-path"] = "/my/dir/foo.fnl", status = "ok"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/foo.fnl", cfg = config["cfg-fn"]({}), source = "(+ 10 20)", ["batch?"] = false}))
  end
  return it("compiles good Fennel to Lua", _3_)
end
return describe("into-string", _2_)
