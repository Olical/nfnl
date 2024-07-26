-- [nfnl] Compiled from fnl/spec/nfnl/core_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local core = require("nfnl.core")
local fs = require("nfnl.fs")
local function _2_()
  math.randomseed(os.time())
  local function _3_()
    return assert.is_number(core.rand())
  end
  it("returns a number", _3_)
  local function _4_()
    return assert.are_not.equal(core.rand(), core.rand())
  end
  return it("is not the same when called twice", _4_)
end
describe("rand", _2_)
local function _5_()
  local function _6_()
    return assert.equals(1, core.first({1, 2, 3}))
  end
  it("gets the first value", _6_)
  local function _7_()
    assert.is_nil(core.first(nil))
    return assert.is_nil(core.first({}))
  end
  return it("returns nil for empty lists or nil", _7_)
end
describe("first", _5_)
local function _8_()
  local function _9_()
    return assert.equals(3, core.last({1, 2, 3}))
  end
  it("gets the last value", _9_)
  local function _10_()
    assert.is_nil(core.last(nil))
    return assert.is_nil(core.last({}))
  end
  return it("returns nil for empty lists or nil", _10_)
end
describe("last", _8_)
local function _11_()
  local function _12_()
    assert.are.same({}, core.butlast(nil))
    assert.are.same({}, core.butlast({}))
    return assert.are.same({}, core.butlast({1}))
  end
  it("returns empty results where appropriate", _12_)
  local function _13_()
    return assert.are.same({1, 2}, core.butlast({1, 2, 3}))
  end
  return it("works when there's more than one item", _13_)
end
describe("butlast", _11_)
local function _14_()
  local function _15_()
    assert.are.same({}, core.rest(nil))
    assert.are.same({}, core.rest({}))
    return assert.are.same({}, core.rest({1}))
  end
  it("returns empty where appropriate", _15_)
  local function _16_()
    return assert.are.same({2, 3}, core.rest({1, 2, 3}))
  end
  return it("returns the rest if there's more than one value", _16_)
end
describe("rest", _14_)
local function _17_()
  local function _18_()
    assert.is_nil(core.second({}))
    assert.is_nil(core.second(nil))
    return assert.is_nil(core.second({1, nil, 3}))
  end
  it("returns nil when required", _18_)
  local function _19_()
    return assert.equals(2, core.second({1, 2, 3}))
  end
  return it("returns the second item if there is one", _19_)
end
describe("second", _17_)
local function _20_()
  local function _21_()
    assert.is_true(core["string?"]("foo"))
    assert.is_false(core["string?"](nil))
    return assert.is_false(core["string?"](10))
  end
  return it("returns true for strings", _21_)
end
describe("string?", _20_)
local function _22_()
  local function _23_()
    assert.is_false(core["nil?"]("foo"))
    assert.is_true(core["nil?"](nil))
    return assert.is_false(core["nil?"](10))
  end
  return it("returns true for strings", _23_)
end
describe("nil?", _22_)
local function _24_()
  local function _25_()
    local function _26_(_241)
      return ((_241 > 5) and _241)
    end
    return assert.is_nil(core.some(_26_, {1, 2, 3}))
  end
  it("returns nil when nothing matches", _25_)
  local function _27_()
    local function _28_(_241)
      return ((_241 > 2) and _241)
    end
    return assert.equals(3, core.some(_28_, {1, 2, 3}))
  end
  it("returns the first match", _27_)
  local function _29_()
    local function _30_(_241)
      return (_241 and (_241 > 2) and _241)
    end
    return assert.equals(3, core.some(_30_, {nil, 1, nil, 2, nil, 3, nil}))
  end
  return it("handles nils", _29_)
end
describe("some", _24_)
local function _31_()
  local function _32_()
    assert.equals(2, core.inc(1))
    return assert.equals(-4, core.inc(-5))
  end
  return it("increments numbers", _32_)
end
describe("inc", _31_)
local function _33_()
  local function _34_()
    assert.equals(1, core.dec(2))
    return assert.equals(-6, core.dec(-5))
  end
  return it("decrements numbers", _34_)
end
describe("dec", _33_)
local function _35_()
  local function _36_()
    assert.is_true(core["even?"](2))
    return assert.is_false(core["even?"](3))
  end
  return it("returns true for even numbers", _36_)
end
describe("even?", _35_)
local function _37_()
  local function _38_()
    assert.is_false(core["odd?"](2))
    return assert.is_true(core["odd?"](3))
  end
  return it("returns true for odd numbers", _38_)
end
describe("odd?", _37_)
local function sort_tables(t)
  local function _39_(x, y)
    if (("table" == type(x)) and ("table" == type(y))) then
      return (core.first(x) < core.first(y))
    elseif (type(x) ~= type(y)) then
      return (tostring(x) < tostring(y))
    else
      return (x < y)
    end
  end
  table.sort(t, _39_)
  return t
