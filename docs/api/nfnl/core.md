# Core.fnl

**Table of contents**

- [`assoc`](#assoc)
- [`assoc-in`](#assoc-in)
- [`boolean?`](#boolean)
- [`butlast`](#butlast)
- [`complement`](#complement)
- [`concat`](#concat)
- [`constantly`](#constantly)
- [`count`](#count)
- [`dec`](#dec)
- [`distinct`](#distinct)
- [`empty?`](#empty)
- [`even?`](#even)
- [`filter`](#filter)
- [`first`](#first)
- [`function?`](#function)
- [`get`](#get)
- [`get-in`](#get-in)
- [`identity`](#identity)
- [`inc`](#inc)
- [`keys`](#keys)
- [`kv-pairs`](#kv-pairs)
- [`last`](#last)
- [`map`](#map)
- [`map-indexed`](#map-indexed)
- [`mapcat`](#mapcat)
- [`merge`](#merge)
- [`merge!`](#merge-1)
- [`nil?`](#nil)
- [`number?`](#number)
- [`odd?`](#odd)
- [`pr`](#pr)
- [`pr-str`](#pr-str)
- [`println`](#println)
- [`rand`](#rand)
- [`reduce`](#reduce)
- [`remove`](#remove)
- [`rest`](#rest)
- [`run!`](#run)
- [`second`](#second)
- [`select-keys`](#select-keys)
- [`slurp`](#slurp)
- [`some`](#some)
- [`sort`](#sort)
- [`spit`](#spit)
- [`str`](#str)
- [`string?`](#string)
- [`table?`](#table)
- [`update`](#update)
- [`update-in`](#update-in)
- [`vals`](#vals)

## `assoc`
Function signature:

```
(assoc t ...)
```

**Undocumented**

## `assoc-in`
Function signature:

```
(assoc-in t ks v)
```

**Undocumented**

## `boolean?`
Function signature:

```
(boolean? x)
```

True if the value is of type 'boolean'.

## `butlast`
Function signature:

```
(butlast xs)
```

**Undocumented**

## `complement`
Function signature:

```
(complement f)
```

**Undocumented**

## `concat`
Function signature:

```
(concat ...)
```

Concatenates the sequential table arguments together.

## `constantly`
Function signature:

```
(constantly v)
```

**Undocumented**

## `count`
Function signature:

```
(count xs)
```

Count the items / characters in the input. Can handle tables, nil, strings and anything else that works with `(length xs)`.

## `dec`
Function signature:

```
(dec n)
```

Decrement n by 1.

## `distinct`
Function signature:

```
(distinct xs)
```

Takes a sequential table of values (xs) and returns a distinct sequential table with all duplicates removed.

## `empty?`
Function signature:

```
(empty? xs)
```

Returns true if the argument is empty, this includes empty strings, lists and nil.

## `even?`
Function signature:

```
(even? n)
```

**Undocumented**

## `filter`
Function signature:

```
(filter f xs)
```

Filter xs down to a new sequential table containing every value that (f x) returned true for.

## `first`
Function signature:

```
(first xs)
```

**Undocumented**

## `function?`
Function signature:

```
(function? value)
```

True if the value is of type 'function'.

## `get`
Function signature:

```
(get t k d)
```

**Undocumented**

## `get-in`
Function signature:

```
(get-in t ks d)
```

**Undocumented**

## `identity`
Function signature:

```
(identity x)
```

Returns what you pass it.

## `inc`
Function signature:

```
(inc n)
```

Increment n by 1.

## `keys`
Function signature:

```
(keys t)
```

Get all keys of a table.

## `kv-pairs`
Function signature:

```
(kv-pairs t)
```

Get all keys and values of a table zipped up in pairs.

## `last`
Function signature:

```
(last xs)
```

**Undocumented**

## `map`
Function signature:

```
(map f xs)
```

Map xs to a new sequential table by calling (f x) on each item.

## `map-indexed`
Function signature:

```
(map-indexed f xs)
```

Map xs to a new sequential table by calling (f [k v]) on each item. 

## `mapcat`
Function signature:

```
(mapcat f xs)
```

**Undocumented**

## `merge`
Function signature:

```
(merge ...)
```

**Undocumented**

## `merge!`
Function signature:

```
(merge! base ...)
```

**Undocumented**

## `nil?`
Function signature:

```
(nil? x)
```

True if the value is equal to Lua `nil`.

## `number?`
Function signature:

```
(number? x)
```

True if the value is of type 'number'.

## `odd?`
Function signature:

```
(odd? n)
```

**Undocumented**

## `pr`
Function signature:

```
(pr ...)
```

**Undocumented**

## `pr-str`
Function signature:

```
(pr-str ...)
```

**Undocumented**

## `println`
Function signature:

```
(println ...)
```

**Undocumented**

## `rand`
Function signature:

```
(rand n)
```

Draw a random floating point number between 0 and `n`, where `n` is 1.0 if omitted.
  You must have a random seed set before running this: (math.randomseed (os.time))

## `reduce`
Function signature:

```
(reduce f init xs)
```

Reduce xs into a result by passing each subsequent value into the fn with
  the previous value as the first arg. Starting with init.

## `remove`
Function signature:

```
(remove f xs)
```

**Undocumented**

## `rest`
Function signature:

```
(rest xs)
```

**Undocumented**

## `run!`
Function signature:

```
(run! f xs)
```

Execute the function (for side effects) for every xs.

## `second`
Function signature:

```
(second xs)
```

**Undocumented**

## `select-keys`
Function signature:

```
(select-keys t ks)
```

**Undocumented**

## `slurp`
Function signature:

```
(slurp path)
```

Read the file into a string.

## `some`
Function signature:

```
(some f xs)
```

Return the first truthy result from (f x) or nil.

## `sort`
Function signature:

```
(sort xs)
```

Copies the sequential table xs, sorts it and returns it.

## `spit`
Function signature:

```
(spit path content opts)
```

Spit the string into the file. When opts.append is true, add to the file.

## `str`
Function signature:

```
(str ...)
```

**Undocumented**

## `string?`
Function signature:

```
(string? x)
```

True if the value is of type 'string'.

## `table?`
Function signature:

```
(table? x)
```

True if the value is of type 'table'.

## `update`
Function signature:

```
(update t k f)
```

**Undocumented**

## `update-in`
Function signature:

```
(update-in t ks f)
```

**Undocumented**

## `vals`
Function signature:

```
(vals t)
```

Get all values of a table.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
