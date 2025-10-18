-- [nfnl] fnl/spec/nfnl/compile_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_.describe
local it = _local_1_.it
local assert = require("luassert.assert")
local config = require("nfnl.config")
local compile = require("nfnl.compile")
local function _2_()
  local function _3_()
    assert.is_true(compile["macro-source?"]({source = ("; " .. "[nfnl-macro]\n(+ 10 20)")}))
    return nil
  end
  it("detects macro source by marker in source", _3_)
  local function _4_()
    assert.is_true(compile["macro-source?"]({path = "/my/dir/foo.fnlm", source = "(+ 10 20)"}))
    return nil
  end
  it("detects macro source by .fnlm extension", _4_)
  local function _5_()
    assert.is_false(compile["macro-source?"]({source = "(+ 10 20)", path = "/my/dir/foo.fnl"}))
    return nil
  end
  return it("returns false for non-macro source", _5_)
end
describe("macro-source?", _2_)
local function _6_()
  local function _7_()
    return assert.are.same({result = "-- [nfnl] bar.fnl\nreturn (10 + 20)\n", ["source-path"] = "/tmp/foo/bar.fnl", status = "ok"}, compile["into-string"]({["root-dir"] = "/tmp/foo", path = "/tmp/foo/bar.fnl", cfg = config["cfg-fn"]({}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = "(+ 10 20)"}))
  end
  it("compiles good Fennel to Lua", _7_)
  local function _8_()
    return assert.are.same({["source-path"] = "/my/dir/baz.fnl", status = "path-is-not-in-source-file-patterns"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/baz.fnl", cfg = config["cfg-fn"]({["source-file-patterns"] = {"bar.fnl"}}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = "(+ 10 20)"}))
  end
  it("skips files that don't match :source-file-patterns", _8_)
  local function _9_()
    return assert.are.same({["source-path"] = "/my/dir/foo.fnl", status = "macros-are-not-compiled"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/foo.fnl", cfg = config["cfg-fn"]({}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = ("; [nfnl" .. "-" .. "macro]\n(+ 10 20)")}))
  end
  it("skips macro files", _9_)
  local function _10_()
    return assert.are.same({["source-path"] = "/my/dir/.nfnl.fnl", status = "nfnl-config-is-not-compiled"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/.nfnl.fnl", cfg = config["cfg-fn"]({}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = "(+ 10 20)"}))
  end
  it("won't compile the .nfnl.fnl config file", _10_)
  local function _11_()
    return assert.are.same({error = "/my/dir/foo.fnl:1:3: Compile error: tried to reference a special form without calling it\n\n10 / 20\n* Try making sure to use prefix operators, not infix.\n* Try wrapping the special in a function if you need it to be first class.", ["source-path"] = "/my/dir/foo.fnl", status = "compilation-error"}, compile["into-string"]({["root-dir"] = "/my/dir", path = "/my/dir/foo.fnl", cfg = config["cfg-fn"]({}, {["root-dir"] = "/tmp/foo"}), ["batch?"] = true, source = "10 / 20"}))
  end
  return it("returns compilation errors", _11_)
end
return describe("into-string", _6_)