end
local function _41_()
  local function _42_()
    assert.are.same({}, core.keys(nil))
    assert.are.same({}, core.keys({}))
    return assert.are.same({"a", "b"}, sort_tables(core.keys({a = 2, b = 3})))
  end
  return it("returns the keys of a map", _42_)
end
describe("keys", _41_)
local function _43_()
  local function _44_()
    assert.are.same({}, core.vals(nil))
    assert.are.same({}, core.vals({}))
    return assert.are.same({2, 3}, sort_tables(core.vals({a = 2, b = 3})))
  end
  return it("returns the values of a map", _44_)
end
describe("vals", _43_)
local function _45_()
  local function _46_()
    assert.are.same({}, core["kv-pairs"](nil))
    assert.are.same({}, core["kv-pairs"]({}))
    assert.are.same({{"a", 1}, {"b", 2}}, sort_tables(core["kv-pairs"]({a = 1, b = 2})))
    return assert.are.same({{1, "a"}, {2, "b"}}, sort_tables(core["kv-pairs"]({"a", "b"})))
  end
  return it("turns a map into key value pair tuples", _46_)
end
describe("kv-pairs", _45_)
local function _47_()
  local function _48_()
    assert.equals("[1 2 3]", core["pr-str"]({1, 2, 3}))
    assert.equals("1 2 3", core["pr-str"](1, 2, 3))
    return assert.equals("nil", core["pr-str"](nil))
  end
  return it("prints a value into a string using Fennel's view function", _48_)
end
describe("pr-str", _47_)
local function _49_()
  local function _50_()
    assert.equals("", core.str())
    assert.equals("", core.str(""))
    assert.equals("", core.str(nil))
    assert.equals("abc", core.str("abc"))
    assert.equals("abc", core.str("a", "b", "c"))
    assert.equals("{:a \"abc\"}", core.str({a = "abc"}))
    return assert.equals("[1 2 3]abc", core.str({1, 2, 3}, "a", "bc"))
  end
  return it("joins many things into one string, using pr-str on the arguments", _50_)
end
describe("str", _49_)
local function _51_()
  local function _52_()
    return assert.are.same({2, 3, 4}, core.map(core.inc, {1, 2, 3}))
  end
  return it("maps a list to another list", _52_)
end
describe("map", _51_)
local function _53_()
  local function _54_()
    local function _56_(_55_)
      local k = _55_[1]
      local v = _55_[2]
      return {core.inc(k), v}
    end
    return assert.are.same({{2, "a"}, {3, "b"}}, core["map-indexed"](_56_, {"a", "b"}))
  end
  return it("maps a list to another list, providing the index to the map fn", _54_)
end
describe("map-indexed", _53_)
local function _57_()
  local function _58_()
    local function _59_()
      return false
    end
    assert.is_true(core.complement(_59_)())
    local function _60_()
      return true
    end
    return assert.is_false(core.complement(_60_)())
  end
  return it("inverts the boolean result of a function", _58_)
end
describe("complement", _57_)
local function _61_()
  local function _62_()
    local function _63_(_241)
      return (0 == (_241 % 2))
    end
    assert.are.same({2, 4, 6}, core.filter(_63_, {1, 2, 3, 4, 5, 6}))
    local function _64_(_241)
      return (0 == (_241 % 2))
    end
    return assert.are.same({}, core.filter(_64_, nil))
  end
  return it("filters values out of a list", _62_)
end
describe("filter", _61_)
local function _65_()
  local function _66_()
    local function _67_(_241)
      return (0 == (_241 % 2))
    end
    assert.are.same({1, 3, 5}, core.remove(_67_, {1, 2, 3, 4, 5, 6}))
    local function _68_(_241)
      return (0 == (_241 % 2))
    end
    return assert.are.same({}, core.remove(_68_, nil))
  end
  return it("removes matching items", _66_)
end
describe("remove", _65_)
local function _69_()
  local function _70_()
    assert.equals("hello", core.identity("hello"))
    return assert.is_nil(core.identity())
  end
  return it("returns what you give it", _70_)
end
describe("identity", _69_)
local function _71_()
  local function _72_()
    local orig = {1, 2, 3}
    assert.are.same({1, 2, 3, 4, 5, 6}, core.concat(orig, {4, 5, 6}))
    assert.are.same({4, 5, 6, 1, 2, 3}, core.concat({4, 5, 6}, orig))
    return assert.are.same({1, 2, 3}, orig)
  end
  return it("concatenates tables together", _72_)
end
describe("concat", _71_)
local function _73_()
  local function _74_()
    local function _75_(n)
      return {n, "x"}
    end
    return assert.are.same({1, "x", 2, "x", 3, "x"}, core.mapcat(_75_, {1, 2, 3}))
  end
  return it("maps and concats", _74_)
