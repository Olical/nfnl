-- [nfnl] fnl/spec/nfnl/header_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_.describe
local it = _local_1_.it
local assert = require("luassert.assert")
local header = require("nfnl.header")
local function _2_()
  local function _3_()
    assert.is_true(header["tagged?"](header["with-header"]("fnl/foo.fnl", "")))
    return assert.is_true(header["tagged?"]("-- [nfnl] fnl/foo.fnl"))
  end
  it("accepts the header nfnl writes", _3_)
  local function _4_()
    assert.is_false(header["tagged?"]("-- The [nfnl] marker below shows the source."))
    assert.is_false(header["tagged?"]("print(\"-- [nfnl] fnl/foo.fnl\")"))
    return assert.is_false(header["tagged?"]("--[nfnl] fnl/foo.fnl"))
  end
  it("rejects lines that mention the tag elsewhere", _4_)
  local function _5_()
    return assert.is_false(header["tagged?"](nil))
  end
  return it("rejects missing lines", _5_)
end
describe("tagged?", _2_)
local function _6_()
  local function _7_()
    return assert.equals("fnl/foo.fnl", header["source-path"]("-- [nfnl] fnl/foo.fnl"))
  end
  it("finds the source path in a header", _7_)
  local function _8_()
    return assert.is_nil(header["source-path"]("-- See [nfnl] fnl/foo.fnl"))
  end
  return it("ignores lines that only mention the tag", _8_)
end
describe("source-path", _6_)
local function _9_()
  local function _10_()
    local path = vim.fn.tempname()
    do
      local f = io.open(path, "w")
      local function close_handlers_13_(ok_14_, ...)
        f:close()
        if ok_14_ then
          return ...
        else
          return error(..., 0)
        end
      end
      local function _12_()
        return f:write("#!/usr/bin/lua\n-- The [nfnl] marker below shows the source.\n-- [nfnl] fnl/foo.fnl\nreturn 1\n")
      end
      local _14_
      do
        local t_13_ = _G
        if (nil ~= t_13_) then
          t_13_ = t_13_.package
        else
        end
        if (nil ~= t_13_) then
          t_13_ = t_13_.loaded
        else
        end
        if (nil ~= t_13_) then
          t_13_ = t_13_.fennel
        else
        end
        _14_ = t_13_
      end
      local or_18_ = _14_ or _G.debug
      if not or_18_ then
        local function _19_()
          return ""
        end
        or_18_ = {traceback = _19_}
      end
      close_handlers_13_(_G.xpcall(_12_, or_18_.traceback))
    end
    do
      local line, prefix = header.read(path, 5)
      assert.equals("-- [nfnl] fnl/foo.fnl", line)
      assert.equals("#!/usr/bin/lua\n-- The [nfnl] marker below shows the source.\n", prefix)
    end
    return os.remove(path)
  end
  return it("skips comments that mention the tag above the real header", _10_)
end
return describe("read", _9_)
