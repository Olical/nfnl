# Core.fnl

**Table of contents**

- [`assoc`](#assoc)
- [`assoc-in`](#assoc-in)
- [`boolean?`](#boolean)
- [`butlast`](#butlast)
- [`clear-table!`](#clear-table)
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
- [`seq`](#seq)
- [`sequential?`](#sequential)
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

Set the key `k` in table `t` to the value `v` while safely handling `nil`.

   Accepts more `k` and `v` pairs as after the initial pair. This allows you
   to assoc multiple values in one call.

   Returns the table `t` once it has been mutated.

## `assoc-in`
Function signature:

```
(assoc-in t ks v)
```

Set the key path `ks` in table `t` to the value `v` while safely handling `nil`.

   `(assoc-in {:foo {:bar 10}} [:foo :bar] 15) // => {:foo {:bar 15}}`

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

Return every value from the sequential table except the last one.

## `clear-table!`
Function signature:

```
(clear-table! t)
```

Clear all keys from the table.

## `complement`
Function signature:

```
(complement f)
```

Takes a fn `f` and returns a fn that takes the same arguments as `f`, has
   the same effects, if any, and returns the opposite truth value.

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

Returns a function that takes any number of arguments and returns `v`.

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

True if `n` is even.

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

The first item of the sequential table.

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

Get the key `k` from table `t` while safely handling `nil`. If it's not
   found it will return the optional default value `d`.

## `get-in`
Function signature:

```
(get-in t ks d)
```

Get the key path `ks` from table `t` while safely handling `nil`. If it's
   not found it will return the optional default value `d`.

   `(get-in {:foo {:bar 10}} [:foo :bar]) // => 10`

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

The last item of the sequential table.

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

The same as `map` but then `concat` all lists within the result together.

## `merge`
Function signature:

```
(merge ...)
```

Merge the tables together, `nil` will be skipped safely so you can use
   `(when ...)` to conditionally include tables. Merges into a fresh table so
   no existing tables will be mutated.

## `merge!`
Function signature:

```
(merge! base ...)
```

The same as `merge` above but will mutate the first argument, so all
   tables are merged into the first one.

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

True if `n` is odd.

## `pr`
Function signature:

```
(pr ...)
```

Print the arguments as data, strings will remain quoted.

## `pr-str`
Function signature:

```
(pr-str ...)
```

Convert the input arguments to a string.

## `println`
Function signature:

```
(println ...)
```

Convert the input arguments to a string (if required) and print them.

## `rand`
Function signature:

```
(rand n)
```

Draw a random floating point number between 0 and `n`, where `n` is 1.0 if omitted.
  You must have a random seed set before running this: `(math.randomseed (os.time))`

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

Opposite of filter, filter `xs` down to a new sequential table containing
   every value that `(f x)` returned falsy for.

## `rest`
Function signature:

```
(rest xs)
```

Return every value from the sequential table except the first one.

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

The second item of the sequential table.

## `select-keys`
Function signature:

```
(select-keys t ks)
```

Extract the keys listed in `ks` from `t` and return it as a new table.

## `seq`
Function signature:

```
(seq x)
```

Sequential tables are just returned, associative tables are returned as [[k v]], strings are returned as sequential tables of characters and nil returns nil. Empty tables and strings also coerce to nil.

## `sequential?`
Function signature:

```
(sequential? xs)
```

True if the value is a sequential table.

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

Concatenate the values into one string. Converting non-string values into
   strings where required.

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

Replace the key `k` in table `t` by passing the current value through the
   function `f`. Returns the table after the key has been mutated.

## `update-in`
Function signature:

```
(update-in t ks f)
```

Same as `update` but replace the key path at `ks` with the result of
   passing the current value through the function `f`.

## `vals`
Function signature:

```
(vals t)
```

Get all values of a table.


<!-- Generated with Fenneldoc v1.0.1
     https://gitlab.com/andreyorst/fenneldoc -->