end
describe("mapcat", _73_)
local function _76_()
  local function _77_()
    assert.equals(3, core.count({1, 2, 3}), "three values")
    assert.equals(0, core.count({}), "empty")
    assert.equals(0, core.count(nil), "nil")
    assert.equals(0, core.count(nil), "no arg")
    assert.equals(3, core.count({1, nil, 3}), "nil gap")
    assert.equals(4, core.count({nil, nil, nil, "a"}), "mostly nils")
    assert.equals(3, core.count("foo"), "strings")
    assert.equals(0, core.count(""), "empty strings")
    return assert.equals(2, core.count({a = 1, b = 2}), "associative also works")
  end
  return it("counts various types", _77_)
end
describe("count", _76_)
local function _78_()
  local function _79_()
    assert.is_true(core["empty?"]({}), "empty table")
    assert.is_false(core["empty?"]({1}), "full table")
    assert.is_true(core["empty?"](""), "empty string")
    return assert.is_false(core["empty?"]("a"), "full string")
  end
  return it("checks if tables are empty", _79_)
end
describe("empty?", _78_)
local function _80_()
  local function _81_()
    assert.are.same({a = 1, b = 2}, core.merge({}, {a = 1}, {b = 2}), "simple maps")
    assert.are.same({}, core.merge(), "always start with an empty table")
    assert.are.same({a = 1}, core.merge(nil, {a = 1}), "into nil")
    return assert.are.same({a = 1, c = 3}, core.merge({a = 1}, nil, {c = 3}), "nil in the middle")
  end
  return it("merges tables together in a pure way returning a new table", _81_)
end
describe("merge", _80_)
local function _82_()
  local function _83_()
    local result = {c = 3}
    assert.are.same({a = 1, b = 2, c = 3}, core["merge!"](result, {a = 1}, {b = 2}), "simple maps")
    return assert.are.same({a = 1, b = 2, c = 3}, result, "the bang version side effects")
  end
  return it("merges in a side effecting way into the first table", _83_)
end
describe("merge!", _82_)
local function _84_()
  local function _85_()
    assert.are.same({}, core["select-keys"](nil, {"a", "b"}), "no table")
    assert.are.same({}, core["select-keys"]({}, {"a", "b"}), "empty table")
    assert.are.same({}, core["select-keys"]({a = 1, b = 2}, nil), "no keys")
    assert.are.same({}, core["select-keys"](nil, nil), "nothing")
    return assert.are.same({a = 1, c = 3}, core["select-keys"]({a = 1, b = 2, c = 3}, {"a", "c"}), "simple table and keys")
  end
  return it("pulls specific keys out of the table into a new one", _85_)
end
describe("select-keys", _84_)
local function _86_()
  local function _87_()
    assert.equals(nil, core.get(nil, "a"), "from nothing is nothing")
    assert.equals(nil, core.get({a = 1}, nil), "nothing from something is nothing")
    assert.equals(10, core.get(nil, nil, 10), "just a default returns a default")
    assert.equals(nil, core.get({a = 1}, "b"), "a missing key is nothing")
    assert.equals(2, core.get({a = 1}, "b", 2), "defaults replace missing")
    assert.equals(1, core.get({a = 1}, "a"), "results match")
    assert.equals(1, core.get({a = 1}, "a", 2), "results match (even with default)")
    return assert.equals("b", core.get({"a", "b"}, 2), "sequential tables work too")
  end
  return it("pulls values out of tables", _87_)
end
describe("get", _86_)
local function _88_()
  local function _89_()
    assert.equals(nil, core["get-in"](nil, {"a"}), "something from nil is nil")
    assert.are.same({a = 1}, core["get-in"]({a = 1}, {}), "empty path is idempotent")
    assert.equals(10, core["get-in"]({a = {b = 10, c = 20}}, {"a", "b"}), "two levels")
    return assert.equals(5, core["get-in"]({a = {b = 10, c = 20}}, {"a", "d"}, 5), "default")
  end
  return it("works like get, but deeply using a path table", _89_)
end
describe("get-in", _88_)
local function _90_()
  local function _91_()
    assert.are.same({}, core.assoc(nil, nil, nil), "3x nil is an empty map")
    assert.are.same({}, core.assoc(nil, "a", nil), "setting to nil is noop")
    assert.are.same({}, core.assoc(nil, nil, "a"), "nil key is noop")
    assert.are.same({a = 1}, core.assoc(nil, "a", 1), "from nothing to one key")
    assert.are.same({"a"}, core.assoc(nil, 1, "a"), "sequential")
    assert.are.same({a = 1, b = 2}, core.assoc({a = 1}, "b", 2), "adding to existing")
    assert.are.same({a = 1, b = 2, c = 3}, core.assoc({a = 1}, "b", 2, "c", 3), "multi arg")
    assert.are.same({a = 1, b = 2, c = 3, d = 4}, core.assoc({a = 1}, "b", 2, "c", 3, "d", 4), "more multi arg")
    local ok_3f, msg = nil, nil
    local function _92_()
      return core.assoc({a = 1}, "b", 2, "c")
    end
    ok_3f, msg = pcall(_92_)
    assert.is_false(ok_3f, "uneven args - ok?")
    return assert.equals("expects even number", msg:match("expects even number"), "uneven args - msg")
  end
  return it("puts values into tables", _91_)
