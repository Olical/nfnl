-- [nfnl] Compiled from fnl/spec/nfnl/compile_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local config = require("nfnl.config")
local compile = require("nfnl.compile")
local function _2_()
  local function _3_()
    return assert.are.same({result = "-- [nfnl] Compiled from foo.fnl by https://github.com/Olical/nfnl, do not edit.\nreturn (10 + 20)\n", ["source-path"] = "/my/dir/foo.fnl", status = "ok"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/foo.fnl", cfg = config["cfg-fn"]({}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = "(+ 10 20)"}))
  end
  it("compiles good Fennel to Lua", _3_)
  local function _4_()
    return assert.are.same({["source-path"] = "/my/dir/foo.fnl", status = "macros-are-not-compiled"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/foo.fnl", cfg = config["cfg-fn"]({}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = ("; [nfnl" .. "-" .. "macro]\n(+ 10 20)")}))
  end
  it("skips macro files", _4_)
  local function _5_()
    return assert.are.same({["source-path"] = "/my/dir/.nfnl.fnl", status = "nfnl-config-is-not-compiled"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/.nfnl.fnl", cfg = config["cfg-fn"]({}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = "(+ 10 20)"}))
  end
  it("won't compile the .nfnl.fnl config file", _5_)
  local function _6_()
    return assert.are.same({error = "/my/dir/foo.fnl:1:3 Compile error: tried to reference a special form without calling it\n\n10 \27[7m/\27[0m 20\n* Try making sure to use prefix operators, not infix.\n* Try wrapping the special in a function if you need it to be first class.", ["source-path"] = "/my/dir/foo.fnl", status = "compilation-error"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/foo.fnl", cfg = config["cfg-fn"]({}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = "10 / 20"}))
  end
  return it("returns compilation errors", _6_)
end
return describe("into-string", _2_)