end
describe("assoc", _90_)
local function _93_()
  local function _94_()
    assert.are.same({}, core["assoc-in"](nil, nil, nil), "empty as possible")
    assert.are.same({}, core["assoc-in"](nil, {}, nil), "empty path, nothing else")
    assert.are.same({}, core["assoc-in"](nil, {}, 2), "empty path and a value")
    assert.are.same({a = 1}, core["assoc-in"]({a = 1}, {}, 2), "empty path, base table and a value")
    assert.are.same({a = 1, b = 2}, core["assoc-in"]({a = 1}, {"b"}, 2), "simple one path segment")
    assert.are.same({a = 1, b = {c = 2}}, core["assoc-in"]({a = 1}, {"b", "c"}, 2), "two levels from base")
    assert.are.same({b = {c = 2}}, core["assoc-in"](nil, {"b", "c"}, 2), "two levels from nothing")
    return assert.are.same({a = {b = {"c"}}}, core["assoc-in"](nil, {"a", "b", 1}, "c"), "mixing associative and sequential")
  end
  return it("works like assoc but deeply with a path table", _94_)
end
describe("assoc-in", _93_)
local function _95_()
  local function _96_()
    return assert.are.same({foo = 2}, core.update({foo = 1}, "foo", core.inc), "increment a value")
  end
  return it("updates a key with a function", _96_)
end
describe("update", _95_)
local function _97_()
  local function _98_()
    return assert.are.same({foo = {bar = 2}}, core["update-in"]({foo = {bar = 1}}, {"foo", "bar"}, core.inc), "increment a value")
  end
  return it("like update but nested with a path table", _98_)
end
describe("update-in", _97_)
local function _99_()
  local function _100_()
    local f = core.constantly("foo")
    assert.equals("foo", f())
    return assert.equals("foo", f("bar"))
  end
  return it("builds a function that always returns the same thing", _100_)
end
describe("constantly", _99_)
local function _101_()
  local tmp_dir = vim.fn.tempname()
  local tmp_path = fs["join-path"]({tmp_dir, "foo.txt"})
  local expected_body = "Hello, World!"
  fs.mkdirp(tmp_dir)
  local function _102_()
    core.spit(tmp_path, expected_body)
    return assert.equals(expected_body, core.slurp(tmp_path))
  end
  it("spits the contents into a file and can be read back with slurp", _102_)
  local function _103_()
    assert.is_nil(core.slurp("nope does not exist"))
    return assert.is_nil(core.slurp(nil))
  end
  it("returns nil if you slurp a nil or bad path", _103_)
  local function _104_()
    core.spit(tmp_path, "\nxyz", {append = true})
    return assert.equals((expected_body .. "\nxyz"), core.slurp(tmp_path))
  end
  return it("appends to a file if the :append option is set", _104_)
end
describe("spit / slurp", _101_)
local function _105_()
  local function _106_()
    return assert.are.same({1, 2, 3}, core.sort({3, 1, 2}))
  end
  return it("sorts tables without modifying the original", _106_)
end
describe("sort", _105_)
local function _107_()
  local function _108_()
    assert.are.same({}, core.distinct(nil))
    return assert.are.same({}, core.distinct({}))
  end
  it("does nothing to empty tables", _108_)
  local function _109_()
    return assert.are.same({1, 2, 3}, sort_tables(core.distinct({1, 2, 3})))
  end
  it("does nothing to already distinct lists", _109_)
  local function _110_()
    return assert.are.same({1, 2, 3}, sort_tables(core.distinct({1, 2, 2, 3})))
  end
  it("removes duplicates of any type", _110_)
  local function _111_()
    assert.are.same({"a", "b", "c"}, sort_tables(core.distinct({"a", "b", "c", "c"})))
    local t = {1, 2}
    return assert.are.same({"a", "c", t}, sort_tables(core.distinct({"a", t, "c", t, "c"})))
  end
  return it("removes duplicates of any type", _111_)
end
describe("distinct", _107_)
local function _112_()
  local function _113_()
    local t = {a = 1, b = 2}
    core["clear-table!"](t)
    return assert.are.same({}, t)
  end
  return it("clears a table", _113_)
end
return describe("clear-table!", _112_)
