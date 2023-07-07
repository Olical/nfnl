#!/usr/bin/env lua
FENNELDOC_VERSION = [[v1.0.1]]
local function _2_()
  return "#<namespace: fenneldoc>"
end
package.preload["config"] = package.preload["config"] or function(...)
  local function _4_()
    return "#<namespace: config-utils>"
  end
  local _local_3_ = {setmetatable({}, {__fennelview = _4_, __name = "namespace"}), require("fennel")}
  local config_utils = _local_3_[1]
  local _local_5_ = _local_3_[2]
  local fennel = _local_5_
  local dofile = _local_5_["dofile"]
  local view = _local_5_["view"]
  local deprecated_keys = {["project-doc-order"] = "'project-doc-order' was deprecated and no longer supported - use the 'doc-order' key in the 'modules-info' table.", keys = "'keys' was deprecated and no longer supported - use the 'modules-info' table to provide module information instead."}
  local config = {["fennel-path"] = {}, ["function-signatures"] = true, ["ignored-args-patterns"] = {"%.%.%.", "%_", "%_[^%s]+"}, ["inline-references"] = "link", ["insert-comment"] = true, ["insert-copyright"] = true, ["insert-license"] = true, ["insert-version"] = true, ["modules-info"] = {}, ["project-copyright"] = nil, ["project-version"] = nil, ["project-license"] = nil, mode = "checkdoc", order = "alphabetic", ["out-dir"] = "./doc", sandbox = true, ["test-requirements"] = {}, toc = true}
  local warned = {}
  local process_config
  do
    local v_33_auto
    local function process_config0(...)
      local version = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "process-config"))
        else
        end
      end
      do
        local _7_, _8_ = pcall(dofile, ".fenneldoc")
        if ((_7_ == true) and (nil ~= _8_)) then
          local rc = _8_
          for k, v in pairs(rc) do
            do
              local _9_ = deprecated_keys[k]
              if (nil ~= _9_) then
                local msg = _9_
                if not warned[k] then
                  do end (io.stderr):write("WARNING: '.fenneldoc': ", msg, "\n")
                  do end (warned)[k] = true
                else
                end
              else
              end
            end
            config[k] = v
          end
        elseif ((_7_ == false) and (nil ~= _8_)) then
          local msg = _8_
          if not msg:match(".fenneldoc: No such file or directory") then
            do end (io.stderr):write(msg, "\n")
          else
          end
        else
        end
      end
      for _, path in pairs(config["fennel-path"]) do
        fennel.path = (path .. ";" .. fennel.path)
      end
      config["fenneldoc-version"] = version
      return config
    end
    v_33_auto = process_config0
    config_utils["process-config"] = v_33_auto
    process_config = v_33_auto
  end
  do end (fennel.metadata):set(process_config, "fnl/docstring", ("Process configuration file and merge it with default configuration.\nConfiguration is stored in `.fenneldoc` which is looked up in the\nworking directory.  Injects private `version` field in config.\n\nDefault configuration:\n\n``` fennel\n" .. view(config) .. "\n```\n\n# Key descriptions\n\n- `mode` - mode to operate in:\n  - `checkdoc` - run checks and generate documentation files if no\n    errors occurred;\n  - `check` - only run checks;\n  - `doc` - only generate documentation files.\n- `ignored-args-patterns` - list of patterns to check when checking\n  function argument docstring presence check should be skipped.\n\n- `inline-references` - how to handle inline references.  Inline\n  references are denoted with opening backtick and closed with single\n  quote.  Fenneldoc supports several modes to operate on inline\n  references:\n  - `:link` - convert inline references into links to headings found\n    in current file.\n  - `:code` - all inline references will be converted to inline code.\n  - `:keep` - inline references are kept as is.\n- `fennel-path` - add PATH to fennel.path for finding Fennel modules.\n- `test-requirements` - code, that will be injected into each test in\n  respecting module.\n  For example, when testing macro module `{:macro-module.fnl\n  \"(import-macros {: some-macro} :macro-module)\"}` will inject the\n  following code into beginning of each test, hence requiring needed\n  macros.  This should be not needed for ordinary modules, as those\n  are compiled before analyzing, which means macros and dependencies\n  should be already resolved.\n- `function-signatures` - whether to generate function signatures in documentation.\n- `final-comment` - whether to insert final comment with fenneldoc version.\n- `copyright` - whether to insert copyright information.\n- `license` - whether to insert license information from the module.\n- `toc` - whether to generate table of contents.\n- `out-dir` - path where to put documentation files.\n- `order` - sorting of items that were not given particular order.\nSupported algorithms: alphabetic, reverse-alphabetic.\nYou also can specify a custom sorting function for this key.\n- `sandbox` - whether to sandbox loading code and running documentation tests.\n\n## Project information\n\nYou can store project information either in project files directly, as\ndescribed in the section above, or you can specify most (but not all)\nof this information in `.fenneldoc` configuration file. Fenneldoc\nprovides the following set of keys for that:\n\n- `project-license` - string that contains project license name or\n  Markdown link.\n- `project-copyright` - copyright string.\n- `project-version` - version information about your project that\n  should appear in each file. This version can be overridden for\n  certain files by specifying version in the module info.\n- `modules-info` - an associative table that holds file names and\n  information about the modules, contained in those.  Supported keys\n  `:description`, `:copyright`, `:doc-order`, `:license`, `:name`,\n  `:version`.  For example:\n\n  ```fennel\n  {:modules-info {:some-module.fnl {:description \"some module description\"\n                                    :license \"GNU GPL\"\n                                    :name \"Some Module\"\n                                    :doc-order [\"some-fn1\" \"some-fn2\" \"etc\"]}}}\n  ```"))
  return config_utils
end
package.preload["fennel"] = package.preload["fennel"] or function(...)
  package.preload["fennel.repl"] = package.preload["fennel.repl"] or function(...)
    local utils = require("fennel.utils")
    local parser = require("fennel.parser")
    local compiler = require("fennel.compiler")
    local specials = require("fennel.specials")
    local view = require("fennel.view")
    local unpack = (table.unpack or _G.unpack)
    local function default_read_chunk(parser_state)
      local function _631_()
        if (0 < parser_state["stack-size"]) then
          return ".."
        else
          return ">> "
        end
      end
      io.write(_631_())
      io.flush()
      local input = io.read()
      return (input and (input .. "\n"))
    end
    local function default_on_values(xs)
      io.write(table.concat(xs, "\9"))
      return io.write("\n")
    end
    local function default_on_error(errtype, err, lua_source)
      local function _633_()
        local _632_ = errtype
        if (_632_ == "Lua Compile") then
          return ("Bad code generated - likely a bug with the compiler:\n" .. "--- Generated Lua Start ---\n" .. lua_source .. "--- Generated Lua End ---\n")
        elseif (_632_ == "Runtime") then
          return (compiler.traceback(tostring(err), 4) .. "\n")
        elseif true then
          local _ = _632_
          return ("%s error: %s\n"):format(errtype, tostring(err))
        else
          return nil
        end
      end
      return io.write(_633_())
    end
    local function splice_save_locals(env, lua_source, scope)
      local saves
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for name in pairs(env.___replLocals___) do
          local val_18_auto = ("local %s = ___replLocals___['%s']"):format(name, name)
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        saves = tbl_16_auto
      end
      local binds
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for _, name in pairs(scope.manglings) do
          local val_18_auto
          if not scope.gensyms[name] then
            val_18_auto = ("___replLocals___['%s'] = %s"):format(name, name)
          else
            val_18_auto = nil
          end
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        binds = tbl_16_auto
      end
      local gap
      if lua_source:find("\n") then
        gap = "\n"
      else
        gap = " "
      end
      local function _639_()
        if next(saves) then
          return (table.concat(saves, " ") .. gap)
        else
          return ""
        end
      end
      local function _642_()
        local _640_, _641_ = lua_source:match("^(.*)[\n ](return .*)$")
        if ((nil ~= _640_) and (nil ~= _641_)) then
          local body = _640_
          local _return = _641_
          return (body .. gap .. table.concat(binds, " ") .. gap .. _return)
        elseif true then
          local _ = _640_
          return lua_source
        else
          return nil
        end
      end
      return (_639_() .. _642_())
    end
    local function completer(env, scope, text)
      local max_items = 2000
      local seen = {}
      local matches = {}
      local input_fragment = text:gsub(".*[%s)(]+", "")
      local stop_looking_3f = false
      local function add_partials(input, tbl, prefix)
        local scope_first_3f = ((tbl == env) or (tbl == env.___replLocals___))
        local tbl_16_auto = matches
        local i_17_auto = #tbl_16_auto
        local function _644_()
          if scope_first_3f then
            return scope.manglings
          else
            return tbl
          end
        end
        for k, is_mangled in utils.allpairs(_644_()) do
          if (max_items <= #matches) then break end
          local val_18_auto
          do
            local lookup_k
            if scope_first_3f then
              lookup_k = is_mangled
            else
              lookup_k = k
            end
            if ((type(k) == "string") and (input == k:sub(0, #input)) and not seen[k] and ((":" ~= prefix:sub(-1)) or ("function" == type(tbl[lookup_k])))) then
              seen[k] = true
              val_18_auto = (prefix .. k)
            else
              val_18_auto = nil
            end
          end
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        return tbl_16_auto
      end
      local function descend(input, tbl, prefix, add_matches, method_3f)
        local splitter
        if method_3f then
          splitter = "^([^:]+):(.*)"
        else
          splitter = "^([^.]+)%.(.*)"
        end
        local head, tail = input:match(splitter)
        local raw_head = (scope.manglings[head] or head)
        if (type(tbl[raw_head]) == "table") then
          stop_looking_3f = true
          if method_3f then
            return add_partials(tail, tbl[raw_head], (prefix .. head .. ":"))
          else
            return add_matches(tail, tbl[raw_head], (prefix .. head))
          end
        else
          return nil
        end
      end
      local function add_matches(input, tbl, prefix)
        local prefix0
        if prefix then
          prefix0 = (prefix .. ".")
        else
          prefix0 = ""
        end
        if (not input:find("%.") and input:find(":")) then
          return descend(input, tbl, prefix0, add_matches, true)
        elseif not input:find("%.") then
          return add_partials(input, tbl, prefix0)
        else
          return descend(input, tbl, prefix0, add_matches, false)
        end
      end
      for _, source in ipairs({scope.specials, scope.macros, (env.___replLocals___ or {}), env, env._G}) do
        if stop_looking_3f then break end
        add_matches(input_fragment, source)
      end
      return matches
    end
    local commands = {}
    local function command_3f(input)
      return input:match("^%s*,")
    end
    local function command_docs()
      local _653_
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for name, f in pairs(commands) do
          local val_18_auto = ("  ,%s - %s"):format(name, ((compiler.metadata):get(f, "fnl/docstring") or "undocumented"))
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        _653_ = tbl_16_auto
      end
      return table.concat(_653_, "\n")
    end
    commands.help = function(_, _0, on_values)
      return on_values({("Welcome to Fennel.\nThis is the REPL where you can enter code to be evaluated.\nYou can also run these repl commands:\n\n" .. command_docs() .. "\n  ,exit - Leave the repl.\n\nUse ,doc something to see descriptions for individual macros and special forms.\n\nFor more information about the language, see https://fennel-lang.org/reference")})
    end
    do end (compiler.metadata):set(commands.help, "fnl/docstring", "Show this message.")
    local function reload(module_name, env, on_values, on_error)
      local _655_, _656_ = pcall(specials["load-code"]("return require(...)", env), module_name)
      if ((_655_ == true) and (nil ~= _656_)) then
        local old = _656_
        local _
        package.loaded[module_name] = nil
        _ = nil
        local ok, new = pcall(require, module_name)
        local new0
        if not ok then
          on_values({new})
          new0 = old
        else
          new0 = new
        end
        specials["macro-loaded"][module_name] = nil
        if ((type(old) == "table") and (type(new0) == "table")) then
          for k, v in pairs(new0) do
            old[k] = v
          end
          for k in pairs(old) do
            if (nil == (new0)[k]) then
              old[k] = nil
            else
            end
          end
          package.loaded[module_name] = old
        else
        end
        return on_values({"ok"})
      elseif ((_655_ == false) and (nil ~= _656_)) then
        local msg = _656_
        if msg:match("loop or previous error loading module") then
          package.loaded[module_name] = nil
          return reload(module_name, env, on_values, on_error)
        elseif (specials["macro-loaded"])[module_name] then
          specials["macro-loaded"][module_name] = nil
          return nil
        else
          local function _661_()
            local _660_ = msg:gsub("\n.*", "")
            return _660_
          end
          return on_error("Runtime", _661_())
        end
      else
        return nil
      end
    end
    local function run_command(read, on_error, f)
      local _664_, _665_, _666_ = pcall(read)
      if ((_664_ == true) and (_665_ == true) and (nil ~= _666_)) then
        local val = _666_
        return f(val)
      elseif (_664_ == false) then
        return on_error("Parse", "Couldn't parse input.")
      else
        return nil
      end
    end
    commands.reload = function(env, read, on_values, on_error)
      local function _668_(_241)
        return reload(tostring(_241), env, on_values, on_error)
      end
      return run_command(read, on_error, _668_)
    end
    do end (compiler.metadata):set(commands.reload, "fnl/docstring", "Reload the specified module.")
    commands.reset = function(env, _, on_values)
      env.___replLocals___ = {}
      return on_values({"ok"})
    end
    do end (compiler.metadata):set(commands.reset, "fnl/docstring", "Erase all repl-local scope.")
    commands.complete = function(env, read, on_values, on_error, scope, chars)
      local function _669_()
        return on_values(completer(env, scope, string.char(unpack(chars)):gsub(",complete +", ""):sub(1, -2)))
      end
      return run_command(read, on_error, _669_)
    end
    do end (compiler.metadata):set(commands.complete, "fnl/docstring", "Print all possible completions for a given input symbol.")
    local function apropos_2a(pattern, tbl, prefix, seen, names)
      for name, subtbl in pairs(tbl) do
        if (("string" == type(name)) and (package ~= subtbl)) then
          local _670_ = type(subtbl)
          if (_670_ == "function") then
            if ((prefix .. name)):match(pattern) then
              table.insert(names, (prefix .. name))
            else
            end
          elseif (_670_ == "table") then
            if not seen[subtbl] then
              local _673_
              do
                local _672_ = seen
                _672_[subtbl] = true
                _673_ = _672_
              end
              apropos_2a(pattern, subtbl, (prefix .. name:gsub("%.", "/") .. "."), _673_, names)
            else
            end
          else
          end
        else
        end
      end
      return names
    end
    local function apropos(pattern)
      local names = apropos_2a(pattern, package.loaded, "", {}, {})
      local tbl_16_auto = {}
      local i_17_auto = #tbl_16_auto
      for _, name in ipairs(names) do
        local val_18_auto = name:gsub("^_G%.", "")
        if (nil ~= val_18_auto) then
          i_17_auto = (i_17_auto + 1)
          do end (tbl_16_auto)[i_17_auto] = val_18_auto
        else
        end
      end
      return tbl_16_auto
    end
    commands.apropos = function(_env, read, on_values, on_error, _scope)
      local function _678_(_241)
        return on_values(apropos(tostring(_241)))
      end
      return run_command(read, on_error, _678_)
    end
    do end (compiler.metadata):set(commands.apropos, "fnl/docstring", "Print all functions matching a pattern in all loaded modules.")
    local function apropos_follow_path(path)
      local paths
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for p in path:gmatch("[^%.]+") do
          local val_18_auto = p
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        paths = tbl_16_auto
      end
      local tgt = package.loaded
      for _, path0 in ipairs(paths) do
        if (nil == tgt) then break end
        local _681_
        do
          local _680_ = path0:gsub("%/", ".")
          _681_ = _680_
        end
        tgt = tgt[_681_]
      end
      return tgt
    end
    local function apropos_doc(pattern)
      local tbl_16_auto = {}
      local i_17_auto = #tbl_16_auto
      for _, path in ipairs(apropos(".*")) do
        local val_18_auto
        do
          local tgt = apropos_follow_path(path)
          if ("function" == type(tgt)) then
            local _682_ = (compiler.metadata):get(tgt, "fnl/docstring")
            if (nil ~= _682_) then
              local docstr = _682_
              val_18_auto = (docstr:match(pattern) and path)
            else
              val_18_auto = nil
            end
          else
            val_18_auto = nil
          end
        end
        if (nil ~= val_18_auto) then
          i_17_auto = (i_17_auto + 1)
          do end (tbl_16_auto)[i_17_auto] = val_18_auto
        else
        end
      end
      return tbl_16_auto
    end
    commands["apropos-doc"] = function(_env, read, on_values, on_error, _scope)
      local function _686_(_241)
        return on_values(apropos_doc(tostring(_241)))
      end
      return run_command(read, on_error, _686_)
    end
    do end (compiler.metadata):set(commands["apropos-doc"], "fnl/docstring", "Print all functions that match the pattern in their docs")
    local function apropos_show_docs(on_values, pattern)
      for _, path in ipairs(apropos(pattern)) do
        local tgt = apropos_follow_path(path)
        if (("function" == type(tgt)) and (compiler.metadata):get(tgt, "fnl/docstring")) then
          on_values(specials.doc(tgt, path))
          on_values()
        else
        end
      end
      return nil
    end
    commands["apropos-show-docs"] = function(_env, read, on_values, on_error)
      local function _688_(_241)
        return apropos_show_docs(on_values, tostring(_241))
      end
      return run_command(read, on_error, _688_)
    end
    do end (compiler.metadata):set(commands["apropos-show-docs"], "fnl/docstring", "Print all documentations matching a pattern in function name")
    local function resolve(identifier, _689_, scope)
      local _arg_690_ = _689_
      local ___replLocals___ = _arg_690_["___replLocals___"]
      local env = _arg_690_
      local e
      local function _691_(_241, _242)
        return (___replLocals___[_242] or env[_242])
      end
      e = setmetatable({}, {__index = _691_})
      local _692_, _693_ = pcall(compiler["compile-string"], tostring(identifier), {scope = scope})
      if ((_692_ == true) and (nil ~= _693_)) then
        local code = _693_
        return specials["load-code"](code, e)()
      else
        return nil
      end
    end
    commands.find = function(env, read, on_values, on_error, scope)
      local function _695_(_241)
        local _696_
        do
          local _697_ = utils["sym?"](_241)
          if (nil ~= _697_) then
            local _698_ = resolve(_697_, env, scope)
            if (nil ~= _698_) then
              _696_ = debug.getinfo(_698_)
            else
              _696_ = _698_
            end
          else
            _696_ = _697_
          end
        end
        if ((_G.type(_696_) == "table") and ((_696_).what == "Lua") and (nil ~= (_696_).source) and (nil ~= (_696_).linedefined) and (nil ~= (_696_).short_src)) then
          local source = (_696_).source
          local line = (_696_).linedefined
          local src = (_696_).short_src
          local fnlsrc
          do
            local t_701_ = compiler.sourcemap
            if (nil ~= t_701_) then
              t_701_ = (t_701_)[source]
            else
            end
            if (nil ~= t_701_) then
              t_701_ = (t_701_)[line]
            else
            end
            if (nil ~= t_701_) then
              t_701_ = (t_701_)[2]
            else
            end
            fnlsrc = t_701_
          end
          return on_values({string.format("%s:%s", src, (fnlsrc or line))})
        elseif (_696_ == nil) then
          return on_error("Repl", "Unknown value")
        elseif true then
          local _ = _696_
          return on_error("Repl", "No source info")
        else
          return nil
        end
      end
      return run_command(read, on_error, _695_)
    end
    do end (compiler.metadata):set(commands.find, "fnl/docstring", "Print the filename and line number for a given function")
    commands.doc = function(env, read, on_values, on_error, scope)
      local function _706_(_241)
        local name = tostring(_241)
        local path = (utils["multi-sym?"](name) or {name})
        local ok_3f, target = nil, nil
        local function _707_()
          return (utils["get-in"](scope.specials, path) or utils["get-in"](scope.macros, path) or resolve(name, env, scope))
        end
        ok_3f, target = pcall(_707_)
        if ok_3f then
          return on_values({specials.doc(target, name)})
        else
          return on_error("Repl", "Could not resolve value for docstring lookup")
        end
      end
      return run_command(read, on_error, _706_)
    end
    do end (compiler.metadata):set(commands.doc, "fnl/docstring", "Print the docstring and arglist for a function, macro, or special form.")
    commands.compile = function(env, read, on_values, on_error, scope)
      local function _709_(_241)
        local allowedGlobals = specials["current-global-names"](env)
        local ok_3f, result = pcall(compiler.compile, _241, {env = env, scope = scope, allowedGlobals = allowedGlobals})
        if ok_3f then
          return on_values({result})
        else
          return on_error("Repl", ("Error compiling expression: " .. result))
        end
      end
      return run_command(read, on_error, _709_)
    end
    do end (compiler.metadata):set(commands.compile, "fnl/docstring", "compiles the expression into lua and prints the result.")
    local function load_plugin_commands(plugins)
      for _, plugin in ipairs((plugins or {})) do
        for name, f in pairs(plugin) do
          local _711_ = name:match("^repl%-command%-(.*)")
          if (nil ~= _711_) then
            local cmd_name = _711_
            commands[cmd_name] = (commands[cmd_name] or f)
          else
          end
        end
      end
      return nil
    end
    local function run_command_loop(input, read, loop, env, on_values, on_error, scope, chars)
      local command_name = input:match(",([^%s/]+)")
      do
        local _713_ = commands[command_name]
        if (nil ~= _713_) then
          local command = _713_
          command(env, read, on_values, on_error, scope, chars)
        elseif true then
          local _ = _713_
          if ("exit" ~= command_name) then
            on_values({"Unknown command", command_name})
          else
          end
        else
        end
      end
      if ("exit" ~= command_name) then
        return loop()
      else
        return nil
      end
    end
    local function try_readline_21(opts, ok, readline)
      if ok then
        if readline.set_readline_name then
          readline.set_readline_name("fennel")
        else
        end
        readline.set_options({keeplines = 1000, histfile = ""})
        opts.readChunk = function(parser_state)
          local prompt
          if (0 < parser_state["stack-size"]) then
            prompt = ".. "
          else
            prompt = ">> "
          end
          local str = readline.readline(prompt)
          if str then
            return (str .. "\n")
          else
            return nil
          end
        end
        local completer0 = nil
        opts.registerCompleter = function(repl_completer)
          completer0 = repl_completer
          return nil
        end
        local function repl_completer(text, from, to)
          if completer0 then
            readline.set_completion_append_character("")
            return completer0(text:sub(from, to))
          else
            return {}
          end
        end
        readline.set_complete_function(repl_completer)
        return readline
      else
        return nil
      end
    end
    local function should_use_readline_3f(opts)
      return (("dumb" ~= os.getenv("TERM")) and not opts.readChunk and not opts.registerCompleter)
    end
    local function repl(_3foptions)
      local old_root_options = utils.root.options
      local _let_722_ = utils.copy(_3foptions)
      local _3ffennelrc = _let_722_["fennelrc"]
      local opts = _let_722_
      local _
      opts.fennelrc = nil
      _ = nil
      local readline = (should_use_readline_3f(opts) and try_readline_21(opts, pcall(require, "readline")))
      local _0
      if _3ffennelrc then
        _0 = _3ffennelrc()
      else
        _0 = nil
      end
      local env = specials["wrap-env"]((opts.env or rawget(_G, "_ENV") or _G))
      local save_locals_3f = (opts.saveLocals ~= false)
      local read_chunk = (opts.readChunk or default_read_chunk)
      local on_values = (opts.onValues or default_on_values)
      local on_error = (opts.onError or default_on_error)
      local pp = (opts.pp or view)
      local byte_stream, clear_stream = parser.granulate(read_chunk)
      local chars = {}
      local read, reset = nil, nil
      local function _724_(parser_state)
        local c = byte_stream(parser_state)
        table.insert(chars, c)
        return c
      end
      read, reset = parser.parser(_724_)
      opts.env, opts.scope = env, compiler["make-scope"]()
      opts.useMetadata = (opts.useMetadata ~= false)
      if (opts.allowedGlobals == nil) then
        opts.allowedGlobals = specials["current-global-names"](env)
      else
      end
      if opts.registerCompleter then
        local function _728_()
          local _726_ = env
          local _727_ = opts.scope
          local function _729_(...)
            return completer(_726_, _727_, ...)
          end
          return _729_
        end
        opts.registerCompleter(_728_())
      else
      end
      load_plugin_commands(opts.plugins)
      if save_locals_3f then
        local function newindex(t, k, v)
          if opts.scope.unmanglings[k] then
            return rawset(t, k, v)
          else
            return nil
          end
        end
        env.___replLocals___ = setmetatable({}, {__newindex = newindex})
      else
      end
      local function print_values(...)
        local vals = {...}
        local out = {}
        env._, env.__ = vals[1], vals
        for i = 1, select("#", ...) do
          table.insert(out, pp(vals[i]))
        end
        return on_values(out)
      end
      local function loop()
        for k in pairs(chars) do
          chars[k] = nil
        end
        reset()
        local ok, parser_not_eof_3f, x = pcall(read)
        local src_string = string.char(unpack(chars))
        local readline_not_eof_3f = (not readline or (src_string ~= "(null)"))
        local not_eof_3f = (readline_not_eof_3f and parser_not_eof_3f)
        if not ok then
          on_error("Parse", not_eof_3f)
          clear_stream()
          return loop()
        elseif command_3f(src_string) then
          return run_command_loop(src_string, read, loop, env, on_values, on_error, opts.scope, chars)
        else
          if not_eof_3f then
            do
              local _733_, _734_ = nil, nil
              local function _736_()
                local _735_ = opts
                _735_["source"] = src_string
                return _735_
              end
              _733_, _734_ = pcall(compiler.compile, x, _736_())
              if ((_733_ == false) and (nil ~= _734_)) then
                local msg = _734_
                clear_stream()
                on_error("Compile", msg)
              elseif ((_733_ == true) and (nil ~= _734_)) then
                local src = _734_
                local src0
                if save_locals_3f then
                  src0 = splice_save_locals(env, src, opts.scope)
                else
                  src0 = src
                end
                local _738_, _739_ = pcall(specials["load-code"], src0, env)
                if ((_738_ == false) and (nil ~= _739_)) then
                  local msg = _739_
                  clear_stream()
                  on_error("Lua Compile", msg, src0)
                elseif (true and (nil ~= _739_)) then
                  local _1 = _738_
                  local chunk = _739_
                  local function _740_()
                    return print_values(chunk())
                  end
                  local function _741_()
                    local function _742_(...)
                      return on_error("Runtime", ...)
                    end
                    return _742_
                  end
                  xpcall(_740_, _741_())
                else
                end
              else
              end
            end
            utils.root.options = old_root_options
            return loop()
          else
            return nil
          end
        end
      end
      loop()
      if readline then
        return readline.save_history()
      else
        return nil
      end
    end
    return repl
  end
  package.preload["fennel.specials"] = package.preload["fennel.specials"] or function(...)
    local utils = require("fennel.utils")
    local view = require("fennel.view")
    local parser = require("fennel.parser")
    local compiler = require("fennel.compiler")
    local unpack = (table.unpack or _G.unpack)
    local SPECIALS = compiler.scopes.global.specials
    local function wrap_env(env)
      local function _424_(_, key)
        if utils["string?"](key) then
          return env[compiler["global-unmangling"](key)]
        else
          return env[key]
        end
      end
      local function _426_(_, key, value)
        if utils["string?"](key) then
          env[compiler["global-unmangling"](key)] = value
          return nil
        else
          env[key] = value
          return nil
        end
      end
      local function _428_()
        local function putenv(k, v)
          local _429_
          if utils["string?"](k) then
            _429_ = compiler["global-unmangling"](k)
          else
            _429_ = k
          end
          return _429_, v
        end
        return next, utils.kvmap(env, putenv), nil
      end
      return setmetatable({}, {__index = _424_, __newindex = _426_, __pairs = _428_})
    end
    local function current_global_names(_3fenv)
      local mt
      do
        local _431_ = getmetatable(_3fenv)
        if ((_G.type(_431_) == "table") and (nil ~= (_431_).__pairs)) then
          local mtpairs = (_431_).__pairs
          local tbl_13_auto = {}
          for k, v in mtpairs(_3fenv) do
            local k_14_auto, v_15_auto = k, v
            if ((k_14_auto ~= nil) and (v_15_auto ~= nil)) then
              tbl_13_auto[k_14_auto] = v_15_auto
            else
            end
          end
          mt = tbl_13_auto
        elseif (_431_ == nil) then
          mt = (_3fenv or _G)
        else
          mt = nil
        end
      end
      return (mt and utils.kvmap(mt, compiler["global-unmangling"]))
    end
    local function load_code(code, _3fenv, _3ffilename)
      local env = (_3fenv or rawget(_G, "_ENV") or _G)
      local _434_, _435_ = rawget(_G, "setfenv"), rawget(_G, "loadstring")
      if ((nil ~= _434_) and (nil ~= _435_)) then
        local setfenv = _434_
        local loadstring = _435_
        local f = assert(loadstring(code, _3ffilename))
        local _436_ = f
        setfenv(_436_, env)
        return _436_
      elseif true then
        local _ = _434_
        return assert(load(code, _3ffilename, "t", env))
      else
        return nil
      end
    end
    local function doc_2a(tgt, name)
      if not tgt then
        return (name .. " not found")
      else
        local docstring = (((compiler.metadata):get(tgt, "fnl/docstring") or "#<undocumented>")):gsub("\n$", ""):gsub("\n", "\n  ")
        local mt = getmetatable(tgt)
        if ((type(tgt) == "function") or ((type(mt) == "table") and (type(mt.__call) == "function"))) then
          local arglist = table.concat(((compiler.metadata):get(tgt, "fnl/arglist") or {"#<unknown-arguments>"}), " ")
          local _438_
          if (0 < #arglist) then
            _438_ = " "
          else
            _438_ = ""
          end
          return string.format("(%s%s%s)\n  %s", name, _438_, arglist, docstring)
        else
          return string.format("%s\n  %s", name, docstring)
        end
      end
    end
    local function doc_special(name, arglist, docstring, body_form_3f)
      compiler.metadata[SPECIALS[name]] = {["fnl/arglist"] = arglist, ["fnl/docstring"] = docstring, ["fnl/body-form?"] = body_form_3f}
      return nil
    end
    local function compile_do(ast, scope, parent, _3fstart)
      local start = (_3fstart or 2)
      local len = #ast
      local sub_scope = compiler["make-scope"](scope)
      for i = start, len do
        compiler.compile1(ast[i], sub_scope, parent, {nval = 0})
      end
      return nil
    end
    SPECIALS["do"] = function(ast, scope, parent, opts, _3fstart, _3fchunk, _3fsub_scope, _3fpre_syms)
      local start = (_3fstart or 2)
      local sub_scope = (_3fsub_scope or compiler["make-scope"](scope))
      local chunk = (_3fchunk or {})
      local len = #ast
      local retexprs = {returned = true}
      local function compile_body(outer_target, outer_tail, outer_retexprs)
        if (len < start) then
          compiler.compile1(nil, sub_scope, chunk, {tail = outer_tail, target = outer_target})
        else
          for i = start, len do
            local subopts = {nval = (((i ~= len) and 0) or opts.nval), tail = (((i == len) and outer_tail) or nil), target = (((i == len) and outer_target) or nil)}
            local _ = utils["propagate-options"](opts, subopts)
            local subexprs = compiler.compile1(ast[i], sub_scope, chunk, subopts)
            if (i ~= len) then
              compiler["keep-side-effects"](subexprs, parent, nil, ast[i])
            else
            end
          end
        end
        compiler.emit(parent, chunk, ast)
        compiler.emit(parent, "end", ast)
        utils.hook("do", ast, sub_scope)
        return (outer_retexprs or retexprs)
      end
      if (opts.target or (opts.nval == 0) or opts.tail) then
        compiler.emit(parent, "do", ast)
        return compile_body(opts.target, opts.tail)
      elseif opts.nval then
        local syms = {}
        for i = 1, opts.nval do
          local s = ((_3fpre_syms and (_3fpre_syms)[i]) or compiler.gensym(scope))
          do end (syms)[i] = s
          retexprs[i] = utils.expr(s, "sym")
        end
        local outer_target = table.concat(syms, ", ")
        compiler.emit(parent, string.format("local %s", outer_target), ast)
        compiler.emit(parent, "do", ast)
        return compile_body(outer_target, opts.tail)
      else
        local fname = compiler.gensym(scope)
        local fargs
        if scope.vararg then
          fargs = "..."
        else
          fargs = ""
        end
        compiler.emit(parent, string.format("local function %s(%s)", fname, fargs), ast)
        return compile_body(nil, true, utils.expr((fname .. "(" .. fargs .. ")"), "statement"))
      end
    end
    doc_special("do", {"..."}, "Evaluate multiple forms; return last value.", true)
    SPECIALS.values = function(ast, scope, parent)
      local len = #ast
      local exprs = {}
      for i = 2, len do
        local subexprs = compiler.compile1(ast[i], scope, parent, {nval = ((i ~= len) and 1)})
        table.insert(exprs, subexprs[1])
        if (i == len) then
          for j = 2, #subexprs do
            table.insert(exprs, subexprs[j])
          end
        else
        end
      end
      return exprs
    end
    doc_special("values", {"..."}, "Return multiple values from a function. Must be in tail position.")
    local function __3estack(stack, tbl)
      for k, v in pairs(tbl) do
        local _447_ = stack
        table.insert(_447_, k)
        table.insert(_447_, v)
      end
      return stack
    end
    local function literal_3f(val)
      local res = true
      if utils["list?"](val) then
        res = false
      elseif utils["table?"](val) then
        local stack = __3estack({}, val)
        for _, elt in ipairs(stack) do
          if not res then break end
          if utils["list?"](elt) then
            res = false
          elseif utils["table?"](elt) then
            __3estack(stack, elt)
          else
          end
        end
      else
      end
      return res
    end
    local function compile_value(v)
      local opts = {nval = 1, tail = false}
      local scope = compiler["make-scope"]()
      local chunk = {}
      local _let_450_ = compiler.compile1(v, scope, chunk, opts)
      local _let_451_ = _let_450_[1]
      local v0 = _let_451_[1]
      return v0
    end
    local function insert_meta(meta, k, v)
      local view_opts = {["escape-newlines?"] = true, ["line-length"] = math.huge, ["one-line?"] = true}
      compiler.assert((type(k) == "string"), ("expected string keys in metadata table, got: %s"):format(view(k, view_opts)))
      compiler.assert(literal_3f(v), ("expected literal value in metadata table, got: %s %s"):format(view(k, view_opts), view(v, view_opts)))
      local _452_ = meta
      table.insert(_452_, view(k))
      local function _453_()
        if ("string" == type(v)) then
          return view(v, view_opts)
        else
          return compile_value(v)
        end
      end
      table.insert(_452_, _453_())
      return _452_
    end
    local function insert_arglist(meta, arg_list)
      local view_opts = {["one-line?"] = true, ["escape-newlines?"] = true, ["line-length"] = math.huge}
      local _454_ = meta
      table.insert(_454_, "\"fnl/arglist\"")
      local function _455_(_241)
        return view(view(_241, view_opts))
      end
      table.insert(_454_, ("{" .. table.concat(utils.map(arg_list, _455_), ", ") .. "}"))
      return _454_
    end
    local function set_fn_metadata(f_metadata, parent, fn_name)
      if utils.root.options.useMetadata then
        local meta_fields = {}
        for k, v in utils.stablepairs(f_metadata) do
          if (k == "fnl/arglist") then
            insert_arglist(meta_fields, v)
          else
            insert_meta(meta_fields, k, v)
          end
        end
        local meta_str = ("require(\"%s\").metadata"):format((utils.root.options.moduleName or "fennel"))
        return compiler.emit(parent, ("pcall(function() %s:setall(%s, %s) end)"):format(meta_str, fn_name, table.concat(meta_fields, ", ")))
      else
        return nil
      end
    end
    local function get_fn_name(ast, scope, fn_name, multi)
      if (fn_name and (fn_name[1] ~= "nil")) then
        local _458_
        if not multi then
          _458_ = compiler["declare-local"](fn_name, {}, scope, ast)
        else
          _458_ = (compiler["symbol-to-expression"](fn_name, scope))[1]
        end
        return _458_, not multi, 3
      else
        return nil, true, 2
      end
    end
    local function compile_named_fn(ast, f_scope, f_chunk, parent, index, fn_name, local_3f, arg_name_list, f_metadata)
      for i = (index + 1), #ast do
        compiler.compile1(ast[i], f_scope, f_chunk, {nval = (((i ~= #ast) and 0) or nil), tail = (i == #ast)})
      end
      local _461_
      if local_3f then
        _461_ = "local function %s(%s)"
      else
        _461_ = "%s = function(%s)"
      end
      compiler.emit(parent, string.format(_461_, fn_name, table.concat(arg_name_list, ", ")), ast)
      compiler.emit(parent, f_chunk, ast)
      compiler.emit(parent, "end", ast)
      set_fn_metadata(f_metadata, parent, fn_name)
      utils.hook("fn", ast, f_scope)
      return utils.expr(fn_name, "sym")
    end
    local function compile_anonymous_fn(ast, f_scope, f_chunk, parent, index, arg_name_list, f_metadata, scope)
      local fn_name = compiler.gensym(scope)
      return compile_named_fn(ast, f_scope, f_chunk, parent, index, fn_name, true, arg_name_list, f_metadata)
    end
    local function assoc_table_3f(t)
      local len = #t
      local nxt, t0, k = pairs(t)
      local function _463_()
        if (len == 0) then
          return k
        else
          return len
        end
      end
      return (nil ~= nxt(t0, _463_()))
    end
    local function get_function_metadata(ast, arg_list, index)
      local f_metadata = {["fnl/arglist"] = arg_list}
      local index_2a = (index + 1)
      local expr = ast[index_2a]
      if (utils["string?"](expr) and (index_2a < #ast)) then
        local _465_
        do
          local _464_ = f_metadata
          _464_["fnl/docstring"] = expr
          _465_ = _464_
        end
        return _465_, index_2a
      elseif (utils["table?"](expr) and (index_2a < #ast) and assoc_table_3f(expr)) then
        local _466_
        do
          local tbl_13_auto = f_metadata
          for k, v in pairs(expr) do
            local k_14_auto, v_15_auto = k, v
            if ((k_14_auto ~= nil) and (v_15_auto ~= nil)) then
              tbl_13_auto[k_14_auto] = v_15_auto
            else
            end
          end
          _466_ = tbl_13_auto
        end
        return _466_, index_2a
      else
        return f_metadata, index
      end
    end
    SPECIALS.fn = function(ast, scope, parent)
      local f_scope
      do
        local _469_ = compiler["make-scope"](scope)
        do end (_469_)["vararg"] = false
        f_scope = _469_
      end
      local f_chunk = {}
      local fn_sym = utils["sym?"](ast[2])
      local multi = (fn_sym and utils["multi-sym?"](fn_sym[1]))
      local fn_name, local_3f, index = get_fn_name(ast, scope, fn_sym, multi)
      local arg_list = compiler.assert(utils["table?"](ast[index]), "expected parameters table", ast)
      compiler.assert((not multi or not multi["multi-sym-method-call"]), ("unexpected multi symbol " .. tostring(fn_name)), fn_sym)
      local function destructure_arg(arg)
        local raw = utils.sym(compiler.gensym(scope))
        local declared = compiler["declare-local"](raw, {}, f_scope, ast)
        compiler.destructure(arg, raw, ast, f_scope, f_chunk, {declaration = true, nomulti = true, symtype = "arg"})
        return declared
      end
      local function destructure_amp(i)
        compiler.assert((i == (#arg_list - 1)), "expected rest argument before last parameter", arg_list[(i + 1)], arg_list)
        f_scope.vararg = true
        compiler.destructure(arg_list[#arg_list], {utils.varg()}, ast, f_scope, f_chunk, {declaration = true, nomulti = true, symtype = "arg"})
        return "..."
      end
      local function get_arg_name(arg, i)
        if f_scope.vararg then
          return nil
        elseif utils["varg?"](arg) then
          compiler.assert((arg == arg_list[#arg_list]), "expected vararg as last parameter", ast)
          f_scope.vararg = true
          return "..."
        elseif (utils.sym("&") == arg) then
          return destructure_amp(i)
        elseif (utils["sym?"](arg) and (tostring(arg) ~= "nil") and not utils["multi-sym?"](tostring(arg))) then
          return compiler["declare-local"](arg, {}, f_scope, ast)
        elseif utils["table?"](arg) then
          return destructure_arg(arg)
        else
          return compiler.assert(false, ("expected symbol for function parameter: %s"):format(tostring(arg)), ast[index])
        end
      end
      local arg_name_list
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for i, a in ipairs(arg_list) do
          local val_18_auto = get_arg_name(a, i)
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        arg_name_list = tbl_16_auto
      end
      local f_metadata, index0 = get_function_metadata(ast, arg_list, index)
      if fn_name then
        return compile_named_fn(ast, f_scope, f_chunk, parent, index0, fn_name, local_3f, arg_name_list, f_metadata)
      else
        return compile_anonymous_fn(ast, f_scope, f_chunk, parent, index0, arg_name_list, f_metadata, scope)
      end
    end
    doc_special("fn", {"name?", "args", "docstring?", "..."}, "Function syntax. May optionally include a name and docstring or a metadata table.\nIf a name is provided, the function will be bound in the current scope.\nWhen called with the wrong number of args, excess args will be discarded\nand lacking args will be nil, use lambda for arity-checked functions.", true)
    SPECIALS.lua = function(ast, _, parent)
      compiler.assert(((#ast == 2) or (#ast == 3)), "expected 1 or 2 arguments", ast)
      local _474_
      do
        local _473_ = utils["sym?"](ast[2])
        if (nil ~= _473_) then
          _474_ = tostring(_473_)
        else
          _474_ = _473_
        end
      end
      if ("nil" ~= _474_) then
        table.insert(parent, {ast = ast, leaf = tostring(ast[2])})
      else
      end
      local _478_
      do
        local _477_ = utils["sym?"](ast[3])
        if (nil ~= _477_) then
          _478_ = tostring(_477_)
        else
          _478_ = _477_
        end
      end
      if ("nil" ~= _478_) then
        return tostring(ast[3])
      else
        return nil
      end
    end
    local function dot(ast, scope, parent)
      compiler.assert((1 < #ast), "expected table argument", ast)
      local len = #ast
      local _let_481_ = compiler.compile1(ast[2], scope, parent, {nval = 1})
      local lhs = _let_481_[1]
      if (len == 2) then
        return tostring(lhs)
      else
        local indices = {}
        for i = 3, len do
          local index = ast[i]
          if (utils["string?"](index) and utils["valid-lua-identifier?"](index)) then
            table.insert(indices, ("." .. index))
          else
            local _let_482_ = compiler.compile1(index, scope, parent, {nval = 1})
            local index0 = _let_482_[1]
            table.insert(indices, ("[" .. tostring(index0) .. "]"))
          end
        end
        if (tostring(lhs):find("[{\"0-9]") or ("nil" == tostring(lhs))) then
          return ("(" .. tostring(lhs) .. ")" .. table.concat(indices))
        else
          return (tostring(lhs) .. table.concat(indices))
        end
      end
    end
    SPECIALS["."] = dot
    doc_special(".", {"tbl", "key1", "..."}, "Look up key1 in tbl table. If more args are provided, do a nested lookup.")
    SPECIALS.global = function(ast, scope, parent)
      compiler.assert((#ast == 3), "expected name and value", ast)
      compiler.destructure(ast[2], ast[3], ast, scope, parent, {forceglobal = true, nomulti = true, symtype = "global"})
      return nil
    end
    doc_special("global", {"name", "val"}, "Set name as a global with val.")
    SPECIALS.set = function(ast, scope, parent)
      compiler.assert((#ast == 3), "expected name and value", ast)
      compiler.destructure(ast[2], ast[3], ast, scope, parent, {noundef = true, symtype = "set"})
      return nil
    end
    doc_special("set", {"name", "val"}, "Set a local variable to a new value. Only works on locals using var.")
    local function set_forcibly_21_2a(ast, scope, parent)
      compiler.assert((#ast == 3), "expected name and value", ast)
      compiler.destructure(ast[2], ast[3], ast, scope, parent, {forceset = true, symtype = "set"})
      return nil
    end
    SPECIALS["set-forcibly!"] = set_forcibly_21_2a
    local function local_2a(ast, scope, parent)
      compiler.assert((#ast == 3), "expected name and value", ast)
      compiler.destructure(ast[2], ast[3], ast, scope, parent, {declaration = true, nomulti = true, symtype = "local"})
      return nil
    end
    SPECIALS["local"] = local_2a
    doc_special("local", {"name", "val"}, "Introduce new top-level immutable local.")
    SPECIALS.var = function(ast, scope, parent)
      compiler.assert((#ast == 3), "expected name and value", ast)
      compiler.destructure(ast[2], ast[3], ast, scope, parent, {declaration = true, isvar = true, nomulti = true, symtype = "var"})
      return nil
    end
    doc_special("var", {"name", "val"}, "Introduce new mutable local.")
    local function kv_3f(t)
      local _486_
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for k in pairs(t) do
          local val_18_auto
          if ("number" ~= type(k)) then
            val_18_auto = k
          else
            val_18_auto = nil
          end
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        _486_ = tbl_16_auto
      end
      return (_486_)[1]
    end
    SPECIALS.let = function(ast, scope, parent, opts)
      local bindings = ast[2]
      local pre_syms = {}
      compiler.assert((utils["table?"](bindings) and not kv_3f(bindings)), "expected binding sequence", bindings)
      compiler.assert(((#bindings % 2) == 0), "expected even number of name/value bindings", ast[2])
      compiler.assert((3 <= #ast), "expected body expression", ast[1])
      for _ = 1, (opts.nval or 0) do
        table.insert(pre_syms, compiler.gensym(scope))
      end
      local sub_scope = compiler["make-scope"](scope)
      local sub_chunk = {}
      for i = 1, #bindings, 2 do
        compiler.destructure(bindings[i], bindings[(i + 1)], ast, sub_scope, sub_chunk, {declaration = true, nomulti = true, symtype = "let"})
      end
      return SPECIALS["do"](ast, scope, parent, opts, 3, sub_chunk, sub_scope, pre_syms)
    end
    doc_special("let", {"[name1 val1 ... nameN valN]", "..."}, "Introduces a new scope in which a given set of local bindings are used.", true)
    local function get_prev_line(parent)
      if ("table" == type(parent)) then
        return get_prev_line((parent.leaf or parent[#parent]))
      else
        return (parent or "")
      end
    end
    local function disambiguate_3f(rootstr, parent)
      local function _491_()
        local _490_ = get_prev_line(parent)
        if (nil ~= _490_) then
          local prev_line = _490_
          return prev_line:match("%)$")
        else
          return nil
        end
      end
      return (rootstr:match("^{") or _491_())
    end
    SPECIALS.tset = function(ast, scope, parent)
      compiler.assert((3 < #ast), "expected table, key, and value arguments", ast)
      local root = (compiler.compile1(ast[2], scope, parent, {nval = 1}))[1]
      local keys = {}
      for i = 3, (#ast - 1) do
        local _let_493_ = compiler.compile1(ast[i], scope, parent, {nval = 1})
        local key = _let_493_[1]
        table.insert(keys, tostring(key))
      end
      local value = (compiler.compile1(ast[#ast], scope, parent, {nval = 1}))[1]
      local rootstr = tostring(root)
      local fmtstr
      if disambiguate_3f(rootstr, parent) then
        fmtstr = "do end (%s)[%s] = %s"
      else
        fmtstr = "%s[%s] = %s"
      end
      return compiler.emit(parent, fmtstr:format(rootstr, table.concat(keys, "]["), tostring(value)), ast)
    end
    doc_special("tset", {"tbl", "key1", "...", "keyN", "val"}, "Set the value of a table field. Can take additional keys to set\nnested values, but all parents must contain an existing table.")
    local function calculate_target(scope, opts)
      if not (opts.tail or opts.target or opts.nval) then
        return "iife", true, nil
      elseif (opts.nval and (opts.nval ~= 0) and not opts.target) then
        local accum = {}
        local target_exprs = {}
        for i = 1, opts.nval do
          local s = compiler.gensym(scope)
          do end (accum)[i] = s
          target_exprs[i] = utils.expr(s, "sym")
        end
        return "target", opts.tail, table.concat(accum, ", "), target_exprs
      else
        return "none", opts.tail, opts.target
      end
    end
    local function if_2a(ast, scope, parent, opts)
      compiler.assert((2 < #ast), "expected condition and body", ast)
      local do_scope = compiler["make-scope"](scope)
      local branches = {}
      local wrapper, inner_tail, inner_target, target_exprs = calculate_target(scope, opts)
      local body_opts = {nval = opts.nval, tail = inner_tail, target = inner_target}
      local function compile_body(i)
        local chunk = {}
        local cscope = compiler["make-scope"](do_scope)
        compiler["keep-side-effects"](compiler.compile1(ast[i], cscope, chunk, body_opts), chunk, nil, ast[i])
        return {chunk = chunk, scope = cscope}
      end
      if (1 == (#ast % 2)) then
        table.insert(ast, utils.sym("nil"))
      else
      end
      for i = 2, (#ast - 1), 2 do
        local condchunk = {}
        local res = compiler.compile1(ast[i], do_scope, condchunk, {nval = 1})
        local cond = res[1]
        local branch = compile_body((i + 1))
        branch.cond = cond
        branch.condchunk = condchunk
        branch.nested = ((i ~= 2) and (next(condchunk, nil) == nil))
        table.insert(branches, branch)
      end
      local else_branch = compile_body(#ast)
      local s = compiler.gensym(scope)
      local buffer = {}
      local last_buffer = buffer
      for i = 1, #branches do
        local branch = branches[i]
        local fstr
        if not branch.nested then
          fstr = "if %s then"
        else
          fstr = "elseif %s then"
        end
        local cond = tostring(branch.cond)
        local cond_line = fstr:format(cond)
        if branch.nested then
          compiler.emit(last_buffer, branch.condchunk, ast)
        else
          for _, v in ipairs(branch.condchunk) do
            compiler.emit(last_buffer, v, ast)
          end
        end
        compiler.emit(last_buffer, cond_line, ast)
        compiler.emit(last_buffer, branch.chunk, ast)
        if (i == #branches) then
          compiler.emit(last_buffer, "else", ast)
          compiler.emit(last_buffer, else_branch.chunk, ast)
          compiler.emit(last_buffer, "end", ast)
        elseif not (branches[(i + 1)]).nested then
          local next_buffer = {}
          compiler.emit(last_buffer, "else", ast)
          compiler.emit(last_buffer, next_buffer, ast)
          compiler.emit(last_buffer, "end", ast)
          last_buffer = next_buffer
        else
        end
      end
      if (wrapper == "iife") then
        local iifeargs = ((scope.vararg and "...") or "")
        compiler.emit(parent, ("local function %s(%s)"):format(tostring(s), iifeargs), ast)
        compiler.emit(parent, buffer, ast)
        compiler.emit(parent, "end", ast)
        return utils.expr(("%s(%s)"):format(tostring(s), iifeargs), "statement")
      elseif (wrapper == "none") then
        for i = 1, #buffer do
          compiler.emit(parent, buffer[i], ast)
        end
        return {returned = true}
      else
        compiler.emit(parent, ("local %s"):format(inner_target), ast)
        for i = 1, #buffer do
          compiler.emit(parent, buffer[i], ast)
        end
        return target_exprs
      end
    end
    SPECIALS["if"] = if_2a
    doc_special("if", {"cond1", "body1", "...", "condN", "bodyN"}, "Conditional form.\nTakes any number of condition/body pairs and evaluates the first body where\nthe condition evaluates to truthy. Similar to cond in other lisps.")
    local function remove_until_condition(bindings)
      local last_item = bindings[(#bindings - 1)]
      if ((utils["sym?"](last_item) and (tostring(last_item) == "&until")) or ("until" == last_item)) then
        table.remove(bindings, (#bindings - 1))
        return table.remove(bindings)
      else
        return nil
      end
    end
    local function compile_until(condition, scope, chunk)
      if condition then
        local _let_502_ = compiler.compile1(condition, scope, chunk, {nval = 1})
        local condition_lua = _let_502_[1]
        return compiler.emit(chunk, ("if %s then break end"):format(tostring(condition_lua)), utils.expr(condition, "expression"))
      else
        return nil
      end
    end
    SPECIALS.each = function(ast, scope, parent)
      compiler.assert((3 <= #ast), "expected body expression", ast[1])
      local binding = compiler.assert(utils["table?"](ast[2]), "expected binding table", ast)
      local _ = compiler.assert((2 <= #binding), "expected binding and iterator", binding)
      local until_condition = remove_until_condition(binding)
      local iter = table.remove(binding, #binding)
      local destructures = {}
      local new_manglings = {}
      local sub_scope = compiler["make-scope"](scope)
      local function destructure_binding(v)
        compiler.assert(not utils["string?"](v), ("unexpected iterator clause " .. tostring(v)), binding)
        if utils["sym?"](v) then
          return compiler["declare-local"](v, {}, sub_scope, ast, new_manglings)
        else
          local raw = utils.sym(compiler.gensym(sub_scope))
          do end (destructures)[raw] = v
          return compiler["declare-local"](raw, {}, sub_scope, ast)
        end
      end
      local bind_vars = utils.map(binding, destructure_binding)
      local vals = compiler.compile1(iter, scope, parent)
      local val_names = utils.map(vals, tostring)
      local chunk = {}
      compiler.emit(parent, ("for %s in %s do"):format(table.concat(bind_vars, ", "), table.concat(val_names, ", ")), ast)
      for raw, args in utils.stablepairs(destructures) do
        compiler.destructure(args, raw, ast, sub_scope, chunk, {declaration = true, nomulti = true, symtype = "each"})
      end
      compiler["apply-manglings"](sub_scope, new_manglings, ast)
      compile_until(until_condition, sub_scope, chunk)
      compile_do(ast, sub_scope, chunk, 3)
      compiler.emit(parent, chunk, ast)
      return compiler.emit(parent, "end", ast)
    end
    doc_special("each", {"[key value (iterator)]", "..."}, "Runs the body once for each set of values provided by the given iterator.\nMost commonly used with ipairs for sequential tables or pairs for  undefined\norder, but can be used with any iterator.", true)
    local function while_2a(ast, scope, parent)
      local len1 = #parent
      local condition = (compiler.compile1(ast[2], scope, parent, {nval = 1}))[1]
      local len2 = #parent
      local sub_chunk = {}
      if (len1 ~= len2) then
        for i = (len1 + 1), len2 do
          table.insert(sub_chunk, parent[i])
          do end (parent)[i] = nil
        end
        compiler.emit(parent, "while true do", ast)
        compiler.emit(sub_chunk, ("if not %s then break end"):format(condition[1]), ast)
      else
        compiler.emit(parent, ("while " .. tostring(condition) .. " do"), ast)
      end
      compile_do(ast, compiler["make-scope"](scope), sub_chunk, 3)
      compiler.emit(parent, sub_chunk, ast)
      return compiler.emit(parent, "end", ast)
    end
    SPECIALS["while"] = while_2a
    doc_special("while", {"condition", "..."}, "The classic while loop. Evaluates body until a condition is non-truthy.", true)
    local function for_2a(ast, scope, parent)
      local ranges = compiler.assert(utils["table?"](ast[2]), "expected binding table", ast)
      local until_condition = remove_until_condition(ast[2])
      local binding_sym = table.remove(ast[2], 1)
      local sub_scope = compiler["make-scope"](scope)
      local range_args = {}
      local chunk = {}
      compiler.assert(utils["sym?"](binding_sym), ("unable to bind %s %s"):format(type(binding_sym), tostring(binding_sym)), ast[2])
      compiler.assert((3 <= #ast), "expected body expression", ast[1])
      compiler.assert((#ranges <= 3), "unexpected arguments", ranges[4])
      for i = 1, math.min(#ranges, 3) do
        range_args[i] = tostring((compiler.compile1(ranges[i], scope, parent, {nval = 1}))[1])
      end
      compiler.emit(parent, ("for %s = %s do"):format(compiler["declare-local"](binding_sym, {}, sub_scope, ast), table.concat(range_args, ", ")), ast)
      compile_until(until_condition, sub_scope, chunk)
      compile_do(ast, sub_scope, chunk, 3)
      compiler.emit(parent, chunk, ast)
      return compiler.emit(parent, "end", ast)
    end
    SPECIALS["for"] = for_2a
    doc_special("for", {"[index start stop step?]", "..."}, "Numeric loop construct.\nEvaluates body once for each value between start and stop (inclusive).", true)
    local function native_method_call(ast, _scope, _parent, target, args)
      local _let_506_ = ast
      local _ = _let_506_[1]
      local _0 = _let_506_[2]
      local method_string = _let_506_[3]
      local call_string
      if ((target.type == "literal") or (target.type == "varg") or (target.type == "expression")) then
        call_string = "(%s):%s(%s)"
      else
        call_string = "%s:%s(%s)"
      end
      return utils.expr(string.format(call_string, tostring(target), method_string, table.concat(args, ", ")), "statement")
    end
    local function nonnative_method_call(ast, scope, parent, target, args)
      local method_string = tostring((compiler.compile1(ast[3], scope, parent, {nval = 1}))[1])
      local args0 = {tostring(target), unpack(args)}
      return utils.expr(string.format("%s[%s](%s)", tostring(target), method_string, table.concat(args0, ", ")), "statement")
    end
    local function double_eval_protected_method_call(ast, scope, parent, target, args)
      local method_string = tostring((compiler.compile1(ast[3], scope, parent, {nval = 1}))[1])
      local call = "(function(tgt, m, ...) return tgt[m](tgt, ...) end)(%s, %s)"
      table.insert(args, 1, method_string)
      return utils.expr(string.format(call, tostring(target), table.concat(args, ", ")), "statement")
    end
    local function method_call(ast, scope, parent)
      compiler.assert((2 < #ast), "expected at least 2 arguments", ast)
      local _let_508_ = compiler.compile1(ast[2], scope, parent, {nval = 1})
      local target = _let_508_[1]
      local args = {}
      for i = 4, #ast do
        local subexprs
        local _509_
        if (i ~= #ast) then
          _509_ = 1
        else
          _509_ = nil
        end
        subexprs = compiler.compile1(ast[i], scope, parent, {nval = _509_})
        utils.map(subexprs, tostring, args)
      end
      if (utils["string?"](ast[3]) and utils["valid-lua-identifier?"](ast[3])) then
        return native_method_call(ast, scope, parent, target, args)
      elseif (target.type == "sym") then
        return nonnative_method_call(ast, scope, parent, target, args)
      else
        return double_eval_protected_method_call(ast, scope, parent, target, args)
      end
    end
    SPECIALS[":"] = method_call
    doc_special(":", {"tbl", "method-name", "..."}, "Call the named method on tbl with the provided args.\nMethod name doesn't have to be known at compile-time; if it is, use\n(tbl:method-name ...) instead.")
    SPECIALS.comment = function(ast, _, parent)
      local els = {}
      for i = 2, #ast do
        table.insert(els, view(ast[i], {["one-line?"] = true}))
      end
      return compiler.emit(parent, ("--[[ " .. table.concat(els, " ") .. " ]]"), ast)
    end
    doc_special("comment", {"..."}, "Comment which will be emitted in Lua output.", true)
    local function hashfn_max_used(f_scope, i, max)
      local max0
      if f_scope.symmeta[("$" .. i)].used then
        max0 = i
      else
        max0 = max
      end
      if (i < 9) then
        return hashfn_max_used(f_scope, (i + 1), max0)
      else
        return max0
      end
    end
    SPECIALS.hashfn = function(ast, scope, parent)
      compiler.assert((#ast == 2), "expected one argument", ast)
      local f_scope
      do
        local _514_ = compiler["make-scope"](scope)
        do end (_514_)["vararg"] = false
        _514_["hashfn"] = true
        f_scope = _514_
      end
      local f_chunk = {}
      local name = compiler.gensym(scope)
      local symbol = utils.sym(name)
      local args = {}
      compiler["declare-local"](symbol, {}, scope, ast)
      for i = 1, 9 do
        args[i] = compiler["declare-local"](utils.sym(("$" .. i)), {}, f_scope, ast)
      end
      local function walker(idx, node, parent_node)
        if (utils["sym?"](node) and (tostring(node) == "$...")) then
          parent_node[idx] = utils.varg()
          f_scope.vararg = true
          return nil
        else
          return (("table" == type(node)) and (utils.sym("hashfn") ~= node[1]) and (utils["list?"](node) or utils["table?"](node)))
        end
      end
      utils["walk-tree"](ast[2], walker)
      compiler.compile1(ast[2], f_scope, f_chunk, {tail = true})
      local max_used = hashfn_max_used(f_scope, 1, 0)
      if f_scope.vararg then
        compiler.assert((max_used == 0), "$ and $... in hashfn are mutually exclusive", ast)
      else
      end
      local arg_str
      if f_scope.vararg then
        arg_str = tostring(utils.varg())
      else
        arg_str = table.concat(args, ", ", 1, max_used)
      end
      compiler.emit(parent, string.format("local function %s(%s)", name, arg_str), ast)
      compiler.emit(parent, f_chunk, ast)
      compiler.emit(parent, "end", ast)
      return utils.expr(name, "sym")
    end
    doc_special("hashfn", {"..."}, "Function literal shorthand; args are either $... OR $1, $2, etc.")
    local function maybe_short_circuit_protect(ast, i, name, _518_)
      local _arg_519_ = _518_
      local mac = _arg_519_["macros"]
      local call = (utils["list?"](ast) and tostring(ast[1]))
      if ((("or" == name) or ("and" == name)) and (1 < i) and (mac[call] or ("set" == call) or ("tset" == call) or ("global" == call))) then
        return utils.list(utils.sym("do"), ast)
      else
        return ast
      end
    end
    local function arithmetic_special(name, zero_arity, unary_prefix, ast, scope, parent)
      local len = #ast
      local operands = {}
      local padded_op = (" " .. name .. " ")
      for i = 2, len do
        local subast = maybe_short_circuit_protect(ast[i], i, name, scope)
        local subexprs = compiler.compile1(subast, scope, parent)
        if (i == len) then
          utils.map(subexprs, tostring, operands)
        else
          table.insert(operands, tostring(subexprs[1]))
        end
      end
      local _522_ = #operands
      if (_522_ == 0) then
        local _524_
        do
          local _523_ = zero_arity
          compiler.assert(_523_, "Expected more than 0 arguments", ast)
          _524_ = _523_
        end
        return utils.expr(_524_, "literal")
      elseif (_522_ == 1) then
        if unary_prefix then
          return ("(" .. unary_prefix .. padded_op .. operands[1] .. ")")
        else
          return operands[1]
        end
      elseif true then
        local _ = _522_
        return ("(" .. table.concat(operands, padded_op) .. ")")
      else
        return nil
      end
    end
    local function define_arithmetic_special(name, zero_arity, unary_prefix, _3flua_name)
      local _530_
      do
        local _527_ = (_3flua_name or name)
        local _528_ = zero_arity
        local _529_ = unary_prefix
        local function _531_(...)
          return arithmetic_special(_527_, _528_, _529_, ...)
        end
        _530_ = _531_
      end
      SPECIALS[name] = _530_
      return doc_special(name, {"a", "b", "..."}, "Arithmetic operator; works the same as Lua but accepts more arguments.")
    end
    define_arithmetic_special("+", "0")
    define_arithmetic_special("..", "''")
    define_arithmetic_special("^")
    define_arithmetic_special("-", nil, "")
    define_arithmetic_special("*", "1")
    define_arithmetic_special("%")
    define_arithmetic_special("/", nil, "1")
    define_arithmetic_special("//", nil, "1")
    SPECIALS["or"] = function(ast, scope, parent)
      return arithmetic_special("or", "false", nil, ast, scope, parent)
    end
    SPECIALS["and"] = function(ast, scope, parent)
      return arithmetic_special("and", "true", nil, ast, scope, parent)
    end
    doc_special("and", {"a", "b", "..."}, "Boolean operator; works the same as Lua but accepts more arguments.")
    doc_special("or", {"a", "b", "..."}, "Boolean operator; works the same as Lua but accepts more arguments.")
    local function bitop_special(native_name, lib_name, zero_arity, unary_prefix, ast, scope, parent)
      if (#ast == 1) then
        return compiler.assert(zero_arity, "Expected more than 0 arguments.", ast)
      else
        local len = #ast
        local operands = {}
        local padded_native_name = (" " .. native_name .. " ")
        local prefixed_lib_name = ("bit." .. lib_name)
        for i = 2, len do
          local subexprs
          local _532_
          if (i ~= len) then
            _532_ = 1
          else
            _532_ = nil
          end
          subexprs = compiler.compile1(ast[i], scope, parent, {nval = _532_})
          utils.map(subexprs, tostring, operands)
        end
        if (#operands == 1) then
          if utils.root.options.useBitLib then
            return (prefixed_lib_name .. "(" .. unary_prefix .. ", " .. operands[1] .. ")")
          else
            return ("(" .. unary_prefix .. padded_native_name .. operands[1] .. ")")
          end
        else
          if utils.root.options.useBitLib then
            return (prefixed_lib_name .. "(" .. table.concat(operands, ", ") .. ")")
          else
            return ("(" .. table.concat(operands, padded_native_name) .. ")")
          end
        end
      end
    end
    local function define_bitop_special(name, zero_arity, unary_prefix, native)
      local _542_
      do
        local _538_ = native
        local _539_ = name
        local _540_ = zero_arity
        local _541_ = unary_prefix
        local function _543_(...)
          return bitop_special(_538_, _539_, _540_, _541_, ...)
        end
        _542_ = _543_
      end
      SPECIALS[name] = _542_
      return nil
    end
    define_bitop_special("lshift", nil, "1", "<<")
    define_bitop_special("rshift", nil, "1", ">>")
    define_bitop_special("band", "0", "0", "&")
    define_bitop_special("bor", "0", "0", "|")
    define_bitop_special("bxor", "0", "0", "~")
    doc_special("lshift", {"x", "n"}, "Bitwise logical left shift of x by n bits.\nOnly works in Lua 5.3+ or LuaJIT with the --use-bit-lib flag.")
    doc_special("rshift", {"x", "n"}, "Bitwise logical right shift of x by n bits.\nOnly works in Lua 5.3+ or LuaJIT with the --use-bit-lib flag.")
    doc_special("band", {"x1", "x2", "..."}, "Bitwise AND of any number of arguments.\nOnly works in Lua 5.3+ or LuaJIT with the --use-bit-lib flag.")
    doc_special("bor", {"x1", "x2", "..."}, "Bitwise OR of any number of arguments.\nOnly works in Lua 5.3+ or LuaJIT with the --use-bit-lib flag.")
    doc_special("bxor", {"x1", "x2", "..."}, "Bitwise XOR of any number of arguments.\nOnly works in Lua 5.3+ or LuaJIT with the --use-bit-lib flag.")
    doc_special("..", {"a", "b", "..."}, "String concatenation operator; works the same as Lua but accepts more arguments.")
    local function native_comparator(op, _544_, scope, parent)
      local _arg_545_ = _544_
      local _ = _arg_545_[1]
      local lhs_ast = _arg_545_[2]
      local rhs_ast = _arg_545_[3]
      local _let_546_ = compiler.compile1(lhs_ast, scope, parent, {nval = 1})
      local lhs = _let_546_[1]
      local _let_547_ = compiler.compile1(rhs_ast, scope, parent, {nval = 1})
      local rhs = _let_547_[1]
      return string.format("(%s %s %s)", tostring(lhs), op, tostring(rhs))
    end
    local function idempotent_comparator(op, chain_op, ast, scope, parent)
      local vals
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for i = 2, #ast do
          local val_18_auto = tostring((compiler.compile1(ast[i], scope, parent, {nval = 1}))[1])
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        vals = tbl_16_auto
      end
      local comparisons
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for i = 1, (#vals - 1) do
          local val_18_auto = string.format("(%s %s %s)", vals[i], op, vals[(i + 1)])
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        comparisons = tbl_16_auto
      end
      local chain = string.format(" %s ", (chain_op or "and"))
      return table.concat(comparisons, chain)
    end
    local function double_eval_protected_comparator(op, chain_op, ast, scope, parent)
      local arglist = {}
      local comparisons = {}
      local vals = {}
      local chain = string.format(" %s ", (chain_op or "and"))
      for i = 2, #ast do
        table.insert(arglist, tostring(compiler.gensym(scope)))
        table.insert(vals, tostring((compiler.compile1(ast[i], scope, parent, {nval = 1}))[1]))
      end
      do
        local tbl_16_auto = comparisons
        local i_17_auto = #tbl_16_auto
        for i = 1, (#arglist - 1) do
          local val_18_auto = string.format("(%s %s %s)", arglist[i], op, arglist[(i + 1)])
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
      end
      return string.format("(function(%s) return %s end)(%s)", table.concat(arglist, ","), table.concat(comparisons, chain), table.concat(vals, ","))
    end
    local function define_comparator_special(name, _3flua_op, _3fchain_op)
      do
        local op = (_3flua_op or name)
        local function opfn(ast, scope, parent)
          compiler.assert((2 < #ast), "expected at least two arguments", ast)
          if (3 == #ast) then
            return native_comparator(op, ast, scope, parent)
          elseif utils["every?"](utils["idempotent-expr?"], {unpack(ast, 2)}) then
            return idempotent_comparator(op, _3fchain_op, ast, scope, parent)
          else
            return double_eval_protected_comparator(op, _3fchain_op, ast, scope, parent)
          end
        end
        SPECIALS[name] = opfn
      end
      return doc_special(name, {"a", "b", "..."}, "Comparison operator; works the same as Lua but accepts more arguments.")
    end
    define_comparator_special(">")
    define_comparator_special("<")
    define_comparator_special(">=")
    define_comparator_special("<=")
    define_comparator_special("=", "==")
    define_comparator_special("not=", "~=", "or")
    local function define_unary_special(op, _3frealop)
      local function opfn(ast, scope, parent)
        compiler.assert((#ast == 2), "expected one argument", ast)
        local tail = compiler.compile1(ast[2], scope, parent, {nval = 1})
        return ((_3frealop or op) .. tostring(tail[1]))
      end
      SPECIALS[op] = opfn
      return nil
    end
    define_unary_special("not", "not ")
    doc_special("not", {"x"}, "Logical operator; works the same as Lua.")
    define_unary_special("bnot", "~")
    doc_special("bnot", {"x"}, "Bitwise negation; only works in Lua 5.3+ or LuaJIT with the --use-bit-lib flag.")
    define_unary_special("length", "#")
    doc_special("length", {"x"}, "Returns the length of a table or string.")
    do end (SPECIALS)["~="] = SPECIALS["not="]
    SPECIALS["#"] = SPECIALS.length
    SPECIALS.quote = function(ast, scope, parent)
      compiler.assert((#ast == 2), "expected one argument", ast)
      local runtime, this_scope = true, scope
      while this_scope do
        this_scope = this_scope.parent
        if (this_scope == compiler.scopes.compiler) then
          runtime = false
        else
        end
      end
      return compiler["do-quote"](ast[2], scope, parent, runtime)
    end
    doc_special("quote", {"x"}, "Quasiquote the following form. Only works in macro/compiler scope.")
    local macro_loaded = {}
    local function safe_getmetatable(tbl)
      local mt = getmetatable(tbl)
      assert((mt ~= getmetatable("")), "Illegal metatable access!")
      return mt
    end
    local safe_require = nil
    local function safe_compiler_env()
      local _554_
      do
        local _553_ = rawget(_G, "utf8")
        if (nil ~= _553_) then
          _554_ = utils.copy(_553_)
        else
          _554_ = _553_
        end
      end
      return {table = utils.copy(table), math = utils.copy(math), string = utils.copy(string), pairs = utils.stablepairs, ipairs = ipairs, select = select, tostring = tostring, tonumber = tonumber, bit = rawget(_G, "bit"), pcall = pcall, xpcall = xpcall, next = next, print = print, type = type, assert = assert, error = error, setmetatable = setmetatable, getmetatable = safe_getmetatable, require = safe_require, rawlen = rawget(_G, "rawlen"), rawget = rawget, rawset = rawset, rawequal = rawequal, _VERSION = _VERSION, utf8 = _554_}
    end
    local function combined_mt_pairs(env)
      local combined = {}
      local _let_556_ = getmetatable(env)
      local __index = _let_556_["__index"]
      if ("table" == type(__index)) then
        for k, v in pairs(__index) do
          combined[k] = v
        end
      else
      end
      for k, v in next, env, nil do
        combined[k] = v
      end
      return next, combined, nil
    end
    local function make_compiler_env(ast, scope, parent, _3fopts)
      local provided
      do
        local _558_ = (_3fopts or utils.root.options)
        if ((_G.type(_558_) == "table") and ((_558_)["compiler-env"] == "strict")) then
          provided = safe_compiler_env()
        elseif ((_G.type(_558_) == "table") and (nil ~= (_558_).compilerEnv)) then
          local compilerEnv = (_558_).compilerEnv
          provided = compilerEnv
        elseif ((_G.type(_558_) == "table") and (nil ~= (_558_)["compiler-env"])) then
          local compiler_env = (_558_)["compiler-env"]
          provided = compiler_env
        elseif true then
          local _ = _558_
          provided = safe_compiler_env(false)
        else
          provided = nil
        end
      end
      local env
      local function _560_(base)
        return utils.sym(compiler.gensym((compiler.scopes.macro or scope), base))
      end
      local function _561_()
        return compiler.scopes.macro
      end
      local function _562_(symbol)
        compiler.assert(compiler.scopes.macro, "must call from macro", ast)
        return compiler.scopes.macro.manglings[tostring(symbol)]
      end
      local function _563_(form)
        compiler.assert(compiler.scopes.macro, "must call from macro", ast)
        return compiler.macroexpand(form, compiler.scopes.macro)
      end
      env = {_AST = ast, _CHUNK = parent, _IS_COMPILER = true, _SCOPE = scope, _SPECIALS = compiler.scopes.global.specials, _VARARG = utils.varg(), ["macro-loaded"] = macro_loaded, unpack = unpack, ["assert-compile"] = compiler.assert, view = view, version = utils.version, metadata = compiler.metadata, ["ast-source"] = utils["ast-source"], list = utils.list, ["list?"] = utils["list?"], ["table?"] = utils["table?"], sequence = utils.sequence, ["sequence?"] = utils["sequence?"], sym = utils.sym, ["sym?"] = utils["sym?"], ["multi-sym?"] = utils["multi-sym?"], comment = utils.comment, ["comment?"] = utils["comment?"], ["varg?"] = utils["varg?"], gensym = _560_, ["get-scope"] = _561_, ["in-scope?"] = _562_, macroexpand = _563_}
      env._G = env
      return setmetatable(env, {__index = provided, __newindex = provided, __pairs = combined_mt_pairs})
    end
    local function _565_(...)
      local tbl_16_auto = {}
      local i_17_auto = #tbl_16_auto
      for c in string.gmatch((package.config or ""), "([^\n]+)") do
        local val_18_auto = c
        if (nil ~= val_18_auto) then
          i_17_auto = (i_17_auto + 1)
          do end (tbl_16_auto)[i_17_auto] = val_18_auto
        else
        end
      end
      return tbl_16_auto
    end
    local _local_564_ = _565_(...)
    local dirsep = _local_564_[1]
    local pathsep = _local_564_[2]
    local pathmark = _local_564_[3]
    local pkg_config = {dirsep = (dirsep or "/"), pathmark = (pathmark or ";"), pathsep = (pathsep or "?")}
    local function escapepat(str)
      return string.gsub(str, "[^%w]", "%%%1")
    end
    local function search_module(modulename, _3fpathstring)
      local pathsepesc = escapepat(pkg_config.pathsep)
      local pattern = ("([^%s]*)%s"):format(pathsepesc, pathsepesc)
      local no_dot_module = modulename:gsub("%.", pkg_config.dirsep)
      local fullpath = ((_3fpathstring or utils["fennel-module"].path) .. pkg_config.pathsep)
      local function try_path(path)
        local filename = path:gsub(escapepat(pkg_config.pathmark), no_dot_module)
        local filename2 = path:gsub(escapepat(pkg_config.pathmark), modulename)
        local _567_ = (io.open(filename) or io.open(filename2))
        if (nil ~= _567_) then
          local file = _567_
          file:close()
          return filename
        elseif true then
          local _ = _567_
          return nil, ("no file '" .. filename .. "'")
        else
          return nil
        end
      end
      local function find_in_path(start, _3ftried_paths)
        local _569_ = fullpath:match(pattern, start)
        if (nil ~= _569_) then
          local path = _569_
          local _570_, _571_ = try_path(path)
          if (nil ~= _570_) then
            local filename = _570_
            return filename
          elseif ((_570_ == nil) and (nil ~= _571_)) then
            local error = _571_
            local function _573_()
              local _572_ = (_3ftried_paths or {})
              table.insert(_572_, error)
              return _572_
            end
            return find_in_path((start + #path + 1), _573_())
          else
            return nil
          end
        elseif true then
          local _ = _569_
          local function _575_()
            local tried_paths = table.concat((_3ftried_paths or {}), "\n\9")
            if (_VERSION < "Lua 5.4") then
              return ("\n\9" .. tried_paths)
            else
              return tried_paths
            end
          end
          return nil, _575_()
        else
          return nil
        end
      end
      return find_in_path(1)
    end
    local function make_searcher(_3foptions)
      local function _578_(module_name)
        local opts = utils.copy(utils.root.options)
        for k, v in pairs((_3foptions or {})) do
          opts[k] = v
        end
        opts["module-name"] = module_name
        local _579_, _580_ = search_module(module_name)
        if (nil ~= _579_) then
          local filename = _579_
          local _583_
          do
            local _581_ = filename
            local _582_ = opts
            local function _584_(...)
              return utils["fennel-module"].dofile(_581_, _582_, ...)
            end
            _583_ = _584_
          end
          return _583_, filename
        elseif ((_579_ == nil) and (nil ~= _580_)) then
          local error = _580_
          return error
        else
          return nil
        end
      end
      return _578_
    end
    local function dofile_with_searcher(fennel_macro_searcher, filename, opts, ...)
      local searchers = (package.loaders or package.searchers or {})
      local _ = table.insert(searchers, 1, fennel_macro_searcher)
      local m = utils["fennel-module"].dofile(filename, opts, ...)
      table.remove(searchers, 1)
      return m
    end
    local function fennel_macro_searcher(module_name)
      local opts
      do
        local _586_ = utils.copy(utils.root.options)
        do end (_586_)["module-name"] = module_name
        _586_["env"] = "_COMPILER"
        _586_["requireAsInclude"] = false
        _586_["allowedGlobals"] = nil
        opts = _586_
      end
      local _587_ = search_module(module_name, utils["fennel-module"]["macro-path"])
      if (nil ~= _587_) then
        local filename = _587_
        local _588_
        if (opts["compiler-env"] == _G) then
          local _589_ = fennel_macro_searcher
          local _590_ = filename
          local _591_ = opts
          local function _593_(...)
            return dofile_with_searcher(_589_, _590_, _591_, ...)
          end
          _588_ = _593_
        else
          local _594_ = filename
          local _595_ = opts
          local function _597_(...)
            return utils["fennel-module"].dofile(_594_, _595_, ...)
          end
          _588_ = _597_
        end
        return _588_, filename
      else
        return nil
      end
    end
    local function lua_macro_searcher(module_name)
      local _600_ = search_module(module_name, package.path)
      if (nil ~= _600_) then
        local filename = _600_
        local code
        do
          local f = io.open(filename)
          local function close_handlers_8_auto(ok_9_auto, ...)
            f:close()
            if ok_9_auto then
              return ...
            else
              return error(..., 0)
            end
          end
          local function _602_()
            return assert(f:read("*a"))
          end
          code = close_handlers_8_auto(_G.xpcall(_602_, (package.loaded.fennel or debug).traceback))
        end
        local chunk = load_code(code, make_compiler_env(), filename)
        return chunk, filename
      else
        return nil
      end
    end
    local macro_searchers = {fennel_macro_searcher, lua_macro_searcher}
    local function search_macro_module(modname, n)
      local _604_ = macro_searchers[n]
      if (nil ~= _604_) then
        local f = _604_
        local _605_, _606_ = f(modname)
        if ((nil ~= _605_) and true) then
          local loader = _605_
          local _3ffilename = _606_
          return loader, _3ffilename
        elseif true then
          local _ = _605_
          return search_macro_module(modname, (n + 1))
        else
          return nil
        end
      else
        return nil
      end
    end
    local function sandbox_fennel_module(modname)
      if ((modname == "fennel.macros") or (package and package.loaded and ("table" == type(package.loaded[modname])) and (package.loaded[modname].metadata == compiler.metadata))) then
        return {metadata = compiler.metadata, view = view}
      else
        return nil
      end
    end
    local function _610_(modname)
      local function _611_()
        local loader, filename = search_macro_module(modname, 1)
        compiler.assert(loader, (modname .. " module not found."))
        do end (macro_loaded)[modname] = loader(modname, filename)
        return macro_loaded[modname]
      end
      return (macro_loaded[modname] or sandbox_fennel_module(modname) or _611_())
    end
    safe_require = _610_
    local function add_macros(macros_2a, ast, scope)
      compiler.assert(utils["table?"](macros_2a), "expected macros to be table", ast)
      for k, v in pairs(macros_2a) do
        compiler.assert((type(v) == "function"), "expected each macro to be function", ast)
        compiler["check-binding-valid"](utils.sym(k), scope, ast, {["macro?"] = true})
        do end (scope.macros)[k] = v
      end
      return nil
    end
    local function resolve_module_name(_612_, _scope, _parent, opts)
      local _arg_613_ = _612_
      local filename = _arg_613_["filename"]
      local second = _arg_613_[2]
      local filename0 = (filename or (utils["table?"](second) and second.filename))
      local module_name = utils.root.options["module-name"]
      local modexpr = compiler.compile(second, opts)
      local modname_chunk = load_code(modexpr)
      return modname_chunk(module_name, filename0)
    end
    SPECIALS["require-macros"] = function(ast, scope, parent, _3freal_ast)
      compiler.assert((#ast == 2), "Expected one module name argument", (_3freal_ast or ast))
      local modname = resolve_module_name(ast, scope, parent, {})
      compiler.assert(utils["string?"](modname), "module name must compile to string", (_3freal_ast or ast))
      if not macro_loaded[modname] then
        local loader, filename = search_macro_module(modname, 1)
        compiler.assert(loader, (modname .. " module not found."), ast)
        do end (macro_loaded)[modname] = compiler.assert(utils["table?"](loader(modname, filename)), "expected macros to be table", (_3freal_ast or ast))
      else
      end
      if ("import-macros" == tostring(ast[1])) then
        return macro_loaded[modname]
      else
        return add_macros(macro_loaded[modname], ast, scope, parent)
      end
    end
    doc_special("require-macros", {"macro-module-name"}, "Load given module and use its contents as macro definitions in current scope.\nMacro module should return a table of macro functions with string keys.\nConsider using import-macros instead as it is more flexible.")
    local function emit_included_fennel(src, path, opts, sub_chunk)
      local subscope = compiler["make-scope"](utils.root.scope.parent)
      local forms = {}
      if utils.root.options.requireAsInclude then
        subscope.specials.require = compiler["require-include"]
      else
      end
      for _, val in parser.parser(parser["string-stream"](src), path) do
        table.insert(forms, val)
      end
      for i = 1, #forms do
        local subopts
        if (i == #forms) then
          subopts = {tail = true}
        else
          subopts = {nval = 0}
        end
        utils["propagate-options"](opts, subopts)
        compiler.compile1(forms[i], subscope, sub_chunk, subopts)
      end
      return nil
    end
    local function include_path(ast, opts, path, mod, fennel_3f)
      utils.root.scope.includes[mod] = "fnl/loading"
      local src
      do
        local f = assert(io.open(path))
        local function close_handlers_8_auto(ok_9_auto, ...)
          f:close()
          if ok_9_auto then
            return ...
          else
            return error(..., 0)
          end
        end
        local function _619_()
          return assert(f:read("*all")):gsub("[\13\n]*$", "")
        end
        src = close_handlers_8_auto(_G.xpcall(_619_, (package.loaded.fennel or debug).traceback))
      end
      local ret = utils.expr(("require(\"" .. mod .. "\")"), "statement")
      local target = ("package.preload[%q]"):format(mod)
      local preload_str = (target .. " = " .. target .. " or function(...)")
      local temp_chunk, sub_chunk = {}, {}
      compiler.emit(temp_chunk, preload_str, ast)
      compiler.emit(temp_chunk, sub_chunk)
      compiler.emit(temp_chunk, "end", ast)
      for _, v in ipairs(temp_chunk) do
        table.insert(utils.root.chunk, v)
      end
      if fennel_3f then
        emit_included_fennel(src, path, opts, sub_chunk)
      else
        compiler.emit(sub_chunk, src, ast)
      end
      utils.root.scope.includes[mod] = ret
      return ret
    end
    local function include_circular_fallback(mod, modexpr, fallback, ast)
      if (utils.root.scope.includes[mod] == "fnl/loading") then
        compiler.assert(fallback, "circular include detected", ast)
        return fallback(modexpr)
      else
        return nil
      end
    end
    SPECIALS.include = function(ast, scope, parent, opts)
      compiler.assert((#ast == 2), "expected one argument", ast)
      local modexpr
      do
        local _622_, _623_ = pcall(resolve_module_name, ast, scope, parent, opts)
        if ((_622_ == true) and (nil ~= _623_)) then
          local modname = _623_
          modexpr = utils.expr(string.format("%q", modname), "literal")
        elseif true then
          local _ = _622_
          modexpr = (compiler.compile1(ast[2], scope, parent, {nval = 1}))[1]
        else
          modexpr = nil
        end
      end
      if ((modexpr.type ~= "literal") or ((modexpr[1]):byte() ~= 34)) then
        if opts.fallback then
          return opts.fallback(modexpr)
        else
          return compiler.assert(false, "module name must be string literal", ast)
        end
      else
        local mod = load_code(("return " .. modexpr[1]))()
        local oldmod = utils.root.options["module-name"]
        local _
        utils.root.options["module-name"] = mod
        _ = nil
        local res
        local function _627_()
          local _626_ = search_module(mod)
          if (nil ~= _626_) then
            local fennel_path = _626_
            return include_path(ast, opts, fennel_path, mod, true)
          elseif true then
            local _0 = _626_
            local lua_path = search_module(mod, package.path)
            if lua_path then
              return include_path(ast, opts, lua_path, mod, false)
            elseif opts.fallback then
              return opts.fallback(modexpr)
            else
              return compiler.assert(false, ("module not found " .. mod), ast)
            end
          else
            return nil
          end
        end
        res = ((utils["member?"](mod, (utils.root.options.skipInclude or {})) and opts.fallback(modexpr, true)) or include_circular_fallback(mod, modexpr, opts.fallback, ast) or utils.root.scope.includes[mod] or _627_())
        utils.root.options["module-name"] = oldmod
        return res
      end
    end
    doc_special("include", {"module-name-literal"}, "Like require but load the target module during compilation and embed it in the\nLua output. The module must be a string literal and resolvable at compile time.")
    local function eval_compiler_2a(ast, scope, parent)
      local env = make_compiler_env(ast, scope, parent)
      local opts = utils.copy(utils.root.options)
      opts.scope = compiler["make-scope"](compiler.scopes.compiler)
      opts.allowedGlobals = current_global_names(env)
      return assert(load_code(compiler.compile(ast, opts), wrap_env(env)), opts["module-name"], ast.filename)()
    end
    SPECIALS.macros = function(ast, scope, parent)
      compiler.assert(((#ast == 2) and utils["table?"](ast[2])), "Expected one table argument", ast)
      return add_macros(eval_compiler_2a(ast[2], scope, parent), ast, scope, parent)
    end
    doc_special("macros", {"{:macro-name-1 (fn [...] ...) ... :macro-name-N macro-body-N}"}, "Define all functions in the given table as macros local to the current scope.")
    SPECIALS["eval-compiler"] = function(ast, scope, parent)
      local old_first = ast[1]
      ast[1] = utils.sym("do")
      local val = eval_compiler_2a(ast, scope, parent)
      do end (ast)[1] = old_first
      return val
    end
    doc_special("eval-compiler", {"..."}, "Evaluate the body at compile-time. Use the macro system instead if possible.", true)
    return {doc = doc_2a, ["current-global-names"] = current_global_names, ["load-code"] = load_code, ["macro-loaded"] = macro_loaded, ["macro-searchers"] = macro_searchers, ["make-compiler-env"] = make_compiler_env, ["search-module"] = search_module, ["make-searcher"] = make_searcher, ["wrap-env"] = wrap_env}
  end
  package.preload["fennel.compiler"] = package.preload["fennel.compiler"] or function(...)
    local utils = require("fennel.utils")
    local parser = require("fennel.parser")
    local friend = require("fennel.friend")
    local unpack = (table.unpack or _G.unpack)
    local scopes = {}
    local function make_scope(_3fparent)
      local parent = (_3fparent or scopes.global)
      local _268_
      if parent then
        _268_ = ((parent.depth or 0) + 1)
      else
        _268_ = 0
      end
      return {includes = setmetatable({}, {__index = (parent and parent.includes)}), macros = setmetatable({}, {__index = (parent and parent.macros)}), manglings = setmetatable({}, {__index = (parent and parent.manglings)}), specials = setmetatable({}, {__index = (parent and parent.specials)}), symmeta = setmetatable({}, {__index = (parent and parent.symmeta)}), unmanglings = setmetatable({}, {__index = (parent and parent.unmanglings)}), gensyms = setmetatable({}, {__index = (parent and parent.gensyms)}), autogensyms = setmetatable({}, {__index = (parent and parent.autogensyms)}), vararg = (parent and parent.vararg), depth = _268_, hashfn = (parent and parent.hashfn), refedglobals = {}, parent = parent}
    end
    local function assert_msg(ast, msg)
      local ast_tbl
      if ("table" == type(ast)) then
        ast_tbl = ast
      else
        ast_tbl = {}
      end
      local m = getmetatable(ast)
      local filename = ((m and m.filename) or ast_tbl.filename or "unknown")
      local line = ((m and m.line) or ast_tbl.line or "?")
      local col = ((m and m.col) or ast_tbl.col or "?")
      local target = tostring((utils["sym?"](ast_tbl[1]) or ast_tbl[1] or "()"))
      return string.format("%s:%s:%s Compile error in '%s': %s", filename, line, col, target, msg)
    end
    local function assert_compile(condition, msg, ast, _3ffallback_ast)
      if not condition then
        local _let_271_ = (utils.root.options or {})
        local source = _let_271_["source"]
        local unfriendly = _let_271_["unfriendly"]
        local error_pinpoint = _let_271_["error-pinpoint"]
        local ast0
        if next(utils["ast-source"](ast)) then
          ast0 = ast
        else
          ast0 = (_3ffallback_ast or {})
        end
        if (nil == utils.hook("assert-compile", condition, msg, ast0, utils.root.reset)) then
          utils.root.reset()
          if (unfriendly or not friend or not _G.io or not _G.io.read) then
            error(assert_msg(ast0, msg), 0)
          else
            friend["assert-compile"](condition, msg, ast0, source, {["error-pinpoint"] = error_pinpoint})
          end
        else
        end
      else
      end
      return condition
    end
    scopes.global = make_scope()
    scopes.global.vararg = true
    scopes.compiler = make_scope(scopes.global)
    scopes.macro = scopes.global
    local serialize_subst = {["\7"] = "\\a", ["\8"] = "\\b", ["\9"] = "\\t", ["\n"] = "n", ["\11"] = "\\v", ["\12"] = "\\f"}
    local function serialize_string(str)
      local function _276_(_241)
        return ("\\" .. _241:byte())
      end
      return string.gsub(string.gsub(string.format("%q", str), ".", serialize_subst), "[\128-\255]", _276_)
    end
    local function global_mangling(str)
      if utils["valid-lua-identifier?"](str) then
        return str
      else
        local function _277_(_241)
          return string.format("_%02x", _241:byte())
        end
        return ("__fnl_global__" .. str:gsub("[^%w]", _277_))
      end
    end
    local function global_unmangling(identifier)
      local _279_ = string.match(identifier, "^__fnl_global__(.*)$")
      if (nil ~= _279_) then
        local rest = _279_
        local _280_
        local function _281_(_241)
          return string.char(tonumber(_241:sub(2), 16))
        end
        _280_ = string.gsub(rest, "_[%da-f][%da-f]", _281_)
        return _280_
      elseif true then
        local _ = _279_
        return identifier
      else
        return nil
      end
    end
    local allowed_globals = nil
    local function global_allowed_3f(name)
      return (not allowed_globals or utils["member?"](name, allowed_globals))
    end
    local function unique_mangling(original, mangling, scope, append)
      if (scope.unmanglings[mangling] and not scope.gensyms[mangling]) then
        return unique_mangling(original, (original .. append), scope, (append + 1))
      else
        return mangling
      end
    end
    local function local_mangling(str, scope, ast, _3ftemp_manglings)
      assert_compile(not utils["multi-sym?"](str), ("unexpected multi symbol " .. str), ast)
      local raw
      if ((utils["lua-keywords"])[str] or str:match("^%d")) then
        raw = ("_" .. str)
      else
        raw = str
      end
      local mangling
      local function _285_(_241)
        return string.format("_%02x", _241:byte())
      end
      mangling = string.gsub(string.gsub(raw, "-", "_"), "[^%w_]", _285_)
      local unique = unique_mangling(mangling, mangling, scope, 0)
      do end (scope.unmanglings)[unique] = str
      do
        local manglings = (_3ftemp_manglings or scope.manglings)
        do end (manglings)[str] = unique
      end
      return unique
    end
    local function apply_manglings(scope, new_manglings, ast)
      for raw, mangled in pairs(new_manglings) do
        assert_compile(not scope.refedglobals[mangled], ("use of global " .. raw .. " is aliased by a local"), ast)
        do end (scope.manglings)[raw] = mangled
      end
      return nil
    end
    local function combine_parts(parts, scope)
      local ret = (scope.manglings[parts[1]] or global_mangling(parts[1]))
      for i = 2, #parts do
        if utils["valid-lua-identifier?"](parts[i]) then
          if (parts["multi-sym-method-call"] and (i == #parts)) then
            ret = (ret .. ":" .. parts[i])
          else
            ret = (ret .. "." .. parts[i])
          end
        else
          ret = (ret .. "[" .. serialize_string(parts[i]) .. "]")
        end
      end
      return ret
    end
    local function next_append()
      utils.root.scope["gensym-append"] = ((utils.root.scope["gensym-append"] or 0) + 1)
      return ("_" .. utils.root.scope["gensym-append"] .. "_")
    end
    local function gensym(scope, _3fbase, _3fsuffix)
      local mangling = ((_3fbase or "") .. next_append() .. (_3fsuffix or ""))
      while scope.unmanglings[mangling] do
        mangling = ((_3fbase or "") .. next_append() .. (_3fsuffix or ""))
      end
      scope.unmanglings[mangling] = (_3fbase or true)
      do end (scope.gensyms)[mangling] = true
      return mangling
    end
    local function combine_auto_gensym(parts, first)
      parts[1] = first
      local last = table.remove(parts)
      local last2 = table.remove(parts)
      local last_joiner = ((parts["multi-sym-method-call"] and ":") or ".")
      table.insert(parts, (last2 .. last_joiner .. last))
      return table.concat(parts, ".")
    end
    local function autogensym(base, scope)
      local _288_ = utils["multi-sym?"](base)
      if (nil ~= _288_) then
        local parts = _288_
        return combine_auto_gensym(parts, autogensym(parts[1], scope))
      elseif true then
        local _ = _288_
        local function _289_()
          local mangling = gensym(scope, base:sub(1, ( - 2)), "auto")
          do end (scope.autogensyms)[base] = mangling
          return mangling
        end
        return (scope.autogensyms[base] or _289_())
      else
        return nil
      end
    end
    local function check_binding_valid(symbol, scope, ast, _3fopts)
      local name = tostring(symbol)
      local macro_3f
      do
        local t_291_ = _3fopts
        if (nil ~= t_291_) then
          t_291_ = (t_291_)["macro?"]
        else
        end
        macro_3f = t_291_
      end
      assert_compile(not name:find("&"), "invalid character: &", symbol)
      assert_compile(not name:find("^%."), "invalid character: .", symbol)
      assert_compile(not (scope.specials[name] or (not macro_3f and scope.macros[name])), ("local %s was overshadowed by a special form or macro"):format(name), ast)
      return assert_compile(not utils["quoted?"](symbol), string.format("macro tried to bind %s without gensym", name), symbol)
    end
    local function declare_local(symbol, meta, scope, ast, _3ftemp_manglings)
      check_binding_valid(symbol, scope, ast)
      local name = tostring(symbol)
      assert_compile(not utils["multi-sym?"](name), ("unexpected multi symbol " .. name), ast)
      do end (scope.symmeta)[name] = meta
      return local_mangling(name, scope, ast, _3ftemp_manglings)
    end
    local function hashfn_arg_name(name, multi_sym_parts, scope)
      if not scope.hashfn then
        return nil
      elseif (name == "$") then
        return "$1"
      elseif multi_sym_parts then
        if (multi_sym_parts and (multi_sym_parts[1] == "$")) then
          multi_sym_parts[1] = "$1"
        else
        end
        return table.concat(multi_sym_parts, ".")
      else
        return nil
      end
    end
    local function symbol_to_expression(symbol, scope, _3freference_3f)
      utils.hook("symbol-to-expression", symbol, scope, _3freference_3f)
      local name = symbol[1]
      local multi_sym_parts = utils["multi-sym?"](name)
      local name0 = (hashfn_arg_name(name, multi_sym_parts, scope) or name)
      local parts = (multi_sym_parts or {name0})
      local etype = (((1 < #parts) and "expression") or "sym")
      local local_3f = scope.manglings[parts[1]]
      if (local_3f and scope.symmeta[parts[1]]) then
        scope.symmeta[parts[1]]["used"] = true
      else
      end
      assert_compile(not scope.macros[parts[1]], "tried to reference a macro without calling it", symbol)
      assert_compile((not scope.specials[parts[1]] or ("require" == parts[1])), "tried to reference a special form without calling it", symbol)
      assert_compile((not _3freference_3f or local_3f or ("_ENV" == parts[1]) or global_allowed_3f(parts[1])), ("unknown identifier: " .. tostring(parts[1])), symbol)
      if (allowed_globals and not local_3f and scope.parent) then
        scope.parent.refedglobals[parts[1]] = true
      else
      end
      return utils.expr(combine_parts(parts, scope), etype)
    end
    local function emit(chunk, out, _3fast)
      if (type(out) == "table") then
        return table.insert(chunk, out)
      else
        return table.insert(chunk, {ast = _3fast, leaf = out})
      end
    end
    local function peephole(chunk)
      if chunk.leaf then
        return chunk
      elseif ((3 <= #chunk) and (chunk[(#chunk - 2)].leaf == "do") and not chunk[(#chunk - 1)].leaf and (chunk[#chunk].leaf == "end")) then
        local kid = peephole(chunk[(#chunk - 1)])
        local new_chunk = {ast = chunk.ast}
        for i = 1, (#chunk - 3) do
          table.insert(new_chunk, peephole(chunk[i]))
        end
        for i = 1, #kid do
          table.insert(new_chunk, kid[i])
        end
        return new_chunk
      else
        return utils.map(chunk, peephole)
      end
    end
    local function flatten_chunk_correlated(main_chunk, options)
      local function flatten(chunk, out, last_line, file)
        local last_line0 = last_line
        if chunk.leaf then
          out[last_line0] = ((out[last_line0] or "") .. " " .. chunk.leaf)
        else
          for _, subchunk in ipairs(chunk) do
            if (subchunk.leaf or (0 < #subchunk)) then
              local source = utils["ast-source"](subchunk.ast)
              if (file == source.filename) then
                last_line0 = math.max(last_line0, (source.line or 0))
              else
              end
              last_line0 = flatten(subchunk, out, last_line0, file)
            else
            end
          end
        end
        return last_line0
      end
      local out = {}
      local last = flatten(main_chunk, out, 1, options.filename)
      for i = 1, last do
        if (out[i] == nil) then
          out[i] = ""
        else
        end
      end
      return table.concat(out, "\n")
    end
    local function flatten_chunk(file_sourcemap, chunk, tab, depth)
      if chunk.leaf then
        local _let_303_ = utils["ast-source"](chunk.ast)
        local filename = _let_303_["filename"]
        local line = _let_303_["line"]
        table.insert(file_sourcemap, {filename, line})
        return chunk.leaf
      else
        local tab0
        do
          local _304_ = tab
          if (_304_ == true) then
            tab0 = "  "
          elseif (_304_ == false) then
            tab0 = ""
          elseif (_304_ == tab) then
            tab0 = tab
          elseif (_304_ == nil) then
            tab0 = ""
          else
            tab0 = nil
          end
        end
        local function parter(c)
          if (c.leaf or (0 < #c)) then
            local sub = flatten_chunk(file_sourcemap, c, tab0, (depth + 1))
            if (0 < depth) then
              return (tab0 .. sub:gsub("\n", ("\n" .. tab0)))
            else
              return sub
            end
          else
            return nil
          end
        end
        return table.concat(utils.map(chunk, parter), "\n")
      end
    end
    local sourcemap = {}
    local function make_short_src(source)
      local source0 = source:gsub("\n", " ")
      if (#source0 <= 49) then
        return ("[fennel \"" .. source0 .. "\"]")
      else
        return ("[fennel \"" .. source0:sub(1, 46) .. "...\"]")
      end
    end
    local function flatten(chunk, options)
      local chunk0 = peephole(chunk)
      if options.correlate then
        return flatten_chunk_correlated(chunk0, options), {}
      else
        local file_sourcemap = {}
        local src = flatten_chunk(file_sourcemap, chunk0, options.indent, 0)
        file_sourcemap.short_src = (options.filename or make_short_src((options.source or src)))
        if options.filename then
          file_sourcemap.key = ("@" .. options.filename)
        else
          file_sourcemap.key = src
        end
        sourcemap[file_sourcemap.key] = file_sourcemap
        return src, file_sourcemap
      end
    end
    local function make_metadata()
      local function _312_(self, tgt, key)
        if self[tgt] then
          return self[tgt][key]
        else
          return nil
        end
      end
      local function _314_(self, tgt, key, value)
        self[tgt] = (self[tgt] or {})
        do end (self[tgt])[key] = value
        return tgt
      end
      local function _315_(self, tgt, ...)
        local kv_len = select("#", ...)
        local kvs = {...}
        if ((kv_len % 2) ~= 0) then
          error("metadata:setall() expected even number of k/v pairs")
        else
        end
        self[tgt] = (self[tgt] or {})
        for i = 1, kv_len, 2 do
          self[tgt][kvs[i]] = kvs[(i + 1)]
        end
        return tgt
      end
      return setmetatable({}, {__index = {get = _312_, set = _314_, setall = _315_}, __mode = "k"})
    end
    local function exprs1(exprs)
      return table.concat(utils.map(exprs, tostring), ", ")
    end
    local function keep_side_effects(exprs, chunk, start, ast)
      local start0 = (start or 1)
      for j = start0, #exprs do
        local se = exprs[j]
        if ((se.type == "expression") and (se[1] ~= "nil")) then
          emit(chunk, string.format("do local _ = %s end", tostring(se)), ast)
        elseif (se.type == "statement") then
          local code = tostring(se)
          local disambiguated
          if (code:byte() == 40) then
            disambiguated = ("do end " .. code)
          else
            disambiguated = code
          end
          emit(chunk, disambiguated, ast)
        else
        end
      end
      return nil
    end
    local function handle_compile_opts(exprs, parent, opts, ast)
      if opts.nval then
        local n = opts.nval
        local len = #exprs
        if (n ~= len) then
          if (n < len) then
            keep_side_effects(exprs, parent, (n + 1), ast)
            for i = (n + 1), len do
              exprs[i] = nil
            end
          else
            for i = (#exprs + 1), n do
              exprs[i] = utils.expr("nil", "literal")
            end
          end
        else
        end
      else
      end
      if opts.tail then
        emit(parent, string.format("return %s", exprs1(exprs)), ast)
      else
      end
      if opts.target then
        local result = exprs1(exprs)
        local function _323_()
          if (result == "") then
            return "nil"
          else
            return result
          end
        end
        emit(parent, string.format("%s = %s", opts.target, _323_()), ast)
      else
      end
      if (opts.tail or opts.target) then
        return {returned = true}
      else
        local _325_ = exprs
        _325_["returned"] = true
        return _325_
      end
    end
    local function find_macro(ast, scope)
      local macro_2a
      do
        local _327_ = utils["sym?"](ast[1])
        if (_327_ ~= nil) then
          local _328_ = tostring(_327_)
          if (_328_ ~= nil) then
            macro_2a = scope.macros[_328_]
          else
            macro_2a = _328_
          end
        else
          macro_2a = _327_
        end
      end
      local multi_sym_parts = utils["multi-sym?"](ast[1])
      if (not macro_2a and multi_sym_parts) then
        local nested_macro = utils["get-in"](scope.macros, multi_sym_parts)
        assert_compile((not scope.macros[multi_sym_parts[1]] or (type(nested_macro) == "function")), "macro not found in imported macro module", ast)
        return nested_macro
      else
        return macro_2a
      end
    end
    local function propagate_trace_info(_332_, _index, node)
      local _arg_333_ = _332_
      local filename = _arg_333_["filename"]
      local line = _arg_333_["line"]
      local bytestart = _arg_333_["bytestart"]
      local byteend = _arg_333_["byteend"]
      do
        local src = utils["ast-source"](node)
        if (("table" == type(node)) and (filename ~= src.filename)) then
          src.filename, src.line, src["from-macro?"] = filename, line, true
          src.bytestart, src.byteend = bytestart, byteend
        else
        end
      end
      return ("table" == type(node))
    end
    local function quote_literal_nils(index, node, parent)
      if (parent and utils["list?"](parent)) then
        for i = 1, utils.maxn(parent) do
          local _335_ = parent[i]
          if (_335_ == nil) then
            parent[i] = utils.sym("nil")
          else
          end
        end
      else
      end
      return index, node, parent
    end
    local function comp(f, g)
      local function _338_(...)
        return f(g(...))
      end
      return _338_
    end
    local function built_in_3f(m)
      local found_3f = false
      for _, f in pairs(scopes.global.macros) do
        if found_3f then break end
        found_3f = (f == m)
      end
      return found_3f
    end
    local function macroexpand_2a(ast, scope, _3fonce)
      local _339_
      if utils["list?"](ast) then
        _339_ = find_macro(ast, scope)
      else
        _339_ = nil
      end
      if (_339_ == false) then
        return ast
      elseif (nil ~= _339_) then
        local macro_2a = _339_
        local old_scope = scopes.macro
        local _
        scopes.macro = scope
        _ = nil
        local ok, transformed = nil, nil
        local function _341_()
          return macro_2a(unpack(ast, 2))
        end
        local function _342_()
          if built_in_3f(macro_2a) then
            return tostring
          else
            return debug.traceback
          end
        end
        ok, transformed = xpcall(_341_, _342_())
        local _344_
        do
          local _343_ = ast
          local function _345_(...)
            return propagate_trace_info(_343_, ...)
          end
          _344_ = _345_
        end
        utils["walk-tree"](transformed, comp(_344_, quote_literal_nils))
        scopes.macro = old_scope
        assert_compile(ok, transformed, ast)
        if (_3fonce or not transformed) then
          return transformed
        else
          return macroexpand_2a(transformed, scope)
        end
      elseif true then
        local _ = _339_
        return ast
      else
        return nil
      end
    end
    local function compile_special(ast, scope, parent, opts, special)
      local exprs = (special(ast, scope, parent, opts) or utils.expr("nil", "literal"))
      local exprs0
      if ("table" ~= type(exprs)) then
        exprs0 = utils.expr(exprs, "expression")
      else
        exprs0 = exprs
      end
      local exprs2
      if utils["expr?"](exprs0) then
        exprs2 = {exprs0}
      else
        exprs2 = exprs0
      end
      if not exprs2.returned then
        return handle_compile_opts(exprs2, parent, opts, ast)
      elseif (opts.tail or opts.target) then
        return {returned = true}
      else
        return exprs2
      end
    end
    local function compile_function_call(ast, scope, parent, opts, compile1, len)
      local fargs = {}
      local fcallee = (compile1(ast[1], scope, parent, {nval = 1}))[1]
      assert_compile((utils["sym?"](ast[1]) or utils["list?"](ast[1]) or ("string" == type(ast[1]))), ("cannot call literal value " .. tostring(ast[1])), ast)
      for i = 2, len do
        local subexprs
        local _351_
        if (i ~= len) then
          _351_ = 1
        else
          _351_ = nil
        end
        subexprs = compile1(ast[i], scope, parent, {nval = _351_})
        table.insert(fargs, subexprs[1])
        if (i == len) then
          for j = 2, #subexprs do
            table.insert(fargs, subexprs[j])
          end
        else
          keep_side_effects(subexprs, parent, 2, ast[i])
        end
      end
      local pat
      if ("string" == type(ast[1])) then
        pat = "(%s)(%s)"
      else
        pat = "%s(%s)"
      end
      local call = string.format(pat, tostring(fcallee), exprs1(fargs))
      return handle_compile_opts({utils.expr(call, "statement")}, parent, opts, ast)
    end
    local function compile_call(ast, scope, parent, opts, compile1)
      utils.hook("call", ast, scope)
      local len = #ast
      local first = ast[1]
      local multi_sym_parts = utils["multi-sym?"](first)
      local special = (utils["sym?"](first) and scope.specials[tostring(first)])
      assert_compile((0 < len), "expected a function, macro, or special to call", ast)
      if special then
        return compile_special(ast, scope, parent, opts, special)
      elseif (multi_sym_parts and multi_sym_parts["multi-sym-method-call"]) then
        local table_with_method = table.concat({unpack(multi_sym_parts, 1, (#multi_sym_parts - 1))}, ".")
        local method_to_call = multi_sym_parts[#multi_sym_parts]
        local new_ast = utils.list(utils.sym(":", ast), utils.sym(table_with_method, ast), method_to_call, select(2, unpack(ast)))
        return compile1(new_ast, scope, parent, opts)
      else
        return compile_function_call(ast, scope, parent, opts, compile1, len)
      end
    end
    local function compile_varg(ast, scope, parent, opts)
      local _356_
      if scope.hashfn then
        _356_ = "use $... in hashfn"
      else
        _356_ = "unexpected vararg"
      end
      assert_compile(scope.vararg, _356_, ast)
      return handle_compile_opts({utils.expr("...", "varg")}, parent, opts, ast)
    end
    local function compile_sym(ast, scope, parent, opts)
      local multi_sym_parts = utils["multi-sym?"](ast)
      assert_compile(not (multi_sym_parts and multi_sym_parts["multi-sym-method-call"]), "multisym method calls may only be in call position", ast)
      local e
      if (ast[1] == "nil") then
        e = utils.expr("nil", "literal")
      else
        e = symbol_to_expression(ast, scope, true)
      end
      return handle_compile_opts({e}, parent, opts, ast)
    end
    local function serialize_number(n)
      local _359_ = string.gsub(tostring(n), ",", ".")
      return _359_
    end
    local function compile_scalar(ast, _scope, parent, opts)
      local serialize
      do
        local _360_ = type(ast)
        if (_360_ == "nil") then
          serialize = tostring
        elseif (_360_ == "boolean") then
          serialize = tostring
        elseif (_360_ == "string") then
          serialize = serialize_string
        elseif (_360_ == "number") then
          serialize = serialize_number
        else
          serialize = nil
        end
      end
      return handle_compile_opts({utils.expr(serialize(ast), "literal")}, parent, opts)
    end
    local function compile_table(ast, scope, parent, opts, compile1)
      local function escape_key(k)
        if ((type(k) == "string") and utils["valid-lua-identifier?"](k)) then
          return k
        else
          local _let_362_ = compile1(k, scope, parent, {nval = 1})
          local compiled = _let_362_[1]
          return ("[" .. tostring(compiled) .. "]")
        end
      end
      local keys = {}
      local buffer
      do
        local tbl_16_auto = {}
        local i_17_auto = #tbl_16_auto
        for i, elem in ipairs(ast) do
          local val_18_auto
          do
            local nval = ((nil ~= ast[(i + 1)]) and 1)
            do end (keys)[i] = true
            val_18_auto = exprs1(compile1(elem, scope, parent, {nval = nval}))
          end
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
        buffer = tbl_16_auto
      end
      do
        local tbl_16_auto = buffer
        local i_17_auto = #tbl_16_auto
        for k, v in utils.stablepairs(ast) do
          local val_18_auto
          if not keys[k] then
            local _let_365_ = compile1(ast[k], scope, parent, {nval = 1})
            local v0 = _let_365_[1]
            val_18_auto = string.format("%s = %s", escape_key(k), tostring(v0))
          else
            val_18_auto = nil
          end
          if (nil ~= val_18_auto) then
            i_17_auto = (i_17_auto + 1)
            do end (tbl_16_auto)[i_17_auto] = val_18_auto
          else
          end
        end
      end
      return handle_compile_opts({utils.expr(("{" .. table.concat(buffer, ", ") .. "}"), "expression")}, parent, opts, ast)
    end
    local function compile1(ast, scope, parent, _3fopts)
      local opts = (_3fopts or {})
      local ast0 = macroexpand_2a(ast, scope)
      if utils["list?"](ast0) then
        return compile_call(ast0, scope, parent, opts, compile1)
      elseif utils["varg?"](ast0) then
        return compile_varg(ast0, scope, parent, opts)
      elseif utils["sym?"](ast0) then
        return compile_sym(ast0, scope, parent, opts)
      elseif (type(ast0) == "table") then
        return compile_table(ast0, scope, parent, opts, compile1)
      elseif ((type(ast0) == "nil") or (type(ast0) == "boolean") or (type(ast0) == "number") or (type(ast0) == "string")) then
        return compile_scalar(ast0, scope, parent, opts)
      else
        return assert_compile(false, ("could not compile value of type " .. type(ast0)), ast0)
      end
    end
    local function destructure(to, from, ast, scope, parent, opts)
      local opts0 = (opts or {})
      local _let_369_ = opts0
      local isvar = _let_369_["isvar"]
      local declaration = _let_369_["declaration"]
      local forceglobal = _let_369_["forceglobal"]
      local forceset = _let_369_["forceset"]
      local symtype = _let_369_["symtype"]
      local symtype0 = ("_" .. (symtype or "dst"))
      local setter
      if declaration then
        setter = "local %s = %s"
      else
        setter = "%s = %s"
      end
      local new_manglings = {}
      local function getname(symbol, up1)
        local raw = symbol[1]
        assert_compile(not (opts0.nomulti and utils["multi-sym?"](raw)), ("unexpected multi symbol " .. raw), up1)
        if declaration then
          return declare_local(symbol, nil, scope, symbol, new_manglings)
        else
          local parts = (utils["multi-sym?"](raw) or {raw})
          local meta = scope.symmeta[parts[1]]
          assert_compile(not raw:find(":"), "cannot set method sym", symbol)
          if ((#parts == 1) and not forceset) then
            assert_compile(not (forceglobal and meta), string.format("global %s conflicts with local", tostring(symbol)), symbol)
            assert_compile(not (meta and not meta.var), ("expected var " .. raw), symbol)
          else
          end
          assert_compile((meta or not opts0.noundef or global_allowed_3f(parts[1])), ("expected local " .. parts[1]), symbol)
          if forceglobal then
            assert_compile(not scope.symmeta[scope.unmanglings[raw]], ("global " .. raw .. " conflicts with local"), symbol)
            do end (scope.manglings)[raw] = global_mangling(raw)
            do end (scope.unmanglings)[global_mangling(raw)] = raw
            if allowed_globals then
              table.insert(allowed_globals, raw)
            else
            end
          else
          end
          return symbol_to_expression(symbol, scope)[1]
        end
      end
      local function compile_top_target(lvalues)
        local inits
        local function _375_(_241)
          if scope.manglings[_241] then
            return _241
          else
            return "nil"
          end
        end
        inits = utils.map(lvalues, _375_)
        local init = table.concat(inits, ", ")
        local lvalue = table.concat(lvalues, ", ")
        local plast = parent[#parent]
        local plen = #parent
        local ret = compile1(from, scope, parent, {target = lvalue})
        if declaration then
          for pi = plen, #parent do
            if (parent[pi] == plast) then
              plen = pi
            else
            end
          end
          if ((#parent == (plen + 1)) and parent[#parent].leaf) then
            parent[#parent]["leaf"] = ("local " .. parent[#parent].leaf)
          elseif (init == "nil") then
            table.insert(parent, (plen + 1), {ast = ast, leaf = ("local " .. lvalue)})
          else
            table.insert(parent, (plen + 1), {ast = ast, leaf = ("local " .. lvalue .. " = " .. init)})
          end
        else
        end
        return ret
      end
      local function destructure_sym(left, rightexprs, up1, top_3f)
        local lname = getname(left, up1)
        check_binding_valid(left, scope, left)
        if top_3f then
          compile_top_target({lname})
        else
          emit(parent, setter:format(lname, exprs1(rightexprs)), left)
        end
        if declaration then
          scope.symmeta[tostring(left)] = {var = isvar}
          return nil
        else
          return nil
        end
      end
      local unpack_fn = "function (t, k, e)\n                        local mt = getmetatable(t)\n                        if 'table' == type(mt) and mt.__fennelrest then\n                          return mt.__fennelrest(t, k)\n                        elseif e then\n                          local rest = {}\n                          for k, v in pairs(t) do\n                            if not e[k] then rest[k] = v end\n                          end\n                          return rest\n                        else\n                          return {(table.unpack or unpack)(t, k)}\n                        end\n                      end"
      local function destructure_kv_rest(s, v, left, excluded_keys, destructure1)
        local exclude_str
        local _382_
        do
          local tbl_16_auto = {}
          local i_17_auto = #tbl_16_auto
          for _, k in ipairs(excluded_keys) do
            local val_18_auto = string.format("[%s] = true", serialize_string(k))
            if (nil ~= val_18_auto) then
              i_17_auto = (i_17_auto + 1)
              do end (tbl_16_auto)[i_17_auto] = val_18_auto
            else
            end
          end
          _382_ = tbl_16_auto
        end
        exclude_str = table.concat(_382_, ", ")
        local subexpr = utils.expr(string.format(string.gsub(("(" .. unpack_fn .. ")(%s, %s, {%s})"), "\n%s*", " "), s, tostring(v), exclude_str), "expression")
        return destructure1(v, {subexpr}, left)
      end
      local function destructure_rest(s, k, left, destructure1)
        local unpack_str = ("(" .. unpack_fn .. ")(%s, %s)")
        local formatted = string.format(string.gsub(unpack_str, "\n%s*", " "), s, k)
        local subexpr = utils.expr(formatted, "expression")
        assert_compile((utils["sequence?"](left) and (nil == left[(k + 2)])), "expected rest argument before last parameter", left)
        return destructure1(left[(k + 1)], {subexpr}, left)
      end
      local function destructure_table(left, rightexprs, top_3f, destructure1)
        local s = gensym(scope, symtype0)
        local right
        do
          local _384_
          if top_3f then
            _384_ = exprs1(compile1(from, scope, parent))
          else
            _384_ = exprs1(rightexprs)
          end
          if (_384_ == "") then
            right = "nil"
          elseif (nil ~= _384_) then
            local right0 = _384_
            right = right0
          else
            right = nil
          end
        end
        local excluded_keys = {}
        emit(parent, string.format("local %s = %s", s, right), left)
        for k, v in utils.stablepairs(left) do
          if not (("number" == type(k)) and tostring(left[(k - 1)]):find("^&")) then
            if (utils["sym?"](k) and (tostring(k) == "&")) then
              destructure_kv_rest(s, v, left, excluded_keys, destructure1)
            elseif (utils["sym?"](v) and (tostring(v) == "&")) then
              destructure_rest(s, k, left, destructure1)
            elseif (utils["sym?"](k) and (tostring(k) == "&as")) then
              destructure_sym(v, {utils.expr(tostring(s))}, left)
            elseif (utils["sequence?"](left) and (tostring(v) == "&as")) then
              local _, next_sym, trailing = select(k, unpack(left))
              assert_compile((nil == trailing), "expected &as argument before last parameter", left)
              destructure_sym(next_sym, {utils.expr(tostring(s))}, left)
            else
              local key
              if (type(k) == "string") then
                key = serialize_string(k)
              else
                key = k
              end
              local subexpr = utils.expr(string.format("%s[%s]", s, key), "expression")
              if (type(k) == "string") then
                table.insert(excluded_keys, k)
              else
              end
              destructure1(v, {subexpr}, left)
            end
          else
          end
        end
        return nil
      end
      local function destructure_values(left, up1, top_3f, destructure1)
        local left_names, tables = {}, {}
        for i, name in ipairs(left) do
          if utils["sym?"](name) then
            table.insert(left_names, getname(name, up1))
          else
            local symname = gensym(scope, symtype0)
            table.insert(left_names, symname)
            do end (tables)[i] = {name, utils.expr(symname, "sym")}
          end
        end
        assert_compile(left[1], "must provide at least one value", left)
        assert_compile(top_3f, "can't nest multi-value destructuring", left)
        compile_top_target(left_names)
        if declaration then
          for _, sym in ipairs(left) do
            if utils["sym?"](sym) then
              scope.symmeta[tostring(sym)] = {var = isvar}
            else
            end
          end
        else
        end
        for _, pair in utils.stablepairs(tables) do
          destructure1(pair[1], {pair[2]}, left)
        end
        return nil
      end
      local function destructure1(left, rightexprs, up1, top_3f)
        if (utils["sym?"](left) and (left[1] ~= "nil")) then
          destructure_sym(left, rightexprs, up1, top_3f)
        elseif utils["table?"](left) then
          destructure_table(left, rightexprs, top_3f, destructure1)
        elseif utils["list?"](left) then
          destructure_values(left, up1, top_3f, destructure1)
        else
          assert_compile(false, string.format("unable to bind %s %s", type(left), tostring(left)), (((type((up1)[2]) == "table") and (up1)[2]) or up1))
        end
        if top_3f then
          return {returned = true}
        else
          return nil
        end
      end
      local ret = destructure1(to, nil, ast, true)
      utils.hook("destructure", from, to, scope, opts0)
      apply_manglings(scope, new_manglings, ast)
      return ret
    end
    local function require_include(ast, scope, parent, opts)
      opts.fallback = function(e, no_warn)
        if (not no_warn and ("literal" == e.type)) then
          utils.warn(("include module not found, falling back to require: %s"):format(tostring(e)))
        else
        end
        return utils.expr(string.format("require(%s)", tostring(e)), "statement")
      end
      return scopes.global.specials.include(ast, scope, parent, opts)
    end
    local function compile_stream(strm, options)
      local opts = utils.copy(options)
      local old_globals = allowed_globals
      local scope = (opts.scope or make_scope(scopes.global))
      local vals = {}
      local chunk = {}
      do end (function(tgt, m, ...) return tgt[m](tgt, ...) end)(utils.root, "set-reset")
      allowed_globals = opts.allowedGlobals
      if (opts.indent == nil) then
        opts.indent = "  "
      else
      end
      if opts.requireAsInclude then
        scope.specials.require = require_include
      else
      end
      utils.root.chunk, utils.root.scope, utils.root.options = chunk, scope, opts
      for _, val in parser.parser(strm, opts.filename, opts) do
        table.insert(vals, val)
      end
      for i = 1, #vals do
        local exprs = compile1(vals[i], scope, chunk, {nval = (((i < #vals) and 0) or nil), tail = (i == #vals)})
        keep_side_effects(exprs, chunk, nil, vals[i])
        if (i == #vals) then
          utils.hook("chunk", vals[i], scope)
        else
        end
      end
      allowed_globals = old_globals
      utils.root.reset()
      return flatten(chunk, opts)
    end
    local function compile_string(str, _3fopts)
      local opts = (_3fopts or {})
      return compile_stream(parser["string-stream"](str, opts), opts)
    end
    local function compile(ast, opts)
      local opts0 = utils.copy(opts)
      local old_globals = allowed_globals
      local chunk = {}
      local scope = (opts0.scope or make_scope(scopes.global))
      do end (function(tgt, m, ...) return tgt[m](tgt, ...) end)(utils.root, "set-reset")
      allowed_globals = opts0.allowedGlobals
      if (opts0.indent == nil) then
        opts0.indent = "  "
      else
      end
      if opts0.requireAsInclude then
        scope.specials.require = require_include
      else
      end
      utils.root.chunk, utils.root.scope, utils.root.options = chunk, scope, opts0
      local exprs = compile1(ast, scope, chunk, {tail = true})
      keep_side_effects(exprs, chunk, nil, ast)
      utils.hook("chunk", ast, scope)
      allowed_globals = old_globals
      utils.root.reset()
      return flatten(chunk, opts0)
    end
    local function traceback_frame(info)
      if ((info.what == "C") and info.name) then
        return string.format("  [C]: in function '%s'", info.name)
      elseif (info.what == "C") then
        return "  [C]: in ?"
      else
        local remap = sourcemap[info.source]
        if (remap and remap[info.currentline]) then
          if ((remap[info.currentline][1] or "unknown") ~= "unknown") then
            info.short_src = sourcemap[("@" .. remap[info.currentline][1])].short_src
          else
            info.short_src = remap.short_src
          end
          info.currentline = (remap[info.currentline][2] or -1)
        else
        end
        if (info.what == "Lua") then
          local function _404_()
            if info.name then
              return ("'" .. info.name .. "'")
            else
              return "?"
            end
          end
          return string.format("  %s:%d: in function %s", info.short_src, info.currentline, _404_())
        elseif (info.short_src == "(tail call)") then
          return "  (tail call)"
        else
          return string.format("  %s:%d: in main chunk", info.short_src, info.currentline)
        end
      end
    end
    local function traceback(_3fmsg, _3fstart)
      local msg = tostring((_3fmsg or ""))
      if ((msg:find("^%g+:%d+:%d+ Compile error:.*") or msg:find("^%g+:%d+:%d+ Parse error:.*")) and not utils["debug-on?"]("trace")) then
        return msg
      else
        local lines = {}
        if (msg:find("^%g+:%d+:%d+ Compile error:") or msg:find("^%g+:%d+:%d+ Parse error:")) then
          table.insert(lines, msg)
        else
          local newmsg = msg:gsub("^[^:]*:%d+:%s+", "runtime error: ")
          table.insert(lines, newmsg)
        end
        table.insert(lines, "stack traceback:")
        local done_3f, level = false, (_3fstart or 2)
        while not done_3f do
          do
            local _408_ = debug.getinfo(level, "Sln")
            if (_408_ == nil) then
              done_3f = true
            elseif (nil ~= _408_) then
              local info = _408_
              table.insert(lines, traceback_frame(info))
            else
            end
          end
          level = (level + 1)
        end
        return table.concat(lines, "\n")
      end
    end
    local function entry_transform(fk, fv)
      local function _411_(k, v)
        if (type(k) == "number") then
          return k, fv(v)
        else
          return fk(k), fv(v)
        end
      end
      return _411_
    end
    local function mixed_concat(t, joiner)
      local seen = {}
      local ret, s = "", ""
      for k, v in ipairs(t) do
        table.insert(seen, k)
        ret = (ret .. s .. v)
        s = joiner
      end
      for k, v in utils.stablepairs(t) do
        if not seen[k] then
          ret = (ret .. s .. "[" .. k .. "]" .. "=" .. v)
          s = joiner
        else
        end
      end
      return ret
    end
    local function do_quote(form, scope, parent, runtime_3f)
      local function q(x)
        return do_quote(x, scope, parent, runtime_3f)
      end
      if utils["varg?"](form) then
        assert_compile(not runtime_3f, "quoted ... may only be used at compile time", form)
        return "_VARARG"
      elseif utils["sym?"](form) then
        local filename
        if form.filename then
          filename = string.format("%q", form.filename)
        else
          filename = "nil"
        end
        local symstr = tostring(form)
        assert_compile(not runtime_3f, "symbols may only be used at compile time", form)
        if (symstr:find("#$") or symstr:find("#[:.]")) then
          return string.format("sym('%s', {filename=%s, line=%s})", autogensym(symstr, scope), filename, (form.line or "nil"))
        else
          return string.format("sym('%s', {quoted=true, filename=%s, line=%s})", symstr, filename, (form.line or "nil"))
        end
      elseif (utils["list?"](form) and utils["sym?"](form[1]) and (tostring(form[1]) == "unquote")) then
        local payload = form[2]
        local res = unpack(compile1(payload, scope, parent))
        return res[1]
      elseif utils["list?"](form) then
        local mapped
        local function _416_()
          return nil
        end
        mapped = utils.kvmap(form, entry_transform(_416_, q))
        local filename
        if form.filename then
          filename = string.format("%q", form.filename)
        else
          filename = "nil"
        end
        assert_compile(not runtime_3f, "lists may only be used at compile time", form)
        return string.format(("setmetatable({filename=%s, line=%s, bytestart=%s, %s}" .. ", getmetatable(list()))"), filename, (form.line or "nil"), (form.bytestart or "nil"), mixed_concat(mapped, ", "))
      elseif utils["sequence?"](form) then
        local mapped = utils.kvmap(form, entry_transform(q, q))
        local source = getmetatable(form)
        local filename
        if source.filename then
          filename = string.format("%q", source.filename)
        else
          filename = "nil"
        end
        local _419_
        if source then
          _419_ = source.line
        else
          _419_ = "nil"
        end
        return string.format("setmetatable({%s}, {filename=%s, line=%s, sequence=%s})", mixed_concat(mapped, ", "), filename, _419_, "(getmetatable(sequence()))['sequence']")
      elseif (type(form) == "table") then
        local mapped = utils.kvmap(form, entry_transform(q, q))
        local source = getmetatable(form)
        local filename
        if source.filename then
          filename = string.format("%q", source.filename)
        else
          filename = "nil"
        end
        local function _422_()
          if source then
            return source.line
          else
            return "nil"
          end
        end
        return string.format("setmetatable({%s}, {filename=%s, line=%s})", mixed_concat(mapped, ", "), filename, _422_())
      elseif (type(form) == "string") then
        return serialize_string(form)
      else
        return tostring(form)
      end
    end
    return {compile = compile, compile1 = compile1, ["compile-stream"] = compile_stream, ["compile-string"] = compile_string, ["check-binding-valid"] = check_binding_valid, emit = emit, destructure = destructure, ["require-include"] = require_include, autogensym = autogensym, gensym = gensym, ["do-quote"] = do_quote, ["global-mangling"] = global_mangling, ["global-unmangling"] = global_unmangling, ["apply-manglings"] = apply_manglings, macroexpand = macroexpand_2a, ["declare-local"] = declare_local, ["make-scope"] = make_scope, ["keep-side-effects"] = keep_side_effects, ["symbol-to-expression"] = symbol_to_expression, assert = assert_compile, scopes = scopes, traceback = traceback, metadata = make_metadata(), sourcemap = sourcemap}
  end
  package.preload["fennel.friend"] = package.preload["fennel.friend"] or function(...)
    local utils = require("fennel.utils")
    local utf8_ok_3f, utf8 = pcall(require, "utf8")
    local suggestions = {["unexpected multi symbol (.*)"] = {"removing periods or colons from %s"}, ["use of global (.*) is aliased by a local"] = {"renaming local %s", "refer to the global using _G.%s instead of directly"}, ["local (.*) was overshadowed by a special form or macro"] = {"renaming local %s"}, ["global (.*) conflicts with local"] = {"renaming local %s"}, ["expected var (.*)"] = {"declaring %s using var instead of let/local", "introducing a new local instead of changing the value of %s"}, ["expected macros to be table"] = {"ensuring your macro definitions return a table"}, ["expected each macro to be function"] = {"ensuring that the value for each key in your macros table contains a function", "avoid defining nested macro tables"}, ["macro not found in macro module"] = {"checking the keys of the imported macro module's returned table"}, ["macro tried to bind (.*) without gensym"] = {"changing to %s# when introducing identifiers inside macros"}, ["unknown identifier: (.*)"] = {"looking to see if there's a typo", "using the _G table instead, eg. _G.%s if you really want a global", "moving this code to somewhere that %s is in scope", "binding %s as a local in the scope of this code"}, ["expected a function.* to call"] = {"removing the empty parentheses", "using square brackets if you want an empty table"}, ["cannot call literal value"] = {"checking for typos", "checking for a missing function name", "making sure to use prefix operators, not infix"}, ["unexpected vararg"] = {"putting \"...\" at the end of the fn parameters if the vararg was intended"}, ["multisym method calls may only be in call position"] = {"using a period instead of a colon to reference a table's fields", "putting parens around this"}, ["unused local (.*)"] = {"renaming the local to _%s if it is meant to be unused", "fixing a typo so %s is used", "disabling the linter which checks for unused locals"}, ["expected parameters"] = {"adding function parameters as a list of identifiers in brackets"}, ["unable to bind (.*)"] = {"replacing the %s with an identifier"}, ["expected rest argument before last parameter"] = {"moving & to right before the final identifier when destructuring"}, ["expected vararg as last parameter"] = {"moving the \"...\" to the end of the parameter list"}, ["expected symbol for function parameter: (.*)"] = {"changing %s to an identifier instead of a literal value"}, ["could not compile value of type "] = {"debugging the macro you're calling to return a list or table"}, ["expected local"] = {"looking for a typo", "looking for a local which is used out of its scope"}, ["expected body expression"] = {"putting some code in the body of this form after the bindings"}, ["expected binding and iterator"] = {"making sure you haven't omitted a local name or iterator"}, ["expected binding sequence"] = {"placing a table here in square brackets containing identifiers to bind"}, ["expected even number of name/value bindings"] = {"finding where the identifier or value is missing"}, ["may only be used at compile time"] = {"moving this to inside a macro if you need to manipulate symbols/lists", "using square brackets instead of parens to construct a table"}, ["unexpected closing delimiter (.)"] = {"deleting %s", "adding matching opening delimiter earlier"}, ["mismatched closing delimiter (.), expected (.)"] = {"replacing %s with %s", "deleting %s", "adding matching opening delimiter earlier"}, ["expected even number of values in table literal"] = {"removing a key", "adding a value"}, ["expected whitespace before opening delimiter"] = {"adding whitespace"}, ["invalid character: (.)"] = {"deleting or replacing %s", "avoiding reserved characters like \", \\, ', ~, ;, @, `, and comma"}, ["could not read number (.*)"] = {"removing the non-digit character", "beginning the identifier with a non-digit if it is not meant to be a number"}, ["can't start multisym segment with a digit"] = {"removing the digit", "adding a non-digit before the digit"}, ["malformed multisym"] = {"ensuring each period or colon is not followed by another period or colon"}, ["method must be last component"] = {"using a period instead of a colon for field access", "removing segments after the colon", "making the method call, then looking up the field on the result"}, ["$ and $... in hashfn are mutually exclusive"] = {"modifying the hashfn so it only contains $... or $, $1, $2, $3, etc"}, ["tried to reference a macro without calling it"] = {"renaming the macro so as not to conflict with locals"}, ["tried to reference a special form without calling it"] = {"making sure to use prefix operators, not infix", "wrapping the special in a function if you need it to be first class"}, ["missing subject"] = {"adding an item to operate on"}, ["expected even number of pattern/body pairs"] = {"checking that every pattern has a body to go with it", "adding _ before the final body"}, ["expected at least one pattern/body pair"] = {"adding a pattern and a body to execute when the pattern matches"}, ["unexpected arguments"] = {"removing an argument", "checking for typos"}, ["unexpected iterator clause"] = {"removing an argument", "checking for typos"}}
    local unpack = (table.unpack or _G.unpack)
    local function suggest(msg)
      local s = nil
      for pat, sug in pairs(suggestions) do
        if s then break end
        local matches = {msg:match(pat)}
        if (0 < #matches) then
          local tbl_16_auto = {}
          local i_17_auto = #tbl_16_auto
          for _, s0 in ipairs(sug) do
            local val_18_auto = s0:format(unpack(matches))
            if (nil ~= val_18_auto) then
              i_17_auto = (i_17_auto + 1)
              do end (tbl_16_auto)[i_17_auto] = val_18_auto
            else
            end
          end
          s = tbl_16_auto
        else
          s = nil
        end
      end
      return s
    end
    local function read_line(filename, line, _3fsource)
      if _3fsource then
        local matcher = string.gmatch((_3fsource .. "\n"), "(.-)(\13?\n)")
        for _ = 2, line do
          matcher()
        end
        return matcher()
      else
        local f = assert(io.open(filename))
        local function close_handlers_8_auto(ok_9_auto, ...)
          f:close()
          if ok_9_auto then
            return ...
          else
            return error(..., 0)
          end
        end
        local function _185_()
          for _ = 2, line do
            f:read()
          end
          return f:read()
        end
        return close_handlers_8_auto(_G.xpcall(_185_, (package.loaded.fennel or debug).traceback))
      end
    end
    local function sub(str, start, _end)
      if ((_end < start) or (#str < start) or (#str < _end)) then
        return ""
      elseif utf8_ok_3f then
        return string.sub(str, utf8.offset(str, start), ((utf8.offset(str, (_end + 1)) or (utf8.len(str) + 1)) - 1))
      else
        return string.sub(str, start, math.min(_end, str:len()))
      end
    end
    local function highlight_line(codeline, col, _3fendcol, opts)
      if ((opts and (false == opts["error-pinpoint"])) or (os and os.getenv and os.getenv("NO_COLOR"))) then
        return codeline
      else
        local _let_188_ = (opts or {})
        local error_pinpoint = _let_188_["error-pinpoint"]
        local endcol = (_3fendcol or col)
        local eol
        if utf8_ok_3f then
          eol = utf8.len(codeline)
        else
          eol = string.len(codeline)
        end
        local _let_190_ = (error_pinpoint or {"\27[7m", "\27[0m"})
        local open = _let_190_[1]
        local close = _let_190_[2]
        return (sub(codeline, 1, col) .. open .. sub(codeline, (col + 1), (endcol + 1)) .. close .. sub(codeline, (endcol + 2), eol))
      end
    end
    local function friendly_msg(msg, _192_, source, opts)
      local _arg_193_ = _192_
      local filename = _arg_193_["filename"]
      local line = _arg_193_["line"]
      local col = _arg_193_["col"]
      local endcol = _arg_193_["endcol"]
      local ok, codeline = pcall(read_line, filename, line, source)
      local out = {msg, ""}
      if (ok and codeline) then
        if col then
          table.insert(out, highlight_line(codeline, col, endcol, opts))
        else
          table.insert(out, codeline)
        end
      else
      end
      for _, suggestion in ipairs((suggest(msg) or {})) do
        table.insert(out, ("* Try %s."):format(suggestion))
      end
      return table.concat(out, "\n")
    end
    local function assert_compile(condition, msg, ast, source, opts)
      if not condition then
        local _let_196_ = utils["ast-source"](ast)
        local filename = _let_196_["filename"]
        local line = _let_196_["line"]
        local col = _let_196_["col"]
        error(friendly_msg(("%s:%s:%s Compile error: %s"):format((filename or "unknown"), (line or "?"), (col or "?"), msg), utils["ast-source"](ast), source, opts), 0)
      else
      end
      return condition
    end
    local function parse_error(msg, filename, line, col, source, opts)
      return error(friendly_msg(("%s:%s:%s Parse error: %s"):format(filename, line, col, msg), {filename = filename, line = line, col = col}, source, opts), 0)
    end
    return {["assert-compile"] = assert_compile, ["parse-error"] = parse_error}
  end
  package.preload["fennel.parser"] = package.preload["fennel.parser"] or function(...)
    local utils = require("fennel.utils")
    local friend = require("fennel.friend")
    local unpack = (table.unpack or _G.unpack)
    local function granulate(getchunk)
      local c, index, done_3f = "", 1, false
      local function _198_(parser_state)
        if not done_3f then
          if (index <= #c) then
            local b = c:byte(index)
            index = (index + 1)
            return b
          else
            local _199_ = getchunk(parser_state)
            local function _200_()
              local char = _199_
              return (char ~= "")
            end
            if ((nil ~= _199_) and _200_()) then
              local char = _199_
              c = char
              index = 2
              return c:byte()
            elseif true then
              local _ = _199_
              done_3f = true
              return nil
            else
              return nil
            end
          end
        else
          return nil
        end
      end
      local function _204_()
        c = ""
        return nil
      end
      return _198_, _204_
    end
    local function string_stream(str, _3foptions)
      local str0 = str:gsub("^#!", ";;")
      if _3foptions then
        _3foptions.source = str0
      else
      end
      local index = 1
      local function _206_()
        local r = str0:byte(index)
        index = (index + 1)
        return r
      end
      return _206_
    end
    local delims = {[40] = 41, [41] = true, [91] = 93, [93] = true, [123] = 125, [125] = true}
    local function sym_char_3f(b)
      local b0
      if ("number" == type(b)) then
        b0 = b
      else
        b0 = string.byte(b)
      end
      return ((32 < b0) and not delims[b0] and (b0 ~= 127) and (b0 ~= 34) and (b0 ~= 39) and (b0 ~= 126) and (b0 ~= 59) and (b0 ~= 44) and (b0 ~= 64) and (b0 ~= 96))
    end
    local prefixes = {[35] = "hashfn", [39] = "quote", [44] = "unquote", [96] = "quote"}
    local function char_starter_3f(b)
      return ((function(_208_,_209_,_210_) return (_208_ < _209_) and (_209_ < _210_) end)(1,b,127) or (function(_211_,_212_,_213_) return (_211_ < _212_) and (_212_ < _213_) end)(192,b,247))
    end
    local function parser_fn(getbyte, filename, _214_)
      local _arg_215_ = _214_
      local source = _arg_215_["source"]
      local unfriendly = _arg_215_["unfriendly"]
      local comments = _arg_215_["comments"]
      local options = _arg_215_
      local stack = {}
      local line, byteindex, col, prev_col, lastb = 1, 0, 0, 0, nil
      local function ungetb(ub)
        if char_starter_3f(ub) then
          col = (col - 1)
        else
        end
        if (ub == 10) then
          line, col = (line - 1), prev_col
        else
        end
        byteindex = (byteindex - 1)
        lastb = ub
        return nil
      end
      local function getb()
        local r = nil
        if lastb then
          r, lastb = lastb, nil
        else
          r = getbyte({["stack-size"] = #stack})
        end
        byteindex = (byteindex + 1)
        if (r and char_starter_3f(r)) then
          col = (col + 1)
        else
        end
        if (r == 10) then
          line, col, prev_col = (line + 1), 0, col
        else
        end
        return r
      end
      local function whitespace_3f(b)
        local function _225_()
          local t_224_ = options.whitespace
          if (nil ~= t_224_) then
            t_224_ = (t_224_)[b]
          else
          end
          return t_224_
        end
        return ((b == 32) or (function(_221_,_222_,_223_) return (_221_ <= _222_) and (_222_ <= _223_) end)(9,b,13) or _225_())
      end
      local function parse_error(msg, _3fcol_adjust)
        local col0 = (col + (_3fcol_adjust or -1))
        if (nil == utils["hook-opts"]("parse-error", options, msg, filename, (line or "?"), col0, source, utils.root.reset)) then
          utils.root.reset()
          if (unfriendly or not _G.io or not _G.io.read) then
            return error(string.format("%s:%s:%s Parse error: %s", filename, (line or "?"), col0, msg), 0)
          else
            return friend["parse-error"](msg, filename, (line or "?"), col0, source, options)
          end
        else
          return nil
        end
      end
      local function parse_stream()
        local whitespace_since_dispatch, done_3f, retval = true
        local function set_source_fields(source0)
          source0.byteend, source0.endcol = byteindex, (col - 1)
          return nil
        end
        local function dispatch(v)
          local _229_ = stack[#stack]
          if (_229_ == nil) then
            retval, done_3f, whitespace_since_dispatch = v, true, false
            return nil
          elseif ((_G.type(_229_) == "table") and (nil ~= (_229_).prefix)) then
            local prefix = (_229_).prefix
            local source0
            do
              local _230_ = table.remove(stack)
              set_source_fields(_230_)
              source0 = _230_
            end
            local list = utils.list(utils.sym(prefix, source0), v)
            for k, v0 in pairs(source0) do
              list[k] = v0
            end
            return dispatch(list)
          elseif (nil ~= _229_) then
            local top = _229_
            whitespace_since_dispatch = false
            return table.insert(top, v)
          else
            return nil
          end
        end
        local function badend()
          local accum = utils.map(stack, "closer")
          local _232_
          if (#stack == 1) then
            _232_ = ""
          else
            _232_ = "s"
          end
          return parse_error(string.format("expected closing delimiter%s %s", _232_, string.char(unpack(accum))))
        end
        local function skip_whitespace(b)
          if (b and whitespace_3f(b)) then
            whitespace_since_dispatch = true
            return skip_whitespace(getb())
          elseif (not b and (0 < #stack)) then
            return badend()
          else
            return b
          end
        end
        local function parse_comment(b, contents)
          if (b and (10 ~= b)) then
            local function _236_()
              local _235_ = contents
              table.insert(_235_, string.char(b))
              return _235_
            end
            return parse_comment(getb(), _236_())
          elseif comments then
            ungetb(10)
            return dispatch(utils.comment(table.concat(contents), {line = line, filename = filename}))
          else
            return nil
          end
        end
        local function open_table(b)
          if not whitespace_since_dispatch then
            parse_error(("expected whitespace before opening delimiter " .. string.char(b)))
          else
          end
          return table.insert(stack, {bytestart = byteindex, closer = delims[b], filename = filename, line = line, col = (col - 1)})
        end
        local function close_list(list)
          return dispatch(setmetatable(list, getmetatable(utils.list())))
        end
        local function close_sequence(tbl)
          local val = utils.sequence(unpack(tbl))
          for k, v in pairs(tbl) do
            getmetatable(val)[k] = v
          end
          return dispatch(val)
        end
        local function add_comment_at(comments0, index, node)
          local _239_ = (comments0)[index]
          if (nil ~= _239_) then
            local existing = _239_
            return table.insert(existing, node)
          elseif true then
            local _ = _239_
            comments0[index] = {node}
            return nil
          else
            return nil
          end
        end
        local function next_noncomment(tbl, i)
          if utils["comment?"](tbl[i]) then
            return next_noncomment(tbl, (i + 1))
          elseif (utils.sym(":") == tbl[i]) then
            return tostring(tbl[(i + 1)])
          else
            return tbl[i]
          end
        end
        local function extract_comments(tbl)
          local comments0 = {keys = {}, values = {}, last = {}}
          while utils["comment?"](tbl[#tbl]) do
            table.insert(comments0.last, 1, table.remove(tbl))
          end
          local last_key_3f = false
          for i, node in ipairs(tbl) do
            if not utils["comment?"](node) then
              last_key_3f = not last_key_3f
            elseif last_key_3f then
              add_comment_at(comments0.values, next_noncomment(tbl, i), node)
            else
              add_comment_at(comments0.keys, next_noncomment(tbl, i), node)
            end
          end
          for i = #tbl, 1, -1 do
            if utils["comment?"](tbl[i]) then
              table.remove(tbl, i)
            else
            end
          end
          return comments0
        end
        local function close_curly_table(tbl)
          local comments0 = extract_comments(tbl)
          local keys = {}
          local val = {}
          if ((#tbl % 2) ~= 0) then
            byteindex = (byteindex - 1)
            parse_error("expected even number of values in table literal")
          else
          end
          setmetatable(val, tbl)
          for i = 1, #tbl, 2 do
            if ((tostring(tbl[i]) == ":") and utils["sym?"](tbl[(i + 1)]) and utils["sym?"](tbl[i])) then
              tbl[i] = tostring(tbl[(i + 1)])
            else
            end
            val[tbl[i]] = tbl[(i + 1)]
            table.insert(keys, tbl[i])
          end
          tbl.comments = comments0
          tbl.keys = keys
          return dispatch(val)
        end
        local function close_table(b)
          local top = table.remove(stack)
          if (top == nil) then
            parse_error(("unexpected closing delimiter " .. string.char(b)))
          else
          end
          if (top.closer and (top.closer ~= b)) then
            parse_error(("mismatched closing delimiter " .. string.char(b) .. ", expected " .. string.char(top.closer)))
          else
          end
          set_source_fields(top)
          if (b == 41) then
            return close_list(top)
          elseif (b == 93) then
            return close_sequence(top)
          else
            return close_curly_table(top)
          end
        end
        local function parse_string_loop(chars, b, state)
          table.insert(chars, b)
          local state0
          do
            local _249_ = {state, b}
            if ((_G.type(_249_) == "table") and ((_249_)[1] == "base") and ((_249_)[2] == 92)) then
              state0 = "backslash"
            elseif ((_G.type(_249_) == "table") and ((_249_)[1] == "base") and ((_249_)[2] == 34)) then
              state0 = "done"
            elseif ((_G.type(_249_) == "table") and ((_249_)[1] == "backslash") and ((_249_)[2] == 10)) then
              table.remove(chars, (#chars - 1))
              state0 = "base"
            elseif true then
              local _ = _249_
              state0 = "base"
            else
              state0 = nil
            end
          end
          if (b and (state0 ~= "done")) then
            return parse_string_loop(chars, getb(), state0)
          else
            return b
          end
        end
        local function escape_char(c)
          return ({[7] = "\\a", [8] = "\\b", [9] = "\\t", [10] = "\\n", [11] = "\\v", [12] = "\\f", [13] = "\\r"})[c:byte()]
        end
        local function parse_string()
          table.insert(stack, {closer = 34})
          local chars = {34}
          if not parse_string_loop(chars, getb(), "base") then
            badend()
          else
          end
          table.remove(stack)
          local raw = string.char(unpack(chars))
          local formatted = raw:gsub("[\7-\13]", escape_char)
          local _253_ = (rawget(_G, "loadstring") or load)(("return " .. formatted))
          if (nil ~= _253_) then
            local load_fn = _253_
            return dispatch(load_fn())
          elseif (_253_ == nil) then
            return parse_error(("Invalid string: " .. raw))
          else
            return nil
          end
        end
        local function parse_prefix(b)
          table.insert(stack, {prefix = prefixes[b], filename = filename, line = line, bytestart = byteindex, col = (col - 1)})
          local nextb = getb()
          if (whitespace_3f(nextb) or (true == delims[nextb])) then
            if (b ~= 35) then
              parse_error("invalid whitespace after quoting prefix")
            else
            end
            table.remove(stack)
            dispatch(utils.sym("#"))
          else
          end
          return ungetb(nextb)
        end
        local function parse_sym_loop(chars, b)
          if (b and sym_char_3f(b)) then
            table.insert(chars, b)
            return parse_sym_loop(chars, getb())
          else
            if b then
              ungetb(b)
            else
            end
            return chars
          end
        end
        local function parse_number(rawstr)
          local number_with_stripped_underscores = (not rawstr:find("^_") and rawstr:gsub("_", ""))
          if rawstr:match("^%d") then
            dispatch((tonumber(number_with_stripped_underscores) or parse_error(("could not read number \"" .. rawstr .. "\""))))
            return true
          else
            local _259_ = tonumber(number_with_stripped_underscores)
            if (nil ~= _259_) then
              local x = _259_
              dispatch(x)
              return true
            elseif true then
              local _ = _259_
              return false
            else
              return nil
            end
          end
        end
        local function check_malformed_sym(rawstr)
          local function col_adjust(pat)
            return (rawstr:find(pat) - utils.len(rawstr) - 1)
          end
          if (rawstr:match("^~") and (rawstr ~= "~=")) then
            return parse_error("invalid character: ~")
          elseif rawstr:match("%.[0-9]") then
            return parse_error(("can't start multisym segment with a digit: " .. rawstr), col_adjust("%.[0-9]"))
          elseif (rawstr:match("[%.:][%.:]") and (rawstr ~= "..") and (rawstr ~= "$...")) then
            return parse_error(("malformed multisym: " .. rawstr), col_adjust("[%.:][%.:]"))
          elseif ((rawstr ~= ":") and rawstr:match(":$")) then
            return parse_error(("malformed multisym: " .. rawstr), col_adjust(":$"))
          elseif rawstr:match(":.+[%.:]") then
            return parse_error(("method must be last component of multisym: " .. rawstr), col_adjust(":.+[%.:]"))
          else
            return rawstr
          end
        end
        local function parse_sym(b)
          local source0 = {bytestart = byteindex, filename = filename, line = line, col = (col - 1)}
          local rawstr = string.char(unpack(parse_sym_loop({b}, getb())))
          set_source_fields(source0)
          if (rawstr == "true") then
            return dispatch(true)
          elseif (rawstr == "false") then
            return dispatch(false)
          elseif (rawstr == "...") then
            return dispatch(utils.varg(source0))
          elseif rawstr:match("^:.+$") then
            return dispatch(rawstr:sub(2))
          elseif not parse_number(rawstr) then
            return dispatch(utils.sym(check_malformed_sym(rawstr), source0))
          else
            return nil
          end
        end
        local function parse_loop(b)
          if not b then
          elseif (b == 59) then
            parse_comment(getb(), {";"})
          elseif (type(delims[b]) == "number") then
            open_table(b)
          elseif delims[b] then
            close_table(b)
          elseif (b == 34) then
            parse_string(b)
          elseif prefixes[b] then
            parse_prefix(b)
          elseif (sym_char_3f(b) or (b == string.byte("~"))) then
            parse_sym(b)
          elseif not utils["hook-opts"]("illegal-char", options, b, getb, ungetb, dispatch) then
            parse_error(("invalid character: " .. string.char(b)))
          else
          end
          if not b then
            return nil
          elseif done_3f then
            return true, retval
          else
            return parse_loop(skip_whitespace(getb()))
          end
        end
        return parse_loop(skip_whitespace(getb()))
      end
      local function _266_()
        stack, line, byteindex, col, lastb = {}, 1, 0, 0, nil
        return nil
      end
      return parse_stream, _266_
    end
    local function parser(stream_or_string, _3ffilename, _3foptions)
      local filename = (_3ffilename or "unknown")
      local options = (_3foptions or utils.root.options or {})
      assert(("string" == type(filename)), "expected filename as second argument to parser")
      if ("string" == type(stream_or_string)) then
        return parser_fn(string_stream(stream_or_string, options), filename, options)
      else
        return parser_fn(stream_or_string, filename, options)
      end
    end
    return {granulate = granulate, parser = parser, ["string-stream"] = string_stream, ["sym-char?"] = sym_char_3f}
  end
  local utils
  package.preload["fennel.view"] = package.preload["fennel.view"] or function(...)
    local type_order = {number = 1, boolean = 2, string = 3, table = 4, ["function"] = 5, userdata = 6, thread = 7}
    local default_opts = {["one-line?"] = false, ["detect-cycles?"] = true, ["empty-as-sequence?"] = false, ["metamethod?"] = true, ["prefer-colon?"] = false, ["escape-newlines?"] = false, ["utf8?"] = true, ["line-length"] = 80, depth = 128, ["max-sparse-gap"] = 10}
    local lua_pairs = pairs
    local lua_ipairs = ipairs
    local function pairs(t)
      local _1_ = getmetatable(t)
      if ((_G.type(_1_) == "table") and (nil ~= (_1_).__pairs)) then
        local p = (_1_).__pairs
        return p(t)
      elseif true then
        local _ = _1_
        return lua_pairs(t)
      else
        return nil
      end
    end
    local function ipairs(t)
      local _3_ = getmetatable(t)
      if ((_G.type(_3_) == "table") and (nil ~= (_3_).__ipairs)) then
        local i = (_3_).__ipairs
        return i(t)
      elseif true then
        local _ = _3_
        return lua_ipairs(t)
      else
        return nil
      end
    end
    local function length_2a(t)
      local _5_ = getmetatable(t)
      if ((_G.type(_5_) == "table") and (nil ~= (_5_).__len)) then
        local l = (_5_).__len
        return l(t)
      elseif true then
        local _ = _5_
        return #t
      else
        return nil
      end
    end
    local function get_default(key)
      local _7_ = default_opts[key]
      if (_7_ == nil) then
        return error(("option '%s' doesn't have a default value, use the :after key to set it"):format(tostring(key)))
      elseif (nil ~= _7_) then
        local v = _7_
        return v
      else
        return nil
      end
    end
    local function getopt(options, key)
      local val = options[key]
      local _9_ = val
      if ((_G.type(_9_) == "table") and (nil ~= (_9_).once)) then
        local val_2a = (_9_).once
        return val_2a
      elseif true then
        local _ = _9_
        return val
      else
        return nil
      end
    end
    local function normalize_opts(options)
      local tbl_13_auto = {}
      for k, v in pairs(options) do
        local k_14_auto, v_15_auto = nil, nil
        local function _12_()
          local _11_ = v
          if ((_G.type(_11_) == "table") and (nil ~= (_11_).after)) then
            local val = (_11_).after
            return val
          else
            local function _13_()
              return v.once
            end
            if ((_G.type(_11_) == "table") and _13_()) then
              return get_default(k)
            elseif true then
              local _ = _11_
              return v
            else
              return nil
            end
          end
        end
        k_14_auto, v_15_auto = k, _12_()
        if ((k_14_auto ~= nil) and (v_15_auto ~= nil)) then
          tbl_13_auto[k_14_auto] = v_15_auto
        else
        end
      end
      return tbl_13_auto
    end
    local function sort_keys(_16_, _18_)
      local _arg_17_ = _16_
      local a = _arg_17_[1]
      local _arg_19_ = _18_
      local b = _arg_19_[1]
      local ta = type(a)
      local tb = type(b)
      if ((ta == tb) and ((ta == "string") or (ta == "number"))) then
        return (a < b)
      else
        local dta = type_order[ta]
        local dtb = type_order[tb]
        if (dta and dtb) then
          return (dta < dtb)
        elseif dta then
          return true
        elseif dtb then
          return false
        else
          return (ta < tb)
        end
      end
    end
    local function max_index_gap(kv)
      local gap = 0
      if (0 < length_2a(kv)) then
        local i = 0
        for _, _22_ in ipairs(kv) do
          local _each_23_ = _22_
          local k = _each_23_[1]
          if (gap < (k - i)) then
            gap = (k - i)
          else
          end
          i = k
        end
      else
      end
      return gap
    end
    local function fill_gaps(kv)
      local missing_indexes = {}
      local i = 0
      for _, _26_ in ipairs(kv) do
        local _each_27_ = _26_
        local j = _each_27_[1]
        i = (i + 1)
        while (i < j) do
          table.insert(missing_indexes, i)
          i = (i + 1)
        end
      end
      for _, k in ipairs(missing_indexes) do
        table.insert(kv, k, {k})
      end
      return nil
    end
    local function table_kv_pairs(t, options)
      local assoc_3f = false
      local kv = {}
      local insert = table.insert
      for k, v in pairs(t) do
        if ((type(k) ~= "number") or (k < 1)) then
          assoc_3f = true
        else
        end
        insert(kv, {k, v})
      end
      table.sort(kv, sort_keys)
      if not assoc_3f then
        if (options["max-sparse-gap"] < max_index_gap(kv)) then
          assoc_3f = true
        else
          fill_gaps(kv)
        end
      else
      end
      if (length_2a(kv) == 0) then
        return kv, "empty"
      else
        local function _31_()
          if assoc_3f then
            return "table"
          else
            return "seq"
          end
        end
        return kv, _31_()
      end
    end
    local function count_table_appearances(t, appearances)
      if (type(t) == "table") then
        if not appearances[t] then
          appearances[t] = 1
          for k, v in pairs(t) do
            count_table_appearances(k, appearances)
            count_table_appearances(v, appearances)
          end
        else
          appearances[t] = ((appearances[t] or 0) + 1)
        end
      else
      end
      return appearances
    end
    local function save_table(t, seen)
      local seen0 = (seen or {len = 0})
      local id = (seen0.len + 1)
      if not (seen0)[t] then
        seen0[t] = id
        seen0.len = id
      else
      end
      return seen0
    end
    local function detect_cycle(t, seen, _3fk)
      if ("table" == type(t)) then
        seen[t] = true
        local _36_, _37_ = next(t, _3fk)
        if ((nil ~= _36_) and (nil ~= _37_)) then
          local k = _36_
          local v = _37_
          return (seen[k] or detect_cycle(k, seen) or seen[v] or detect_cycle(v, seen) or detect_cycle(t, seen, k))
        else
          return nil
        end
      else
        return nil
      end
    end
    local function visible_cycle_3f(t, options)
      return (getopt(options, "detect-cycles?") and detect_cycle(t, {}) and save_table(t, options.seen) and (1 < (options.appearances[t] or 0)))
    end
    local function table_indent(indent, id)
      local opener_length
      if id then
        opener_length = (length_2a(tostring(id)) + 2)
      else
        opener_length = 1
      end
      return (indent + opener_length)
    end
    local pp = nil
    local function concat_table_lines(elements, options, multiline_3f, indent, table_type, prefix, last_comment_3f)
      local indent_str = ("\n" .. string.rep(" ", indent))
      local open
      local function _41_()
        if ("seq" == table_type) then
          return "["
        else
          return "{"
        end
      end
      open = ((prefix or "") .. _41_())
      local close
      if ("seq" == table_type) then
        close = "]"
      else
        close = "}"
      end
      local oneline = (open .. table.concat(elements, " ") .. close)
      if (not getopt(options, "one-line?") and (multiline_3f or (options["line-length"] < (indent + length_2a(oneline))) or last_comment_3f)) then
        local function _43_()
          if last_comment_3f then
            return indent_str
          else
            return ""
          end
        end
        return (open .. table.concat(elements, indent_str) .. _43_() .. close)
      else
        return oneline
      end
    end
    local function utf8_len(x)
      local n = 0
      for _ in string.gmatch(x, "[%z\1-\127\192-\247]") do
        n = (n + 1)
      end
      return n
    end
    local function comment_3f(x)
      if ("table" == type(x)) then
        local fst = x[1]
        return (("string" == type(fst)) and (nil ~= fst:find("^;")))
      else
        return false
      end
    end
    local function pp_associative(t, kv, options, indent)
      local multiline_3f = false
      local id = options.seen[t]
      if (options.depth <= options.level) then
        return "{...}"
      elseif (id and getopt(options, "detect-cycles?")) then
        return ("@" .. id .. "{...}")
      else
        local visible_cycle_3f0 = visible_cycle_3f(t, options)
        local id0 = (visible_cycle_3f0 and options.seen[t])
        local indent0 = table_indent(indent, id0)
        local slength
        if getopt(options, "utf8?") then
          slength = utf8_len
        else
          local function _46_(_241)
            return #_241
          end
          slength = _46_
        end
        local prefix
        if visible_cycle_3f0 then
          prefix = ("@" .. id0)
        else
          prefix = ""
        end
        local items
        do
          local options0 = normalize_opts(options)
          local tbl_16_auto = {}
          local i_17_auto = #tbl_16_auto
          for _, _49_ in ipairs(kv) do
            local _each_50_ = _49_
            local k = _each_50_[1]
            local v = _each_50_[2]
            local val_18_auto
            do
              local k0 = pp(k, options0, (indent0 + 1), true)
              local v0 = pp(v, options0, (indent0 + slength(k0) + 1))
              multiline_3f = (multiline_3f or k0:find("\n") or v0:find("\n"))
              val_18_auto = (k0 .. " " .. v0)
            end
            if (nil ~= val_18_auto) then
              i_17_auto = (i_17_auto + 1)
              do end (tbl_16_auto)[i_17_auto] = val_18_auto
            else
            end
          end
          items = tbl_16_auto
        end
        return concat_table_lines(items, options, multiline_3f, indent0, "table", prefix, false)
      end
    end
    local function pp_sequence(t, kv, options, indent)
      local multiline_3f = false
      local id = options.seen[t]
      if (options.depth <= options.level) then
        return "[...]"
      elseif (id and getopt(options, "detect-cycles?")) then
        return ("@" .. id .. "[...]")
      else
        local visible_cycle_3f0 = visible_cycle_3f(t, options)
        local id0 = (visible_cycle_3f0 and options.seen[t])
        local indent0 = table_indent(indent, id0)
        local prefix
        if visible_cycle_3f0 then
          prefix = ("@" .. id0)
        else
          prefix = ""
        end
        local last_comment_3f = comment_3f(t[#t])
        local items
        do
          local options0 = normalize_opts(options)
          local tbl_16_auto = {}
          local i_17_auto = #tbl_16_auto
          for _, _54_ in ipairs(kv) do
            local _each_55_ = _54_
            local _0 = _each_55_[1]
            local v = _each_55_[2]
            local val_18_auto
            do
              local v0 = pp(v, options0, indent0)
              multiline_3f = (multiline_3f or v0:find("\n") or v0:find("^;"))
              val_18_auto = v0
            end
            if (nil ~= val_18_auto) then
              i_17_auto = (i_17_auto + 1)
              do end (tbl_16_auto)[i_17_auto] = val_18_auto
            else
            end
          end
          items = tbl_16_auto
        end
        return concat_table_lines(items, options, multiline_3f, indent0, "seq", prefix, last_comment_3f)
      end
    end
    local function concat_lines(lines, options, indent, force_multi_line_3f)
      if (length_2a(lines) == 0) then
        if getopt(options, "empty-as-sequence?") then
          return "[]"
        else
          return "{}"
        end
      else
        local oneline
        local _59_
        do
          local tbl_16_auto = {}
          local i_17_auto = #tbl_16_auto
          for _, line in ipairs(lines) do
            local val_18_auto = line:gsub("^%s+", "")
            if (nil ~= val_18_auto) then
              i_17_auto = (i_17_auto + 1)
              do end (tbl_16_auto)[i_17_auto] = val_18_auto
            else
            end
          end
          _59_ = tbl_16_auto
        end
        oneline = table.concat(_59_, " ")
        if (not getopt(options, "one-line?") and (force_multi_line_3f or oneline:find("\n") or (options["line-length"] < (indent + length_2a(oneline))))) then
          return table.concat(lines, ("\n" .. string.rep(" ", indent)))
        else
          return oneline
        end
      end
    end
    local function pp_metamethod(t, metamethod, options, indent)
      if (options.depth <= options.level) then
        if getopt(options, "empty-as-sequence?") then
          return "[...]"
        else
          return "{...}"
        end
      else
        local _
        local function _64_(_241)
          return visible_cycle_3f(_241, options)
        end
        options["visible-cycle?"] = _64_
        _ = nil
        local lines, force_multi_line_3f = nil, nil
        do
          local options0 = normalize_opts(options)
          lines, force_multi_line_3f = metamethod(t, pp, options0, indent)
        end
        options["visible-cycle?"] = nil
        local _65_ = type(lines)
        if (_65_ == "string") then
          return lines
        elseif (_65_ == "table") then
          return concat_lines(lines, options, indent, force_multi_line_3f)
        elseif true then
          local _0 = _65_
          return error("__fennelview metamethod must return a table of lines")
        else
          return nil
        end
      end
    end
    local function pp_table(x, options, indent)
      options.level = (options.level + 1)
      local x0
      do
        local _68_
        if getopt(options, "metamethod?") then
          local _69_ = x
          if (nil ~= _69_) then
            local _70_ = getmetatable(_69_)
            if (nil ~= _70_) then
              _68_ = (_70_).__fennelview
            else
              _68_ = _70_
            end
          else
            _68_ = _69_
          end
        else
          _68_ = nil
        end
        if (nil ~= _68_) then
          local metamethod = _68_
          x0 = pp_metamethod(x, metamethod, options, indent)
        elseif true then
          local _ = _68_
          local _74_, _75_ = table_kv_pairs(x, options)
          if (true and (_75_ == "empty")) then
            local _0 = _74_
            if getopt(options, "empty-as-sequence?") then
              x0 = "[]"
            else
              x0 = "{}"
            end
          elseif ((nil ~= _74_) and (_75_ == "table")) then
            local kv = _74_
            x0 = pp_associative(x, kv, options, indent)
          elseif ((nil ~= _74_) and (_75_ == "seq")) then
            local kv = _74_
            x0 = pp_sequence(x, kv, options, indent)
          else
            x0 = nil
          end
        else
          x0 = nil
        end
      end
      options.level = (options.level - 1)
      return x0
    end
    local function number__3estring(n)
      local _79_ = string.gsub(tostring(n), ",", ".")
      return _79_
    end
    local function colon_string_3f(s)
      return s:find("^[-%w?^_!$%&*+./@|<=>]+$")
    end
    local utf8_inits = {{["min-byte"] = 0, ["max-byte"] = 127, ["min-code"] = 0, ["max-code"] = 127, len = 1}, {["min-byte"] = 192, ["max-byte"] = 223, ["min-code"] = 128, ["max-code"] = 2047, len = 2}, {["min-byte"] = 224, ["max-byte"] = 239, ["min-code"] = 2048, ["max-code"] = 65535, len = 3}, {["min-byte"] = 240, ["max-byte"] = 247, ["min-code"] = 65536, ["max-code"] = 1114111, len = 4}}
    local function utf8_escape(str)
      local function validate_utf8(str0, index)
        local inits = utf8_inits
        local byte = string.byte(str0, index)
        local init
        do
          local ret = nil
          for _, init0 in ipairs(inits) do
            if ret then break end
            ret = (byte and (function(_80_,_81_,_82_) return (_80_ <= _81_) and (_81_ <= _82_) end)(init0["min-byte"],byte,init0["max-byte"]) and init0)
          end
          init = ret
        end
        local code
        local function _83_()
          local code0
          if init then
            code0 = (byte - init["min-byte"])
          else
            code0 = nil
          end
          for i = (index + 1), (index + init.len + -1) do
            local byte0 = string.byte(str0, i)
            code0 = (byte0 and code0 and (function(_85_,_86_,_87_) return (_85_ <= _86_) and (_86_ <= _87_) end)(128,byte0,191) and ((code0 * 64) + (byte0 - 128)))
          end
          return code0
        end
        code = (init and _83_())
        if (code and (function(_88_,_89_,_90_) return (_88_ <= _89_) and (_89_ <= _90_) end)(init["min-code"],code,init["max-code"]) and not (function(_91_,_92_,_93_) return (_91_ <= _92_) and (_92_ <= _93_) end)(55296,code,57343)) then
          return init.len
        else
          return nil
        end
      end
      local index = 1
      local output = {}
      while (index <= #str) do
        local nexti = (string.find(str, "[\128-\255]", index) or (#str + 1))
        local len = validate_utf8(str, nexti)
        table.insert(output, string.sub(str, index, (nexti + (len or 0) + -1)))
        if (not len and (nexti <= #str)) then
          table.insert(output, string.format("\\%03d", string.byte(str, nexti)))
        else
        end
        if len then
          index = (nexti + len)
        else
          index = (nexti + 1)
        end
      end
      return table.concat(output)
    end
    local function pp_string(str, options, indent)
      local len = length_2a(str)
      local esc_newline_3f = ((len < 2) or (getopt(options, "escape-newlines?") and (len < (options["line-length"] - indent))))
      local escs
      local _97_
      if esc_newline_3f then
        _97_ = "\\n"
      else
        _97_ = "\n"
      end
      local function _99_(_241, _242)
        return ("\\%03d"):format(_242:byte())
      end
      escs = setmetatable({["\7"] = "\\a", ["\8"] = "\\b", ["\12"] = "\\f", ["\11"] = "\\v", ["\13"] = "\\r", ["\9"] = "\\t", ["\\"] = "\\\\", ["\""] = "\\\"", ["\n"] = _97_}, {__index = _99_})
      local str0 = ("\"" .. str:gsub("[%c\\\"]", escs) .. "\"")
      if getopt(options, "utf8?") then
        return utf8_escape(str0)
      else
        return str0
      end
    end
    local function make_options(t, options)
      local defaults
      do
        local tbl_13_auto = {}
        for k, v in pairs(default_opts) do
          local k_14_auto, v_15_auto = k, v
          if ((k_14_auto ~= nil) and (v_15_auto ~= nil)) then
            tbl_13_auto[k_14_auto] = v_15_auto
          else
          end
        end
        defaults = tbl_13_auto
      end
      local overrides = {level = 0, appearances = count_table_appearances(t, {}), seen = {len = 0}}
      for k, v in pairs((options or {})) do
        defaults[k] = v
      end
      for k, v in pairs(overrides) do
        defaults[k] = v
      end
      return defaults
    end
    local function _102_(x, options, indent, colon_3f)
      local indent0 = (indent or 0)
      local options0 = (options or make_options(x))
      local x0
      if options0.preprocess then
        x0 = options0.preprocess(x, options0)
      else
        x0 = x
      end
      local tv = type(x0)
      local function _105_()
        local _104_ = getmetatable(x0)
        if (nil ~= _104_) then
          return (_104_).__fennelview
        else
          return _104_
        end
      end
      if ((tv == "table") or ((tv == "userdata") and _105_())) then
        return pp_table(x0, options0, indent0)
      elseif (tv == "number") then
        return number__3estring(x0)
      else
        local function _107_()
          if (colon_3f ~= nil) then
            return colon_3f
          elseif ("function" == type(options0["prefer-colon?"])) then
            return options0["prefer-colon?"](x0)
          else
            return getopt(options0, "prefer-colon?")
          end
        end
        if ((tv == "string") and colon_string_3f(x0) and _107_()) then
          return (":" .. x0)
        elseif (tv == "string") then
          return pp_string(x0, options0, indent0)
        elseif ((tv == "boolean") or (tv == "nil")) then
          return tostring(x0)
        else
          return ("#<" .. tostring(x0) .. ">")
        end
      end
    end
    pp = _102_
    local function view(x, _3foptions)
      return pp(x, make_options(x, _3foptions), 0)
    end
    return view
  end
  package.preload["fennel.utils"] = package.preload["fennel.utils"] or function(...)
    local view = require("fennel.view")
    local version = "1.3.0"
    local function luajit_vm_3f()
      return ((nil ~= _G.jit) and (type(_G.jit) == "table") and (nil ~= _G.jit.on) and (nil ~= _G.jit.off) and (type(_G.jit.version_num) == "number"))
    end
    local function luajit_vm_version()
      local jit_os
      if (_G.jit.os == "OSX") then
        jit_os = "macOS"
      else
        jit_os = _G.jit.os
      end
      return (_G.jit.version .. " " .. jit_os .. "/" .. _G.jit.arch)
    end
    local function fengari_vm_3f()
      return ((nil ~= _G.fengari) and (type(_G.fengari) == "table") and (nil ~= _G.fengari.VERSION) and (type(_G.fengari.VERSION_NUM) == "number"))
    end
    local function fengari_vm_version()
      return (_G.fengari.RELEASE .. " (" .. _VERSION .. ")")
    end
    local function lua_vm_version()
      if luajit_vm_3f() then
        return luajit_vm_version()
      elseif fengari_vm_3f() then
        return fengari_vm_version()
      else
        return ("PUC " .. _VERSION)
      end
    end
    local function runtime_version()
      return ("Fennel " .. version .. " on " .. lua_vm_version())
    end
    local function warn(message)
      if (_G.io and _G.io.stderr) then
        return (_G.io.stderr):write(("--WARNING: %s\n"):format(tostring(message)))
      else
        return nil
      end
    end
    local len
    do
      local _112_, _113_ = pcall(require, "utf8")
      if ((_112_ == true) and (nil ~= _113_)) then
        local utf8 = _113_
        len = utf8.len
      elseif true then
        local _ = _112_
        len = string.len
      else
        len = nil
      end
    end
    local function mt_keys_in_order(t, out, used_keys)
      for _, k in ipairs(getmetatable(t).keys) do
        if (t[k] and not used_keys[k]) then
          used_keys[k] = true
          table.insert(out, k)
        else
        end
      end
      for k in pairs(t) do
        if not used_keys[k] then
          table.insert(out, k)
        else
        end
      end
      return out
    end
    local function stablepairs(t)
      local keys
      local _118_
      do
        local t_117_ = getmetatable(t)
        if (nil ~= t_117_) then
          t_117_ = (t_117_).keys
        else
        end
        _118_ = t_117_
      end
      if _118_ then
        keys = mt_keys_in_order(t, {}, {})
      else
        local _120_
        do
          local tbl_16_auto = {}
          local i_17_auto = #tbl_16_auto
          for k in pairs(t) do
            local val_18_auto = k
            if (nil ~= val_18_auto) then
              i_17_auto = (i_17_auto + 1)
              do end (tbl_16_auto)[i_17_auto] = val_18_auto
            else
            end
          end
          _120_ = tbl_16_auto
        end
        local function _122_(_241, _242)
          return (tostring(_241) < tostring(_242))
        end
        table.sort(_120_, _122_)
        keys = _120_
      end
      local succ
      do
        local tbl_13_auto = {}
        for i, k in ipairs(keys) do
          local k_14_auto, v_15_auto = k, keys[(i + 1)]
          if ((k_14_auto ~= nil) and (v_15_auto ~= nil)) then
            tbl_13_auto[k_14_auto] = v_15_auto
          else
          end
        end
        succ = tbl_13_auto
      end
      local function stablenext(tbl, key)
        local next_key
        if (key == nil) then
          next_key = keys[1]
        else
          next_key = succ[key]
        end
        return next_key, tbl[next_key]
      end
      return stablenext, t, nil
    end
    local function get_in(tbl, path, _3ffallback)
      assert(("table" == type(tbl)), "get-in expects path to be a table")
      if (0 == #path) then
        return _3ffallback
      else
        local _126_
        do
          local t = tbl
          for _, k in ipairs(path) do
            if (nil == t) then break end
            local _127_ = type(t)
            if (_127_ == "table") then
              t = t[k]
            else
              t = nil
            end
          end
          _126_ = t
        end
        if (nil ~= _126_) then
          local res = _126_
          return res
        elseif true then
          local _ = _126_
          return _3ffallback
        else
          return nil
        end
      end
    end
    local function map(t, f, _3fout)
      local out = (_3fout or {})
      local f0
      if (type(f) == "function") then
        f0 = f
      else
        local function _131_(_241)
          return (_241)[f]
        end
        f0 = _131_
      end
      for _, x in ipairs(t) do
        local _133_ = f0(x)
        if (nil ~= _133_) then
          local v = _133_
          table.insert(out, v)
        else
        end
      end
      return out
    end
    local function kvmap(t, f, _3fout)
      local out = (_3fout or {})
      local f0
      if (type(f) == "function") then
        f0 = f
      else
        local function _135_(_241)
          return (_241)[f]
        end
        f0 = _135_
      end
      for k, x in stablepairs(t) do
        local _137_, _138_ = f0(k, x)
        if ((nil ~= _137_) and (nil ~= _138_)) then
          local key = _137_
          local value = _138_
          out[key] = value
        elseif (nil ~= _137_) then
          local value = _137_
          table.insert(out, value)
        else
        end
      end
      return out
    end
    local function copy(from, _3fto)
      local tbl_13_auto = (_3fto or {})
      for k, v in pairs((from or {})) do
        local k_14_auto, v_15_auto = k, v
        if ((k_14_auto ~= nil) and (v_15_auto ~= nil)) then
          tbl_13_auto[k_14_auto] = v_15_auto
        else
        end
      end
      return tbl_13_auto
    end
    local function member_3f(x, tbl, _3fn)
      local _141_ = tbl[(_3fn or 1)]
      if (_141_ == x) then
        return true
      elseif (_141_ == nil) then
        return nil
      elseif true then
        local _ = _141_
        return member_3f(x, tbl, ((_3fn or 1) + 1))
      else
        return nil
      end
    end
    local function maxn(tbl)
      local max = 0
      for k in pairs(tbl) do
        if ("number" == type(k)) then
          max = math.max(max, k)
        else
          max = max
        end
      end
      return max
    end
    local function every_3f(predicate, seq)
      local result = true
      for _, item in ipairs(seq) do
        if not result then break end
        result = predicate(item)
      end
      return result
    end
    local function allpairs(tbl)
      assert((type(tbl) == "table"), "allpairs expects a table")
      local t = tbl
      local seen = {}
      local function allpairs_next(_, state)
        local next_state, value = next(t, state)
        if seen[next_state] then
          return allpairs_next(nil, next_state)
        elseif next_state then
          seen[next_state] = true
          return next_state, value
        else
          local _144_ = getmetatable(t)
          if ((_G.type(_144_) == "table") and true) then
            local __index = (_144_).__index
            if ("table" == type(__index)) then
              t = __index
              return allpairs_next(t)
            else
              return nil
            end
          else
            return nil
          end
        end
      end
      return allpairs_next
    end
    local function deref(self)
      return self[1]
    end
    local nil_sym = nil
    local function list__3estring(self, _3fview, _3foptions, _3findent)
      local safe = {}
      local view0
      if _3fview then
        local function _148_(_241)
          return _3fview(_241, _3foptions, _3findent)
        end
        view0 = _148_
      else
        view0 = view
      end
      local max = maxn(self)
      for i = 1, max do
        safe[i] = (((self[i] == nil) and nil_sym) or self[i])
      end
      return ("(" .. table.concat(map(safe, view0), " ", 1, max) .. ")")
    end
    local function comment_view(c)
      return c, true
    end
    local function sym_3d(a, b)
      return ((deref(a) == deref(b)) and (getmetatable(a) == getmetatable(b)))
    end
    local function sym_3c(a, b)
      return (a[1] < tostring(b))
    end
    local symbol_mt = {__fennelview = deref, __tostring = deref, __eq = sym_3d, __lt = sym_3c, "SYMBOL"}
    local expr_mt
    local function _150_(x)
      return tostring(deref(x))
    end
    expr_mt = {__tostring = _150_, "EXPR"}
    local list_mt = {__fennelview = list__3estring, __tostring = list__3estring, "LIST"}
    local comment_mt = {__fennelview = comment_view, __tostring = deref, __eq = sym_3d, __lt = sym_3c, "COMMENT"}
    local sequence_marker = {"SEQUENCE"}
    local varg_mt = {__fennelview = deref, __tostring = deref, "VARARG"}
    local getenv
    local function _151_()
      return nil
    end
    getenv = ((os and os.getenv) or _151_)
    local function debug_on_3f(flag)
      local level = (getenv("FENNEL_DEBUG") or "")
      return ((level == "all") or level:find(flag))
    end
    local function list(...)
      return setmetatable({...}, list_mt)
    end
    local function sym(str, _3fsource)
      local _152_
      do
        local tbl_13_auto = {str}
        for k, v in pairs((_3fsource or {})) do
          local k_14_auto, v_15_auto = nil, nil
          if (type(k) == "string") then
            k_14_auto, v_15_auto = k, v
          else
            k_14_auto, v_15_auto = nil
          end
          if ((k_14_auto ~= nil) and (v_15_auto ~= nil)) then
            tbl_13_auto[k_14_auto] = v_15_auto
          else
          end
        end
        _152_ = tbl_13_auto
      end
      return setmetatable(_152_, symbol_mt)
    end
    nil_sym = sym("nil")
    local function sequence(...)
      local function _155_(seq, view0, inspector, indent)
        local opts
        do
          local _156_ = inspector
          _156_["empty-as-sequence?"] = {once = true, after = inspector["empty-as-sequence?"]}
          _156_["metamethod?"] = {once = false, after = inspector["metamethod?"]}
          opts = _156_
        end
        return view0(seq, opts, indent)
      end
      return setmetatable({...}, {sequence = sequence_marker, __fennelview = _155_})
    end
    local function expr(strcode, etype)
      return setmetatable({type = etype, strcode}, expr_mt)
    end
    local function comment_2a(contents, _3fsource)
      local _let_157_ = (_3fsource or {})
      local filename = _let_157_["filename"]
      local line = _let_157_["line"]
      return setmetatable({filename = filename, line = line, contents}, comment_mt)
    end
    local function varg(_3fsource)
      local _158_
      do
        local tbl_13_auto = {"..."}
        for k, v in pairs((_3fsource or {})) do
          local k_14_auto, v_15_auto = nil, nil
          if (type(k) == "string") then
            k_14_auto, v_15_auto = k, v
          else
            k_14_auto, v_15_auto = nil
          end
          if ((k_14_auto ~= nil) and (v_15_auto ~= nil)) then
            tbl_13_auto[k_14_auto] = v_15_auto
          else
          end
        end
        _158_ = tbl_13_auto
      end
      return setmetatable(_158_, varg_mt)
    end
    local function expr_3f(x)
      return ((type(x) == "table") and (getmetatable(x) == expr_mt) and x)
    end
    local function varg_3f(x)
      return ((type(x) == "table") and (getmetatable(x) == varg_mt) and x)
    end
    local function list_3f(x)
      return ((type(x) == "table") and (getmetatable(x) == list_mt) and x)
    end
    local function sym_3f(x)
      return ((type(x) == "table") and (getmetatable(x) == symbol_mt) and x)
    end
    local function sequence_3f(x)
      local mt = ((type(x) == "table") and getmetatable(x))
      return (mt and (mt.sequence == sequence_marker) and x)
    end
    local function comment_3f(x)
      return ((type(x) == "table") and (getmetatable(x) == comment_mt) and x)
    end
    local function table_3f(x)
      return ((type(x) == "table") and not varg_3f(x) and (getmetatable(x) ~= list_mt) and (getmetatable(x) ~= symbol_mt) and not comment_3f(x) and x)
    end
    local function string_3f(x)
      return (type(x) == "string")
    end
    local function multi_sym_3f(str)
      if sym_3f(str) then
        return multi_sym_3f(tostring(str))
      elseif (type(str) ~= "string") then
        return false
      else
        local function _161_()
          local parts = {}
          for part in str:gmatch("[^%.%:]+[%.%:]?") do
            local last_char = part:sub(( - 1))
            if (last_char == ":") then
              parts["multi-sym-method-call"] = true
            else
            end
            if ((last_char == ":") or (last_char == ".")) then
              parts[(#parts + 1)] = part:sub(1, ( - 2))
            else
              parts[(#parts + 1)] = part
            end
          end
          return ((0 < #parts) and parts)
        end
        return ((str:match("%.") or str:match(":")) and not str:match("%.%.") and (str:byte() ~= string.byte(".")) and (str:byte(( - 1)) ~= string.byte(".")) and _161_())
      end
    end
    local function quoted_3f(symbol)
      return symbol.quoted
    end
    local function idempotent_expr_3f(x)
      return ((type(x) == "string") or (type(x) == "integer") or (type(x) == "number") or (sym_3f(x) and not multi_sym_3f(x)))
    end
    local function ast_source(ast)
      if (table_3f(ast) or sequence_3f(ast)) then
        return (getmetatable(ast) or {})
      elseif ("table" == type(ast)) then
        return ast
      else
        return {}
      end
    end
    local function walk_tree(root, f, _3fcustom_iterator)
      local function walk(iterfn, parent, idx, node)
        if f(idx, node, parent) then
          for k, v in iterfn(node) do
            walk(iterfn, node, k, v)
          end
          return nil
        else
          return nil
        end
      end
      walk((_3fcustom_iterator or pairs), nil, nil, root)
      return root
    end
    local lua_keywords = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while", "goto"}
    for i, v in ipairs(lua_keywords) do
      lua_keywords[v] = i
    end
    local function valid_lua_identifier_3f(str)
      return (str:match("^[%a_][%w_]*$") and not lua_keywords[str])
    end
    local propagated_options = {"allowedGlobals", "indent", "correlate", "useMetadata", "env", "compiler-env", "compilerEnv"}
    local function propagate_options(options, subopts)
      for _, name in ipairs(propagated_options) do
        subopts[name] = options[name]
      end
      return subopts
    end
    local root
    local function _167_()
    end
    root = {chunk = nil, scope = nil, options = nil, reset = _167_}
    root["set-reset"] = function(_168_)
      local _arg_169_ = _168_
      local chunk = _arg_169_["chunk"]
      local scope = _arg_169_["scope"]
      local options = _arg_169_["options"]
      local reset = _arg_169_["reset"]
      root.reset = function()
        root.chunk, root.scope, root.options, root.reset = chunk, scope, options, reset
        return nil
      end
      return root.reset
    end
    local warned = {}
    local function check_plugin_version(_170_)
      local _arg_171_ = _170_
      local name = _arg_171_["name"]
      local versions = _arg_171_["versions"]
      local plugin = _arg_171_
      if (not member_3f(version:gsub("-dev", ""), (versions or {})) and not warned[plugin]) then
        warned[plugin] = true
        return warn(string.format("plugin %s does not support Fennel version %s", (name or "unknown"), version))
      else
        return nil
      end
    end
    local function hook_opts(event, _3foptions, ...)
      local plugins
      local function _174_(...)
        local t_173_ = _3foptions
        if (nil ~= t_173_) then
          t_173_ = (t_173_).plugins
        else
        end
        return t_173_
      end
      local function _177_(...)
        local t_176_ = root.options
        if (nil ~= t_176_) then
          t_176_ = (t_176_).plugins
        else
        end
        return t_176_
      end
      plugins = (_174_(...) or _177_(...))
      if plugins then
        local result = nil
        for _, plugin in ipairs(plugins) do
          if result then break end
          check_plugin_version(plugin)
          local _179_ = plugin[event]
          if (nil ~= _179_) then
            local f = _179_
            result = f(...)
          else
            result = nil
          end
        end
        return result
      else
        return nil
      end
    end
    local function hook(event, ...)
      return hook_opts(event, root.options, ...)
    end
    return {warn = warn, allpairs = allpairs, stablepairs = stablepairs, copy = copy, ["get-in"] = get_in, kvmap = kvmap, map = map, ["walk-tree"] = walk_tree, ["member?"] = member_3f, maxn = maxn, ["every?"] = every_3f, list = list, sequence = sequence, sym = sym, varg = varg, expr = expr, comment = comment_2a, ["comment?"] = comment_3f, ["expr?"] = expr_3f, ["list?"] = list_3f, ["multi-sym?"] = multi_sym_3f, ["sequence?"] = sequence_3f, ["sym?"] = sym_3f, ["table?"] = table_3f, ["varg?"] = varg_3f, ["quoted?"] = quoted_3f, ["string?"] = string_3f, ["idempotent-expr?"] = idempotent_expr_3f, ["valid-lua-identifier?"] = valid_lua_identifier_3f, ["lua-keywords"] = lua_keywords, hook = hook, ["hook-opts"] = hook_opts, ["propagate-options"] = propagate_options, root = root, ["debug-on?"] = debug_on_3f, ["ast-source"] = ast_source, version = version, ["runtime-version"] = runtime_version, len = len, path = table.concat({"./?.fnl", "./?/init.fnl", getenv("FENNEL_PATH")}, ";"), ["macro-path"] = table.concat({"./?.fnl", "./?/init-macros.fnl", "./?/init.fnl", getenv("FENNEL_MACRO_PATH")}, ";")}
  end
  utils = require("fennel.utils")
  local parser = require("fennel.parser")
  local compiler = require("fennel.compiler")
  local specials = require("fennel.specials")
  local repl = require("fennel.repl")
  local view = require("fennel.view")
  local function eval_env(env, opts)
    if (env == "_COMPILER") then
      local env0 = specials["make-compiler-env"](nil, compiler.scopes.compiler, {}, opts)
      if (opts.allowedGlobals == nil) then
        opts.allowedGlobals = specials["current-global-names"](env0)
      else
      end
      return specials["wrap-env"](env0)
    else
      return (env and specials["wrap-env"](env))
    end
  end
  local function eval_opts(options, str)
    local opts = utils.copy(options)
    if (opts.allowedGlobals == nil) then
      opts.allowedGlobals = specials["current-global-names"](opts.env)
    else
    end
    if (not opts.filename and not opts.source) then
      opts.source = str
    else
    end
    if (opts.env == "_COMPILER") then
      opts.scope = compiler["make-scope"](compiler.scopes.compiler)
    else
    end
    return opts
  end
  local function eval(str, options, ...)
    local opts = eval_opts(options, str)
    local env = eval_env(opts.env, opts)
    local lua_source = compiler["compile-string"](str, opts)
    local loader
    local function _753_(...)
      if opts.filename then
        return ("@" .. opts.filename)
      else
        return str
      end
    end
    loader = specials["load-code"](lua_source, env, _753_(...))
    opts.filename = nil
    return loader(...)
  end
  local function dofile_2a(filename, options, ...)
    local opts = utils.copy(options)
    local f = assert(io.open(filename, "rb"))
    local source = assert(f:read("*all"), ("Could not read " .. filename))
    f:close()
    opts.filename = filename
    return eval(source, opts, ...)
  end
  local function syntax()
    local body_3f = {"when", "with-open", "collect", "icollect", "fcollect", "lambda", "\206\187", "macro", "match", "match-try", "case", "case-try", "accumulate", "faccumulate", "doto"}
    local binding_3f = {"collect", "icollect", "fcollect", "each", "for", "let", "with-open", "accumulate", "faccumulate"}
    local define_3f = {"fn", "lambda", "\206\187", "var", "local", "macro", "macros", "global"}
    local out = {}
    for k, v in pairs(compiler.scopes.global.specials) do
      local metadata = (compiler.metadata[v] or {})
      do end (out)[k] = {["special?"] = true, ["body-form?"] = metadata["fnl/body-form?"], ["binding-form?"] = utils["member?"](k, binding_3f), ["define?"] = utils["member?"](k, define_3f)}
    end
    for k, v in pairs(compiler.scopes.global.macros) do
      out[k] = {["macro?"] = true, ["body-form?"] = utils["member?"](k, body_3f), ["binding-form?"] = utils["member?"](k, binding_3f), ["define?"] = utils["member?"](k, define_3f)}
    end
    for k, v in pairs(_G) do
      local _754_ = type(v)
      if (_754_ == "function") then
        out[k] = {["global?"] = true, ["function?"] = true}
      elseif (_754_ == "table") then
        for k2, v2 in pairs(v) do
          if (("function" == type(v2)) and (k ~= "_G")) then
            out[(k .. "." .. k2)] = {["function?"] = true, ["global?"] = true}
          else
          end
        end
        out[k] = {["global?"] = true}
      else
      end
    end
    return out
  end
  local mod = {list = utils.list, ["list?"] = utils["list?"], sym = utils.sym, ["sym?"] = utils["sym?"], ["multi-sym?"] = utils["multi-sym?"], sequence = utils.sequence, ["sequence?"] = utils["sequence?"], ["table?"] = utils["table?"], comment = utils.comment, ["comment?"] = utils["comment?"], varg = utils.varg, ["varg?"] = utils["varg?"], ["sym-char?"] = parser["sym-char?"], parser = parser.parser, compile = compiler.compile, ["compile-string"] = compiler["compile-string"], ["compile-stream"] = compiler["compile-stream"], eval = eval, repl = repl, view = view, dofile = dofile_2a, ["load-code"] = specials["load-code"], doc = specials.doc, metadata = compiler.metadata, traceback = compiler.traceback, version = utils.version, ["runtime-version"] = utils["runtime-version"], ["ast-source"] = utils["ast-source"], path = utils.path, ["macro-path"] = utils["macro-path"], ["macro-loaded"] = specials["macro-loaded"], ["macro-searchers"] = specials["macro-searchers"], ["search-module"] = specials["search-module"], ["make-searcher"] = specials["make-searcher"], searcher = specials["make-searcher"](), syntax = syntax, gensym = compiler.gensym, scope = compiler["make-scope"], mangle = compiler["global-mangling"], unmangle = compiler["global-unmangling"], compile1 = compiler.compile1, ["string-stream"] = parser["string-stream"], granulate = parser.granulate, loadCode = specials["load-code"], make_searcher = specials["make-searcher"], makeSearcher = specials["make-searcher"], searchModule = specials["search-module"], macroPath = utils["macro-path"], macroSearchers = specials["macro-searchers"], macroLoaded = specials["macro-loaded"], compileStream = compiler["compile-stream"], compileString = compiler["compile-string"], stringStream = parser["string-stream"], runtimeVersion = utils["runtime-version"]}
  mod.install = function(_3fopts)
    table.insert((package.searchers or package.loaders), specials["make-searcher"](_3fopts))
    return mod
  end
  utils["fennel-module"] = mod
  do
    local module_name = "fennel.macros"
    local _
    local function _757_()
      return mod
    end
    package.preload[module_name] = _757_
    _ = nil
    local env
    do
      local _758_ = specials["make-compiler-env"](nil, compiler.scopes.compiler, {})
      do end (_758_)["utils"] = utils
      _758_["fennel"] = mod
      env = _758_
    end
    local built_ins = eval([===[;; These macros are awkward because their definition cannot rely on the any
    ;; built-in macros, only special forms. (no when, no icollect, etc)
    
    (fn copy [t]
      (let [out []]
        (each [_ v (ipairs t)] (table.insert out v))
        (setmetatable out (getmetatable t))))
    
    (fn ->* [val ...]
      "Thread-first macro.
    Take the first value and splice it into the second form as its first argument.
    The value of the second form is spliced into the first arg of the third, etc."
      (var x val)
      (each [_ e (ipairs [...])]
        (let [elt (if (list? e) (copy e) (list e))]
          (table.insert elt 2 x)
          (set x elt)))
      x)
    
    (fn ->>* [val ...]
      "Thread-last macro.
    Same as ->, except splices the value into the last position of each form
    rather than the first."
      (var x val)
      (each [_ e (ipairs [...])]
        (let [elt (if (list? e) (copy e) (list e))]
          (table.insert elt x)
          (set x elt)))
      x)
    
    (fn -?>* [val ?e ...]
      "Nil-safe thread-first macro.
    Same as -> except will short-circuit with nil when it encounters a nil value."
      (if (= nil ?e)
          val
          (let [el (if (list? ?e) (copy ?e) (list ?e))
                tmp (gensym)]
            (table.insert el 2 tmp)
            `(let [,tmp ,val]
               (if (not= nil ,tmp)
                   (-?> ,el ,...)
                   ,tmp)))))
    
    (fn -?>>* [val ?e ...]
      "Nil-safe thread-last macro.
    Same as ->> except will short-circuit with nil when it encounters a nil value."
      (if (= nil ?e)
          val
          (let [el (if (list? ?e) (copy ?e) (list ?e))
                tmp (gensym)]
            (table.insert el tmp)
            `(let [,tmp ,val]
               (if (not= ,tmp nil)
                   (-?>> ,el ,...)
                   ,tmp)))))
    
    (fn ?dot [tbl ...]
      "Nil-safe table look up.
    Same as . (dot), except will short-circuit with nil when it encounters
    a nil value in any of subsequent keys."
      (let [head (gensym :t)
            lookups `(do
                       (var ,head ,tbl)
                       ,head)]
        (each [_ k (ipairs [...])]
          ;; Kinda gnarly to reassign in place like this, but it emits the best lua.
          ;; With this impl, it emits a flat, concise, and readable set of ifs
          (table.insert lookups (# lookups) `(if (not= nil ,head)
                                               (set ,head (. ,head ,k)))))
        lookups))
    
    (fn doto* [val ...]
      "Evaluate val and splice it into the first argument of subsequent forms."
      (assert (not= val nil) "missing subject")
      (let [rebind? (or (not (sym? val))
                        (multi-sym? val))
            name (if rebind? (gensym)            val)
            form (if rebind? `(let [,name ,val]) `(do))]
        (each [_ elt (ipairs [...])]
          (let [elt (if (list? elt) (copy elt) (list elt))]
            (table.insert elt 2 name)
            (table.insert form elt)))
        (table.insert form name)
        form))
    
    (fn when* [condition body1 ...]
      "Evaluate body for side-effects only when condition is truthy."
      (assert body1 "expected body")
      `(if ,condition
           (do
             ,body1
             ,...)))
    
    (fn with-open* [closable-bindings ...]
      "Like `let`, but invokes (v:close) on each binding after evaluating the body.
    The body is evaluated inside `xpcall` so that bound values will be closed upon
    encountering an error before propagating it."
      (let [bodyfn `(fn []
                      ,...)
            closer `(fn close-handlers# [ok# ...]
                      (if ok# ... (error ... 0)))
            traceback `(. (or package.loaded.fennel debug) :traceback)]
        (for [i 1 (length closable-bindings) 2]
          (assert (sym? (. closable-bindings i))
                  "with-open only allows symbols in bindings")
          (table.insert closer 4 `(: ,(. closable-bindings i) :close)))
        `(let ,closable-bindings
           ,closer
           (close-handlers# (_G.xpcall ,bodyfn ,traceback)))))
    
    (fn extract-into [iter-tbl]
      (var (into iter-out found?) (values [] (copy iter-tbl)))
      (for [i (length iter-tbl) 2 -1]
        (let [item (. iter-tbl i)]
          (if (or (= `&into item)
                  (= :into  item))
              (do
                (assert (not found?) "expected only one &into clause")
                (set found? true)
                (set into (. iter-tbl (+ i 1)))
                (table.remove iter-out i)
                (table.remove iter-out i)))))
      (assert (or (not found?) (sym? into) (table? into) (list? into))
              "expected table, function call, or symbol in &into clause")
      (values into iter-out))
    
    (fn collect* [iter-tbl key-expr value-expr ...]
      "Return a table made by running an iterator and evaluating an expression that
    returns key-value pairs to be inserted sequentially into the table.  This can
    be thought of as a table comprehension. The body should provide two expressions
    (used as key and value) or nil, which causes it to be omitted.
    
    For example,
      (collect [k v (pairs {:apple \"red\" :orange \"orange\"})]
        (values v k))
    returns
      {:red \"apple\" :orange \"orange\"}
    
    Supports an &into clause after the iterator to put results in an existing table.
    Supports early termination with an &until clause."
      (assert (and (sequence? iter-tbl) (<= 2 (length iter-tbl)))
              "expected iterator binding table")
      (assert (not= nil key-expr) "expected key and value expression")
      (assert (= nil ...)
              "expected 1 or 2 body expressions; wrap multiple expressions with do")
      (let [kv-expr (if (= nil value-expr) key-expr `(values ,key-expr ,value-expr))
            (into iter) (extract-into iter-tbl)]
        `(let [tbl# ,into]
           (each ,iter
             (let [(k# v#) ,kv-expr]
               (if (and (not= k# nil) (not= v# nil))
                 (tset tbl# k# v#))))
           tbl#)))
    
    (fn seq-collect [how iter-tbl value-expr ...]
      "Common part between icollect and fcollect for producing sequential tables.
    
    Iteration code only differs in using the for or each keyword, the rest
    of the generated code is identical."
      (assert (not= nil value-expr) "expected table value expression")
      (assert (= nil ...)
              "expected exactly one body expression. Wrap multiple expressions in do")
      (let [(into iter) (extract-into iter-tbl)]
        `(let [tbl# ,into]
           ;; believe it or not, using a var here has a pretty good performance
           ;; boost: https://p.hagelb.org/icollect-performance.html
           (var i# (length tbl#))
           (,how ,iter
                 (let [val# ,value-expr]
                   (when (not= nil val#)
                     (set i# (+ i# 1))
                     (tset tbl# i# val#))))
           tbl#)))
    
    (fn icollect* [iter-tbl value-expr ...]
      "Return a sequential table made by running an iterator and evaluating an
    expression that returns values to be inserted sequentially into the table.
    This can be thought of as a table comprehension. If the body evaluates to nil
    that element is omitted.
    
    For example,
      (icollect [_ v (ipairs [1 2 3 4 5])]
        (when (not= v 3)
          (* v v)))
    returns
      [1 4 16 25]
    
    Supports an &into clause after the iterator to put results in an existing table.
    Supports early termination with an &until clause."
      (assert (and (sequence? iter-tbl) (<= 2 (length iter-tbl)))
              "expected iterator binding table")
      (seq-collect 'each iter-tbl value-expr ...))
    
    (fn fcollect* [iter-tbl value-expr ...]
      "Return a sequential table made by advancing a range as specified by
    for, and evaluating an expression that returns values to be inserted
    sequentially into the table.  This can be thought of as a range
    comprehension. If the body evaluates to nil that element is omitted.
    
    For example,
      (fcollect [i 1 10 2]
        (when (not= i 3)
          (* i i)))
    returns
      [1 25 49 81]
    
    Supports an &into clause after the range to put results in an existing table.
    Supports early termination with an &until clause."
      (assert (and (sequence? iter-tbl) (< 2 (length iter-tbl)))
              "expected range binding table")
      (seq-collect 'for iter-tbl value-expr ...))
    
    (fn accumulate-impl [for? iter-tbl body ...]
      (assert (and (sequence? iter-tbl) (<= 4 (length iter-tbl)))
              "expected initial value and iterator binding table")
      (assert (not= nil body) "expected body expression")
      (assert (= nil ...)
              "expected exactly one body expression. Wrap multiple expressions with do")
      (let [[accum-var accum-init] iter-tbl
            iter (sym (if for? "for" "each"))] ; accumulate or faccumulate?
        `(do
           (var ,accum-var ,accum-init)
           (,iter ,[(unpack iter-tbl 3)]
                  (set ,accum-var ,body))
           ,(if (list? accum-var)
              (list (sym :values) (unpack accum-var))
              accum-var))))
    
    (fn accumulate* [iter-tbl body ...]
      "Accumulation macro.
    
    It takes a binding table and an expression as its arguments.  In the binding
    table, the first form starts out bound to the second value, which is an initial
    accumulator. The rest are an iterator binding table in the format `each` takes.
    
    It runs through the iterator in each step of which the given expression is
    evaluated, and the accumulator is set to the value of the expression. It
    eventually returns the final value of the accumulator.
    
    For example,
      (accumulate [total 0
                   _ n (pairs {:apple 2 :orange 3})]
        (+ total n))
    returns 5"
      (accumulate-impl false iter-tbl body ...))
    
    (fn faccumulate* [iter-tbl body ...]
      "Identical to accumulate, but after the accumulator the binding table is the
    same as `for` instead of `each`. Like collect to fcollect, will iterate over a
    numerical range like `for` rather than an iterator."
      (accumulate-impl true iter-tbl body ...))
    
    (fn double-eval-safe? [x type]
      (or (= :number type) (= :string type) (= :boolean type)
          (and (sym? x) (not (multi-sym? x)))))
    
    (fn partial* [f ...]
      "Return a function with all arguments partially applied to f."
      (assert f "expected a function to partially apply")
      (let [bindings []
            args []]
        (each [_ arg (ipairs [...])]
          (if (double-eval-safe? arg (type arg))
            (table.insert args arg)
            (let [name (gensym)]
              (table.insert bindings name)
              (table.insert bindings arg)
              (table.insert args name))))
        (let [body (list f (unpack args))]
          (table.insert body _VARARG)
          ;; only use the extra let if we need double-eval protection
          (if (= 0 (length bindings))
              `(fn [,_VARARG] ,body)
              `(let ,bindings
                 (fn [,_VARARG] ,body))))))
    
    (fn pick-args* [n f]
      "Create a function of arity n that applies its arguments to f.
    
    For example,
      (pick-args 2 func)
    expands to
      (fn [_0_ _1_] (func _0_ _1_))"
      (if (and _G.io _G.io.stderr)
          (_G.io.stderr:write
           "-- WARNING: pick-args is deprecated and will be removed in the future.\n"))
      (assert (and (= (type n) :number) (= n (math.floor n)) (<= 0 n))
              (.. "Expected n to be an integer literal >= 0, got " (tostring n)))
      (let [bindings []]
        (for [i 1 n]
          (tset bindings i (gensym)))
        `(fn ,bindings
           (,f ,(unpack bindings)))))
    
    (fn pick-values* [n ...]
      "Evaluate to exactly n values.
    
    For example,
      (pick-values 2 ...)
    expands to
      (let [(_0_ _1_) ...]
        (values _0_ _1_))"
      (assert (and (= :number (type n)) (<= 0 n) (= n (math.floor n)))
              (.. "Expected n to be an integer >= 0, got " (tostring n)))
      (let [let-syms (list)
            let-values (if (= 1 (select "#" ...)) ... `(values ,...))]
        (for [i 1 n]
          (table.insert let-syms (gensym)))
        (if (= n 0) `(values)
            `(let [,let-syms ,let-values]
               (values ,(unpack let-syms))))))
    
    (fn lambda* [...]
      "Function literal with nil-checked arguments.
    Like `fn`, but will throw an exception if a declared argument is passed in as
    nil, unless that argument's name begins with a question mark."
      (let [args [...]
            has-internal-name? (sym? (. args 1))
            arglist (if has-internal-name? (. args 2) (. args 1))
            docstring-position (if has-internal-name? 3 2)
            has-docstring? (and (< docstring-position (length args))
                                (= :string (type (. args docstring-position))))
            arity-check-position (- 4 (if has-internal-name? 0 1)
                                    (if has-docstring? 0 1))
            empty-body? (< (length args) arity-check-position)]
        (fn check! [a]
          (if (table? a)
              (each [_ a (pairs a)]
                (check! a))
              (let [as (tostring a)]
                (and (not (as:match "^?")) (not= as "&") (not= as "_")
                     (not= as "...") (not= as "&as")))
              (table.insert args arity-check-position
                            `(_G.assert (not= nil ,a)
                                        ,(: "Missing argument %s on %s:%s" :format
                                            (tostring a)
                                            (or a.filename :unknown)
                                            (or a.line "?"))))))
    
        (assert (= :table (type arglist)) "expected arg list")
        (each [_ a (ipairs arglist)]
          (check! a))
        (if empty-body?
            (table.insert args (sym :nil)))
        `(fn ,(unpack args))))
    
    (fn macro* [name ...]
      "Define a single macro."
      (assert (sym? name) "expected symbol for macro name")
      (local args [...])
      `(macros {,(tostring name) (fn ,(unpack args))}))
    
    (fn macrodebug* [form return?]
      "Print the resulting form after performing macroexpansion.
    With a second argument, returns expanded form as a string instead of printing."
      (let [handle (if return? `do `print)]
        `(,handle ,(view (macroexpand form _SCOPE)))))
    
    (fn import-macros* [binding1 module-name1 ...]
      "Bind a table of macros from each macro module according to a binding form.
    Each binding form can be either a symbol or a k/v destructuring table.
    Example:
      (import-macros mymacros                 :my-macros    ; bind to symbol
                     {:macro1 alias : macro2} :proj.macros) ; import by name"
      (assert (and binding1 module-name1 (= 0 (% (select "#" ...) 2)))
              "expected even number of binding/modulename pairs")
      (for [i 1 (select "#" binding1 module-name1 ...) 2]
        ;; delegate the actual loading of the macros to the require-macros
        ;; special which already knows how to set up the compiler env and stuff.
        ;; this is weird because require-macros is deprecated but it works.
        (let [(binding modname) (select i binding1 module-name1 ...)
              scope (get-scope)
              ;; if the module-name is an expression (and not just a string) we
              ;; patch our expression to have the correct source filename so
              ;; require-macros can pass it down when resolving the module-name.
              expr `(import-macros ,modname)
              filename (if (list? modname) (. modname 1 :filename) :unknown)
              _ (tset expr :filename filename)
              macros* (_SPECIALS.require-macros expr scope {} binding)]
          (if (sym? binding)
              ;; bind whole table of macros to table bound to symbol
              (tset scope.macros (. binding 1) macros*)
              ;; 1-level table destructuring for importing individual macros
              (table? binding)
              (each [macro-name [import-key] (pairs binding)]
                (assert (= :function (type (. macros* macro-name)))
                        (.. "macro " macro-name " not found in module "
                            (tostring modname)))
                (tset scope.macros import-key (. macros* macro-name))))))
      nil)
    
    {:-> ->*
     :->> ->>*
     :-?> -?>*
     :-?>> -?>>*
     :?. ?dot
     :doto doto*
     :when when*
     :with-open with-open*
     :collect collect*
     :icollect icollect*
     :fcollect fcollect*
     :accumulate accumulate*
     :faccumulate faccumulate*
     :partial partial*
     :lambda lambda*
     :λ lambda*
     :pick-args pick-args*
     :pick-values pick-values*
     :macro macro*
     :macrodebug macrodebug*
     :import-macros import-macros*}
    ]===], {env = env, scope = compiler.scopes.compiler, useMetadata = true, filename = "src/fennel/macros.fnl", moduleName = module_name})
    local _0
    for k, v in pairs(built_ins) do
      compiler.scopes.global.macros[k] = v
    end
    _0 = nil
    local match_macros = eval([===[;;; Pattern matching
    ;; This is separated out so we can use the "core" macros during the
    ;; implementation of pattern matching.
    
    (fn copy [t] (collect [k v (pairs t)] k v))
    
    (fn with [opts k]
      (doto (copy opts) (tset k true)))
    
    (fn without [opts k]
      (doto (copy opts) (tset k nil)))
    
    (fn case-values [vals pattern unifications case-pattern opts]
      (let [condition `(and)
            bindings []]
        (each [i pat (ipairs pattern)]
          (let [(subcondition subbindings) (case-pattern [(. vals i)] pat
                                                          unifications (without opts :multival?))]
            (table.insert condition subcondition)
            (icollect [_ b (ipairs subbindings) &into bindings] b)))
        (values condition bindings)))
    
    (fn case-table [val pattern unifications case-pattern opts]
      (let [condition `(and (= (_G.type ,val) :table))
            bindings []]
        (each [k pat (pairs pattern)]
          (if (= pat `&)
              (let [rest-pat (. pattern (+ k 1))
                    rest-val `(select ,k ((or table.unpack _G.unpack) ,val))
                    subcondition (case-table `(pick-values 1 ,rest-val)
                                              rest-pat unifications case-pattern
                                              (without opts :multival?))]
                (if (not (sym? rest-pat))
                    (table.insert condition subcondition))
                (assert (= nil (. pattern (+ k 2)))
                        "expected & rest argument before last parameter")
                (table.insert bindings rest-pat)
                (table.insert bindings [rest-val]))
              (= k `&as)
              (do
                (table.insert bindings pat)
                (table.insert bindings val))
              (and (= :number (type k)) (= `&as pat))
              (do
                (assert (= nil (. pattern (+ k 2)))
                        "expected &as argument before last parameter")
                (table.insert bindings (. pattern (+ k 1)))
                (table.insert bindings val))
              ;; don't process the pattern right after &/&as; already got it
              (or (not= :number (type k)) (and (not= `&as (. pattern (- k 1)))
                                               (not= `& (. pattern (- k 1)))))
              (let [subval `(. ,val ,k)
                    (subcondition subbindings) (case-pattern [subval] pat
                                                              unifications
                                                              (without opts :multival?))]
                (table.insert condition subcondition)
                (icollect [_ b (ipairs subbindings) &into bindings] b))))
        (values condition bindings)))
    
    (fn case-guard [vals condition guards unifications case-pattern opts]
      (if (= 0 (length guards))
        (case-pattern vals condition unifications opts)
        (let [(pcondition bindings) (case-pattern vals condition unifications opts)
              condition `(and ,(unpack guards))]
           (values `(and ,pcondition
                         (let ,bindings
                           ,condition)) bindings))))
    
    (fn symbols-in-pattern [pattern]
      "gives the set of symbols inside a pattern"
      (if (list? pattern)
          (let [result {}]
            (each [_ child-pattern (ipairs pattern)]
              (collect [name symbol (pairs (symbols-in-pattern child-pattern)) &into result]
                name symbol))
            result)
          (sym? pattern)
          (if (and (not= pattern `or)
                   (not= pattern `where)
                   (not= pattern `?)
                   (not= pattern `nil))
              {(tostring pattern) pattern}
              {})
          (= (type pattern) :table)
          (let [result {}]
            (each [key-pattern value-pattern (pairs pattern)]
              (collect [name symbol (pairs (symbols-in-pattern key-pattern)) &into result]
                name symbol)
              (collect [name symbol (pairs (symbols-in-pattern value-pattern)) &into result]
                name symbol))
            result)
          {}))
    
    (fn symbols-in-every-pattern [pattern-list infer-unification?]
      "gives a list of symbols that are present in every pattern in the list"
      (let [?symbols (accumulate [?symbols nil
                                  _ pattern (ipairs pattern-list)]
                       (let [in-pattern (symbols-in-pattern pattern)]
                         (if ?symbols
                           (do
                             (each [name symbol (pairs ?symbols)]
                               (when (not (. in-pattern name))
                                 (tset ?symbols name nil)))
                             ?symbols)
                           in-pattern)))]
        (icollect [_ symbol (pairs (or ?symbols {}))]
          (if (not (and infer-unification?
                        (in-scope? symbol)))
            symbol))))
    
    (fn case-or [vals pattern guards unifications case-pattern opts]
      (let [pattern [(unpack pattern 2)]
            bindings (symbols-in-every-pattern pattern opts.infer-unification?)] ;; TODO opts.infer-unification instead of opts.unification?
        (if (= 0 (length bindings))
          ;; no bindings special case generates simple code
          (let [condition
                (icollect [i subpattern (ipairs pattern) &into `(or)]
                  (let [(subcondition subbindings) (case-pattern vals subpattern unifications opts)]
                    subcondition))]
            (values
              (if (= 0 (length guards))
                condition
                `(and ,condition ,(unpack guards)))
              []))
          ;; case with bindings is handled specially, and returns three values instead of two
          (let [matched? (gensym :matched?)
                bindings-mangled (icollect [_ binding (ipairs bindings)]
                                   (gensym (tostring binding)))
                pre-bindings `(if)]
            (each [i subpattern (ipairs pattern)]
              (let [(subcondition subbindings) (case-guard vals subpattern guards {} case-pattern opts)]
                (table.insert pre-bindings subcondition)
                (table.insert pre-bindings `(let ,subbindings
                                              (values true ,(unpack bindings))))))
            (values matched?
                    [`(,(unpack bindings)) `(values ,(unpack bindings-mangled))]
                    [`(,matched? ,(unpack bindings-mangled)) pre-bindings])))))
    
    (fn case-pattern [vals pattern unifications opts top-level?]
      "Take the AST of values and a single pattern and returns a condition
    to determine if it matches as well as a list of bindings to
    introduce for the duration of the body if it does match."
    
      ;; This function returns the following values (multival):
      ;; a "condition", which is an expression that determines whether the
      ;;   pattern should match,
      ;; a "bindings", which bind all of the symbols used in a pattern
      ;; an optional "pre-bindings", which is a list of bindings that happen
      ;;   before the condition and bindings are evaluated. These should only
      ;;   come from a (case-or). In this case there should be no recursion:
      ;;   the call stack should be case-condition > case-pattern > case-or
      ;;
      ;; Here are the expected flags in the opts table:
      ;;   :infer-unification? boolean - if the pattern should guess when to unify  (ie, match -> true, case -> false)
      ;;   :multival? boolean - if the pattern can contain multivals  (in order to disallow patterns like [(1 2)])
      ;;   :in-where? boolean - if the pattern is surrounded by (where)  (where opts into more pattern features)
      ;;   :legacy-guard-allowed? boolean - if the pattern should allow `(a ? b) patterns
    
      ;; we have to assume we're matching against multiple values here until we
      ;; know we're either in a multi-valued clause (in which case we know the #
      ;; of vals) or we're not, in which case we only care about the first one.
      (let [[val] vals]
        (if (and (sym? pattern)
                 (or (= pattern `nil)
                     (and opts.infer-unification?
                          (in-scope? pattern)
                          (not= pattern `_))
                     (and opts.infer-unification?
                          (multi-sym? pattern)
                          (in-scope? (. (multi-sym? pattern) 1)))))
            (values `(= ,val ,pattern) [])
            ;; unify a local we've seen already
            (and (sym? pattern) (. unifications (tostring pattern)))
            (values `(= ,(. unifications (tostring pattern)) ,val) [])
            ;; bind a fresh local
            (sym? pattern)
            (let [wildcard? (: (tostring pattern) :find "^_")]
              (if (not wildcard?) (tset unifications (tostring pattern) val))
              (values (if (or wildcard? (string.find (tostring pattern) "^?")) true
                          `(not= ,(sym :nil) ,val)) [pattern val]))
            ;; opt-in unify with (=)
            (and (list? pattern)
                 (= (. pattern 1) `=)
                 (sym? (. pattern 2)))
            (let [bind (. pattern 2)]
              (assert-compile (= 2 (length pattern)) "(=) should take only one argument" pattern)
              (assert-compile (not opts.infer-unification?) "(=) cannot be used inside of match" pattern)
              (assert-compile opts.in-where? "(=) must be used in (where) patterns" pattern)
              (assert-compile (and (sym? bind) (not= bind `nil) "= has to bind to a symbol" bind))
              (values `(= ,val ,bind) []))
            ;; where-or clause
            (and (list? pattern) (= (. pattern 1) `where) (list? (. pattern 2)) (= (. pattern 2 1) `or))
            (do
              (assert-compile top-level? "can't nest (where) pattern" pattern)
              (case-or vals (. pattern 2) [(unpack pattern 3)] unifications case-pattern (with opts :in-where?)))
            ;; where clause
            (and (list? pattern) (= (. pattern 1) `where))
            (do
              (assert-compile top-level? "can't nest (where) pattern" pattern)
              (case-guard vals (. pattern 2) [(unpack pattern 3)] unifications case-pattern (with opts :in-where?)))
            ;; or clause (not allowed on its own)
            (and (list? pattern) (= (. pattern 1) `or))
            (do
              (assert-compile top-level? "can't nest (or) pattern" pattern)
              ;; This assertion can be removed to make patterns more permissive
              (assert-compile false "(or) must be used in (where) patterns" pattern)
              (case-or vals pattern [] unifications case-pattern opts))
            ;; guard clause
            (and (list? pattern) (= (. pattern 2) `?))
            (do
              (assert-compile opts.legacy-guard-allowed? "legacy guard clause not supported in case" pattern)
              (case-guard vals (. pattern 1) [(unpack pattern 3)] unifications case-pattern opts))
            ;; multi-valued patterns (represented as lists)
            (list? pattern)
            (do
              (assert-compile opts.multival? "can't nest multi-value destructuring" pattern)
              (case-values vals pattern unifications case-pattern opts))
            ;; table patterns
            (= (type pattern) :table)
            (case-table val pattern unifications case-pattern opts)
            ;; literal value
            (values `(= ,val ,pattern) []))))
    
    (fn add-pre-bindings [out pre-bindings]
      "Decide when to switch from the current `if` AST to a new one"
      (if pre-bindings
          ;; `out` no longer needs to grow.
          ;; Instead, a new tail `if` AST is introduced, which is where the rest of
          ;; the clauses will get appended. This way, all future clauses have the
          ;; pre-bindings in scope.
          (let [tail `(if)]
            (table.insert out true)
            (table.insert out `(let ,pre-bindings ,tail))
            tail)
          ;; otherwise, keep growing the current `if` AST.
          out))
    
    (fn case-condition [vals clauses match?]
      "Construct the actual `if` AST for the given match values and clauses."
      ;; root is the original `if` AST.
      ;; out is the `if` AST that is currently being grown.
      (let [root `(if)]
        (faccumulate [out root
                      i 1 (length clauses) 2]
          (let [pattern (. clauses i)
                body (. clauses (+ i 1))
                (condition bindings pre-bindings) (case-pattern vals pattern {}
                                                                {:multival? true
                                                                 :infer-unification? match?
                                                                 :legacy-guard-allowed? match?}
                                                                true)
                out (add-pre-bindings out pre-bindings)]
            ;; grow the `if` AST by one extra condition
            (table.insert out condition)
            (table.insert out `(let ,bindings
                                ,body))
            out))
        root))
    
    (fn count-case-multival [pattern]
      "Identify the amount of multival values that a pattern requires."
      (if (and (list? pattern) (= (. pattern 2) `?))
          (count-case-multival (. pattern 1))
          (and (list? pattern) (= (. pattern 1) `where))
          (count-case-multival (. pattern 2))
          (and (list? pattern) (= (. pattern 1) `or))
          (accumulate [longest 0
                       _ child-pattern (ipairs pattern)]
            (math.max longest (count-case-multival child-pattern)))
          (list? pattern)
          (length pattern)
          1))
    
    (fn case-val-syms [clauses]
      "What is the length of the largest multi-valued clause? return a list of that
    many gensyms."
      (let [patterns (fcollect [i 1 (length clauses) 2]
                       (. clauses i))
            sym-count (accumulate [longest 0
                                   _ pattern (ipairs patterns)]
                        (math.max longest (count-case-multival pattern)))]
        (fcollect [i 1 sym-count &into (list)]
          (gensym))))
    
    (fn case-impl [match? val ...]
      "The shared implementation of case and match."
      (assert (not= val nil) "missing subject")
      (assert (= 0 (math.fmod (select :# ...) 2))
              "expected even number of pattern/body pairs")
      (assert (not= 0 (select :# ...))
              "expected at least one pattern/body pair")
      (let [clauses [...]
            vals (case-val-syms clauses)]
        ;; protect against multiple evaluation of the value, bind against as
        ;; many values as we ever match against in the clauses.
        (list `let [vals val] (case-condition vals clauses match?))))
    
    (fn case* [val ...]
      "Perform pattern matching on val. See reference for details.
    
    Syntax:
    
    (case data-expression
      pattern body
      (where pattern guards*) body
      (or pattern patterns*) body
      (where (or pattern patterns*) guards*) body
      ;; legacy:
      (pattern ? guards*) body)"
      (case-impl false val ...))
    
    (fn match* [val ...]
      "Perform pattern matching on val, automatically unifying on variables in
    local scope. See reference for details.
    
    Syntax:
    
    (match data-expression
      pattern body
      (where pattern guards*) body
      (or pattern patterns*) body
      (where (or pattern patterns*) guards*) body
      ;; legacy:
      (pattern ? guards*) body)"
      (case-impl true val ...))
    
    (fn case-try-step [how expr else pattern body ...]
      (if (= nil pattern body)
          expr
          ;; unlike regular match, we can't know how many values the value
          ;; might evaluate to, so we have to capture them all in ... via IIFE
          ;; to avoid double-evaluation.
          `((fn [...]
              (,how ...
                ,pattern ,(case-try-step how body else ...)
                ,(unpack else)))
            ,expr)))
    
    (fn case-try-impl [how expr pattern body ...]
      (let [clauses [pattern body ...]
            last (. clauses (length clauses))
            catch (if (= `catch (and (= :table (type last)) (. last 1)))
                     (let [[_ & e] (table.remove clauses)] e) ; remove `catch sym
                     [`_# `...])]
        (assert (= 0 (math.fmod (length clauses) 2))
                "expected every pattern to have a body")
        (assert (= 0 (math.fmod (length catch) 2))
                "expected every catch pattern to have a body")
        (case-try-step how expr catch (unpack clauses))))
    
    (fn case-try* [expr pattern body ...]
      "Perform chained pattern matching for a sequence of steps which might fail.
    
    The values from the initial expression are matched against the first pattern.
    If they match, the first body is evaluated and its values are matched against
    the second pattern, etc.
    
    If there is a (catch pat1 body1 pat2 body2 ...) form at the end, any mismatch
    from the steps will be tried against these patterns in sequence as a fallback
    just like a normal match. If there is no catch, the mismatched values will be
    returned as the value of the entire expression."
      (case-try-impl `case expr pattern body ...))
    
    (fn match-try* [expr pattern body ...]
      "Perform chained pattern matching for a sequence of steps which might fail.
    
    The values from the initial expression are matched against the first pattern.
    If they match, the first body is evaluated and its values are matched against
    the second pattern, etc.
    
    If there is a (catch pat1 body1 pat2 body2 ...) form at the end, any mismatch
    from the steps will be tried against these patterns in sequence as a fallback
    just like a normal match. If there is no catch, the mismatched values will be
    returned as the value of the entire expression."
      (case-try-impl `match expr pattern body ...))
    
    {:case case*
     :case-try case-try*
     :match match*
     :match-try match-try*}
    ]===], {env = env, scope = compiler.scopes.compiler, allowedGlobals = false, useMetadata = true, filename = "src/fennel/match.fnl", moduleName = module_name})
    for k, v in pairs(match_macros) do
      compiler.scopes.global.macros[k] = v
    end
    package.preload[module_name] = nil
  end
  return mod
end
package.preload["argparse"] = package.preload["argparse"] or function(...)
  local function _15_()
    return "#<namespace: argparse>"
  end
  local _local_14_ = {setmetatable({}, {__fennelview = _15_, __name = "namespace"}), require("cljlib"), require("fennel")}
  local argparse = _local_14_[1]
  local _local_865_ = _local_14_[2]
  local conj = _local_865_["conj"]
  local first = _local_865_["first"]
  local hash_map = _local_865_["hash-map"]
  local hash_set = _local_865_["hash-set"]
  local inc = _local_865_["inc"]
  local into = _local_865_["into"]
  local keys = _local_865_["keys"]
  local map = _local_865_["map"]
  local reduce = _local_865_["reduce"]
  local vals = _local_865_["vals"]
  local fennel = _local_14_[3]
  local key_flags = {["--license-key"] = {"_LICENSE", "License information of the module."}, ["--description-key"] = {"_DESCRIPTION", "The description of the module."}, ["--copyright-key"] = {"_COPYRIGHT", "Copyright information of the module."}, ["--doc-order-key"] = {"_DOC_ORDER", "Order of items of the module."}, ["--version-key"] = {"_VERSION", "The version of the module."}}
  local value_flags
  local function _866_(_241)
    if not hash_set("alphabetic", "reverse-alphabetic")(_241) then
      do end (io.stderr):write("Error: wrong value specified for key --order '", _241, "'\n", "Supported orders: alphabetic, reverse-alphabetic\n")
      return os.exit(1)
    else
      return nil
    end
  end
  local function _868_(_241)
    if not hash_set("checkdoc", "check", "doc")(_241) then
      do end (io.stderr):write("Error wrong value specified for key --mode '", _241, "'\n", "Supported modes: checkdoc, check, doc.\n")
      return os.exit(1)
    else
      return nil
    end
  end
  local function _870_(_241)
    if not hash_set("link", "code", "keep")(_241) then
      do end (io.stderr):write("Error wrong value specified for key --inline-references '", _241, "'\n", "Supported modes: link, code, keep.\n")
      return os.exit(1)
    else
      return nil
    end
  end
  value_flags = {["--out-dir"] = {"./doc", "Output directory for generated documentation."}, ["--order"] = {"alphabetic", "Sorting of items that were not given particular order.\n                                              Supported algorithms: alphabetic, reverse-alphabetic.\n                                              You also can specify a custom sorting function\n                                              in .fenneldoc file.", _866_}, ["--mode"] = {"checkdoc", "Mode to operate in.  Supported modes:\n                                            checkdoc - check documentation and generate markdown;\n                                            check    - only check documentation;\n                                            doc      - only generate markdown.", _868_}, ["--inline-references"] = {"link", "How to handle inline references. Supported modes:\n                                                  link - convert inline references to markdown links;\n                                                  code - convert inline references to inline code;\n                                                  keep - keep inline references as is.", _870_}, ["--project-version"] = {"version", "Project version to include in the documentation files."}, ["--project-license"] = {"license", "Project license to include in the documentation files.\n                                                   Markdown style links are supported."}, ["--project-copyright"] = {"copyright", "Project copyright to include in the documentation files."}}
  local bool_flags = {["--function-signatures"] = {true, "(Don't) generate function signatures in documentation."}, ["--final-comment"] = {true, "(Don't) insert final comment with fenneldoc version."}, ["--copyright"] = {true, "(Don't) insert copyright information."}, ["--license"] = {true, "(Don't) insert license information from the module."}, ["--toc"] = {true, "(Don't) generate table of contents."}, ["--sandbox"] = {true, "(Don't) sandbox loaded code and documentation tests."}}
  local longest_length
  local function longest_length0(...)
    local items = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "longest-length"))
      else
      end
    end
    local len = 0
    for _, x in ipairs(items) do
      len = math.max(len, #tostring((x or "")))
    end
    return (len + 1)
  end
  longest_length = longest_length0
  local gen_help_info
  local function gen_help_info0(...)
    local flags = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-help-info"))
      else
      end
    end
    local lines = {}
    local longest_flag = longest_length(keys(flags))
    local longest_default = longest_length(map(first, vals(flags)))
    for flag, _874_ in pairs(flags) do
      local _each_875_ = _874_
      local default = _each_875_[1]
      local docstring = _each_875_[2]
      local default0 = tostring((default or ""))
      local flag_pad = string.rep(" ", (longest_flag - #flag))
      local doc_pad = string.rep(" ", (longest_default - #default0))
      local function _877_(...)
        local tbl_17_auto = {}
        local i_18_auto = #tbl_17_auto
        for s in docstring:gmatch("[^\13\n]+") do
          local val_19_auto = s:gsub("^%s*(.-)%s*$", "%1")
          if (nil ~= val_19_auto) then
            i_18_auto = (i_18_auto + 1)
            do end (tbl_17_auto)[i_18_auto] = val_19_auto
          else
          end
        end
        return tbl_17_auto
      end
      local _let_876_ = _877_(...)
      local doc_line = _let_876_[1]
      local doc_lines = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_876_, 2)
      local doc_line0 = ("  " .. flag .. flag_pad .. default0 .. doc_pad .. doc_line)
      if next(doc_lines) then
        for _, line in ipairs(doc_lines) do
          doc_line0 = (doc_line0 .. "\n  " .. string.rep(" ", (#flag - 1)) .. flag_pad .. string.rep(" ", (#default0 - 1)) .. doc_pad .. "  " .. line)
        end
      else
      end
      table.insert(lines, doc_line0)
    end
    table.sort(lines)
    return table.concat(lines, "\n")
  end
  gen_help_info = gen_help_info0
  local help
  local function help0(...)
    do
      local cnt_68_auto = select("#", ...)
      if (0 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "help"))
      else
      end
    end
    local function _884_(_881_)
      local _arg_882_ = _881_
      local k = _arg_882_[1]
      local _arg_883_ = _arg_882_[2]
      local default = _arg_883_[1]
      local docstring = _arg_883_[2]
      return {k:gsub("^[-][-]", "--[no-]"), {"", docstring}}
    end
    print(("Usage: fenneldoc [flags] [files]\n\nCreate documentation for your Fennel project.\n\nKey lookup flags:\n" .. gen_help_info(key_flags) .. "\n\nOption flags:\n" .. gen_help_info(value_flags) .. "\n\nToggle flags:\n" .. gen_help_info(into(hash_map(), map(_884_), bool_flags)) .. "\n\nOther flags:\n  --       treat remaining flags as files.\n  --config consume all regular flags and write to config file.\n           Updates current config if .fenneldoc already exists at\n           current directory.\n  --help   print this message and exit.\n\nAll keys have corresponding entry in `.fenneldoc' configuration file,\nand args passed via command line have higher precedence, therefore\nwill override following values in `.fenneldoc'.\n\nEach toggle key has two variants with and without `no'.  For example,\npassing `--no-toc' will disable generation of contents table, and\n`--toc` will enable it."))
    return os.exit(0)
  end
  help = help0
  local bool_flags_set
  local function _887_(flags, _885_)
    local _arg_886_ = _885_
    local flag = _arg_886_[1]
    local toggle_3f = _arg_886_[2]
    local flags0 = conj(flags, flag)
    if toggle_3f then
      local inverse_flag = flag:gsub("^[-][-]", "--no-")
      return conj(flags0, inverse_flag)
    else
      return flags0
    end
  end
  bool_flags_set = reduce(_887_, hash_set(), bool_flags)
  local handle_bool_flag
  local function handle_bool_flag0(...)
    local flag, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (2 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "handle-bool-flag"))
      else
      end
    end
    local _890_ = string.sub(flag, 1, 4)
    if (_890_ == "--no") then
      config[string.sub(flag, 6)] = false
      return nil
    elseif true then
      local _ = _890_
      config[string.sub(flag, 3)] = true
      return nil
    else
      return nil
    end
  end
  handle_bool_flag = handle_bool_flag0
  local handle_value_flag
  local function handle_value_flag0(...)
    local i, flag, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (3 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "handle-value-flag"))
      else
      end
    end
    local _let_893_ = value_flags[flag]
    local _ = _let_893_[1]
    local _0 = _let_893_[2]
    local validate_fn = _let_893_[3]
    local flag0 = string.sub(flag, 3, -1)
    local _894_ = arg[i]
    if (nil ~= _894_) then
      local val = _894_
      if validate_fn then
        validate_fn(val)
      else
      end
      config[flag0] = val
      return nil
    elseif (_894_ == nil) then
      do end (io.stderr):write("fenneldoc: expected value for ", flag0, "\n")
      return os.exit(-1)
    else
      return nil
    end
  end
  handle_value_flag = handle_value_flag0
  local handle_key_flag
  local function handle_key_flag0(...)
    local i, flag, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (3 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "handle-key-flag"))
      else
      end
    end
    local flag0 = string.sub(flag, 3, -5)
    local _898_ = arg[i]
    if (nil ~= _898_) then
      local val = _898_
      config.keys[flag0] = val
      return nil
    elseif (_898_ == nil) then
      do end (io.stderr):write("fenneldoc: expected value for ", flag0, "\n")
      return os.exit(-1)
    else
      return nil
    end
  end
  handle_key_flag = handle_key_flag0
  local handle_file
  local function handle_file0(...)
    local _901_ = select("#", ...)
    if (_901_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "handle-file"))
    elseif (_901_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "handle-file"))
    elseif (_901_ == 2) then
      local file, files = ...
      return handle_file0(file, files, false)
    elseif (_901_ == 3) then
      local file, files, no_check = ...
      if (not no_check and (string.sub(file, 1, 2) == "--")) then
        do end (io.stderr):write("fenneldoc: unknown flag ", file, "\n")
        os.exit(-1)
      else
      end
      return table.insert(files, file)
    elseif true then
      local _ = _901_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "handle-file"))
    else
      return nil
    end
  end
  handle_file = handle_file0
  local handle_fennel_path
  local function handle_fennel_path0(...)
    local i = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "handle-fennel-path"))
      else
      end
    end
    local _905_ = arg[inc(i)]
    if (nil ~= _905_) then
      local val = _905_
      fennel.path = (val .. ";" .. fennel.path)
      return nil
    elseif (_905_ == nil) then
      do end (io.stderr):write("fenneldoc: expected value for --add-fennel-path\n")
      return os.exit(-1)
    else
      return nil
    end
  end
  handle_fennel_path = handle_fennel_path0
  local write_config
  local function write_config0(...)
    local config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "write-config"))
      else
      end
    end
    local _908_, _909_, _910_ = io.open(".fenneldoc", "w")
    if (nil ~= _908_) then
      local f = _908_
      local file = f
      local function close_handlers_10_auto(ok_11_auto, ...)
        file:close()
        if ok_11_auto then
          return ...
        else
          return error(..., 0)
        end
      end
      local function _912_()
        local version = config["fenneldoc-version"]
        config["fenneldoc-version"] = nil
        local _914_
        do
          local _913_ = fennel.view(config):gsub("\\\n", "\n")
          _914_ = _913_
        end
        file:write(";; -*- mode: fennel; -*- vi:ft=fennel\n", ";; Configuration file for Fenneldoc ", version, "\n", ";; https://gitlab.com/andreyorst/fenneldoc\n\n", _914_, "\n")
        config["fenneldoc-version"] = version
        return nil
      end
      return close_handlers_10_auto(_G.xpcall(_912_, (package.loaded.fennel or debug).traceback))
    elseif ((_908_ == nil) and (nil ~= _909_) and (nil ~= _910_)) then
      local msg = _909_
      local code = _910_
      do end (io.stderr):write("Error opening file '.fenneldoc': ", msg, " (", code, ")\n")
      return os.exit(code)
    else
      return nil
    end
  end
  write_config = write_config0
  local process_args
  do
    local v_33_auto
    local function process_args0(...)
      local config = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "process-args"))
        else
        end
      end
      local files = {}
      local arglen = #arg
      local i = 1
      local write_config_3f = false
      while (i <= arglen) do
        do
          local _917_ = arg[i]
          local function _918_(...)
            local flag = _917_
            return bool_flags_set[flag]
          end
          if ((nil ~= _917_) and _918_(...)) then
            local flag = _917_
            handle_bool_flag(flag, config)
          else
            local function _919_(...)
              local flag = _917_
              return key_flags[flag]
            end
            if ((nil ~= _917_) and _919_(...)) then
              local flag = _917_
              i = inc(i)
              handle_key_flag(i, flag, config)
            else
              local function _920_(...)
                local flag = _917_
                return value_flags[flag]
              end
              if ((nil ~= _917_) and _920_(...)) then
                local flag = _917_
                i = inc(i)
                handle_value_flag(i, flag, config)
              elseif (_917_ == "--add-fennel-path") then
                i = inc(i)
                handle_fennel_path(i)
              elseif (_917_ == "--config") then
                write_config_3f = true
              elseif (_917_ == "--") then
                i = inc(i)
                break
              elseif (_917_ == "--check-only") then
                handle_bool_flag("--check-only", config)
              elseif (_917_ == "--skip-check") then
                handle_bool_flag("--skip-check", config)
              elseif (_917_ == "--help") then
                help()
              else
                local function _921_(...)
                  local flag = _917_
                  return flag:find("^%-%-")
                end
                if ((nil ~= _917_) and _921_(...)) then
                  local flag = _917_
                  do end (io.stderr):write("fenneldoc: unknown flag '", flag, "'\n")
                  os.exit(1)
                elseif (nil ~= _917_) then
                  local file = _917_
                  handle_file(file, files)
                else
                end
              end
            end
          end
        end
        i = inc(i)
      end
      if write_config_3f then
        write_config(config)
      else
      end
      while (i <= arglen) do
        handle_file(arg[i], files, true)
        i = inc(i)
      end
      for i0 = 1, arglen do
        arg[i0] = nil
      end
      return files, config
    end
    v_33_auto = process_args0
    argparse["process-args"] = v_33_auto
    process_args = v_33_auto
  end
  return argparse
end
package.preload["cljlib"] = package.preload["cljlib"] or function(...)
  local function _17_()
    return "#<namespace: core>"
  end
  --[[ "MIT License
  
  Copyright (c) 2022 Andrey Listopadov
  
  Permission is hereby granted‚ free of charge‚ to any person obtaining a copy
  of this software and associated documentation files (the “Software”)‚ to deal
  in the Software without restriction‚ including without limitation the rights
  to use‚ copy‚ modify‚ merge‚ publish‚ distribute‚ sublicense‚ and/or sell
  copies of the Software‚ and to permit persons to whom the Software is
  furnished to do so‚ subject to the following conditions：
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED “AS IS”‚ WITHOUT WARRANTY OF ANY KIND‚ EXPRESS OR
  IMPLIED‚ INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY‚
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM‚ DAMAGES OR OTHER
  LIABILITY‚ WHETHER IN AN ACTION OF CONTRACT‚ TORT OR OTHERWISE‚ ARISING FROM‚
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE." ]]
  local _local_16_ = {setmetatable({}, {__fennelview = _17_, __name = "namespace"}), require("lazy-seq"), require("itable")}, nil
  local core = _local_16_[1]
  local lazy = _local_16_[2]
  local itable = _local_16_[3]
  local function unpack_2a(x, ...)
    if core["seq?"](x) then
      return lazy.unpack(x)
    else
      return itable.unpack(x, ...)
    end
  end
  local function pack_2a(...)
    local _257_ = {...}
    _257_["n"] = select("#", ...)
    return _257_
  end
  local function pairs_2a(t)
    local _258_ = getmetatable(t)
    if ((_G.type(_258_) == "table") and (nil ~= (_258_).__pairs)) then
      local p = (_258_).__pairs
      return p(t)
    elseif true then
      local _ = _258_
      return pairs(t)
    else
      return nil
    end
  end
  local function ipairs_2a(t)
    local _260_ = getmetatable(t)
    if ((_G.type(_260_) == "table") and (nil ~= (_260_).__ipairs)) then
      local i = (_260_).__ipairs
      return i(t)
    elseif true then
      local _ = _260_
      return ipairs(t)
    else
      return nil
    end
  end
  local function length_2a(t)
    local _262_ = getmetatable(t)
    if ((_G.type(_262_) == "table") and (nil ~= (_262_).__len)) then
      local l = (_262_).__len
      return l(t)
    elseif true then
      local _ = _262_
      return #t
    else
      return nil
    end
  end
  local apply
  do
    local v_33_auto
    local function apply0(...)
      local _265_ = select("#", ...)
      if (_265_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "apply"))
      elseif (_265_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "apply"))
      elseif (_265_ == 2) then
        local f, args = ...
        return f(unpack_2a(args))
      elseif (_265_ == 3) then
        local f, a, args = ...
        return f(a, unpack_2a(args))
      elseif (_265_ == 4) then
        local f, a, b, args = ...
        return f(a, b, unpack_2a(args))
      elseif (_265_ == 5) then
        local f, a, b, c, args = ...
        return f(a, b, c, unpack_2a(args))
      elseif true then
        local _ = _265_
        local core_48_auto = require("cljlib")
        local _let_266_ = core_48_auto.list(...)
        local f = _let_266_[1]
        local a = _let_266_[2]
        local b = _let_266_[3]
        local c = _let_266_[4]
        local d = _let_266_[5]
        local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_266_, 6)
        local flat_args = {}
        local len = (length_2a(args) - 1)
        for i = 1, len do
          flat_args[i] = args[i]
        end
        for i, a0 in pairs_2a(args[(len + 1)]) do
          flat_args[(i + len)] = a0
        end
        return f(a, b, c, d, unpack_2a(flat_args))
      else
        return nil
      end
    end
    v_33_auto = apply0
    core["apply"] = v_33_auto
    apply = v_33_auto
  end
  local add
  do
    local v_33_auto
    local function add0(...)
      local _268_ = select("#", ...)
      if (_268_ == 0) then
        return 0
      elseif (_268_ == 1) then
        local a = ...
        return a
      elseif (_268_ == 2) then
        local a, b = ...
        return (a + b)
      elseif (_268_ == 3) then
        local a, b, c = ...
        return (a + b + c)
      elseif (_268_ == 4) then
        local a, b, c, d = ...
        return (a + b + c + d)
      elseif true then
        local _ = _268_
        local core_48_auto = require("cljlib")
        local _let_269_ = core_48_auto.list(...)
        local a = _let_269_[1]
        local b = _let_269_[2]
        local c = _let_269_[3]
        local d = _let_269_[4]
        local rest = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_269_, 5)
        return apply(add0, (a + b + c + d), rest)
      else
        return nil
      end
    end
    v_33_auto = add0
    core["add"] = v_33_auto
    add = v_33_auto
  end
  local sub
  do
    local v_33_auto
    local function sub0(...)
      local _271_ = select("#", ...)
      if (_271_ == 0) then
        return 0
      elseif (_271_ == 1) then
        local a = ...
        return ( - a)
      elseif (_271_ == 2) then
        local a, b = ...
        return (a - b)
      elseif (_271_ == 3) then
        local a, b, c = ...
        return (a - b - c)
      elseif (_271_ == 4) then
        local a, b, c, d = ...
        return (a - b - c - d)
      elseif true then
        local _ = _271_
        local core_48_auto = require("cljlib")
        local _let_272_ = core_48_auto.list(...)
        local a = _let_272_[1]
        local b = _let_272_[2]
        local c = _let_272_[3]
        local d = _let_272_[4]
        local rest = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_272_, 5)
        return apply(sub0, (a - b - c - d), rest)
      else
        return nil
      end
    end
    v_33_auto = sub0
    core["sub"] = v_33_auto
    sub = v_33_auto
  end
  local mul
  do
    local v_33_auto
    local function mul0(...)
      local _274_ = select("#", ...)
      if (_274_ == 0) then
        return 1
      elseif (_274_ == 1) then
        local a = ...
        return a
      elseif (_274_ == 2) then
        local a, b = ...
        return (a * b)
      elseif (_274_ == 3) then
        local a, b, c = ...
        return (a * b * c)
      elseif (_274_ == 4) then
        local a, b, c, d = ...
        return (a * b * c * d)
      elseif true then
        local _ = _274_
        local core_48_auto = require("cljlib")
        local _let_275_ = core_48_auto.list(...)
        local a = _let_275_[1]
        local b = _let_275_[2]
        local c = _let_275_[3]
        local d = _let_275_[4]
        local rest = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_275_, 5)
        return apply(mul0, (a * b * c * d), rest)
      else
        return nil
      end
    end
    v_33_auto = mul0
    core["mul"] = v_33_auto
    mul = v_33_auto
  end
  local div
  do
    local v_33_auto
    local function div0(...)
      local _277_ = select("#", ...)
      if (_277_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "div"))
      elseif (_277_ == 1) then
        local a = ...
        return (1 / a)
      elseif (_277_ == 2) then
        local a, b = ...
        return (a / b)
      elseif (_277_ == 3) then
        local a, b, c = ...
        return (a / b / c)
      elseif (_277_ == 4) then
        local a, b, c, d = ...
        return (a / b / c / d)
      elseif true then
        local _ = _277_
        local core_48_auto = require("cljlib")
        local _let_278_ = core_48_auto.list(...)
        local a = _let_278_[1]
        local b = _let_278_[2]
        local c = _let_278_[3]
        local d = _let_278_[4]
        local rest = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_278_, 5)
        return apply(div0, (a / b / c / d), rest)
      else
        return nil
      end
    end
    v_33_auto = div0
    core["div"] = v_33_auto
    div = v_33_auto
  end
  local le
  do
    local v_33_auto
    local function le0(...)
      local _280_ = select("#", ...)
      if (_280_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "le"))
      elseif (_280_ == 1) then
        local a = ...
        return true
      elseif (_280_ == 2) then
        local a, b = ...
        return (a <= b)
      elseif true then
        local _ = _280_
        local core_48_auto = require("cljlib")
        local _let_281_ = core_48_auto.list(...)
        local a = _let_281_[1]
        local b = _let_281_[2]
        local _let_282_ = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_281_, 3)
        local c = _let_282_[1]
        local d = _let_282_[2]
        local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_282_, 3)
        if (a <= b) then
          if d then
            return apply(le0, b, c, d, more)
          else
            return (b <= c)
          end
        else
          return false
        end
      else
        return nil
      end
    end
    v_33_auto = le0
    core["le"] = v_33_auto
    le = v_33_auto
  end
  local lt
  do
    local v_33_auto
    local function lt0(...)
      local _286_ = select("#", ...)
      if (_286_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "lt"))
      elseif (_286_ == 1) then
        local a = ...
        return true
      elseif (_286_ == 2) then
        local a, b = ...
        return (a < b)
      elseif true then
        local _ = _286_
        local core_48_auto = require("cljlib")
        local _let_287_ = core_48_auto.list(...)
        local a = _let_287_[1]
        local b = _let_287_[2]
        local _let_288_ = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_287_, 3)
        local c = _let_288_[1]
        local d = _let_288_[2]
        local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_288_, 3)
        if (a < b) then
          if d then
            return apply(lt0, b, c, d, more)
          else
            return (b < c)
          end
        else
          return false
        end
      else
        return nil
      end
    end
    v_33_auto = lt0
    core["lt"] = v_33_auto
    lt = v_33_auto
  end
  local ge
  do
    local v_33_auto
    local function ge0(...)
      local _292_ = select("#", ...)
      if (_292_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "ge"))
      elseif (_292_ == 1) then
        local a = ...
        return true
      elseif (_292_ == 2) then
        local a, b = ...
        return (a >= b)
      elseif true then
        local _ = _292_
        local core_48_auto = require("cljlib")
        local _let_293_ = core_48_auto.list(...)
        local a = _let_293_[1]
        local b = _let_293_[2]
        local _let_294_ = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_293_, 3)
        local c = _let_294_[1]
        local d = _let_294_[2]
        local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_294_, 3)
        if (a >= b) then
          if d then
            return apply(ge0, b, c, d, more)
          else
            return (b >= c)
          end
        else
          return false
        end
      else
        return nil
      end
    end
    v_33_auto = ge0
    core["ge"] = v_33_auto
    ge = v_33_auto
  end
  local gt
  do
    local v_33_auto
    local function gt0(...)
      local _298_ = select("#", ...)
      if (_298_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "gt"))
      elseif (_298_ == 1) then
        local a = ...
        return true
      elseif (_298_ == 2) then
        local a, b = ...
        return (a > b)
      elseif true then
        local _ = _298_
        local core_48_auto = require("cljlib")
        local _let_299_ = core_48_auto.list(...)
        local a = _let_299_[1]
        local b = _let_299_[2]
        local _let_300_ = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_299_, 3)
        local c = _let_300_[1]
        local d = _let_300_[2]
        local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_300_, 3)
        if (a > b) then
          if d then
            return apply(gt0, b, c, d, more)
          else
            return (b > c)
          end
        else
          return false
        end
      else
        return nil
      end
    end
    v_33_auto = gt0
    core["gt"] = v_33_auto
    gt = v_33_auto
  end
  local inc
  do
    local v_33_auto
    local function inc0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "inc"))
        else
        end
      end
      return (x + 1)
    end
    v_33_auto = inc0
    core["inc"] = v_33_auto
    inc = v_33_auto
  end
  local dec
  do
    local v_33_auto
    local function dec0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "dec"))
        else
        end
      end
      return (x - 1)
    end
    v_33_auto = dec0
    core["dec"] = v_33_auto
    dec = v_33_auto
  end
  local class
  do
    local v_33_auto
    local function class0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "class"))
        else
        end
      end
      local _307_ = type(x)
      if (_307_ == "table") then
        local _308_ = getmetatable(x)
        if ((_G.type(_308_) == "table") and (nil ~= (_308_)["cljlib/type"])) then
          local t = (_308_)["cljlib/type"]
          return t
        elseif true then
          local _ = _308_
          return "table"
        else
          return nil
        end
      elseif (nil ~= _307_) then
        local t = _307_
        return t
      else
        return nil
      end
    end
    v_33_auto = class0
    core["class"] = v_33_auto
    class = v_33_auto
  end
  local constantly
  do
    local v_33_auto
    local function constantly0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "constantly"))
        else
        end
      end
      local function _312_()
        return x
      end
      return _312_
    end
    v_33_auto = constantly0
    core["constantly"] = v_33_auto
    constantly = v_33_auto
  end
  local complement
  do
    local v_33_auto
    local function complement0(...)
      local f = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "complement"))
        else
        end
      end
      local function fn_314_(...)
        local _315_ = select("#", ...)
        if (_315_ == 0) then
          return not f()
        elseif (_315_ == 1) then
          local a = ...
          return not f(a)
        elseif (_315_ == 2) then
          local a, b = ...
          return not f(a, b)
        elseif true then
          local _ = _315_
          local core_48_auto = require("cljlib")
          local _let_316_ = core_48_auto.list(...)
          local a = _let_316_[1]
          local b = _let_316_[2]
          local cs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_316_, 3)
          return not apply(f, a, b, cs)
        else
          return nil
        end
      end
      return fn_314_
    end
    v_33_auto = complement0
    core["complement"] = v_33_auto
    complement = v_33_auto
  end
  local identity
  do
    local v_33_auto
    local function identity0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "identity"))
        else
        end
      end
      return x
    end
    v_33_auto = identity0
    core["identity"] = v_33_auto
    identity = v_33_auto
  end
  local comp
  do
    local v_33_auto
    local function comp0(...)
      local _319_ = select("#", ...)
      if (_319_ == 0) then
        return identity
      elseif (_319_ == 1) then
        local f = ...
        return f
      elseif (_319_ == 2) then
        local f, g = ...
        local function fn_320_(...)
          local _321_ = select("#", ...)
          if (_321_ == 0) then
            return f(g())
          elseif (_321_ == 1) then
            local x = ...
            return f(g(x))
          elseif (_321_ == 2) then
            local x, y = ...
            return f(g(x, y))
          elseif (_321_ == 3) then
            local x, y, z = ...
            return f(g(x, y, z))
          elseif true then
            local _ = _321_
            local core_48_auto = require("cljlib")
            local _let_322_ = core_48_auto.list(...)
            local x = _let_322_[1]
            local y = _let_322_[2]
            local z = _let_322_[3]
            local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_322_, 4)
            return f(apply(g, x, y, z, args))
          else
            return nil
          end
        end
        return fn_320_
      elseif true then
        local _ = _319_
        local core_48_auto = require("cljlib")
        local _let_324_ = core_48_auto.list(...)
        local f = _let_324_[1]
        local g = _let_324_[2]
        local fs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_324_, 3)
        return core.reduce(comp0, core.cons(f, core.cons(g, fs)))
      else
        return nil
      end
    end
    v_33_auto = comp0
    core["comp"] = v_33_auto
    comp = v_33_auto
  end
  local eq
  do
    local v_33_auto
    local function eq0(...)
      local _326_ = select("#", ...)
      if (_326_ == 0) then
        return true
      elseif (_326_ == 1) then
        local _ = ...
        return true
      elseif (_326_ == 2) then
        local a, b = ...
        if ((a == b) and (b == a)) then
          return true
        elseif (function(_327_,_328_,_329_) return (_327_ == _328_) and (_328_ == _329_) end)("table",type(a),type(b)) then
          local res, count_a = true, 0
          for k, v in pairs_2a(a) do
            if not res then break end
            local function _330_(...)
              local res0, done = nil, nil
              for k_2a, v0 in pairs_2a(b) do
                if done then break end
                if eq0(k_2a, k) then
                  res0, done = v0, true
                else
                end
              end
              return res0
            end
            res = eq0(v, _330_(...))
            count_a = (count_a + 1)
          end
          if res then
            local count_b
            do
              local res0 = 0
              for _, _0 in pairs_2a(b) do
                res0 = (res0 + 1)
              end
              count_b = res0
            end
            res = (count_a == count_b)
          else
          end
          return res
        else
          return false
        end
      elseif true then
        local _ = _326_
        local core_48_auto = require("cljlib")
        local _let_334_ = core_48_auto.list(...)
        local a = _let_334_[1]
        local b = _let_334_[2]
        local cs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_334_, 3)
        return (eq0(a, b) and apply(eq0, b, cs))
      else
        return nil
      end
    end
    v_33_auto = eq0
    core["eq"] = v_33_auto
    eq = v_33_auto
  end
  local function deep_index(tbl, key)
    local res = nil
    for k, v in pairs_2a(tbl) do
      if res then break end
      if eq(k, key) then
        res = v
      else
        res = nil
      end
    end
    return res
  end
  local function deep_newindex(tbl, key, val)
    local done = false
    if ("table" == type(key)) then
      for k, _ in pairs_2a(tbl) do
        if done then break end
        if eq(k, key) then
          rawset(tbl, k, val)
          done = true
        else
        end
      end
    else
    end
    if not done then
      return rawset(tbl, key, val)
    else
      return nil
    end
  end
  local memoize
  do
    local v_33_auto
    local function memoize0(...)
      local f = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "memoize"))
        else
        end
      end
      local memo = setmetatable({}, {__index = deep_index})
      local function fn_341_(...)
        local core_48_auto = require("cljlib")
        local _let_342_ = core_48_auto.list(...)
        local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_342_, 1)
        local _343_ = memo[args]
        if (nil ~= _343_) then
          local res = _343_
          return unpack_2a(res, 1, res.n)
        elseif true then
          local _ = _343_
          local res = pack_2a(f(...))
          do end (memo)[args] = res
          return unpack_2a(res, 1, res.n)
        else
          return nil
        end
      end
      return fn_341_
    end
    v_33_auto = memoize0
    core["memoize"] = v_33_auto
    memoize = v_33_auto
  end
  local deref
  do
    local v_33_auto
    local function deref0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "deref"))
        else
        end
      end
      local _346_ = getmetatable(x)
      if ((_G.type(_346_) == "table") and (nil ~= (_346_)["cljlib/deref"])) then
        local f = (_346_)["cljlib/deref"]
        return f(x)
      elseif true then
        local _ = _346_
        return error("object doesn't implement cljlib/deref metamethod", 2)
      else
        return nil
      end
    end
    v_33_auto = deref0
    core["deref"] = v_33_auto
    deref = v_33_auto
  end
  local empty
  do
    local v_33_auto
    local function empty0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "empty"))
        else
        end
      end
      local _349_ = getmetatable(x)
      if ((_G.type(_349_) == "table") and (nil ~= (_349_)["cljlib/empty"])) then
        local f = (_349_)["cljlib/empty"]
        return f()
      elseif true then
        local _ = _349_
        local _350_ = type(x)
        if (_350_ == "table") then
          return {}
        elseif (_350_ == "string") then
          return ""
        elseif true then
          local _0 = _350_
          return error(("don't know how to create empty variant of type " .. _0))
        else
          return nil
        end
      else
        return nil
      end
    end
    v_33_auto = empty0
    core["empty"] = v_33_auto
    empty = v_33_auto
  end
  local nil_3f
  do
    local v_33_auto
    local function nil_3f0(...)
      local _353_ = select("#", ...)
      if (_353_ == 0) then
        return true
      elseif (_353_ == 1) then
        local x = ...
        return (x == nil)
      elseif true then
        local _ = _353_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "nil?"))
      else
        return nil
      end
    end
    v_33_auto = nil_3f0
    core["nil?"] = v_33_auto
    nil_3f = v_33_auto
  end
  local zero_3f
  do
    local v_33_auto
    local function zero_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "zero?"))
        else
        end
      end
      return (x == 0)
    end
    v_33_auto = zero_3f0
    core["zero?"] = v_33_auto
    zero_3f = v_33_auto
  end
  local pos_3f
  do
    local v_33_auto
    local function pos_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "pos?"))
        else
        end
      end
      return (x > 0)
    end
    v_33_auto = pos_3f0
    core["pos?"] = v_33_auto
    pos_3f = v_33_auto
  end
  local neg_3f
  do
    local v_33_auto
    local function neg_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "neg?"))
        else
        end
      end
      return (x < 0)
    end
    v_33_auto = neg_3f0
    core["neg?"] = v_33_auto
    neg_3f = v_33_auto
  end
  local even_3f
  do
    local v_33_auto
    local function even_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "even?"))
        else
        end
      end
      return ((x % 2) == 0)
    end
    v_33_auto = even_3f0
    core["even?"] = v_33_auto
    even_3f = v_33_auto
  end
  local odd_3f
  do
    local v_33_auto
    local function odd_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "odd?"))
        else
        end
      end
      return not even_3f(x)
    end
    v_33_auto = odd_3f0
    core["odd?"] = v_33_auto
    odd_3f = v_33_auto
  end
  local string_3f
  do
    local v_33_auto
    local function string_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "string?"))
        else
        end
      end
      return (type(x) == "string")
    end
    v_33_auto = string_3f0
    core["string?"] = v_33_auto
    string_3f = v_33_auto
  end
  local boolean_3f
  do
    local v_33_auto
    local function boolean_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "boolean?"))
        else
        end
      end
      return (type(x) == "boolean")
    end
    v_33_auto = boolean_3f0
    core["boolean?"] = v_33_auto
    boolean_3f = v_33_auto
  end
  local true_3f
  do
    local v_33_auto
    local function true_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "true?"))
        else
        end
      end
      return (x == true)
    end
    v_33_auto = true_3f0
    core["true?"] = v_33_auto
    true_3f = v_33_auto
  end
  local false_3f
  do
    local v_33_auto
    local function false_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "false?"))
        else
        end
      end
      return (x == false)
    end
    v_33_auto = false_3f0
    core["false?"] = v_33_auto
    false_3f = v_33_auto
  end
  local int_3f
  do
    local v_33_auto
    local function int_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "int?"))
        else
        end
      end
      return ((type(x) == "number") and (x == math.floor(x)))
    end
    v_33_auto = int_3f0
    core["int?"] = v_33_auto
    int_3f = v_33_auto
  end
  local pos_int_3f
  do
    local v_33_auto
    local function pos_int_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "pos-int?"))
        else
        end
      end
      return (int_3f(x) and pos_3f(x))
    end
    v_33_auto = pos_int_3f0
    core["pos-int?"] = v_33_auto
    pos_int_3f = v_33_auto
  end
  local neg_int_3f
  do
    local v_33_auto
    local function neg_int_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "neg-int?"))
        else
        end
      end
      return (int_3f(x) and neg_3f(x))
    end
    v_33_auto = neg_int_3f0
    core["neg-int?"] = v_33_auto
    neg_int_3f = v_33_auto
  end
  local double_3f
  do
    local v_33_auto
    local function double_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "double?"))
        else
        end
      end
      return ((type(x) == "number") and (x ~= math.floor(x)))
    end
    v_33_auto = double_3f0
    core["double?"] = v_33_auto
    double_3f = v_33_auto
  end
  local empty_3f
  do
    local v_33_auto
    local function empty_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "empty?"))
        else
        end
      end
      local _369_ = type(x)
      if (_369_ == "table") then
        local _370_ = getmetatable(x)
        if ((_G.type(_370_) == "table") and ((_370_)["cljlib/type"] == "seq")) then
          return nil_3f(core.seq(x))
        elseif ((_370_ == nil) or ((_G.type(_370_) == "table") and ((_370_)["cljlib/type"] == nil))) then
          local next_2a = pairs_2a(x)
          return (next_2a(x) == nil)
        else
          return nil
        end
      elseif (_369_ == "string") then
        return (x == "")
      elseif (_369_ == "nil") then
        return true
      elseif true then
        local _ = _369_
        return error("empty?: unsupported collection")
      else
        return nil
      end
    end
    v_33_auto = empty_3f0
    core["empty?"] = v_33_auto
    empty_3f = v_33_auto
  end
  local not_empty
  do
    local v_33_auto
    local function not_empty0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "not-empty"))
        else
        end
      end
      if not empty_3f(x) then
        return x
      else
        return nil
      end
    end
    v_33_auto = not_empty0
    core["not-empty"] = v_33_auto
    not_empty = v_33_auto
  end
  local map_3f
  do
    local v_33_auto
    local function map_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "map?"))
        else
        end
      end
      if ("table" == type(x)) then
        local _376_ = getmetatable(x)
        if ((_G.type(_376_) == "table") and ((_376_)["cljlib/type"] == "hash-map")) then
          return true
        elseif ((_G.type(_376_) == "table") and ((_376_)["cljlib/type"] == "sorted-map")) then
          return true
        elseif ((_376_ == nil) or ((_G.type(_376_) == "table") and ((_376_)["cljlib/type"] == nil))) then
          local len = length_2a(x)
          local nxt, t, k = pairs_2a(x)
          local function _377_(...)
            if (len == 0) then
              return k
            else
              return len
            end
          end
          return (nil ~= nxt(t, _377_(...)))
        elseif true then
          local _ = _376_
          return false
        else
          return nil
        end
      else
        return false
      end
    end
    v_33_auto = map_3f0
    core["map?"] = v_33_auto
    map_3f = v_33_auto
  end
  local vector_3f
  do
    local v_33_auto
    local function vector_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "vector?"))
        else
        end
      end
      if ("table" == type(x)) then
        local _381_ = getmetatable(x)
        if ((_G.type(_381_) == "table") and ((_381_)["cljlib/type"] == "vector")) then
          return true
        elseif ((_381_ == nil) or ((_G.type(_381_) == "table") and ((_381_)["cljlib/type"] == nil))) then
          local len = length_2a(x)
          local nxt, t, k = pairs_2a(x)
          local function _382_(...)
            if (len == 0) then
              return k
            else
              return len
            end
          end
          if (nil ~= nxt(t, _382_(...))) then
            return false
          elseif (len > 0) then
            return true
          else
            return false
          end
        elseif true then
          local _ = _381_
          return false
        else
          return nil
        end
      else
        return false
      end
    end
    v_33_auto = vector_3f0
    core["vector?"] = v_33_auto
    vector_3f = v_33_auto
  end
  local set_3f
  do
    local v_33_auto
    local function set_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "set?"))
        else
        end
      end
      local _387_ = getmetatable(x)
      if ((_G.type(_387_) == "table") and ((_387_)["cljlib/type"] == "hash-set")) then
        return true
      elseif true then
        local _ = _387_
        return false
      else
        return nil
      end
    end
    v_33_auto = set_3f0
    core["set?"] = v_33_auto
    set_3f = v_33_auto
  end
  local seq_3f
  do
    local v_33_auto
    local function seq_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "seq?"))
        else
        end
      end
      return lazy["seq?"](x)
    end
    v_33_auto = seq_3f0
    core["seq?"] = v_33_auto
    seq_3f = v_33_auto
  end
  local some_3f
  do
    local v_33_auto
    local function some_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "some?"))
        else
        end
      end
      return (x ~= nil)
    end
    v_33_auto = some_3f0
    core["some?"] = v_33_auto
    some_3f = v_33_auto
  end
  local function vec__3etransient(immutable)
    local function _391_(vec)
      local len = #vec
      local function _392_(_, i)
        if (i <= len) then
          return vec[i]
        else
          return nil
        end
      end
      local function _394_()
        return len
      end
      local function _395_()
        return error("can't `conj` onto transient vector, use `conj!`")
      end
      local function _396_()
        return error("can't `assoc` onto transient vector, use `assoc!`")
      end
      local function _397_()
        return error("can't `dissoc` onto transient vector, use `dissoc!`")
      end
      local function _398_(tvec, v)
        len = (len + 1)
        tvec[len] = v
        return tvec
      end
      local function _399_(tvec, ...)
        do
          local len0 = #tvec
          for i = 1, select("#", ...), 2 do
            local k, v = select(i, ...)
            if (1 <= i) and (i <= len0) then
              tvec[i] = v
            else
              error(("index " .. i .. " is out of bounds"))
            end
          end
        end
        return tvec
      end
      local function _401_(tvec)
        if (len == 0) then
          return error("transient vector is empty", 2)
        else
          local val = table.remove(tvec)
          len = (len - 1)
          return tvec
        end
      end
      local function _403_()
        return error("can't `dissoc!` with a transient vector")
      end
      local function _404_(tvec)
        local v
        do
          local tbl_17_auto = {}
          local i_18_auto = #tbl_17_auto
          for i = 1, len do
            local val_19_auto = tvec[i]
            if (nil ~= val_19_auto) then
              i_18_auto = (i_18_auto + 1)
              do end (tbl_17_auto)[i_18_auto] = val_19_auto
            else
            end
          end
          v = tbl_17_auto
        end
        while (len > 0) do
          table.remove(tvec)
          len = (len - 1)
        end
        local function _406_()
          return error("attempt to use transient after it was persistet")
        end
        local function _407_()
          return error("attempt to use transient after it was persistet")
        end
        setmetatable(tvec, {__index = _406_, __newindex = _407_})
        return immutable(itable(v))
      end
      return setmetatable({}, {__index = _392_, __len = _394_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _395_, ["cljlib/assoc"] = _396_, ["cljlib/dissoc"] = _397_, ["cljlib/conj!"] = _398_, ["cljlib/assoc!"] = _399_, ["cljlib/pop!"] = _401_, ["cljlib/dissoc!"] = _403_, ["cljlib/persistent!"] = _404_})
    end
    return _391_
  end
  local function vec_2a(v, len)
    do
      local _408_ = getmetatable(v)
      if (nil ~= _408_) then
        local mt = _408_
        mt["__len"] = constantly((len or length_2a(v)))
        do end (mt)["cljlib/type"] = "vector"
        mt["cljlib/editable"] = true
        local function _409_(t, v0)
          local len0 = length_2a(t)
          return vec_2a(itable.assoc(t, (len0 + 1), v0), (len0 + 1))
        end
        mt["cljlib/conj"] = _409_
        local function _410_(t)
          local len0 = (length_2a(t) - 1)
          local coll = {}
          if (len0 < 0) then
            error("can't pop empty vector", 2)
          else
          end
          for i = 1, len0 do
            coll[i] = t[i]
          end
          return vec_2a(itable(coll), len0)
        end
        mt["cljlib/pop"] = _410_
        local function _412_()
          return vec_2a(itable({}))
        end
        mt["cljlib/empty"] = _412_
        mt["cljlib/transient"] = vec__3etransient(vec_2a)
        local function _413_(coll, view, inspector, indent)
          if empty_3f(coll) then
            return "[]"
          else
            local lines
            do
              local tbl_17_auto = {}
              local i_18_auto = #tbl_17_auto
              for i = 1, length_2a(coll) do
                local val_19_auto = (" " .. view(coll[i], inspector, indent))
                if (nil ~= val_19_auto) then
                  i_18_auto = (i_18_auto + 1)
                  do end (tbl_17_auto)[i_18_auto] = val_19_auto
                else
                end
              end
              lines = tbl_17_auto
            end
            lines[1] = ("[" .. string.gsub((lines[1] or ""), "^%s+", ""))
            do end (lines)[#lines] = (lines[#lines] .. "]")
            return lines
          end
        end
        mt["__fennelview"] = _413_
      elseif (_408_ == nil) then
        vec_2a(setmetatable(v, {}))
      else
      end
    end
    return v
  end
  local vec
  do
    local v_33_auto
    local function vec0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "vec"))
        else
        end
      end
      if empty_3f(coll) then
        return vec_2a(itable({}), 0)
      elseif vector_3f(coll) then
        return vec_2a(itable(coll), length_2a(coll))
      elseif "else" then
        local packed = lazy.pack(core.seq(coll))
        local len = packed.n
        local _418_
        do
          packed["n"] = nil
          _418_ = packed
        end
        return vec_2a(itable(_418_, {["fast-index?"] = true}), len)
      else
        return nil
      end
    end
    v_33_auto = vec0
    core["vec"] = v_33_auto
    vec = v_33_auto
  end
  local vector
  do
    local v_33_auto
    local function vector0(...)
      local core_48_auto = require("cljlib")
      local _let_420_ = core_48_auto.list(...)
      local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_420_, 1)
      return vec(args)
    end
    v_33_auto = vector0
    core["vector"] = v_33_auto
    vector = v_33_auto
  end
  local nth
  do
    local v_33_auto
    local function nth0(...)
      local _422_ = select("#", ...)
      if (_422_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "nth"))
      elseif (_422_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "nth"))
      elseif (_422_ == 2) then
        local coll, i = ...
        if vector_3f(coll) then
          if ((i < 1) or (length_2a(coll) < i)) then
            return error(string.format("index %d is out of bounds", i))
          else
            return coll[i]
          end
        elseif string_3f(coll) then
          return nth0(vec(coll), i)
        elseif seq_3f(coll) then
          return nth0(vec(coll), i)
        elseif "else" then
          return error("expected an indexed collection")
        else
          return nil
        end
      elseif (_422_ == 3) then
        local coll, i, not_found = ...
        assert(int_3f(i), "expected an integer key")
        if vector_3f(coll) then
          return (coll[i] or not_found)
        elseif string_3f(coll) then
          return nth0(vec(coll), i, not_found)
        elseif seq_3f(coll) then
          return nth0(vec(coll), i, not_found)
        elseif "else" then
          return error("expected an indexed collection")
        else
          return nil
        end
      elseif true then
        local _ = _422_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "nth"))
      else
        return nil
      end
    end
    v_33_auto = nth0
    core["nth"] = v_33_auto
    nth = v_33_auto
  end
  local seq_2a
  local function seq_2a0(...)
    local x = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "seq*"))
      else
      end
    end
    do
      local _428_ = getmetatable(x)
      if (nil ~= _428_) then
        local mt = _428_
        mt["cljlib/type"] = "seq"
        local function _429_(s, v)
          return core.cons(v, s)
        end
        mt["cljlib/conj"] = _429_
        local function _430_()
          return core.list()
        end
        mt["cljlib/empty"] = _430_
      else
      end
    end
    return x
  end
  seq_2a = seq_2a0
  local seq
  do
    local v_33_auto
    local function seq0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "seq"))
        else
        end
      end
      local function _434_(...)
        local _433_ = getmetatable(coll)
        if ((_G.type(_433_) == "table") and (nil ~= (_433_)["cljlib/seq"])) then
          local f = (_433_)["cljlib/seq"]
          return f(coll)
        elseif true then
          local _ = _433_
          if lazy["seq?"](coll) then
            return lazy.seq(coll)
          elseif map_3f(coll) then
            return lazy.map(vec, coll)
          elseif "else" then
            return lazy.seq(coll)
          else
            return nil
          end
        else
          return nil
        end
      end
      return seq_2a(_434_(...))
    end
    v_33_auto = seq0
    core["seq"] = v_33_auto
    seq = v_33_auto
  end
  local rseq
  do
    local v_33_auto
    local function rseq0(...)
      local rev = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "rseq"))
        else
        end
      end
      return seq_2a(lazy.rseq(rev))
    end
    v_33_auto = rseq0
    core["rseq"] = v_33_auto
    rseq = v_33_auto
  end
  local lazy_seq
  do
    local v_33_auto
    local function lazy_seq0(...)
      local f = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "lazy-seq"))
        else
        end
      end
      return seq_2a(lazy["lazy-seq"](f))
    end
    v_33_auto = lazy_seq0
    core["lazy-seq"] = v_33_auto
    lazy_seq = v_33_auto
  end
  local first
  do
    local v_33_auto
    local function first0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "first"))
        else
        end
      end
      return lazy.first(seq(coll))
    end
    v_33_auto = first0
    core["first"] = v_33_auto
    first = v_33_auto
  end
  local rest
  do
    local v_33_auto
    local function rest0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "rest"))
        else
        end
      end
      return seq_2a(lazy.rest(seq(coll)))
    end
    v_33_auto = rest0
    core["rest"] = v_33_auto
    rest = v_33_auto
  end
  local next_2a
  local function next_2a0(...)
    local s = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "next*"))
      else
      end
    end
    return seq_2a(lazy.next(s))
  end
  next_2a = next_2a0
  do
    core["next"] = next_2a
  end
  local count
  do
    local v_33_auto
    local function count0(...)
      local s = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "count"))
        else
        end
      end
      local _443_ = getmetatable(s)
      if ((_G.type(_443_) == "table") and ((_443_)["cljlib/type"] == "vector")) then
        return length_2a(s)
      elseif true then
        local _ = _443_
        return lazy.count(s)
      else
        return nil
      end
    end
    v_33_auto = count0
    core["count"] = v_33_auto
    count = v_33_auto
  end
  local cons
  do
    local v_33_auto
    local function cons0(...)
      local head, tail = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "cons"))
        else
        end
      end
      return seq_2a(lazy.cons(head, tail))
    end
    v_33_auto = cons0
    core["cons"] = v_33_auto
    cons = v_33_auto
  end
  local function list(...)
    return seq_2a(lazy.list(...))
  end
  core.list = list
  local list_2a
  do
    local v_33_auto
    local function list_2a0(...)
      local core_48_auto = require("cljlib")
      local _let_446_ = core_48_auto.list(...)
      local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_446_, 1)
      return seq_2a(apply(lazy["list*"], args))
    end
    v_33_auto = list_2a0
    core["list*"] = v_33_auto
    list_2a = v_33_auto
  end
  local last
  do
    local v_33_auto
    local function last0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "last"))
        else
        end
      end
      local _448_ = next_2a(coll)
      if (nil ~= _448_) then
        local coll_2a = _448_
        return last0(coll_2a)
      elseif true then
        local _ = _448_
        return first(coll)
      else
        return nil
      end
    end
    v_33_auto = last0
    core["last"] = v_33_auto
    last = v_33_auto
  end
  local butlast
  do
    local v_33_auto
    local function butlast0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "butlast"))
        else
        end
      end
      return seq(lazy["drop-last"](coll))
    end
    v_33_auto = butlast0
    core["butlast"] = v_33_auto
    butlast = v_33_auto
  end
  local map
  do
    local v_33_auto
    local function map0(...)
      local _451_ = select("#", ...)
      if (_451_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "map"))
      elseif (_451_ == 1) then
        local f = ...
        local function fn_452_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_452_"))
            else
            end
          end
          local function fn_454_(...)
            local _455_ = select("#", ...)
            if (_455_ == 0) then
              return rf()
            elseif (_455_ == 1) then
              local result = ...
              return rf(result)
            elseif (_455_ == 2) then
              local result, input = ...
              return rf(result, f(input))
            elseif true then
              local _ = _455_
              local core_48_auto = require("cljlib")
              local _let_456_ = core_48_auto.list(...)
              local result = _let_456_[1]
              local input = _let_456_[2]
              local inputs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_456_, 3)
              return rf(result, apply(f, input, inputs))
            else
              return nil
            end
          end
          return fn_454_
        end
        return fn_452_
      elseif (_451_ == 2) then
        local f, coll = ...
        return seq_2a(lazy.map(f, coll))
      elseif true then
        local _ = _451_
        local core_48_auto = require("cljlib")
        local _let_458_ = core_48_auto.list(...)
        local f = _let_458_[1]
        local coll = _let_458_[2]
        local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_458_, 3)
        return seq_2a(apply(lazy.map, f, coll, colls))
      else
        return nil
      end
    end
    v_33_auto = map0
    core["map"] = v_33_auto
    map = v_33_auto
  end
  local mapv
  do
    local v_33_auto
    local function mapv0(...)
      local _461_ = select("#", ...)
      if (_461_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "mapv"))
      elseif (_461_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "mapv"))
      elseif (_461_ == 2) then
        local f, coll = ...
        return core["persistent!"](core.transduce(map(f), core["conj!"], core.transient(vector()), coll))
      elseif true then
        local _ = _461_
        local core_48_auto = require("cljlib")
        local _let_462_ = core_48_auto.list(...)
        local f = _let_462_[1]
        local coll = _let_462_[2]
        local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_462_, 3)
        return vec(apply(map, f, coll, colls))
      else
        return nil
      end
    end
    v_33_auto = mapv0
    core["mapv"] = v_33_auto
    mapv = v_33_auto
  end
  local map_indexed
  do
    local v_33_auto
    local function map_indexed0(...)
      local _464_ = select("#", ...)
      if (_464_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "map-indexed"))
      elseif (_464_ == 1) then
        local f = ...
        local function fn_465_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_465_"))
            else
            end
          end
          local i = -1
          local function fn_467_(...)
            local _468_ = select("#", ...)
            if (_468_ == 0) then
              return rf()
            elseif (_468_ == 1) then
              local result = ...
              return rf(result)
            elseif (_468_ == 2) then
              local result, input = ...
              i = (i + 1)
              return rf(result, f(i, input))
            elseif true then
              local _ = _468_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_467_"))
            else
              return nil
            end
          end
          return fn_467_
        end
        return fn_465_
      elseif (_464_ == 2) then
        local f, coll = ...
        return seq_2a(lazy["map-indexed"](f, coll))
      elseif true then
        local _ = _464_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "map-indexed"))
      else
        return nil
      end
    end
    v_33_auto = map_indexed0
    core["map-indexed"] = v_33_auto
    map_indexed = v_33_auto
  end
  local mapcat
  do
    local v_33_auto
    local function mapcat0(...)
      local _471_ = select("#", ...)
      if (_471_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "mapcat"))
      elseif (_471_ == 1) then
        local f = ...
        return comp(map(f), core.cat)
      elseif true then
        local _ = _471_
        local core_48_auto = require("cljlib")
        local _let_472_ = core_48_auto.list(...)
        local f = _let_472_[1]
        local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_472_, 2)
        return seq_2a(apply(lazy.mapcat, f, colls))
      else
        return nil
      end
    end
    v_33_auto = mapcat0
    core["mapcat"] = v_33_auto
    mapcat = v_33_auto
  end
  local filter
  do
    local v_33_auto
    local function filter0(...)
      local _474_ = select("#", ...)
      if (_474_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "filter"))
      elseif (_474_ == 1) then
        local pred = ...
        local function fn_475_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_475_"))
            else
            end
          end
          local function fn_477_(...)
            local _478_ = select("#", ...)
            if (_478_ == 0) then
              return rf()
            elseif (_478_ == 1) then
              local result = ...
              return rf(result)
            elseif (_478_ == 2) then
              local result, input = ...
              if pred(input) then
                return rf(result, input)
              else
                return result
              end
            elseif true then
              local _ = _478_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_477_"))
            else
              return nil
            end
          end
          return fn_477_
        end
        return fn_475_
      elseif (_474_ == 2) then
        local pred, coll = ...
        return seq_2a(lazy.filter(pred, coll))
      elseif true then
        local _ = _474_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "filter"))
      else
        return nil
      end
    end
    v_33_auto = filter0
    core["filter"] = v_33_auto
    filter = v_33_auto
  end
  local filterv
  do
    local v_33_auto
    local function filterv0(...)
      local pred, coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "filterv"))
        else
        end
      end
      return vec(filter(pred, coll))
    end
    v_33_auto = filterv0
    core["filterv"] = v_33_auto
    filterv = v_33_auto
  end
  local every_3f
  do
    local v_33_auto
    local function every_3f0(...)
      local pred, coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "every?"))
        else
        end
      end
      return lazy["every?"](pred, coll)
    end
    v_33_auto = every_3f0
    core["every?"] = v_33_auto
    every_3f = v_33_auto
  end
  local some
  do
    local v_33_auto
    local function some0(...)
      local pred, coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "some"))
        else
        end
      end
      return lazy["some?"](pred, coll)
    end
    v_33_auto = some0
    core["some"] = v_33_auto
    some = v_33_auto
  end
  local not_any_3f
  do
    local v_33_auto
    local function not_any_3f0(...)
      local pred, coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "not-any?"))
        else
        end
      end
      local function _486_(_241)
        return not pred(_241)
      end
      return some(_486_, coll)
    end
    v_33_auto = not_any_3f0
    core["not-any?"] = v_33_auto
    not_any_3f = v_33_auto
  end
  local range
  do
    local v_33_auto
    local function range0(...)
      local _487_ = select("#", ...)
      if (_487_ == 0) then
        return seq_2a(lazy.range())
      elseif (_487_ == 1) then
        local upper = ...
        return seq_2a(lazy.range(upper))
      elseif (_487_ == 2) then
        local lower, upper = ...
        return seq_2a(lazy.range(lower, upper))
      elseif (_487_ == 3) then
        local lower, upper, step = ...
        return seq_2a(lazy.range(lower, upper, step))
      elseif true then
        local _ = _487_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "range"))
      else
        return nil
      end
    end
    v_33_auto = range0
    core["range"] = v_33_auto
    range = v_33_auto
  end
  local concat
  do
    local v_33_auto
    local function concat0(...)
      local core_48_auto = require("cljlib")
      local _let_489_ = core_48_auto.list(...)
      local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_489_, 1)
      return seq_2a(apply(lazy.concat, colls))
    end
    v_33_auto = concat0
    core["concat"] = v_33_auto
    concat = v_33_auto
  end
  local reverse
  do
    local v_33_auto
    local function reverse0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "reverse"))
        else
        end
      end
      return seq_2a(lazy.reverse(coll))
    end
    v_33_auto = reverse0
    core["reverse"] = v_33_auto
    reverse = v_33_auto
  end
  local take
  do
    local v_33_auto
    local function take0(...)
      local _491_ = select("#", ...)
      if (_491_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "take"))
      elseif (_491_ == 1) then
        local n = ...
        local function fn_492_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_492_"))
            else
            end
          end
          local n0 = n
          local function fn_494_(...)
            local _495_ = select("#", ...)
            if (_495_ == 0) then
              return rf()
            elseif (_495_ == 1) then
              local result = ...
              return rf(result)
            elseif (_495_ == 2) then
              local result, input = ...
              local result0
              if (0 < n0) then
                result0 = rf(result, input)
              else
                result0 = result
              end
              n0 = (n0 - 1)
              if not (0 < n0) then
                return core["ensure-reduced"](result0)
              else
                return result0
              end
            elseif true then
              local _ = _495_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_494_"))
            else
              return nil
            end
          end
          return fn_494_
        end
        return fn_492_
      elseif (_491_ == 2) then
        local n, coll = ...
        return seq_2a(lazy.take(n, coll))
      elseif true then
        local _ = _491_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "take"))
      else
        return nil
      end
    end
    v_33_auto = take0
    core["take"] = v_33_auto
    take = v_33_auto
  end
  local take_while
  do
    local v_33_auto
    local function take_while0(...)
      local _500_ = select("#", ...)
      if (_500_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "take-while"))
      elseif (_500_ == 1) then
        local pred = ...
        local function fn_501_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_501_"))
            else
            end
          end
          local function fn_503_(...)
            local _504_ = select("#", ...)
            if (_504_ == 0) then
              return rf()
            elseif (_504_ == 1) then
              local result = ...
              return rf(result)
            elseif (_504_ == 2) then
              local result, input = ...
              if pred(input) then
                return rf(result, input)
              else
                return core.reduced(result)
              end
            elseif true then
              local _ = _504_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_503_"))
            else
              return nil
            end
          end
          return fn_503_
        end
        return fn_501_
      elseif (_500_ == 2) then
        local pred, coll = ...
        return seq_2a(lazy["take-while"](pred, coll))
      elseif true then
        local _ = _500_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "take-while"))
      else
        return nil
      end
    end
    v_33_auto = take_while0
    core["take-while"] = v_33_auto
    take_while = v_33_auto
  end
  local drop
  do
    local v_33_auto
    local function drop0(...)
      local _508_ = select("#", ...)
      if (_508_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "drop"))
      elseif (_508_ == 1) then
        local n = ...
        local function fn_509_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_509_"))
            else
            end
          end
          local nv = n
          local function fn_511_(...)
            local _512_ = select("#", ...)
            if (_512_ == 0) then
              return rf()
            elseif (_512_ == 1) then
              local result = ...
              return rf(result)
            elseif (_512_ == 2) then
              local result, input = ...
              local n0 = nv
              nv = (nv - 1)
              if pos_3f(n0) then
                return result
              else
                return rf(result, input)
              end
            elseif true then
              local _ = _512_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_511_"))
            else
              return nil
            end
          end
          return fn_511_
        end
        return fn_509_
      elseif (_508_ == 2) then
        local n, coll = ...
        return seq_2a(lazy.drop(n, coll))
      elseif true then
        local _ = _508_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "drop"))
      else
        return nil
      end
    end
    v_33_auto = drop0
    core["drop"] = v_33_auto
    drop = v_33_auto
  end
  local drop_while
  do
    local v_33_auto
    local function drop_while0(...)
      local _516_ = select("#", ...)
      if (_516_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "drop-while"))
      elseif (_516_ == 1) then
        local pred = ...
        local function fn_517_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_517_"))
            else
            end
          end
          local dv = true
          local function fn_519_(...)
            local _520_ = select("#", ...)
            if (_520_ == 0) then
              return rf()
            elseif (_520_ == 1) then
              local result = ...
              return rf(result)
            elseif (_520_ == 2) then
              local result, input = ...
              local drop_3f = dv
              if (drop_3f and pred(input)) then
                return result
              else
                dv = nil
                return rf(result, input)
              end
            elseif true then
              local _ = _520_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_519_"))
            else
              return nil
            end
          end
          return fn_519_
        end
        return fn_517_
      elseif (_516_ == 2) then
        local pred, coll = ...
        return seq_2a(lazy["drop-while"](pred, coll))
      elseif true then
        local _ = _516_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "drop-while"))
      else
        return nil
      end
    end
    v_33_auto = drop_while0
    core["drop-while"] = v_33_auto
    drop_while = v_33_auto
  end
  local drop_last
  do
    local v_33_auto
    local function drop_last0(...)
      local _524_ = select("#", ...)
      if (_524_ == 0) then
        return seq_2a(lazy["drop-last"]())
      elseif (_524_ == 1) then
        local coll = ...
        return seq_2a(lazy["drop-last"](coll))
      elseif (_524_ == 2) then
        local n, coll = ...
        return seq_2a(lazy["drop-last"](n, coll))
      elseif true then
        local _ = _524_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "drop-last"))
      else
        return nil
      end
    end
    v_33_auto = drop_last0
    core["drop-last"] = v_33_auto
    drop_last = v_33_auto
  end
  local take_last
  do
    local v_33_auto
    local function take_last0(...)
      local n, coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "take-last"))
        else
        end
      end
      return seq_2a(lazy["take-last"](n, coll))
    end
    v_33_auto = take_last0
    core["take-last"] = v_33_auto
    take_last = v_33_auto
  end
  local take_nth
  do
    local v_33_auto
    local function take_nth0(...)
      local _527_ = select("#", ...)
      if (_527_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "take-nth"))
      elseif (_527_ == 1) then
        local n = ...
        local function fn_528_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_528_"))
            else
            end
          end
          local iv = -1
          local function fn_530_(...)
            local _531_ = select("#", ...)
            if (_531_ == 0) then
              return rf()
            elseif (_531_ == 1) then
              local result = ...
              return rf(result)
            elseif (_531_ == 2) then
              local result, input = ...
              iv = (iv + 1)
              if (0 == (iv % n)) then
                return rf(result, input)
              else
                return result
              end
            elseif true then
              local _ = _531_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_530_"))
            else
              return nil
            end
          end
          return fn_530_
        end
        return fn_528_
      elseif (_527_ == 2) then
        local n, coll = ...
        return seq_2a(lazy["take-nth"](n, coll))
      elseif true then
        local _ = _527_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "take-nth"))
      else
        return nil
      end
    end
    v_33_auto = take_nth0
    core["take-nth"] = v_33_auto
    take_nth = v_33_auto
  end
  local split_at
  do
    local v_33_auto
    local function split_at0(...)
      local n, coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "split-at"))
        else
        end
      end
      return vec(lazy["split-at"](n, coll))
    end
    v_33_auto = split_at0
    core["split-at"] = v_33_auto
    split_at = v_33_auto
  end
  local split_with
  do
    local v_33_auto
    local function split_with0(...)
      local pred, coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "split-with"))
        else
        end
      end
      return vec(lazy["split-with"](pred, coll))
    end
    v_33_auto = split_with0
    core["split-with"] = v_33_auto
    split_with = v_33_auto
  end
  local nthrest
  do
    local v_33_auto
    local function nthrest0(...)
      local coll, n = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "nthrest"))
        else
        end
      end
      return seq_2a(lazy.nthrest(coll, n))
    end
    v_33_auto = nthrest0
    core["nthrest"] = v_33_auto
    nthrest = v_33_auto
  end
  local nthnext
  do
    local v_33_auto
    local function nthnext0(...)
      local coll, n = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "nthnext"))
        else
        end
      end
      return lazy.nthnext(coll, n)
    end
    v_33_auto = nthnext0
    core["nthnext"] = v_33_auto
    nthnext = v_33_auto
  end
  local keep
  do
    local v_33_auto
    local function keep0(...)
      local _539_ = select("#", ...)
      if (_539_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "keep"))
      elseif (_539_ == 1) then
        local f = ...
        local function fn_540_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_540_"))
            else
            end
          end
          local function fn_542_(...)
            local _543_ = select("#", ...)
            if (_543_ == 0) then
              return rf()
            elseif (_543_ == 1) then
              local result = ...
              return rf(result)
            elseif (_543_ == 2) then
              local result, input = ...
              local v = f(input)
              if nil_3f(v) then
                return result
              else
                return rf(result, v)
              end
            elseif true then
              local _ = _543_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_542_"))
            else
              return nil
            end
          end
          return fn_542_
        end
        return fn_540_
      elseif (_539_ == 2) then
        local f, coll = ...
        return seq_2a(lazy.keep(f, coll))
      elseif true then
        local _ = _539_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "keep"))
      else
        return nil
      end
    end
    v_33_auto = keep0
    core["keep"] = v_33_auto
    keep = v_33_auto
  end
  local keep_indexed
  do
    local v_33_auto
    local function keep_indexed0(...)
      local _547_ = select("#", ...)
      if (_547_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "keep-indexed"))
      elseif (_547_ == 1) then
        local f = ...
        local function fn_548_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_548_"))
            else
            end
          end
          local iv = -1
          local function fn_550_(...)
            local _551_ = select("#", ...)
            if (_551_ == 0) then
              return rf()
            elseif (_551_ == 1) then
              local result = ...
              return rf(result)
            elseif (_551_ == 2) then
              local result, input = ...
              iv = (iv + 1)
              local v = f(iv, input)
              if nil_3f(v) then
                return result
              else
                return rf(result, v)
              end
            elseif true then
              local _ = _551_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_550_"))
            else
              return nil
            end
          end
          return fn_550_
        end
        return fn_548_
      elseif (_547_ == 2) then
        local f, coll = ...
        return seq_2a(lazy["keep-indexed"](f, coll))
      elseif true then
        local _ = _547_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "keep-indexed"))
      else
        return nil
      end
    end
    v_33_auto = keep_indexed0
    core["keep-indexed"] = v_33_auto
    keep_indexed = v_33_auto
  end
  local partition
  do
    local v_33_auto
    local function partition0(...)
      local _556_ = select("#", ...)
      if (_556_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "partition"))
      elseif (_556_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "partition"))
      elseif (_556_ == 2) then
        local n, coll = ...
        return map(seq_2a, lazy.partition(n, coll))
      elseif (_556_ == 3) then
        local n, step, coll = ...
        return map(seq_2a, lazy.partition(n, step, coll))
      elseif (_556_ == 4) then
        local n, step, pad, coll = ...
        return map(seq_2a, lazy.partition(n, step, pad, coll))
      elseif true then
        local _ = _556_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "partition"))
      else
        return nil
      end
    end
    v_33_auto = partition0
    core["partition"] = v_33_auto
    partition = v_33_auto
  end
  local function array()
    local len = 0
    local function _558_()
      return len
    end
    local function _559_(self)
      while (0 ~= len) do
        self[len] = nil
        len = (len - 1)
      end
      return nil
    end
    local function _560_(self, val)
      len = (len + 1)
      do end (self)[len] = val
      return self
    end
    return setmetatable({}, {__len = _558_, __index = {clear = _559_, add = _560_}})
  end
  local partition_by
  do
    local v_33_auto
    local function partition_by0(...)
      local _561_ = select("#", ...)
      if (_561_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "partition-by"))
      elseif (_561_ == 1) then
        local f = ...
        local function fn_562_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_562_"))
            else
            end
          end
          local a = array()
          local none = {}
          local pv = none
          local function fn_564_(...)
            local _565_ = select("#", ...)
            if (_565_ == 0) then
              return rf()
            elseif (_565_ == 1) then
              local result = ...
              local function _566_(...)
                if empty_3f(a) then
                  return result
                else
                  local v = vec(a)
                  a:clear()
                  return core.unreduced(rf(result, v))
                end
              end
              return rf(_566_(...))
            elseif (_565_ == 2) then
              local result, input = ...
              local pval = pv
              local val = f(input)
              pv = val
              if ((pval == none) or (val == pval)) then
                a:add(input)
                return result
              else
                local v = vec(a)
                a:clear()
                local ret = rf(result, v)
                if not core["reduced?"](ret) then
                  a:add(input)
                else
                end
                return ret
              end
            elseif true then
              local _ = _565_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_564_"))
            else
              return nil
            end
          end
          return fn_564_
        end
        return fn_562_
      elseif (_561_ == 2) then
        local f, coll = ...
        return map(seq_2a, lazy["partition-by"](f, coll))
      elseif true then
        local _ = _561_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "partition-by"))
      else
        return nil
      end
    end
    v_33_auto = partition_by0
    core["partition-by"] = v_33_auto
    partition_by = v_33_auto
  end
  local partition_all
  do
    local v_33_auto
    local function partition_all0(...)
      local _571_ = select("#", ...)
      if (_571_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "partition-all"))
      elseif (_571_ == 1) then
        local n = ...
        local function fn_572_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_572_"))
            else
            end
          end
          local a = array()
          local function fn_574_(...)
            local _575_ = select("#", ...)
            if (_575_ == 0) then
              return rf()
            elseif (_575_ == 1) then
              local result = ...
              local function _576_(...)
                if (0 == #a) then
                  return result
                else
                  local v = vec(a)
                  a:clear()
                  return core.unreduced(rf(result, v))
                end
              end
              return rf(_576_(...))
            elseif (_575_ == 2) then
              local result, input = ...
              a:add(input)
              if (n == #a) then
                local v = vec(a)
                a:clear()
                return rf(result, v)
              else
                return result
              end
            elseif true then
              local _ = _575_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_574_"))
            else
              return nil
            end
          end
          return fn_574_
        end
        return fn_572_
      elseif (_571_ == 2) then
        local n, coll = ...
        return map(seq_2a, lazy["partition-all"](n, coll))
      elseif (_571_ == 3) then
        local n, step, coll = ...
        return map(seq_2a, lazy["partition-all"](n, step, coll))
      elseif true then
        local _ = _571_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "partition-all"))
      else
        return nil
      end
    end
    v_33_auto = partition_all0
    core["partition-all"] = v_33_auto
    partition_all = v_33_auto
  end
  local reductions
  do
    local v_33_auto
    local function reductions0(...)
      local _581_ = select("#", ...)
      if (_581_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "reductions"))
      elseif (_581_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "reductions"))
      elseif (_581_ == 2) then
        local f, coll = ...
        return seq_2a(lazy.reductions(f, coll))
      elseif (_581_ == 3) then
        local f, init, coll = ...
        return seq_2a(lazy.reductions(f, init, coll))
      elseif true then
        local _ = _581_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "reductions"))
      else
        return nil
      end
    end
    v_33_auto = reductions0
    core["reductions"] = v_33_auto
    reductions = v_33_auto
  end
  local contains_3f
  do
    local v_33_auto
    local function contains_3f0(...)
      local coll, elt = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "contains?"))
        else
        end
      end
      return lazy["contains?"](coll, elt)
    end
    v_33_auto = contains_3f0
    core["contains?"] = v_33_auto
    contains_3f = v_33_auto
  end
  local distinct
  do
    local v_33_auto
    local function distinct0(...)
      local _584_ = select("#", ...)
      if (_584_ == 0) then
        local function fn_585_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_585_"))
            else
            end
          end
          local seen = setmetatable({}, {__index = deep_index})
          local function fn_587_(...)
            local _588_ = select("#", ...)
            if (_588_ == 0) then
              return rf()
            elseif (_588_ == 1) then
              local result = ...
              return rf(result)
            elseif (_588_ == 2) then
              local result, input = ...
              if seen[input] then
                return result
              else
                seen[input] = true
                return rf(result, input)
              end
            elseif true then
              local _ = _588_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_587_"))
            else
              return nil
            end
          end
          return fn_587_
        end
        return fn_585_
      elseif (_584_ == 1) then
        local coll = ...
        return seq_2a(lazy.distinct(coll))
      elseif true then
        local _ = _584_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "distinct"))
      else
        return nil
      end
    end
    v_33_auto = distinct0
    core["distinct"] = v_33_auto
    distinct = v_33_auto
  end
  local dedupe
  do
    local v_33_auto
    local function dedupe0(...)
      local _592_ = select("#", ...)
      if (_592_ == 0) then
        local function fn_593_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_593_"))
            else
            end
          end
          local none = {}
          local pv = none
          local function fn_595_(...)
            local _596_ = select("#", ...)
            if (_596_ == 0) then
              return rf()
            elseif (_596_ == 1) then
              local result = ...
              return rf(result)
            elseif (_596_ == 2) then
              local result, input = ...
              local prior = pv
              pv = input
              if (prior == input) then
                return result
              else
                return rf(result, input)
              end
            elseif true then
              local _ = _596_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_595_"))
            else
              return nil
            end
          end
          return fn_595_
        end
        return fn_593_
      elseif (_592_ == 1) then
        local coll = ...
        return core.sequence(dedupe0(), coll)
      elseif true then
        local _ = _592_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "dedupe"))
      else
        return nil
      end
    end
    v_33_auto = dedupe0
    core["dedupe"] = v_33_auto
    dedupe = v_33_auto
  end
  local random_sample
  do
    local v_33_auto
    local function random_sample0(...)
      local _600_ = select("#", ...)
      if (_600_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "random-sample"))
      elseif (_600_ == 1) then
        local prob = ...
        local function _601_()
          return (math.random() < prob)
        end
        return filter(_601_)
      elseif (_600_ == 2) then
        local prob, coll = ...
        local function _602_()
          return (math.random() < prob)
        end
        return filter(_602_, coll)
      elseif true then
        local _ = _600_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "random-sample"))
      else
        return nil
      end
    end
    v_33_auto = random_sample0
    core["random-sample"] = v_33_auto
    random_sample = v_33_auto
  end
  local doall
  do
    local v_33_auto
    local function doall0(...)
      local seq0 = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "doall"))
        else
        end
      end
      return seq_2a(lazy.doall(seq0))
    end
    v_33_auto = doall0
    core["doall"] = v_33_auto
    doall = v_33_auto
  end
  local dorun
  do
    local v_33_auto
    local function dorun0(...)
      local seq0 = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "dorun"))
        else
        end
      end
      return lazy.dorun(seq0)
    end
    v_33_auto = dorun0
    core["dorun"] = v_33_auto
    dorun = v_33_auto
  end
  local line_seq
  do
    local v_33_auto
    local function line_seq0(...)
      local file = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "line-seq"))
        else
        end
      end
      return seq_2a(lazy["line-seq"](file))
    end
    v_33_auto = line_seq0
    core["line-seq"] = v_33_auto
    line_seq = v_33_auto
  end
  local iterate
  do
    local v_33_auto
    local function iterate0(...)
      local f, x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "iterate"))
        else
        end
      end
      return seq_2a(lazy.iterate(f, x))
    end
    v_33_auto = iterate0
    core["iterate"] = v_33_auto
    iterate = v_33_auto
  end
  local remove
  do
    local v_33_auto
    local function remove0(...)
      local _608_ = select("#", ...)
      if (_608_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "remove"))
      elseif (_608_ == 1) then
        local pred = ...
        return filter(complement(pred))
      elseif (_608_ == 2) then
        local pred, coll = ...
        return seq_2a(lazy.remove(pred, coll))
      elseif true then
        local _ = _608_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "remove"))
      else
        return nil
      end
    end
    v_33_auto = remove0
    core["remove"] = v_33_auto
    remove = v_33_auto
  end
  local cycle
  do
    local v_33_auto
    local function cycle0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "cycle"))
        else
        end
      end
      return seq_2a(lazy.cycle(coll))
    end
    v_33_auto = cycle0
    core["cycle"] = v_33_auto
    cycle = v_33_auto
  end
  local _repeat
  do
    local v_33_auto
    local function _repeat0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "repeat"))
        else
        end
      end
      return seq_2a(lazy["repeat"](x))
    end
    v_33_auto = _repeat0
    core["repeat"] = v_33_auto
    _repeat = v_33_auto
  end
  local repeatedly
  do
    local v_33_auto
    local function repeatedly0(...)
      local core_48_auto = require("cljlib")
      local _let_612_ = core_48_auto.list(...)
      local f = _let_612_[1]
      local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_612_, 2)
      return seq_2a(apply(lazy.repeatedly, f, args))
    end
    v_33_auto = repeatedly0
    core["repeatedly"] = v_33_auto
    repeatedly = v_33_auto
  end
  local tree_seq
  do
    local v_33_auto
    local function tree_seq0(...)
      local branch_3f, children, root = ...
      do
        local cnt_68_auto = select("#", ...)
        if (3 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "tree-seq"))
        else
        end
      end
      return seq_2a(lazy["tree-seq"](branch_3f, children, root))
    end
    v_33_auto = tree_seq0
    core["tree-seq"] = v_33_auto
    tree_seq = v_33_auto
  end
  local interleave
  do
    local v_33_auto
    local function interleave0(...)
      local _614_ = select("#", ...)
      if (_614_ == 0) then
        return seq_2a(lazy.interleave())
      elseif (_614_ == 1) then
        local s = ...
        return seq_2a(lazy.interleave(s))
      elseif (_614_ == 2) then
        local s1, s2 = ...
        return seq_2a(lazy.interleave(s1, s2))
      elseif true then
        local _ = _614_
        local core_48_auto = require("cljlib")
        local _let_615_ = core_48_auto.list(...)
        local s1 = _let_615_[1]
        local s2 = _let_615_[2]
        local ss = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_615_, 3)
        return seq_2a(apply(lazy.interleave, s1, s2, ss))
      else
        return nil
      end
    end
    v_33_auto = interleave0
    core["interleave"] = v_33_auto
    interleave = v_33_auto
  end
  local interpose
  do
    local v_33_auto
    local function interpose0(...)
      local _617_ = select("#", ...)
      if (_617_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "interpose"))
      elseif (_617_ == 1) then
        local sep = ...
        local function fn_618_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_618_"))
            else
            end
          end
          local started = false
          local function fn_620_(...)
            local _621_ = select("#", ...)
            if (_621_ == 0) then
              return rf()
            elseif (_621_ == 1) then
              local result = ...
              return rf(result)
            elseif (_621_ == 2) then
              local result, input = ...
              if started then
                local sepr = rf(result, sep)
                if core["reduced?"](sepr) then
                  return sepr
                else
                  return rf(sepr, input)
                end
              else
                started = true
                return rf(result, input)
              end
            elseif true then
              local _ = _621_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_620_"))
            else
              return nil
            end
          end
          return fn_620_
        end
        return fn_618_
      elseif (_617_ == 2) then
        local separator, coll = ...
        return seq_2a(lazy.interpose(separator, coll))
      elseif true then
        local _ = _617_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "interpose"))
      else
        return nil
      end
    end
    v_33_auto = interpose0
    core["interpose"] = v_33_auto
    interpose = v_33_auto
  end
  local halt_when
  do
    local v_33_auto
    local function halt_when0(...)
      local _626_ = select("#", ...)
      if (_626_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "halt-when"))
      elseif (_626_ == 1) then
        local pred = ...
        return halt_when0(pred, nil)
      elseif (_626_ == 2) then
        local pred, retf = ...
        local function fn_627_(...)
          local rf = ...
          do
            local cnt_68_auto = select("#", ...)
            if (1 ~= cnt_68_auto) then
              error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_627_"))
            else
            end
          end
          local halt
          local function _629_()
            return "#<halt>"
          end
          halt = setmetatable({}, {__fennelview = _629_})
          local function fn_630_(...)
            local _631_ = select("#", ...)
            if (_631_ == 0) then
              return rf()
            elseif (_631_ == 1) then
              local result = ...
              if (map_3f(result) and contains_3f(result, halt)) then
                return result.value
              else
                return rf(result)
              end
            elseif (_631_ == 2) then
              local result, input = ...
              if pred(input) then
                local _633_
                if retf then
                  _633_ = retf(rf(result), input)
                else
                  _633_ = input
                end
                return core.reduced({[halt] = true, value = _633_})
              else
                return rf(result, input)
              end
            elseif true then
              local _ = _631_
              return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_630_"))
            else
              return nil
            end
          end
          return fn_630_
        end
        return fn_627_
      elseif true then
        local _ = _626_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "halt-when"))
      else
        return nil
      end
    end
    v_33_auto = halt_when0
    core["halt-when"] = v_33_auto
    halt_when = v_33_auto
  end
  local realized_3f
  do
    local v_33_auto
    local function realized_3f0(...)
      local s = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "realized?"))
        else
        end
      end
      return lazy["realized?"](s)
    end
    v_33_auto = realized_3f0
    core["realized?"] = v_33_auto
    realized_3f = v_33_auto
  end
  local keys
  do
    local v_33_auto
    local function keys0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "keys"))
        else
        end
      end
      assert((map_3f(coll) or empty_3f(coll)), "expected a map")
      if empty_3f(coll) then
        return lazy.list()
      else
        return lazy.keys(coll)
      end
    end
    v_33_auto = keys0
    core["keys"] = v_33_auto
    keys = v_33_auto
  end
  local vals
  do
    local v_33_auto
    local function vals0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "vals"))
        else
        end
      end
      assert((map_3f(coll) or empty_3f(coll)), "expected a map")
      if empty_3f(coll) then
        return lazy.list()
      else
        return lazy.vals(coll)
      end
    end
    v_33_auto = vals0
    core["vals"] = v_33_auto
    vals = v_33_auto
  end
  local find
  do
    local v_33_auto
    local function find0(...)
      local coll, key = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "find"))
        else
        end
      end
      assert((map_3f(coll) or empty_3f(coll)), "expected a map")
      local _644_ = coll[key]
      if (nil ~= _644_) then
        local v = _644_
        return {key, v}
      else
        return nil
      end
    end
    v_33_auto = find0
    core["find"] = v_33_auto
    find = v_33_auto
  end
  local sort
  do
    local v_33_auto
    local function sort0(...)
      local _646_ = select("#", ...)
      if (_646_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "sort"))
      elseif (_646_ == 1) then
        local coll = ...
        local _647_ = seq(coll)
        if (nil ~= _647_) then
          local s = _647_
          return seq(itable.sort(vec(s)))
        elseif true then
          local _ = _647_
          return list()
        else
          return nil
        end
      elseif (_646_ == 2) then
        local comparator, coll = ...
        local _649_ = seq(coll)
        if (nil ~= _649_) then
          local s = _649_
          return seq(itable.sort(vec(s), comparator))
        elseif true then
          local _ = _649_
          return list()
        else
          return nil
        end
      elseif true then
        local _ = _646_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "sort"))
      else
        return nil
      end
    end
    v_33_auto = sort0
    core["sort"] = v_33_auto
    sort = v_33_auto
  end
  local reduce
  do
    local v_33_auto
    local function reduce0(...)
      local _653_ = select("#", ...)
      if (_653_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "reduce"))
      elseif (_653_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "reduce"))
      elseif (_653_ == 2) then
        local f, coll = ...
        return lazy.reduce(f, seq(coll))
      elseif (_653_ == 3) then
        local f, val, coll = ...
        return lazy.reduce(f, val, seq(coll))
      elseif true then
        local _ = _653_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "reduce"))
      else
        return nil
      end
    end
    v_33_auto = reduce0
    core["reduce"] = v_33_auto
    reduce = v_33_auto
  end
  local reduced
  do
    local v_33_auto
    local function reduced0(...)
      local value = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "reduced"))
        else
        end
      end
      local _656_ = lazy.reduced(value)
      local function _657_(_241)
        return _241:unbox()
      end
      getmetatable(_656_)["cljlib/deref"] = _657_
      return _656_
    end
    v_33_auto = reduced0
    core["reduced"] = v_33_auto
    reduced = v_33_auto
  end
  local reduced_3f
  do
    local v_33_auto
    local function reduced_3f0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "reduced?"))
        else
        end
      end
      return lazy["reduced?"](x)
    end
    v_33_auto = reduced_3f0
    core["reduced?"] = v_33_auto
    reduced_3f = v_33_auto
  end
  local unreduced
  do
    local v_33_auto
    local function unreduced0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "unreduced"))
        else
        end
      end
      if reduced_3f(x) then
        return deref(x)
      else
        return x
      end
    end
    v_33_auto = unreduced0
    core["unreduced"] = v_33_auto
    unreduced = v_33_auto
  end
  local ensure_reduced
  do
    local v_33_auto
    local function ensure_reduced0(...)
      local x = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "ensure-reduced"))
        else
        end
      end
      if reduced_3f(x) then
        return x
      else
        return reduced(x)
      end
    end
    v_33_auto = ensure_reduced0
    core["ensure-reduced"] = v_33_auto
    ensure_reduced = v_33_auto
  end
  local preserving_reduced
  local function preserving_reduced0(...)
    local rf = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "preserving-reduced"))
      else
      end
    end
    local function fn_664_(...)
      local a, b = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "fn_664_"))
        else
        end
      end
      local ret = rf(a, b)
      if reduced_3f(ret) then
        return reduced(ret)
      else
        return ret
      end
    end
    return fn_664_
  end
  preserving_reduced = preserving_reduced0
  local cat
  do
    local v_33_auto
    local function cat0(...)
      local rf = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "cat"))
        else
        end
      end
      local rrf = preserving_reduced(rf)
      local function fn_668_(...)
        local _669_ = select("#", ...)
        if (_669_ == 0) then
          return rf()
        elseif (_669_ == 1) then
          local result = ...
          return rf(result)
        elseif (_669_ == 2) then
          local result, input = ...
          return reduce(rrf, result, input)
        elseif true then
          local _ = _669_
          return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_668_"))
        else
          return nil
        end
      end
      return fn_668_
    end
    v_33_auto = cat0
    core["cat"] = v_33_auto
    cat = v_33_auto
  end
  local reduce_kv
  do
    local v_33_auto
    local function reduce_kv0(...)
      local f, val, s = ...
      do
        local cnt_68_auto = select("#", ...)
        if (3 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "reduce-kv"))
        else
        end
      end
      if map_3f(s) then
        local function _674_(res, _672_)
          local _arg_673_ = _672_
          local k = _arg_673_[1]
          local v = _arg_673_[2]
          return f(res, k, v)
        end
        return reduce(_674_, val, seq(s))
      else
        local function _677_(res, _675_)
          local _arg_676_ = _675_
          local k = _arg_676_[1]
          local v = _arg_676_[2]
          return f(res, k, v)
        end
        return reduce(_677_, val, map(vector, drop(1, range()), seq(s)))
      end
    end
    v_33_auto = reduce_kv0
    core["reduce-kv"] = v_33_auto
    reduce_kv = v_33_auto
  end
  local completing
  do
    local v_33_auto
    local function completing0(...)
      local _679_ = select("#", ...)
      if (_679_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "completing"))
      elseif (_679_ == 1) then
        local f = ...
        return completing0(f, identity)
      elseif (_679_ == 2) then
        local f, cf = ...
        local function fn_680_(...)
          local _681_ = select("#", ...)
          if (_681_ == 0) then
            return f()
          elseif (_681_ == 1) then
            local x = ...
            return cf(x)
          elseif (_681_ == 2) then
            local x, y = ...
            return f(x, y)
          elseif true then
            local _ = _681_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_680_"))
          else
            return nil
          end
        end
        return fn_680_
      elseif true then
        local _ = _679_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "completing"))
      else
        return nil
      end
    end
    v_33_auto = completing0
    core["completing"] = v_33_auto
    completing = v_33_auto
  end
  local transduce
  do
    local v_33_auto
    local function transduce0(...)
      local _687_ = select("#", ...)
      if (_687_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "transduce"))
      elseif (_687_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "transduce"))
      elseif (_687_ == 2) then
        return error(("Wrong number of args (%s) passed to %s"):format(2, "transduce"))
      elseif (_687_ == 3) then
        local xform, f, coll = ...
        return transduce0(xform, f, f(), coll)
      elseif (_687_ == 4) then
        local xform, f, init, coll = ...
        local f0 = xform(f)
        return f0(reduce(f0, init, seq(coll)))
      elseif true then
        local _ = _687_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "transduce"))
      else
        return nil
      end
    end
    v_33_auto = transduce0
    core["transduce"] = v_33_auto
    transduce = v_33_auto
  end
  local sequence
  do
    local v_33_auto
    local function sequence0(...)
      local _689_ = select("#", ...)
      if (_689_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "sequence"))
      elseif (_689_ == 1) then
        local coll = ...
        if seq_3f(coll) then
          return coll
        else
          return (seq(coll) or list())
        end
      elseif (_689_ == 2) then
        local xform, coll = ...
        local f
        local function _691_(_241, _242)
          return cons(_242, _241)
        end
        f = xform(completing(_691_))
        local function step(coll0)
          local val_106_auto = seq(coll0)
          if (nil ~= val_106_auto) then
            local s = val_106_auto
            local res = f(nil, first(s))
            if reduced_3f(res) then
              return f(deref(res))
            elseif seq_3f(res) then
              local function _692_()
                return step(rest(s))
              end
              return concat(res, lazy_seq(_692_))
            elseif "else" then
              return step(rest(s))
            else
              return nil
            end
          else
            return f(nil)
          end
        end
        return (step(coll) or list())
      elseif true then
        local _ = _689_
        local core_48_auto = require("cljlib")
        local _let_695_ = core_48_auto.list(...)
        local xform = _let_695_[1]
        local coll = _let_695_[2]
        local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_695_, 3)
        local f
        local function _696_(_241, _242)
          return cons(_242, _241)
        end
        f = xform(completing(_696_))
        local function step(colls0)
          if every_3f(seq, colls0) then
            local res = apply(f, nil, map(first, colls0))
            if reduced_3f(res) then
              return f(deref(res))
            elseif seq_3f(res) then
              local function _697_()
                return step(map(rest, colls0))
              end
              return concat(res, lazy_seq(_697_))
            elseif "else" then
              return step(map(rest, colls0))
            else
              return nil
            end
          else
            return f(nil)
          end
        end
        return (step(cons(coll, colls)) or list())
      else
        return nil
      end
    end
    v_33_auto = sequence0
    core["sequence"] = v_33_auto
    sequence = v_33_auto
  end
  local function map__3etransient(immutable)
    local function _701_(map0)
      local removed = setmetatable({}, {__index = deep_index})
      local function _702_(_, k)
        if not removed[k] then
          return (map0)[k]
        else
          return nil
        end
      end
      local function _704_()
        return error("can't `conj` onto transient map, use `conj!`")
      end
      local function _705_()
        return error("can't `assoc` onto transient map, use `assoc!`")
      end
      local function _706_()
        return error("can't `dissoc` onto transient map, use `dissoc!`")
      end
      local function _709_(tmap, _707_)
        local _arg_708_ = _707_
        local k = _arg_708_[1]
        local v = _arg_708_[2]
        if (nil == v) then
          removed[k] = true
        else
          removed[k] = nil
        end
        tmap[k] = v
        return tmap
      end
      local function _711_(tmap, ...)
        for i = 1, select("#", ...), 2 do
          local k, v = select(i, ...)
          do end (tmap)[k] = v
          if (nil == v) then
            removed[k] = true
          else
            removed[k] = nil
          end
        end
        return tmap
      end
      local function _713_(tmap, ...)
        for i = 1, select("#", ...) do
          local k = select(i, ...)
          do end (tmap)[k] = nil
          removed[k] = true
        end
        return tmap
      end
      local function _714_(tmap)
        local t
        do
          local tbl_14_auto
          do
            local tbl_14_auto0 = {}
            for k, v in pairs(map0) do
              local k_15_auto, v_16_auto = k, v
              if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
                tbl_14_auto0[k_15_auto] = v_16_auto
              else
              end
            end
            tbl_14_auto = tbl_14_auto0
          end
          for k, v in pairs(tmap) do
            local k_15_auto, v_16_auto = k, v
            if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
              tbl_14_auto[k_15_auto] = v_16_auto
            else
            end
          end
          t = tbl_14_auto
        end
        for k in pairs(removed) do
          t[k] = nil
        end
        local function _717_()
          local tbl_17_auto = {}
          local i_18_auto = #tbl_17_auto
          for k in pairs_2a(tmap) do
            local val_19_auto = k
            if (nil ~= val_19_auto) then
              i_18_auto = (i_18_auto + 1)
              do end (tbl_17_auto)[i_18_auto] = val_19_auto
            else
            end
          end
          return tbl_17_auto
        end
        for _, k in ipairs(_717_()) do
          tmap[k] = nil
        end
        local function _719_()
          return error("attempt to use transient after it was persistet")
        end
        local function _720_()
          return error("attempt to use transient after it was persistet")
        end
        setmetatable(tmap, {__index = _719_, __newindex = _720_})
        return immutable(itable(t))
      end
      return setmetatable({}, {__index = _702_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _704_, ["cljlib/assoc"] = _705_, ["cljlib/dissoc"] = _706_, ["cljlib/conj!"] = _709_, ["cljlib/assoc!"] = _711_, ["cljlib/dissoc!"] = _713_, ["cljlib/persistent!"] = _714_})
    end
    return _701_
  end
  local function hash_map_2a(x)
    do
      local _721_ = getmetatable(x)
      if (nil ~= _721_) then
        local mt = _721_
        mt["cljlib/type"] = "hash-map"
        mt["cljlib/editable"] = true
        local function _724_(t, _722_, ...)
          local _arg_723_ = _722_
          local k = _arg_723_[1]
          local v = _arg_723_[2]
          local function _725_(...)
            local kvs = {}
            for _, _726_ in ipairs_2a({...}) do
              local _each_727_ = _726_
              local k0 = _each_727_[1]
              local v0 = _each_727_[2]
              table.insert(kvs, k0)
              table.insert(kvs, v0)
              kvs = kvs
            end
            return kvs
          end
          return apply(core.assoc, t, k, v, _725_(...))
        end
        mt["cljlib/conj"] = _724_
        mt["cljlib/transient"] = map__3etransient(hash_map_2a)
        local function _728_()
          return hash_map_2a(itable({}))
        end
        mt["cljlib/empty"] = _728_
      elseif true then
        local _ = _721_
        hash_map_2a(setmetatable(x, {}))
      else
      end
    end
    return x
  end
  local assoc
  do
    local v_33_auto
    local function assoc0(...)
      local _732_ = select("#", ...)
      if (_732_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "assoc"))
      elseif (_732_ == 1) then
        local tbl = ...
        return hash_map_2a(itable({}))
      elseif (_732_ == 2) then
        return error(("Wrong number of args (%s) passed to %s"):format(2, "assoc"))
      elseif (_732_ == 3) then
        local tbl, k, v = ...
        assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
        assert(not nil_3f(k), "attempt to use nil as key")
        return hash_map_2a(itable.assoc((tbl or {}), k, v))
      elseif true then
        local _ = _732_
        local core_48_auto = require("cljlib")
        local _let_733_ = core_48_auto.list(...)
        local tbl = _let_733_[1]
        local k = _let_733_[2]
        local v = _let_733_[3]
        local kvs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_733_, 4)
        assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
        assert(not nil_3f(k), "attempt to use nil as key")
        return hash_map_2a(apply(itable.assoc, (tbl or {}), k, v, kvs))
      else
        return nil
      end
    end
    v_33_auto = assoc0
    core["assoc"] = v_33_auto
    assoc = v_33_auto
  end
  local assoc_in
  do
    local v_33_auto
    local function assoc_in0(...)
      local tbl, key_seq, val = ...
      do
        local cnt_68_auto = select("#", ...)
        if (3 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "assoc-in"))
        else
        end
      end
      assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map or nil")
      return hash_map_2a(itable["assoc-in"](tbl, key_seq, val))
    end
    v_33_auto = assoc_in0
    core["assoc-in"] = v_33_auto
    assoc_in = v_33_auto
  end
  local update
  do
    local v_33_auto
    local function update0(...)
      local tbl, key, f = ...
      do
        local cnt_68_auto = select("#", ...)
        if (3 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "update"))
        else
        end
      end
      assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
      return hash_map_2a(itable.update(tbl, key, f))
    end
    v_33_auto = update0
    core["update"] = v_33_auto
    update = v_33_auto
  end
  local update_in
  do
    local v_33_auto
    local function update_in0(...)
      local tbl, key_seq, f = ...
      do
        local cnt_68_auto = select("#", ...)
        if (3 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "update-in"))
        else
        end
      end
      assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map or nil")
      return hash_map_2a(itable["update-in"](tbl, key_seq, f))
    end
    v_33_auto = update_in0
    core["update-in"] = v_33_auto
    update_in = v_33_auto
  end
  local hash_map
  do
    local v_33_auto
    local function hash_map0(...)
      local core_48_auto = require("cljlib")
      local _let_738_ = core_48_auto.list(...)
      local kvs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_738_, 1)
      return apply(assoc, {}, kvs)
    end
    v_33_auto = hash_map0
    core["hash-map"] = v_33_auto
    hash_map = v_33_auto
  end
  local get
  do
    local v_33_auto
    local function get0(...)
      local _740_ = select("#", ...)
      if (_740_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "get"))
      elseif (_740_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "get"))
      elseif (_740_ == 2) then
        local tbl, key = ...
        return get0(tbl, key, nil)
      elseif (_740_ == 3) then
        local tbl, key, not_found = ...
        assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
        return (tbl[key] or not_found)
      elseif true then
        local _ = _740_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "get"))
      else
        return nil
      end
    end
    v_33_auto = get0
    core["get"] = v_33_auto
    get = v_33_auto
  end
  local get_in
  do
    local v_33_auto
    local function get_in0(...)
      local _743_ = select("#", ...)
      if (_743_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "get-in"))
      elseif (_743_ == 1) then
        return error(("Wrong number of args (%s) passed to %s"):format(1, "get-in"))
      elseif (_743_ == 2) then
        local tbl, keys0 = ...
        return get_in0(tbl, keys0, nil)
      elseif (_743_ == 3) then
        local tbl, keys0, not_found = ...
        assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
        local res, t, done = tbl, tbl, nil
        for _, k in ipairs_2a(keys0) do
          if done then break end
          local _744_ = t[k]
          if (nil ~= _744_) then
            local v = _744_
            res, t = v, v
          elseif true then
            local _0 = _744_
            res, done = not_found, true
          else
          end
        end
        return res
      elseif true then
        local _ = _743_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "get-in"))
      else
        return nil
      end
    end
    v_33_auto = get_in0
    core["get-in"] = v_33_auto
    get_in = v_33_auto
  end
  local dissoc
  do
    local v_33_auto
    local function dissoc0(...)
      local _747_ = select("#", ...)
      if (_747_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "dissoc"))
      elseif (_747_ == 1) then
        local tbl = ...
        return tbl
      elseif (_747_ == 2) then
        local tbl, key = ...
        assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
        local function _748_(...)
          tbl[key] = nil
          return tbl
        end
        return hash_map_2a(_748_(...))
      elseif true then
        local _ = _747_
        local core_48_auto = require("cljlib")
        local _let_749_ = core_48_auto.list(...)
        local tbl = _let_749_[1]
        local key = _let_749_[2]
        local keys0 = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_749_, 3)
        return apply(dissoc0, dissoc0(tbl, key), keys0)
      else
        return nil
      end
    end
    v_33_auto = dissoc0
    core["dissoc"] = v_33_auto
    dissoc = v_33_auto
  end
  local merge
  do
    local v_33_auto
    local function merge0(...)
      local core_48_auto = require("cljlib")
      local _let_751_ = core_48_auto.list(...)
      local maps = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_751_, 1)
      if some(identity, maps) then
        local function _752_(a, b)
          local tbl_14_auto = a
          for k, v in pairs_2a(b) do
            local k_15_auto, v_16_auto = k, v
            if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
              tbl_14_auto[k_15_auto] = v_16_auto
            else
            end
          end
          return tbl_14_auto
        end
        return hash_map_2a(itable(reduce(_752_, {}, maps)))
      else
        return nil
      end
    end
    v_33_auto = merge0
    core["merge"] = v_33_auto
    merge = v_33_auto
  end
  local frequencies
  do
    local v_33_auto
    local function frequencies0(...)
      local t = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "frequencies"))
        else
        end
      end
      return hash_map_2a(itable.frequencies(t))
    end
    v_33_auto = frequencies0
    core["frequencies"] = v_33_auto
    frequencies = v_33_auto
  end
  local group_by
  do
    local v_33_auto
    local function group_by0(...)
      local f, t = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "group-by"))
        else
        end
      end
      local function _758_(...)
        local _757_ = itable["group-by"](f, t)
        return _757_
      end
      return hash_map_2a(_758_(...))
    end
    v_33_auto = group_by0
    core["group-by"] = v_33_auto
    group_by = v_33_auto
  end
  local zipmap
  do
    local v_33_auto
    local function zipmap0(...)
      local keys0, vals0 = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "zipmap"))
        else
        end
      end
      return hash_map_2a(itable(lazy.zipmap(keys0, vals0)))
    end
    v_33_auto = zipmap0
    core["zipmap"] = v_33_auto
    zipmap = v_33_auto
  end
  local replace
  do
    local v_33_auto
    local function replace0(...)
      local _760_ = select("#", ...)
      if (_760_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "replace"))
      elseif (_760_ == 1) then
        local smap = ...
        local function _761_(_241)
          local val_100_auto = find(smap, _241)
          if val_100_auto then
            local e = val_100_auto
            return e[2]
          else
            return _241
          end
        end
        return map(_761_)
      elseif (_760_ == 2) then
        local smap, coll = ...
        if vector_3f(coll) then
          local function _763_(res, v)
            local val_100_auto = find(smap, v)
            if val_100_auto then
              local e = val_100_auto
              table.insert(res, e[2])
              return res
            else
              table.insert(res, v)
              return res
            end
          end
          return vec_2a(itable(reduce(_763_, {}, coll)))
        else
          local function _765_(_241)
            local val_100_auto = find(smap, _241)
            if val_100_auto then
              local e = val_100_auto
              return e[2]
            else
              return _241
            end
          end
          return map(_765_, coll)
        end
      elseif true then
        local _ = _760_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "replace"))
      else
        return nil
      end
    end
    v_33_auto = replace0
    core["replace"] = v_33_auto
    replace = v_33_auto
  end
  local conj
  do
    local v_33_auto
    local function conj0(...)
      local _769_ = select("#", ...)
      if (_769_ == 0) then
        return vector()
      elseif (_769_ == 1) then
        local s = ...
        return s
      elseif (_769_ == 2) then
        local s, x = ...
        local _770_ = getmetatable(s)
        if ((_G.type(_770_) == "table") and (nil ~= (_770_)["cljlib/conj"])) then
          local f = (_770_)["cljlib/conj"]
          return f(s, x)
        elseif true then
          local _ = _770_
          if vector_3f(s) then
            return vec_2a(itable.insert(s, x))
          elseif map_3f(s) then
            return apply(assoc, s, x)
          elseif nil_3f(s) then
            return cons(x, s)
          elseif empty_3f(s) then
            return vector(x)
          else
            return error("expected collection, got", type(s))
          end
        else
          return nil
        end
      elseif true then
        local _ = _769_
        local core_48_auto = require("cljlib")
        local _let_773_ = core_48_auto.list(...)
        local s = _let_773_[1]
        local x = _let_773_[2]
        local xs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_773_, 3)
        return apply(conj0, conj0(s, x), xs)
      else
        return nil
      end
    end
    v_33_auto = conj0
    core["conj"] = v_33_auto
    conj = v_33_auto
  end
  local disj
  do
    local v_33_auto
    local function disj0(...)
      local _775_ = select("#", ...)
      if (_775_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "disj"))
      elseif (_775_ == 1) then
        local Set = ...
        return Set
      elseif (_775_ == 2) then
        local Set, key = ...
        local _776_ = getmetatable(Set)
        if ((_G.type(_776_) == "table") and ((_776_)["cljlib/type"] == "hash-set") and (nil ~= (_776_)["cljlib/disj"])) then
          local f = (_776_)["cljlib/disj"]
          return f(Set, key)
        elseif true then
          local _ = _776_
          return error(("disj is not supported on " .. class(Set)), 2)
        else
          return nil
        end
      elseif true then
        local _ = _775_
        local core_48_auto = require("cljlib")
        local _let_778_ = core_48_auto.list(...)
        local Set = _let_778_[1]
        local key = _let_778_[2]
        local keys0 = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_778_, 3)
        local _779_ = getmetatable(Set)
        if ((_G.type(_779_) == "table") and ((_779_)["cljlib/type"] == "hash-set") and (nil ~= (_779_)["cljlib/disj"])) then
          local f = (_779_)["cljlib/disj"]
          return apply(f, Set, key, keys0)
        elseif true then
          local _0 = _779_
          return error(("disj is not supported on " .. class(Set)), 2)
        else
          return nil
        end
      else
        return nil
      end
    end
    v_33_auto = disj0
    core["disj"] = v_33_auto
    disj = v_33_auto
  end
  local pop
  do
    local v_33_auto
    local function pop0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "pop"))
        else
        end
      end
      local _783_ = getmetatable(coll)
      if ((_G.type(_783_) == "table") and ((_783_)["cljlib/type"] == "seq")) then
        local _784_ = seq(coll)
        if (nil ~= _784_) then
          local s = _784_
          return drop(1, s)
        elseif true then
          local _ = _784_
          return error("can't pop empty list", 2)
        else
          return nil
        end
      elseif ((_G.type(_783_) == "table") and (nil ~= (_783_)["cljlib/pop"])) then
        local f = (_783_)["cljlib/pop"]
        return f(coll)
      elseif true then
        local _ = _783_
        return error(("pop is not supported on " .. class(coll)), 2)
      else
        return nil
      end
    end
    v_33_auto = pop0
    core["pop"] = v_33_auto
    pop = v_33_auto
  end
  local transient
  do
    local v_33_auto
    local function transient0(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "transient"))
        else
        end
      end
      local _788_ = getmetatable(coll)
      if ((_G.type(_788_) == "table") and ((_788_)["cljlib/editable"] == true) and (nil ~= (_788_)["cljlib/transient"])) then
        local f = (_788_)["cljlib/transient"]
        return f(coll)
      elseif true then
        local _ = _788_
        return error("expected editable collection", 2)
      else
        return nil
      end
    end
    v_33_auto = transient0
    core["transient"] = v_33_auto
    transient = v_33_auto
  end
  local conj_21
  do
    local v_33_auto
    local function conj_210(...)
      local _790_ = select("#", ...)
      if (_790_ == 0) then
        return transient(vec_2a({}))
      elseif (_790_ == 1) then
        local coll = ...
        return coll
      elseif (_790_ == 2) then
        local coll, x = ...
        do
          local _791_ = getmetatable(coll)
          if ((_G.type(_791_) == "table") and ((_791_)["cljlib/type"] == "transient") and (nil ~= (_791_)["cljlib/conj!"])) then
            local f = (_791_)["cljlib/conj!"]
            f(coll, x)
          elseif ((_G.type(_791_) == "table") and ((_791_)["cljlib/type"] == "transient")) then
            error("unsupported transient operation", 2)
          elseif true then
            local _ = _791_
            error("expected transient collection", 2)
          else
          end
        end
        return coll
      elseif true then
        local _ = _790_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "conj!"))
      else
        return nil
      end
    end
    v_33_auto = conj_210
    core["conj!"] = v_33_auto
    conj_21 = v_33_auto
  end
  local assoc_21
  do
    local v_33_auto
    local function assoc_210(...)
      local core_48_auto = require("cljlib")
      local _let_794_ = core_48_auto.list(...)
      local map0 = _let_794_[1]
      local k = _let_794_[2]
      local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_794_, 3)
      do
        local _795_ = getmetatable(map0)
        if ((_G.type(_795_) == "table") and ((_795_)["cljlib/type"] == "transient") and (nil ~= (_795_)["cljlib/dissoc!"])) then
          local f = (_795_)["cljlib/dissoc!"]
          apply(f, map0, k, ks)
        elseif ((_G.type(_795_) == "table") and ((_795_)["cljlib/type"] == "transient")) then
          error("unsupported transient operation", 2)
        elseif true then
          local _ = _795_
          error("expected transient collection", 2)
        else
        end
      end
      return map0
    end
    v_33_auto = assoc_210
    core["assoc!"] = v_33_auto
    assoc_21 = v_33_auto
  end
  local dissoc_21
  do
    local v_33_auto
    local function dissoc_210(...)
      local core_48_auto = require("cljlib")
      local _let_797_ = core_48_auto.list(...)
      local map0 = _let_797_[1]
      local k = _let_797_[2]
      local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_797_, 3)
      do
        local _798_ = getmetatable(map0)
        if ((_G.type(_798_) == "table") and ((_798_)["cljlib/type"] == "transient") and (nil ~= (_798_)["cljlib/dissoc!"])) then
          local f = (_798_)["cljlib/dissoc!"]
          apply(f, map0, k, ks)
        elseif ((_G.type(_798_) == "table") and ((_798_)["cljlib/type"] == "transient")) then
          error("unsupported transient operation", 2)
        elseif true then
          local _ = _798_
          error("expected transient collection", 2)
        else
        end
      end
      return map0
    end
    v_33_auto = dissoc_210
    core["dissoc!"] = v_33_auto
    dissoc_21 = v_33_auto
  end
  local disj_21
  do
    local v_33_auto
    local function disj_210(...)
      local _800_ = select("#", ...)
      if (_800_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "disj!"))
      elseif (_800_ == 1) then
        local Set = ...
        return Set
      elseif true then
        local _ = _800_
        local core_48_auto = require("cljlib")
        local _let_801_ = core_48_auto.list(...)
        local Set = _let_801_[1]
        local key = _let_801_[2]
        local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_801_, 3)
        local _802_ = getmetatable(Set)
        if ((_G.type(_802_) == "table") and ((_802_)["cljlib/type"] == "transient") and (nil ~= (_802_)["cljlib/disj!"])) then
          local f = (_802_)["cljlib/disj!"]
          return apply(f, Set, key, ks)
        elseif ((_G.type(_802_) == "table") and ((_802_)["cljlib/type"] == "transient")) then
          return error("unsupported transient operation", 2)
        elseif true then
          local _0 = _802_
          return error("expected transient collection", 2)
        else
          return nil
        end
      else
        return nil
      end
    end
    v_33_auto = disj_210
    core["disj!"] = v_33_auto
    disj_21 = v_33_auto
  end
  local pop_21
  do
    local v_33_auto
    local function pop_210(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "pop!"))
        else
        end
      end
      local _806_ = getmetatable(coll)
      if ((_G.type(_806_) == "table") and ((_806_)["cljlib/type"] == "transient") and (nil ~= (_806_)["cljlib/pop!"])) then
        local f = (_806_)["cljlib/pop!"]
        return f(coll)
      elseif ((_G.type(_806_) == "table") and ((_806_)["cljlib/type"] == "transient")) then
        return error("unsupported transient operation", 2)
      elseif true then
        local _ = _806_
        return error("expected transient collection", 2)
      else
        return nil
      end
    end
    v_33_auto = pop_210
    core["pop!"] = v_33_auto
    pop_21 = v_33_auto
  end
  local persistent_21
  do
    local v_33_auto
    local function persistent_210(...)
      local coll = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "persistent!"))
        else
        end
      end
      local _809_ = getmetatable(coll)
      if ((_G.type(_809_) == "table") and ((_809_)["cljlib/type"] == "transient") and (nil ~= (_809_)["cljlib/persistent!"])) then
        local f = (_809_)["cljlib/persistent!"]
        return f(coll)
      elseif true then
        local _ = _809_
        return error("expected transient collection", 2)
      else
        return nil
      end
    end
    v_33_auto = persistent_210
    core["persistent!"] = v_33_auto
    persistent_21 = v_33_auto
  end
  local into
  do
    local v_33_auto
    local function into0(...)
      local _811_ = select("#", ...)
      if (_811_ == 0) then
        return vector()
      elseif (_811_ == 1) then
        local to = ...
        return to
      elseif (_811_ == 2) then
        local to, from = ...
        local _812_ = getmetatable(to)
        if ((_G.type(_812_) == "table") and ((_812_)["cljlib/editable"] == true)) then
          return persistent_21(reduce(conj_21, transient(to), from))
        elseif true then
          local _ = _812_
          return reduce(conj, to, from)
        else
          return nil
        end
      elseif (_811_ == 3) then
        local to, xform, from = ...
        local _814_ = getmetatable(to)
        if ((_G.type(_814_) == "table") and ((_814_)["cljlib/editable"] == true)) then
          return persistent_21(transduce(xform, conj_21, transient(to), from))
        elseif true then
          local _ = _814_
          return transduce(xform, conj, to, from)
        else
          return nil
        end
      elseif true then
        local _ = _811_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "into"))
      else
        return nil
      end
    end
    v_33_auto = into0
    core["into"] = v_33_auto
    into = v_33_auto
  end
  local function viewset(Set, view, inspector, indent)
    if inspector.seen[Set] then
      return ("@set" .. inspector.seen[Set] .. "{...}")
    else
      local prefix
      local function _817_()
        if inspector["visible-cycle?"](Set) then
          return inspector.seen[Set]
        else
          return ""
        end
      end
      prefix = ("@set" .. _817_() .. "{")
      local set_indent = #prefix
      local indent_str = string.rep(" ", set_indent)
      local lines
      do
        local tbl_17_auto = {}
        local i_18_auto = #tbl_17_auto
        for v in pairs_2a(Set) do
          local val_19_auto = (indent_str .. view(v, inspector, (indent + set_indent), true))
          if (nil ~= val_19_auto) then
            i_18_auto = (i_18_auto + 1)
            do end (tbl_17_auto)[i_18_auto] = val_19_auto
          else
          end
        end
        lines = tbl_17_auto
      end
      lines[1] = (prefix .. string.gsub((lines[1] or ""), "^%s+", ""))
      do end (lines)[#lines] = (lines[#lines] .. "}")
      return lines
    end
  end
  local function hash_set__3etransient(immutable)
    local function _820_(hset)
      local removed = setmetatable({}, {__index = deep_index})
      local function _821_(_, k)
        if not removed[k] then
          return hset[k]
        else
          return nil
        end
      end
      local function _823_()
        return error("can't `conj` onto transient set, use `conj!`")
      end
      local function _824_()
        return error("can't `disj` a transient set, use `disj!`")
      end
      local function _825_()
        return error("can't `assoc` onto transient set, use `assoc!`")
      end
      local function _826_()
        return error("can't `dissoc` onto transient set, use `dissoc!`")
      end
      local function _827_(thset, v)
        if (nil == v) then
          removed[v] = true
        else
          removed[v] = nil
        end
        thset[v] = v
        return thset
      end
      local function _829_()
        return error("can't `dissoc!` a transient set")
      end
      local function _830_(thset, ...)
        for i = 1, select("#", ...) do
          local k = select(i, ...)
          do end (thset)[k] = nil
          removed[k] = true
        end
        return thset
      end
      local function _831_(thset)
        local t
        do
          local tbl_14_auto
          do
            local tbl_14_auto0 = {}
            for k, v in pairs(hset) do
              local k_15_auto, v_16_auto = k, v
              if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
                tbl_14_auto0[k_15_auto] = v_16_auto
              else
              end
            end
            tbl_14_auto = tbl_14_auto0
          end
          for k, v in pairs(thset) do
            local k_15_auto, v_16_auto = k, v
            if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
              tbl_14_auto[k_15_auto] = v_16_auto
            else
            end
          end
          t = tbl_14_auto
        end
        for k in pairs(removed) do
          t[k] = nil
        end
        local function _834_()
          local tbl_17_auto = {}
          local i_18_auto = #tbl_17_auto
          for k in pairs_2a(thset) do
            local val_19_auto = k
            if (nil ~= val_19_auto) then
              i_18_auto = (i_18_auto + 1)
              do end (tbl_17_auto)[i_18_auto] = val_19_auto
            else
            end
          end
          return tbl_17_auto
        end
        for _, k in ipairs(_834_()) do
          thset[k] = nil
        end
        local function _836_()
          return error("attempt to use transient after it was persistet")
        end
        local function _837_()
          return error("attempt to use transient after it was persistet")
        end
        setmetatable(thset, {__index = _836_, __newindex = _837_})
        return immutable(itable(t))
      end
      return setmetatable({}, {__index = _821_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _823_, ["cljlib/disj"] = _824_, ["cljlib/assoc"] = _825_, ["cljlib/dissoc"] = _826_, ["cljlib/conj!"] = _827_, ["cljlib/assoc!"] = _829_, ["cljlib/disj!"] = _830_, ["cljlib/persistent!"] = _831_})
    end
    return _820_
  end
  local function hash_set_2a(x)
    do
      local _838_ = getmetatable(x)
      if (nil ~= _838_) then
        local mt = _838_
        mt["cljlib/type"] = "hash-set"
        local function _839_(s, v, ...)
          local function _840_(...)
            local res = {}
            for _, v0 in ipairs({...}) do
              table.insert(res, v0)
              table.insert(res, v0)
            end
            return res
          end
          return hash_set_2a(itable.assoc(s, v, v, unpack_2a(_840_(...))))
        end
        mt["cljlib/conj"] = _839_
        local function _841_(s, k, ...)
          local to_remove
          do
            local tbl_14_auto = setmetatable({[k] = true}, {__index = deep_index})
            for _, k0 in ipairs({...}) do
              local k_15_auto, v_16_auto = k0, true
              if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
                tbl_14_auto[k_15_auto] = v_16_auto
              else
              end
            end
            to_remove = tbl_14_auto
          end
          local function _843_(...)
            local res = {}
            for _, v in pairs(s) do
              if not to_remove[v] then
                table.insert(res, v)
                table.insert(res, v)
              else
              end
            end
            return res
          end
          return hash_set_2a(itable.assoc({}, unpack_2a(_843_(...))))
        end
        mt["cljlib/disj"] = _841_
        local function _845_()
          return hash_set_2a(itable({}))
        end
        mt["cljlib/empty"] = _845_
        mt["cljlib/editable"] = true
        mt["cljlib/transient"] = hash_set__3etransient(hash_set_2a)
        local function _846_(s)
          local function _847_(_241)
            if vector_3f(_241) then
              return (_241)[1]
            else
              return _241
            end
          end
          return map(_847_, s)
        end
        mt["cljlib/seq"] = _846_
        mt["__fennelview"] = viewset
        local function _849_(s, i)
          local j = 1
          local vals0 = {}
          for v in pairs_2a(s) do
            if (j >= i) then
              table.insert(vals0, v)
            else
              j = (j + 1)
            end
          end
          return core["hash-set"](unpack_2a(vals0))
        end
        mt["__fennelrest"] = _849_
      elseif true then
        local _ = _838_
        hash_set_2a(setmetatable(x, {}))
      else
      end
    end
    return x
  end
  local hash_set
  do
    local v_33_auto
    local function hash_set0(...)
      local core_48_auto = require("cljlib")
      local _let_852_ = core_48_auto.list(...)
      local xs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_852_, 1)
      local Set
      do
        local tbl_14_auto = setmetatable({}, {__newindex = deep_newindex})
        for _, val in pairs_2a(xs) do
          local k_15_auto, v_16_auto = val, val
          if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
            tbl_14_auto[k_15_auto] = v_16_auto
          else
          end
        end
        Set = tbl_14_auto
      end
      return hash_set_2a(itable(Set))
    end
    v_33_auto = hash_set0
    core["hash-set"] = v_33_auto
    hash_set = v_33_auto
  end
  local multifn_3f
  do
    local v_33_auto
    local function multifn_3f0(...)
      local mf = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "multifn?"))
        else
        end
      end
      local _855_ = getmetatable(mf)
      if ((_G.type(_855_) == "table") and ((_855_)["cljlib/type"] == "multifn")) then
        return true
      elseif true then
        local _ = _855_
        return false
      else
        return nil
      end
    end
    v_33_auto = multifn_3f0
    core["multifn?"] = v_33_auto
    multifn_3f = v_33_auto
  end
  local remove_method
  do
    local v_33_auto
    local function remove_method0(...)
      local multimethod, dispatch_value = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "remove-method"))
        else
        end
      end
      if multifn_3f(multimethod) then
        multimethod[dispatch_value] = nil
      else
        error((tostring(multimethod) .. " is not a multifn"), 2)
      end
      return multimethod
    end
    v_33_auto = remove_method0
    core["remove-method"] = v_33_auto
    remove_method = v_33_auto
  end
  local remove_all_methods
  do
    local v_33_auto
    local function remove_all_methods0(...)
      local multimethod = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "remove-all-methods"))
        else
        end
      end
      if multifn_3f(multimethod) then
        for k, _ in pairs(multimethod) do
          multimethod[k] = nil
        end
      else
        error((tostring(multimethod) .. " is not a multifn"), 2)
      end
      return multimethod
    end
    v_33_auto = remove_all_methods0
    core["remove-all-methods"] = v_33_auto
    remove_all_methods = v_33_auto
  end
  local methods
  do
    local v_33_auto
    local function methods0(...)
      local multimethod = ...
      do
        local cnt_68_auto = select("#", ...)
        if (1 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "methods"))
        else
        end
      end
      if multifn_3f(multimethod) then
        local m = {}
        for k, v in pairs(multimethod) do
          m[k] = v
        end
        return m
      else
        return error((tostring(multimethod) .. " is not a multifn"), 2)
      end
    end
    v_33_auto = methods0
    core["methods"] = v_33_auto
    methods = v_33_auto
  end
  local get_method
  do
    local v_33_auto
    local function get_method0(...)
      local multimethod, dispatch_value = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "get-method"))
        else
        end
      end
      if multifn_3f(multimethod) then
        return (multimethod[dispatch_value] or multimethod.default)
      else
        return error((tostring(multimethod) .. " is not a multifn"), 2)
      end
    end
    v_33_auto = get_method0
    core["get-method"] = v_33_auto
    get_method = v_33_auto
  end
  return core
end
package.preload["lazy-seq"] = package.preload["lazy-seq"] or function(...)
  utf8 = _G.utf8
  local function pairs_2a(t)
    local mt = getmetatable(t)
    if (("table" == mt) and mt.__pairs) then
      return mt.__pairs(t)
    else
      return pairs(t)
    end
  end
  local function ipairs_2a(t)
    local mt = getmetatable(t)
    if (("table" == mt) and mt.__ipairs) then
      return mt.__ipairs(t)
    else
      return ipairs(t)
    end
  end
  local function rev_ipairs(t)
    local function next(t0, i)
      local i0 = (i - 1)
      local _20_ = i0
      if (_20_ == 0) then
        return nil
      elseif true then
        local _ = _20_
        return i0, (t0)[i0]
      else
        return nil
      end
    end
    return next, t, (1 + #t)
  end
  local function length_2a(t)
    local mt = getmetatable(t)
    if (("table" == mt) and mt.__len) then
      return mt.__len(t)
    else
      return #t
    end
  end
  local function table_pack(...)
    local _23_ = {...}
    _23_["n"] = select("#", ...)
    return _23_
  end
  local table_unpack = (table.unpack or _G.unpack)
  local seq = nil
  local cons_iter = nil
  local function first(s)
    local _24_ = seq(s)
    if (nil ~= _24_) then
      local s_2a = _24_
      return s_2a(true)
    elseif true then
      local _ = _24_
      return nil
    else
      return nil
    end
  end
  local function empty_cons_view()
    return "@seq()"
  end
  local function empty_cons_len()
    return 0
  end
  local function empty_cons_index()
    return nil
  end
  local function cons_newindex()
    return error("cons cell is immutable")
  end
  local function empty_cons_next(s)
    return nil
  end
  local function empty_cons_pairs(s)
    return empty_cons_next, nil, s
  end
  local function gettype(x)
    local _26_
    do
      local t_27_ = getmetatable(x)
      if (nil ~= t_27_) then
        t_27_ = (t_27_)["__lazy-seq/type"]
      else
      end
      _26_ = t_27_
    end
    if (nil ~= _26_) then
      local t = _26_
      return t
    elseif true then
      local _ = _26_
      return type(x)
    else
      return nil
    end
  end
  local function realize(c)
    if ("lazy-cons" == gettype(c)) then
      c()
    else
    end
    return c
  end
  local empty_cons = {}
  local function empty_cons_call(tf)
    if tf then
      return nil
    else
      return empty_cons
    end
  end
  local function empty_cons_fennelrest()
    return empty_cons
  end
  local function empty_cons_eq(_, s)
    return rawequal(getmetatable(empty_cons), getmetatable(realize(s)))
  end
  setmetatable(empty_cons, {__call = empty_cons_call, __len = empty_cons_len, __fennelview = empty_cons_view, __fennelrest = empty_cons_fennelrest, ["__lazy-seq/type"] = "empty-cons", __newindex = cons_newindex, __index = empty_cons_index, __name = "cons", __eq = empty_cons_eq, __pairs = empty_cons_pairs})
  local function rest(s)
    local _32_ = seq(s)
    if (nil ~= _32_) then
      local s_2a = _32_
      return s_2a(false)
    elseif true then
      local _ = _32_
      return empty_cons
    else
      return nil
    end
  end
  local function seq_3f(x)
    local tp = gettype(x)
    return ((tp == "cons") or (tp == "lazy-cons") or (tp == "empty-cons"))
  end
  local function empty_3f(x)
    return not seq(x)
  end
  local function next(s)
    return seq(realize(rest(seq(s))))
  end
  local function view_seq(list, options, view, indent, elements)
    table.insert(elements, view(first(list), options, indent))
    do
      local tail = next(list)
      if ("cons" == gettype(tail)) then
        view_seq(tail, options, view, indent, elements)
      else
      end
    end
    return elements
  end
  local function pp_seq(list, view, options, indent)
    local items = view_seq(list, options, view, (indent + 5), {})
    local lines
    do
      local tbl_17_auto = {}
      local i_18_auto = #tbl_17_auto
      for i, line in ipairs(items) do
        local val_19_auto
        if (i == 1) then
          val_19_auto = line
        else
          val_19_auto = ("     " .. line)
        end
        if (nil ~= val_19_auto) then
          i_18_auto = (i_18_auto + 1)
          do end (tbl_17_auto)[i_18_auto] = val_19_auto
        else
        end
      end
      lines = tbl_17_auto
    end
    lines[1] = ("@seq(" .. (lines[1] or ""))
    do end (lines)[#lines] = (lines[#lines] .. ")")
    return lines
  end
  local drop = nil
  local function cons_fennelrest(c, i)
    return drop((i - 1), c)
  end
  local allowed_types = {cons = true, ["empty-cons"] = true, ["lazy-cons"] = true, ["nil"] = true, string = true, table = true}
  local function cons_next(_, s)
    if (empty_cons ~= s) then
      local tail = next(s)
      local _37_ = gettype(tail)
      if (_37_ == "cons") then
        return tail, first(s)
      elseif true then
        local _0 = _37_
        return empty_cons, first(s)
      else
        return nil
      end
    else
      return nil
    end
  end
  local function cons_pairs(s)
    return cons_next, nil, s
  end
  local function cons_eq(s1, s2)
    if rawequal(s1, s2) then
      return true
    else
      if (not rawequal(s2, empty_cons) and not rawequal(s1, empty_cons)) then
        local s10, s20, res = s1, s2, true
        while (res and s10 and s20) do
          res = (first(s10) == first(s20))
          s10 = next(s10)
          s20 = next(s20)
        end
        return res
      else
        return false
      end
    end
  end
  local function cons_len(s)
    local s0, len = s, 0
    while s0 do
      s0, len = next(s0), (len + 1)
    end
    return len
  end
  local function cons_index(s, i)
    if (i > 0) then
      local s0, i_2a = s, 1
      while ((i_2a ~= i) and s0) do
        s0, i_2a = next(s0), (i_2a + 1)
      end
      return first(s0)
    else
      return nil
    end
  end
  local function cons(head, tail)
    do local _ = {head, tail} end
    local tp = gettype(tail)
    assert(allowed_types[tp], ("expected nil, cons, table, or string as a tail, got: %s"):format(tp))
    local function _43_(_241, _242)
      if _242 then
        return head
      else
        local _44_ = tail
        if (nil ~= _44_) then
          local s = _44_
          return s
        elseif (_44_ == nil) then
          return empty_cons
        else
          return nil
        end
      end
    end
    return setmetatable({}, {__call = _43_, ["__lazy-seq/type"] = "cons", __index = cons_index, __newindex = cons_newindex, __len = cons_len, __pairs = cons_pairs, __name = "cons", __eq = cons_eq, __fennelview = pp_seq, __fennelrest = cons_fennelrest})
  end
  local function _47_(s)
    local _48_ = gettype(s)
    if (_48_ == "cons") then
      return s
    elseif (_48_ == "lazy-cons") then
      return seq(realize(s))
    elseif (_48_ == "empty-cons") then
      return nil
    elseif (_48_ == "nil") then
      return nil
    elseif (_48_ == "table") then
      return cons_iter(s)
    elseif (_48_ == "string") then
      return cons_iter(s)
    elseif true then
      local _ = _48_
      return error(("expected table, string or sequence, got %s"):format(_), 2)
    else
      return nil
    end
  end
  seq = _47_
  local function lazy_seq(f)
    local lazy_cons = cons(nil, nil)
    local realize0
    local function _50_()
      local s = seq(f())
      if (nil ~= s) then
        return setmetatable(lazy_cons, getmetatable(s))
      else
        return setmetatable(lazy_cons, getmetatable(empty_cons))
      end
    end
    realize0 = _50_
    local function _52_(_241, _242)
      return realize0()(_242)
    end
    local function _53_(_241, _242)
      return (realize0())[_242]
    end
    local function _54_(...)
      realize0()
      return pp_seq(...)
    end
    local function _55_()
      return length_2a(realize0())
    end
    local function _56_()
      return pairs_2a(realize0())
    end
    local function _57_(_241, _242)
      return (realize0() == _242)
    end
    return setmetatable(lazy_cons, {__call = _52_, __index = _53_, __newindex = cons_newindex, __fennelview = _54_, __fennelrest = cons_fennelrest, __len = _55_, __pairs = _56_, __name = "lazy cons", __eq = _57_, ["__lazy-seq/type"] = "lazy-cons"})
  end
  local function list(...)
    local args = table_pack(...)
    local l = empty_cons
    for i = args.n, 1, -1 do
      l = cons(args[i], l)
    end
    return l
  end
  local function spread(arglist)
    local arglist0 = seq(arglist)
    if (nil == arglist0) then
      return nil
    elseif (nil == next(arglist0)) then
      return seq(first(arglist0))
    elseif "else" then
      return cons(first(arglist0), spread(next(arglist0)))
    else
      return nil
    end
  end
  local function list_2a(...)
    local _59_, _60_, _61_, _62_, _63_ = select("#", ...), ...
    if ((_59_ == 1) and true) then
      local _3fargs = _60_
      return seq(_3fargs)
    elseif ((_59_ == 2) and true and true) then
      local _3fa = _60_
      local _3fargs = _61_
      return cons(_3fa, seq(_3fargs))
    elseif ((_59_ == 3) and true and true and true) then
      local _3fa = _60_
      local _3fb = _61_
      local _3fargs = _62_
      return cons(_3fa, cons(_3fb, seq(_3fargs)))
    elseif ((_59_ == 4) and true and true and true and true) then
      local _3fa = _60_
      local _3fb = _61_
      local _3fc = _62_
      local _3fargs = _63_
      return cons(_3fa, cons(_3fb, cons(_3fc, seq(_3fargs))))
    elseif true then
      local _ = _59_
      return spread(list(...))
    else
      return nil
    end
  end
  local function kind(t)
    local _65_ = type(t)
    if (_65_ == "table") then
      local len = length_2a(t)
      local nxt, t_2a, k = pairs_2a(t)
      local function _66_()
        if (len == 0) then
          return k
        else
          return len
        end
      end
      if (nil ~= nxt(t_2a, _66_())) then
        return "assoc"
      elseif (len > 0) then
        return "seq"
      else
        return "empty"
      end
    elseif (_65_ == "string") then
      local len
      if utf8 then
        len = utf8.len(t)
      else
        len = #t
      end
      if (len > 0) then
        return "string"
      else
        return "empty"
      end
    elseif true then
      local _ = _65_
      return "else"
    else
      return nil
    end
  end
  local function rseq(rev)
    local _71_ = gettype(rev)
    if (_71_ == "table") then
      local _72_ = kind(rev)
      if (_72_ == "seq") then
        local function wrap(nxt, t, i)
          local i0, v = nxt(t, i)
          if (nil ~= i0) then
            local function _73_()
              return wrap(nxt, t, i0)
            end
            return cons(v, lazy_seq(_73_))
          else
            return empty_cons
          end
        end
        return wrap(rev_ipairs(rev))
      elseif (_72_ == "empty") then
        return nil
      elseif true then
        local _ = _72_
        return error("can't create an rseq from a non-sequential table")
      else
        return nil
      end
    elseif true then
      local _ = _71_
      return error(("can't create an rseq from a " .. _))
    else
      return nil
    end
  end
  local function _77_(t)
    local _78_ = kind(t)
    if (_78_ == "assoc") then
      local function wrap(nxt, t0, k)
        local k0, v = nxt(t0, k)
        if (nil ~= k0) then
          local function _79_()
            return wrap(nxt, t0, k0)
          end
          return cons({k0, v}, lazy_seq(_79_))
        else
          return empty_cons
        end
      end
      return wrap(pairs_2a(t))
    elseif (_78_ == "seq") then
      local function wrap(nxt, t0, i)
        local i0, v = nxt(t0, i)
        if (nil ~= i0) then
          local function _81_()
            return wrap(nxt, t0, i0)
          end
          return cons(v, lazy_seq(_81_))
        else
          return empty_cons
        end
      end
      return wrap(ipairs_2a(t))
    elseif (_78_ == "string") then
      local char
      if utf8 then
        char = utf8.char
      else
        char = string.char
      end
      local function wrap(nxt, t0, i)
        local i0, v = nxt(t0, i)
        if (nil ~= i0) then
          local function _84_()
            return wrap(nxt, t0, i0)
          end
          return cons(char(v), lazy_seq(_84_))
        else
          return empty_cons
        end
      end
      local function _86_()
        if utf8 then
          return utf8.codes(t)
        else
          return ipairs_2a({string.byte(t, 1, #t)})
        end
      end
      return wrap(_86_())
    elseif (_78_ == "empty") then
      return nil
    else
      return nil
    end
  end
  cons_iter = _77_
  local function every_3f(pred, coll)
    local _88_ = seq(coll)
    if (nil ~= _88_) then
      local s = _88_
      if pred(first(s)) then
        local _89_ = next(s)
        if (nil ~= _89_) then
          local r = _89_
          return every_3f(pred, r)
        elseif true then
          local _ = _89_
          return true
        else
          return nil
        end
      else
        return false
      end
    elseif true then
      local _ = _88_
      return false
    else
      return nil
    end
  end
  local function some_3f(pred, coll)
    local _93_ = seq(coll)
    if (nil ~= _93_) then
      local s = _93_
      local function _94_()
        local _95_ = next(s)
        if (nil ~= _95_) then
          local r = _95_
          return some_3f(pred, r)
        elseif true then
          local _ = _95_
          return nil
        else
          return nil
        end
      end
      return (pred(first(s)) or _94_())
    elseif true then
      local _ = _93_
      return nil
    else
      return nil
    end
  end
  local function pack(s)
    local res = {}
    local n = 0
    do
      local _98_ = seq(s)
      if (nil ~= _98_) then
        local s_2a = _98_
        for _, v in pairs_2a(s_2a) do
          n = (n + 1)
          do end (res)[n] = v
        end
      else
      end
    end
    res["n"] = n
    return res
  end
  local function count(s)
    local _100_ = seq(s)
    if (nil ~= _100_) then
      local s_2a = _100_
      return length_2a(s_2a)
    elseif true then
      local _ = _100_
      return 0
    else
      return nil
    end
  end
  local function unpack(s)
    local t = pack(s)
    return table_unpack(t, 1, t.n)
  end
  local function concat(...)
    local _102_ = select("#", ...)
    if (_102_ == 0) then
      return empty_cons
    elseif (_102_ == 1) then
      local x = ...
      local function _103_()
        return x
      end
      return lazy_seq(_103_)
    elseif (_102_ == 2) then
      local x, y = ...
      local function _104_()
        local _105_ = seq(x)
        if (nil ~= _105_) then
          local s = _105_
          return cons(first(s), concat(rest(s), y))
        elseif (_105_ == nil) then
          return y
        else
          return nil
        end
      end
      return lazy_seq(_104_)
    elseif true then
      local _ = _102_
      local function _109_(...)
        local _107_, _108_ = ...
        return _107_, _108_
      end
      return concat(concat(_109_(...)), select(3, ...))
    else
      return nil
    end
  end
  local function reverse(s)
    local function helper(s0, res)
      local _111_ = seq(s0)
      if (nil ~= _111_) then
        local s_2a = _111_
        return helper(rest(s_2a), cons(first(s_2a), res))
      elseif true then
        local _ = _111_
        return res
      else
        return nil
      end
    end
    return helper(s, empty_cons)
  end
  local function map(f, ...)
    local _113_ = select("#", ...)
    if (_113_ == 0) then
      return nil
    elseif (_113_ == 1) then
      local col = ...
      local function _114_()
        local _115_ = seq(col)
        if (nil ~= _115_) then
          local x = _115_
          return cons(f(first(x)), map(f, seq(rest(x))))
        elseif true then
          local _ = _115_
          return nil
        else
          return nil
        end
      end
      return lazy_seq(_114_)
    elseif (_113_ == 2) then
      local s1, s2 = ...
      local function _117_()
        local s10 = seq(s1)
        local s20 = seq(s2)
        if (s10 and s20) then
          return cons(f(first(s10), first(s20)), map(f, rest(s10), rest(s20)))
        else
          return nil
        end
      end
      return lazy_seq(_117_)
    elseif (_113_ == 3) then
      local s1, s2, s3 = ...
      local function _119_()
        local s10 = seq(s1)
        local s20 = seq(s2)
        local s30 = seq(s3)
        if (s10 and s20 and s30) then
          return cons(f(first(s10), first(s20), first(s30)), map(f, rest(s10), rest(s20), rest(s30)))
        else
          return nil
        end
      end
      return lazy_seq(_119_)
    elseif true then
      local _ = _113_
      local s = list(...)
      local function _121_()
        local function _122_(_2410)
          return (nil ~= seq(_2410))
        end
        if every_3f(_122_, s) then
          return cons(f(unpack(map(first, s))), map(f, unpack(map(rest, s))))
        else
          return nil
        end
      end
      return lazy_seq(_121_)
    else
      return nil
    end
  end
  local function map_indexed(f, coll)
    local mapi
    local function mapi0(idx, coll0)
      local function _125_()
        local _126_ = seq(coll0)
        if (nil ~= _126_) then
          local s = _126_
          return cons(f(idx, first(s)), mapi0((idx + 1), rest(s)))
        elseif true then
          local _ = _126_
          return nil
        else
          return nil
        end
      end
      return lazy_seq(_125_)
    end
    mapi = mapi0
    return mapi(1, coll)
  end
  local function mapcat(f, ...)
    local step
    local function step0(colls)
      local function _128_()
        local _129_ = seq(colls)
        if (nil ~= _129_) then
          local s = _129_
          local c = first(s)
          return concat(c, step0(rest(colls)))
        elseif true then
          local _ = _129_
          return nil
        else
          return nil
        end
      end
      return lazy_seq(_128_)
    end
    step = step0
    return step(map(f, ...))
  end
  local function take(n, coll)
    local function _131_()
      if (n > 0) then
        local _132_ = seq(coll)
        if (nil ~= _132_) then
          local s = _132_
          return cons(first(s), take((n - 1), rest(s)))
        elseif true then
          local _ = _132_
          return nil
        else
          return nil
        end
      else
        return nil
      end
    end
    return lazy_seq(_131_)
  end
  local function take_while(pred, coll)
    local function _135_()
      local _136_ = seq(coll)
      if (nil ~= _136_) then
        local s = _136_
        local v = first(s)
        if pred(v) then
          return cons(v, take_while(pred, rest(s)))
        else
          return nil
        end
      elseif true then
        local _ = _136_
        return nil
      else
        return nil
      end
    end
    return lazy_seq(_135_)
  end
  local function _139_(n, coll)
    local step
    local function step0(n0, coll0)
      local s = seq(coll0)
      if ((n0 > 0) and s) then
        return step0((n0 - 1), rest(s))
      else
        return s
      end
    end
    step = step0
    local function _141_()
      return step(n, coll)
    end
    return lazy_seq(_141_)
  end
  drop = _139_
  local function drop_while(pred, coll)
    local step
    local function step0(pred0, coll0)
      local s = seq(coll0)
      if (s and pred0(first(s))) then
        return step0(pred0, rest(s))
      else
        return s
      end
    end
    step = step0
    local function _143_()
      return step(pred, coll)
    end
    return lazy_seq(_143_)
  end
  local function drop_last(...)
    local _144_ = select("#", ...)
    if (_144_ == 0) then
      return empty_cons
    elseif (_144_ == 1) then
      return drop_last(1, ...)
    elseif true then
      local _ = _144_
      local n, coll = ...
      local function _145_(x)
        return x
      end
      return map(_145_, coll, drop(n, coll))
    else
      return nil
    end
  end
  local function take_last(n, coll)
    local function loop(s, lead)
      if lead then
        return loop(next(s), next(lead))
      else
        return s
      end
    end
    return loop(seq(coll), seq(drop(n, coll)))
  end
  local function take_nth(n, coll)
    local function _148_()
      local _149_ = seq(coll)
      if (nil ~= _149_) then
        local s = _149_
        return cons(first(s), take_nth(n, drop(n, s)))
      else
        return nil
      end
    end
    return lazy_seq(_148_)
  end
  local function split_at(n, coll)
    return {take(n, coll), drop(n, coll)}
  end
  local function split_with(pred, coll)
    return {take_while(pred, coll), drop_while(pred, coll)}
  end
  local function filter(pred, coll)
    local function _151_()
      local _152_ = seq(coll)
      if (nil ~= _152_) then
        local s = _152_
        local x = first(s)
        local r = rest(s)
        if pred(x) then
          return cons(x, filter(pred, r))
        else
          return filter(pred, r)
        end
      elseif true then
        local _ = _152_
        return nil
      else
        return nil
      end
    end
    return lazy_seq(_151_)
  end
  local function keep(f, coll)
    local function _155_()
      local _156_ = seq(coll)
      if (nil ~= _156_) then
        local s = _156_
        local _157_ = f(first(s))
        if (nil ~= _157_) then
          local x = _157_
          return cons(x, keep(f, rest(s)))
        elseif (_157_ == nil) then
          return keep(f, rest(s))
        else
          return nil
        end
      elseif true then
        local _ = _156_
        return nil
      else
        return nil
      end
    end
    return lazy_seq(_155_)
  end
  local function keep_indexed(f, coll)
    local keepi
    local function keepi0(idx, coll0)
      local function _160_()
        local _161_ = seq(coll0)
        if (nil ~= _161_) then
          local s = _161_
          local x = f(idx, first(s))
          if (nil == x) then
            return keepi0((1 + idx), rest(s))
          else
            return cons(x, keepi0((1 + idx), rest(s)))
          end
        else
          return nil
        end
      end
      return lazy_seq(_160_)
    end
    keepi = keepi0
    return keepi(1, coll)
  end
  local function remove(pred, coll)
    local function _164_(_241)
      return not pred(_241)
    end
    return filter(_164_, coll)
  end
  local function cycle(coll)
    local function _165_()
      return concat(seq(coll), cycle(coll))
    end
    return lazy_seq(_165_)
  end
  local function _repeat(x)
    local function step(x0)
      local function _166_()
        return cons(x0, step(x0))
      end
      return lazy_seq(_166_)
    end
    return step(x)
  end
  local function repeatedly(f, ...)
    local args = table_pack(...)
    local f0
    local function _167_()
      return f(table_unpack(args, 1, args.n))
    end
    f0 = _167_
    local function step(f1)
      local function _168_()
        return cons(f1(), step(f1))
      end
      return lazy_seq(_168_)
    end
    return step(f0)
  end
  local function iterate(f, x)
    local x_2a = f(x)
    local function _169_()
      return iterate(f, x_2a)
    end
    return cons(x, lazy_seq(_169_))
  end
  local function nthnext(coll, n)
    local function loop(n0, xs)
      local _170_ = xs
      local function _171_()
        local xs_2a = _170_
        return (n0 > 0)
      end
      if ((nil ~= _170_) and _171_()) then
        local xs_2a = _170_
        return loop((n0 - 1), next(xs_2a))
      elseif true then
        local _ = _170_
        return xs
      else
        return nil
      end
    end
    return loop(n, seq(coll))
  end
  local function nthrest(coll, n)
    local function loop(n0, xs)
      local _173_ = seq(xs)
      local function _174_()
        local xs_2a = _173_
        return (n0 > 0)
      end
      if ((nil ~= _173_) and _174_()) then
        local xs_2a = _173_
        return loop((n0 - 1), rest(xs_2a))
      elseif true then
        local _ = _173_
        return xs
      else
        return nil
      end
    end
    return loop(n, coll)
  end
  local function dorun(s)
    local _176_ = seq(s)
    if (nil ~= _176_) then
      local s_2a = _176_
      return dorun(next(s_2a))
    elseif true then
      local _ = _176_
      return nil
    else
      return nil
    end
  end
  local function doall(s)
    dorun(s)
    return s
  end
  local function partition(...)
    local _178_ = select("#", ...)
    if (_178_ == 2) then
      local n, coll = ...
      return partition(n, n, coll)
    elseif (_178_ == 3) then
      local n, step, coll = ...
      local function _179_()
        local _180_ = seq(coll)
        if (nil ~= _180_) then
          local s = _180_
          local p = take(n, s)
          if (n == length_2a(p)) then
            return cons(p, partition(n, step, nthrest(s, step)))
          else
            return nil
          end
        elseif true then
          local _ = _180_
          return nil
        else
          return nil
        end
      end
      return lazy_seq(_179_)
    elseif (_178_ == 4) then
      local n, step, pad, coll = ...
      local function _183_()
        local _184_ = seq(coll)
        if (nil ~= _184_) then
          local s = _184_
          local p = take(n, s)
          if (n == length_2a(p)) then
            return cons(p, partition(n, step, pad, nthrest(s, step)))
          else
            return list(take(n, concat(p, pad)))
          end
        elseif true then
          local _ = _184_
          return nil
        else
          return nil
        end
      end
      return lazy_seq(_183_)
    elseif true then
      local _ = _178_
      return error("wrong amount arguments to 'partition'")
    else
      return nil
    end
  end
  local function partition_by(f, coll)
    local function _188_()
      local _189_ = seq(coll)
      if (nil ~= _189_) then
        local s = _189_
        local v = first(s)
        local fv = f(v)
        local run
        local function _190_(_2410)
          return (fv == f(_2410))
        end
        run = cons(v, take_while(_190_, next(s)))
        local function _191_()
          return drop(length_2a(run), s)
        end
        return cons(run, partition_by(f, lazy_seq(_191_)))
      else
        return nil
      end
    end
    return lazy_seq(_188_)
  end
  local function partition_all(...)
    local _193_ = select("#", ...)
    if (_193_ == 2) then
      local n, coll = ...
      return partition_all(n, n, coll)
    elseif (_193_ == 3) then
      local n, step, coll = ...
      local function _194_()
        local _195_ = seq(coll)
        if (nil ~= _195_) then
          local s = _195_
          local p = take(n, s)
          return cons(p, partition_all(n, step, nthrest(s, step)))
        elseif true then
          local _ = _195_
          return nil
        else
          return nil
        end
      end
      return lazy_seq(_194_)
    elseif true then
      local _ = _193_
      return error("wrong amount arguments to 'partition-all'")
    else
      return nil
    end
  end
  local function reductions(...)
    local _198_ = select("#", ...)
    if (_198_ == 2) then
      local f, coll = ...
      local function _199_()
        local _200_ = seq(coll)
        if (nil ~= _200_) then
          local s = _200_
          return reductions(f, first(s), rest(s))
        elseif true then
          local _ = _200_
          return list(f())
        else
          return nil
        end
      end
      return lazy_seq(_199_)
    elseif (_198_ == 3) then
      local f, init, coll = ...
      local function _202_()
        local _203_ = seq(coll)
        if (nil ~= _203_) then
          local s = _203_
          return reductions(f, f(init, first(s)), rest(s))
        else
          return nil
        end
      end
      return cons(init, lazy_seq(_202_))
    elseif true then
      local _ = _198_
      return error("wrong amount arguments to 'reductions'")
    else
      return nil
    end
  end
  local function contains_3f(coll, elt)
    local _206_ = gettype(coll)
    if (_206_ == "table") then
      local _207_ = kind(coll)
      if (_207_ == "seq") then
        local res = false
        for _, v in ipairs_2a(coll) do
          if res then break end
          if (elt == v) then
            res = true
          else
            res = false
          end
        end
        return res
      elseif (_207_ == "assoc") then
        if coll[elt] then
          return true
        else
          return false
        end
      else
        return nil
      end
    elseif true then
      local _ = _206_
      local function loop(coll0)
        local _211_ = seq(coll0)
        if (nil ~= _211_) then
          local s = _211_
          if (elt == first(s)) then
            return true
          else
            return loop(rest(s))
          end
        elseif (_211_ == nil) then
          return false
        else
          return nil
        end
      end
      return loop(coll)
    else
      return nil
    end
  end
  local function distinct(coll)
    local function step(xs, seen)
      local loop
      local function loop0(_215_, seen0)
        local _arg_216_ = _215_
        local f = _arg_216_[1]
        local xs0 = _arg_216_
        local _217_ = seq(xs0)
        if (nil ~= _217_) then
          local s = _217_
          if (seen0)[f] then
            return loop0(rest(s), seen0)
          else
            local function _218_()
              seen0[f] = true
              return seen0
            end
            return cons(f, step(rest(s), _218_()))
          end
        elseif true then
          local _ = _217_
          return nil
        else
          return nil
        end
      end
      loop = loop0
      local function _221_()
        return loop(xs, seen)
      end
      return lazy_seq(_221_)
    end
    return step(coll, {})
  end
  local function inf_range(x, step)
    local function _222_()
      return cons(x, inf_range((x + step), step))
    end
    return lazy_seq(_222_)
  end
  local function fix_range(x, _end, step)
    local function _223_()
      if (((step >= 0) and (x < _end)) or ((step < 0) and (x > _end))) then
        return cons(x, fix_range((x + step), _end, step))
      elseif ((step == 0) and (x ~= _end)) then
        return cons(x, fix_range(x, _end, step))
      else
        return nil
      end
    end
    return lazy_seq(_223_)
  end
  local function range(...)
    local _225_ = select("#", ...)
    if (_225_ == 0) then
      return inf_range(0, 1)
    elseif (_225_ == 1) then
      local _end = ...
      return fix_range(0, _end, 1)
    elseif (_225_ == 2) then
      local x, _end = ...
      return fix_range(x, _end, 1)
    elseif true then
      local _ = _225_
      return fix_range(...)
    else
      return nil
    end
  end
  local function realized_3f(s)
    local _227_ = gettype(s)
    if (_227_ == "lazy-cons") then
      return false
    elseif (_227_ == "empty-cons") then
      return true
    elseif (_227_ == "cons") then
      return true
    elseif true then
      local _ = _227_
      return error(("expected a sequence, got: %s"):format(_))
    else
      return nil
    end
  end
  local function line_seq(file)
    local next_line = file:lines()
    local function step(f)
      local line = f()
      if ("string" == type(line)) then
        local function _229_()
          return step(f)
        end
        return cons(line, lazy_seq(_229_))
      else
        return nil
      end
    end
    return step(next_line)
  end
  local function tree_seq(branch_3f, children, root)
    local function walk(node)
      local function _231_()
        local function _232_()
          if branch_3f(node) then
            return mapcat(walk, children(node))
          else
            return nil
          end
        end
        return cons(node, _232_())
      end
      return lazy_seq(_231_)
    end
    return walk(root)
  end
  local function interleave(...)
    local _233_, _234_, _235_ = select("#", ...), ...
    if (_233_ == 0) then
      return empty_cons
    elseif ((_233_ == 1) and true) then
      local _3fs = _234_
      local function _236_()
        return _3fs
      end
      return lazy_seq(_236_)
    elseif ((_233_ == 2) and true and true) then
      local _3fs1 = _234_
      local _3fs2 = _235_
      local function _237_()
        local s1 = seq(_3fs1)
        local s2 = seq(_3fs2)
        if (s1 and s2) then
          return cons(first(s1), cons(first(s2), interleave(rest(s1), rest(s2))))
        else
          return nil
        end
      end
      return lazy_seq(_237_)
    elseif true then
      local _ = _233_
      local cols = list(...)
      local function _239_()
        local seqs = map(seq, cols)
        local function _240_(_2410)
          return (nil ~= seq(_2410))
        end
        if every_3f(_240_, seqs) then
          return concat(map(first, seqs), interleave(unpack(map(rest, seqs))))
        else
          return nil
        end
      end
      return lazy_seq(_239_)
    else
      return nil
    end
  end
  local function interpose(separator, coll)
    return drop(1, interleave(_repeat(separator), coll))
  end
  local function keys(t)
    assert(("assoc" == kind(t)), "expected an associative table")
    local function _243_(_241)
      return (_241)[1]
    end
    return map(_243_, t)
  end
  local function vals(t)
    assert(("assoc" == kind(t)), "expected an associative table")
    local function _244_(_241)
      return (_241)[2]
    end
    return map(_244_, t)
  end
  local function zipmap(keys0, vals0)
    local t = {}
    local function loop(s1, s2)
      if (s1 and s2) then
        t[first(s1)] = first(s2)
        return loop(next(s1), next(s2))
      else
        return nil
      end
    end
    loop(seq(keys0), seq(vals0))
    return t
  end
  local _local_246_ = require("reduced")
  local reduced = _local_246_["reduced"]
  local reduced_3f = _local_246_["reduced?"]
  local function reduce(f, ...)
    local _247_, _248_, _249_ = select("#", ...), ...
    if (_247_ == 0) then
      return error("expected a collection")
    elseif ((_247_ == 1) and true) then
      local _3fcoll = _248_
      local _250_ = count(_3fcoll)
      if (_250_ == 0) then
        return f()
      elseif (_250_ == 1) then
        return first(_3fcoll)
      elseif true then
        local _ = _250_
        return reduce(f, first(_3fcoll), rest(_3fcoll))
      else
        return nil
      end
    elseif ((_247_ == 2) and true and true) then
      local _3fval = _248_
      local _3fcoll = _249_
      local _252_ = seq(_3fcoll)
      if (nil ~= _252_) then
        local coll = _252_
        local done_3f = false
        local res = _3fval
        for _, v in pairs_2a(coll) do
          if done_3f then break end
          local res0 = f(res, v)
          if reduced_3f(res0) then
            done_3f = true
            res = res0:unbox()
          else
            res = res0
          end
        end
        return res
      elseif true then
        local _ = _252_
        return _3fval
      else
        return nil
      end
    else
      return nil
    end
  end
  return {first = first, rest = rest, nthrest = nthrest, next = next, nthnext = nthnext, cons = cons, seq = seq, rseq = rseq, ["seq?"] = seq_3f, ["empty?"] = empty_3f, ["lazy-seq"] = lazy_seq, list = list, ["list*"] = list_2a, ["every?"] = every_3f, ["some?"] = some_3f, pack = pack, unpack = unpack, count = count, concat = concat, map = map, ["map-indexed"] = map_indexed, mapcat = mapcat, take = take, ["take-while"] = take_while, ["take-last"] = take_last, ["take-nth"] = take_nth, drop = drop, ["drop-while"] = drop_while, ["drop-last"] = drop_last, remove = remove, ["split-at"] = split_at, ["split-with"] = split_with, partition = partition, ["partition-by"] = partition_by, ["partition-all"] = partition_all, filter = filter, keep = keep, ["keep-indexed"] = keep_indexed, ["contains?"] = contains_3f, distinct = distinct, cycle = cycle, ["repeat"] = _repeat, repeatedly = repeatedly, reductions = reductions, iterate = iterate, range = range, ["realized?"] = realized_3f, dorun = dorun, doall = doall, ["line-seq"] = line_seq, ["tree-seq"] = tree_seq, reverse = reverse, interleave = interleave, interpose = interpose, keys = keys, vals = vals, zipmap = zipmap, reduce = reduce, reduced = reduced, ["reduced?"] = reduced_3f}
end
package.preload["reduced"] = package.preload["reduced"] or function(...)
  --[[ MIT License
  
    Copyright (c) 2023 Andrey Listopadov
  
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the “Software”), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
  
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
  
    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE. ]]
  
  local lib_include_path = ...
  
  if lib_include_path ~= "reduced" then
    local msg = [[Invalid usage of the Reduced library: required as "%s" not as "reduced".
  
  The Reduced library must be required by callind require with the string "reduced" as the argument.
  This ensures that all of the code across all libraries uses the same entry from package.loaded.]]
    error(msg:format(lib_include_path))
  end
  
  local Reduced = {
    __index = {unbox = function (x) return x[1] end},
    __fennelview = function (x, view, options, indent)
      return "#<reduced: " .. view(x[1], options, (11 + indent)) .. ">"
    end,
    __name = "reduced",
    __tostring = function (x) return ("reduced: " .. tostring(x[1])) end
  }
  
  local function reduced(value) return setmetatable({value}, Reduced) end
  local function is_reduced(value) return rawequal(getmetatable(value), Reduced) end
  
  return {reduced = reduced, ["reduced?"] = is_reduced, is_reduced = is_reduced}
end
package.preload["itable"] = package.preload["itable"] or function(...)
  -- -*- buffer-read-only: t -*-
  local _local_1_ = table
  local t_2fsort = _local_1_["sort"]
  local t_2fconcat = _local_1_["concat"]
  local t_2fremove = _local_1_["remove"]
  local t_2fmove = _local_1_["move"]
  local t_2finsert = _local_1_["insert"]
  local t_2funpack = (table.unpack or _G.unpack)
  local t_2fpack
  local function _2_(...)
    local _3_ = {...}
    _3_["n"] = select("#", ...)
    return _3_
  end
  t_2fpack = _2_
  local function pairs_2a(t)
    local _5_
    do
      local _4_ = getmetatable(t)
      if ((_G.type(_4_) == "table") and (nil ~= (_4_).__pairs)) then
        local p = (_4_).__pairs
        _5_ = p
      elseif true then
        local _ = _4_
        _5_ = pairs
      else
        _5_ = nil
      end
    end
    return _5_(t)
  end
  local function ipairs_2a(t)
    local _10_
    do
      local _9_ = getmetatable(t)
      if ((_G.type(_9_) == "table") and (nil ~= (_9_).__ipairs)) then
        local i = (_9_).__ipairs
        _10_ = i
      elseif true then
        local _ = _9_
        _10_ = ipairs
      else
        _10_ = nil
      end
    end
    return _10_(t)
  end
  local function length_2a(t)
    local _15_
    do
      local _14_ = getmetatable(t)
      if ((_G.type(_14_) == "table") and (nil ~= (_14_).__len)) then
        local l = (_14_).__len
        _15_ = l
      elseif true then
        local _ = _14_
        local function _18_(...)
          return #...
        end
        _15_ = _18_
      else
        _15_ = nil
      end
    end
    return _15_(t)
  end
  local function copy(t)
    if t then
      local tbl_12_auto = {}
      for k, v in pairs_2a(t) do
        local _20_, _21_ = k, v
        if ((nil ~= _20_) and (nil ~= _21_)) then
          local k_13_auto = _20_
          local v_14_auto = _21_
          tbl_12_auto[k_13_auto] = v_14_auto
        else
        end
      end
      return tbl_12_auto
    else
      return nil
    end
  end
  local function eq(...)
    local _24_, _25_, _26_ = select("#", ...), ...
    local function _27_(...)
      return true
    end
    if ((_24_ == 0) and _27_(...)) then
      return true
    else
      local function _28_(...)
        return true
      end
      if ((_24_ == 1) and _28_(...)) then
        return true
      elseif ((_24_ == 2) and true and true) then
        local _3fa = _25_
        local _3fb = _26_
        if (_3fa == _3fb) then
          return true
        elseif (function(_29_,_30_,_31_) return (_29_ == _30_) and (_30_ == _31_) end)(type(_3fa),type(_3fb),"table") then
          local res, count_a, count_b = true, 0, 0
          for k, v in pairs_2a(_3fa) do
            if not res then break end
            local function _32_(...)
              local res0 = nil
              for k_2a, v0 in pairs_2a(_3fb) do
                if res0 then break end
                if eq(k_2a, k) then
                  res0 = v0
                else
                end
              end
              return res0
            end
            res = eq(v, _32_(...))
            count_a = (count_a + 1)
          end
          if res then
            for _, _0 in pairs_2a(_3fb) do
              count_b = (count_b + 1)
            end
            res = (count_a == count_b)
          else
          end
          return res
        else
          return false
        end
      elseif (true and true and true) then
        local _ = _24_
        local _3fa = _25_
        local _3fb = _26_
        return (eq(_3fa, _3fb) and eq(select(2, ...)))
      else
        return nil
      end
    end
  end
  local function deep_index(tbl, key)
    local res = nil
    for k, v in pairs_2a(tbl) do
      if res then break end
      if eq(k, key) then
        res = v
      else
        res = nil
      end
    end
    return res
  end
  local function deep_newindex(tbl, key, val)
    local done = false
    if ("table" == type(key)) then
      for k, _ in pairs_2a(tbl) do
        if done then break end
        if eq(k, key) then
          rawset(tbl, k, val)
          done = true
        else
        end
      end
    else
    end
    if not done then
      return rawset(tbl, key, val)
    else
      return nil
    end
  end
  local function immutable(t, opts)
    local t0
    if (opts and opts["fast-index?"]) then
      t0 = t
    else
      t0 = setmetatable(t, {__index = deep_index, __newindex = deep_newindex})
    end
    local len = length_2a(t0)
    local proxy = {}
    local __len
    local function _42_()
      return len
    end
    __len = _42_
    local __index
    local function _43_(_241, _242)
      return (t0)[_242]
    end
    __index = _43_
    local __newindex
    local function _44_()
      return error((tostring(proxy) .. " is immutable"), 2)
    end
    __newindex = _44_
    local __pairs
    local function _45_()
      local function _46_(_, k)
        return next(t0, k)
      end
      return _46_, nil, nil
    end
    __pairs = _45_
    local __ipairs
    local function _47_()
      local function _48_(_, k)
        return next(t0, k)
      end
      return _48_
    end
    __ipairs = _47_
    local __call
    local function _49_(_241, _242)
      return (t0)[_242]
    end
    __call = _49_
    local __fennelview
    local function _50_(_241, _242, _243, _244)
      return _242(t0, _243, _244)
    end
    __fennelview = _50_
    local __fennelrest
    local function _51_(_241, _242)
      return immutable({t_2funpack(t0, _242)})
    end
    __fennelrest = _51_
    return setmetatable(proxy, {__index = __index, __newindex = __newindex, __len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __metatable = {__len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __fennelrest = __fennelrest, __fennelview = __fennelview, ["itable/type"] = "immutable"}})
  end
  local function insert(t, ...)
    local t0 = copy(t)
    do
      local _52_, _53_, _54_ = select("#", ...), ...
      if (_52_ == 0) then
        error("wrong number of arguments to 'insert'")
      elseif ((_52_ == 1) and true) then
        local _3fv = _53_
        t_2finsert(t0, _3fv)
      elseif (true and true and true) then
        local _ = _52_
        local _3fk = _53_
        local _3fv = _54_
        t_2finsert(t0, _3fk, _3fv)
      else
      end
    end
    return immutable(t0)
  end
  local move
  if t_2fmove then
    local function _56_(src, start, _end, tgt, dest)
      local src0 = copy(src)
      local dest0 = copy(dest)
      return immutable(t_2fmove(src0, start, _end, tgt, dest0))
    end
    move = _56_
  else
    move = nil
  end
  local function pack(...)
    local function _59_(...)
      local _58_ = {...}
      _58_["n"] = select("#", ...)
      return _58_
    end
    return immutable(_59_(...))
  end
  local function remove(t, key)
    local t0 = copy(t)
    local v = t_2fremove(t0, key)
    return immutable(t0), v
  end
  local function concat(t, sep, start, _end, serializer, opts)
    local serializer0 = (serializer or tostring)
    local _60_
    do
      local tbl_15_auto = {}
      local i_16_auto = #tbl_15_auto
      for _, v in ipairs_2a(t) do
        local val_17_auto = serializer0(v, opts)
        if (nil ~= val_17_auto) then
          i_16_auto = (i_16_auto + 1)
          do end (tbl_15_auto)[i_16_auto] = val_17_auto
        else
        end
      end
      _60_ = tbl_15_auto
    end
    return t_2fconcat(_60_, sep, start, _end)
  end
  local function unpack(t, ...)
    return t_2funpack(copy(t), ...)
  end
  local function assoc(t, key, val, ...)
    local len = select("#", ...)
    if (0 ~= (len % 2)) then
      error(("no value supplied for key " .. tostring(select(len, ...))), 2)
    else
    end
    local t0
    do
      local _63_ = copy(t)
      do end (_63_)[key] = val
      t0 = _63_
    end
    for i = 1, len, 2 do
      local k, v = select(i, ...)
      do end (t0)[k] = v
    end
    return immutable(t0)
  end
  local function assoc_in(t, _64_, val)
    local _arg_65_ = _64_
    local k = _arg_65_[1]
    local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_arg_65_, 2)
    local t0 = (t or {})
    if next(ks) then
      return assoc(t0, k, assoc_in(((t0)[k] or {}), ks, val))
    else
      return assoc(t0, k, val)
    end
  end
  local function update(t, key, f)
    local function _68_()
      local _67_ = copy(t)
      do end (_67_)[key] = f(t[key])
      return _67_
    end
    return immutable(_68_())
  end
  local function update_in(t, _69_, f)
    local _arg_70_ = _69_
    local k = _arg_70_[1]
    local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_arg_70_, 2)
    local t0 = (t or {})
    if next(ks) then
      return assoc(t0, k, update_in((t0)[k], ks, f))
    else
      return update(t0, k, f)
    end
  end
  local function deepcopy(x)
    local function deepcopy_2a(x0, seen)
      local _72_ = type(x0)
      if (_72_ == "table") then
        local _73_ = seen[x0]
        if (_73_ == true) then
          return error("immutable tables can't contain self reference", 2)
        elseif true then
          local _ = _73_
          seen[x0] = true
          local function _74_()
            local tbl_12_auto = {}
            for k, v in pairs_2a(x0) do
              local _75_, _76_ = deepcopy_2a(k, seen), deepcopy_2a(v, seen)
              if ((nil ~= _75_) and (nil ~= _76_)) then
                local k_13_auto = _75_
                local v_14_auto = _76_
                tbl_12_auto[k_13_auto] = v_14_auto
              else
              end
            end
            return tbl_12_auto
          end
          return immutable(_74_())
        else
          return nil
        end
      elseif true then
        local _ = _72_
        return x0
      else
        return nil
      end
    end
    return deepcopy_2a(x, {})
  end
  local function first(_80_)
    local _arg_81_ = _80_
    local x = _arg_81_[1]
    return x
  end
  local function rest(t)
    local _82_ = remove(t, 1)
    return _82_
  end
  local function nthrest(t, n)
    local t_2a = {}
    for i = (n + 1), length_2a(t) do
      t_2finsert(t_2a, t[i])
    end
    return immutable(t_2a)
  end
  local function last(t)
    return t[length_2a(t)]
  end
  local function butlast(t)
    local _83_ = remove(t, length_2a(t))
    return _83_
  end
  local function join(...)
    local _84_, _85_, _86_ = select("#", ...), ...
    if (_84_ == 0) then
      return nil
    elseif ((_84_ == 1) and true) then
      local _3ft = _85_
      return immutable(copy(_3ft))
    elseif ((_84_ == 2) and true and true) then
      local _3ft1 = _85_
      local _3ft2 = _86_
      local to = copy(_3ft1)
      local from = (_3ft2 or {})
      for _, v in ipairs_2a(from) do
        t_2finsert(to, v)
      end
      return immutable(to)
    elseif (true and true and true) then
      local _ = _84_
      local _3ft1 = _85_
      local _3ft2 = _86_
      return join(join(_3ft1, _3ft2), select(3, ...))
    else
      return nil
    end
  end
  local function take(n, t)
    local t_2a = {}
    for i = 1, n do
      t_2finsert(t_2a, t[i])
    end
    return immutable(t_2a)
  end
  local function drop(n, t)
    return nthrest(t, n)
  end
  local function partition(...)
    local res = {}
    local function partition_2a(...)
      local _88_, _89_, _90_, _91_, _92_ = select("#", ...), ...
      local function _93_(...)
        return true
      end
      if ((_88_ == 0) and _93_(...)) then
        return error("wrong amount arguments to 'partition'")
      else
        local function _94_(...)
          return true
        end
        if ((_88_ == 1) and _94_(...)) then
          return error("wrong amount arguments to 'partition'")
        elseif ((_88_ == 2) and true and true) then
          local _3fn = _89_
          local _3ft = _90_
          return partition_2a(_3fn, _3fn, _3ft)
        elseif ((_88_ == 3) and true and true and true) then
          local _3fn = _89_
          local _3fstep = _90_
          local _3ft = _91_
          local p = take(_3fn, _3ft)
          if (_3fn == length_2a(p)) then
            t_2finsert(res, p)
            return partition_2a(_3fn, _3fstep, {t_2funpack(_3ft, (_3fstep + 1))})
          else
            return nil
          end
        elseif (true and true and true and true and true) then
          local _ = _88_
          local _3fn = _89_
          local _3fstep = _90_
          local _3fpad = _91_
          local _3ft = _92_
          local p = take(_3fn, _3ft)
          if (_3fn == length_2a(p)) then
            t_2finsert(res, p)
            return partition_2a(_3fn, _3fstep, _3fpad, {t_2funpack(_3ft, (_3fstep + 1))})
          else
            return t_2finsert(res, take(_3fn, join(p, _3fpad)))
          end
        else
          return nil
        end
      end
    end
    partition_2a(...)
    return immutable(res)
  end
  local function keys(t)
    local function _98_()
      local tbl_15_auto = {}
      local i_16_auto = #tbl_15_auto
      for k, _ in pairs_2a(t) do
        local val_17_auto = k
        if (nil ~= val_17_auto) then
          i_16_auto = (i_16_auto + 1)
          do end (tbl_15_auto)[i_16_auto] = val_17_auto
        else
        end
      end
      return tbl_15_auto
    end
    return immutable(_98_())
  end
  local function vals(t)
    local function _100_()
      local tbl_15_auto = {}
      local i_16_auto = #tbl_15_auto
      for _, v in pairs_2a(t) do
        local val_17_auto = v
        if (nil ~= val_17_auto) then
          i_16_auto = (i_16_auto + 1)
          do end (tbl_15_auto)[i_16_auto] = val_17_auto
        else
        end
      end
      return tbl_15_auto
    end
    return immutable(_100_())
  end
  local function group_by(f, t)
    local res = {}
    local ungroupped = {}
    for _, v in pairs_2a(t) do
      local k = f(v)
      if (nil ~= k) then
        local _102_ = res[k]
        if (nil ~= _102_) then
          local t_2a = _102_
          t_2finsert(t_2a, v)
        elseif true then
          local _0 = _102_
          res[k] = {v}
        else
        end
      else
        t_2finsert(ungroupped, v)
      end
    end
    local function _105_()
      local tbl_12_auto = {}
      for k, t0 in pairs_2a(res) do
        local _106_, _107_ = k, immutable(t0)
        if ((nil ~= _106_) and (nil ~= _107_)) then
          local k_13_auto = _106_
          local v_14_auto = _107_
          tbl_12_auto[k_13_auto] = v_14_auto
        else
        end
      end
      return tbl_12_auto
    end
    return immutable(_105_()), immutable(ungroupped)
  end
  local function frequencies(t)
    local res = setmetatable({}, {__index = deep_index, __newindex = deep_newindex})
    for _, v in pairs_2a(t) do
      local _109_ = res[v]
      if (nil ~= _109_) then
        local a = _109_
        res[v] = (a + 1)
      elseif true then
        local _0 = _109_
        res[v] = 1
      else
      end
    end
    return immutable(res)
  end
  local itable
  local function _111_(t, f)
    local function _113_()
      local _112_ = copy(t)
      t_2fsort(_112_, f)
      return _112_
    end
    return immutable(_113_())
  end
  itable = {sort = _111_, pack = pack, unpack = unpack, concat = concat, insert = insert, move = move, remove = remove, pairs = pairs_2a, ipairs = ipairs_2a, length = length_2a, eq = eq, deepcopy = deepcopy, assoc = assoc, ["assoc-in"] = assoc_in, update = update, ["update-in"] = update_in, keys = keys, vals = vals, ["group-by"] = group_by, frequencies = frequencies, first = first, rest = rest, nthrest = nthrest, last = last, butlast = butlast, join = join, partition = partition, take = take, drop = drop}
  local function _114_(_, t, opts)
    local _115_ = getmetatable(t)
    if ((_G.type(_115_) == "table") and ((_115_)["itable/type"] == "immutable")) then
      return t
    elseif true then
      local _0 = _115_
      return immutable(copy(t), opts)
    else
      return nil
    end
  end
  return setmetatable(itable, {__call = _114_})
end
package.preload["doctest"] = package.preload["doctest"] or function(...)
  local function _925_()
    return "#<namespace: doctest>"
  end
  --[[ "Documentation testing facilities." ]]
  local _local_924_ = {setmetatable({}, {__fennelview = _925_, __name = "namespace"}), require("cljlib"), require("parser"), require("fennel")}, nil
  local doctest = _local_924_[1]
  local _local_1024_ = _local_924_[2]
  local conj = _local_1024_["conj"]
  local empty_3f = _local_1024_["empty?"]
  local filter = _local_1024_["filter"]
  local hash_set = _local_1024_["hash-set"]
  local keep = _local_1024_["keep"]
  local keys = _local_1024_["keys"]
  local reduce = _local_1024_["reduce"]
  local _local_1025_ = _local_924_[3]
  local create_sandbox = _local_1025_["create-sandbox"]
  local fennel = _local_924_[4]
  local extract_tests
  local function extract_tests0(...)
    local name, fn_doc = ...
    do
      local cnt_68_auto = select("#", ...)
      if (2 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "extract-tests"))
      else
      end
    end
    local tbl_17_auto = {}
    local i_18_auto = #tbl_17_auto
    for test in fn_doc:gmatch("\n?```%s*fennel.-\n```") do
      local val_19_auto
      if not string.match(test, "\n?%s*```%s*fennel[ \9]+:skip%-test") then
        val_19_auto = string.gsub(string.gsub(string.gsub(test, "\n?%s*```%s*fennel", ""), "\n%s*```", ""), "^\n", "")
      else
        do end (io.stderr):write("skipping test in '", tostring(name), "'\n")
        val_19_auto = nil
      end
      if (nil ~= val_19_auto) then
        i_18_auto = (i_18_auto + 1)
        do end (tbl_17_auto)[i_18_auto] = val_19_auto
      else
      end
    end
    return tbl_17_auto
  end
  extract_tests = extract_tests0
  local copy_table
  local function copy_table0(...)
    local t = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "copy-table"))
      else
      end
    end
    local tbl_14_auto = {}
    for k, v in pairs(t) do
      local k_15_auto, v_16_auto = k, v
      if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
        tbl_14_auto[k_15_auto] = v_16_auto
      else
      end
    end
    return tbl_14_auto
  end
  copy_table = copy_table0
  table.insert((package.loaders or package.searchers), fennel.searcher)
  local run_test
  local function run_test0(...)
    local test, requirements, module_info, sandbox_3f = ...
    do
      local cnt_68_auto = select("#", ...)
      if (4 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "run-test"))
      else
      end
    end
    local env
    if sandbox_3f then
      local function _1032_(...)
        return (io.stderr):write("WARNING: IO detected in the '", (module_info.file or "unknown"), "' file in the following test:\n``` fennel\n", test, "\n```\n")
      end
      local function _1033_()
        return (io.stderr):write("WARNING: 'io' module access detected in the '", (module_info.file or "unknown"), "' file in the following test:\n``` fennel\n", test, "\n```\n")
      end
      env = create_sandbox(module_info.file, {print = _1032_, io = setmetatable({}, {__index = _1033_})})
    else
      env = copy_table(_G)
    end
    local requirements0
    local function _1035_(...)
      local _1036_ = requirements
      if (nil ~= _1036_) then
        return (_1036_ .. "\n")
      else
        return _1036_
      end
    end
    requirements0 = (_1035_(...) or "")
    for fname, fval in pairs(module_info["f-table"]) do
      env[fname] = fval
    end
    return pcall(fennel.eval, (requirements0 .. test), {env = env})
  end
  run_test = run_test0
  local run_tests_for_fn
  local function run_tests_for_fn0(...)
    local func, docstring, module_info, sandbox_3f = ...
    do
      local cnt_68_auto = select("#", ...)
      if (4 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "run-tests-for-fn"))
      else
      end
    end
    local error_3f = false
    for n, test in ipairs(extract_tests(func, docstring)) do
      local _1039_, _1040_ = run_test(test, module_info.requirements, module_info, sandbox_3f)
      if ((_1039_ == false) and (nil ~= _1040_)) then
        local msg = _1040_
        local msg0 = string.gsub(tostring(msg), "^%[.-%]:%d+:%s*", "")
        do end (io.stderr):write("In file: '", module_info.file, "'\n", "Error in docstring for: '", func, "'\n", "In test:\n``` fennel\n", test, "\n```\n", "Error:\n", msg0, "\n\n")
        error_3f = true
      else
      end
    end
    return error_3f
  end
  run_tests_for_fn = run_tests_for_fn0
  local check_argument
  local function check_argument0(...)
    local func, argument, docstring, file, seen = ...
    do
      local cnt_68_auto = select("#", ...)
      if (5 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "check-argument"))
      else
      end
    end
    if (argument ~= "") then
      local argument_pat = (":?" .. argument:gsub("([][().%+-*?$^])", "%%%1"))
      if not (string.find(docstring, ("`" .. argument_pat .. "`")) or string.find(docstring, ("`" .. argument_pat .. "'"))) then
        if not seen(argument) then
          if string.find(docstring, ("%f[%w_]" .. argument_pat .. "%f[^%w_]")) then
            return (io.stderr):write("WARNING: in file '", file, "' argument '", argument, "' should appear in backtics in docstring for '", func, "'\n")
          else
            if (argument ~= "...") then
              return (io.stderr):write("WARNING: in file '", file, "' function '", func, "' has undocumented argument '", argument, "'\n")
            else
              return nil
            end
          end
        else
          return nil
        end
      else
        return nil
      end
    else
      return nil
    end
  end
  check_argument = check_argument0
  local function skip_arg_check_3f(argument, patterns)
    local function _1048_(pattern)
      return string.find(argument:gsub("^%s*(.-)%s*$", "%1"), ("^%f[%w_]" .. pattern .. "%f[^%w_]$"))
    end
    return not empty_3f(keep(_1048_, patterns))
  end
  local remove_code_blocks
  local function remove_code_blocks0(...)
    local docstring = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "remove-code-blocks"))
      else
      end
    end
    local _1050_ = string.gsub(docstring, "\n?```.-\n```\n?", "")
    return _1050_
  end
  remove_code_blocks = remove_code_blocks0
  local normalize_name
  local function normalize_name0(...)
    local name = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "normalize-name"))
      else
      end
    end
    return name:gsub("[\n\13()&]+", ""):gsub("\"[^\"]-\"", "")
  end
  normalize_name = normalize_name0
  local extract_destructured_args
  local function extract_destructured_args0(...)
    local argument = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "extract-destructured-args"))
      else
      end
    end
    local tbl_17_auto = {}
    local i_18_auto = #tbl_17_auto
    for arg in argument:gmatch("[^][ \n\13{}}]+") do
      local val_19_auto
      if not string.match(arg, "^:") then
        val_19_auto = arg
      else
        val_19_auto = nil
      end
      if (nil ~= val_19_auto) then
        i_18_auto = (i_18_auto + 1)
        do end (tbl_17_auto)[i_18_auto] = val_19_auto
      else
      end
    end
    return tbl_17_auto
  end
  extract_destructured_args = extract_destructured_args0
  local check_function_arglist
  local function check_function_arglist0(...)
    local func, arglist, docstring, _let_1055_, seen, patterns = ...
    local _let_1056_ = _let_1055_
    local file = _let_1056_["file"]
    do
      local cnt_68_auto = select("#", ...)
      if (6 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "check-function-arglist"))
      else
      end
    end
    local docstring0 = remove_code_blocks(docstring)
    local function _1058_(seen0, argument)
      local argument0 = normalize_name(argument)
      local function _1059_(seen1, argument1)
        check_argument(func, argument1, docstring0, file, seen1)
        return conj(seen1, argument1)
      end
      local function _1060_(_241)
        return not skip_arg_check_3f(_241, patterns)
      end
      local function _1061_()
        if argument0:find("[][{}]") then
          return extract_destructured_args(argument0)
        else
          return {argument0}
        end
      end
      return reduce(_1059_, seen0, filter(_1060_, _1061_()))
    end
    return reduce(_1058_, seen, arglist)
  end
  check_function_arglist = check_function_arglist0
  local check_function
  local function check_function0(...)
    local func, docstring, arglist, module_info, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (5 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "check-function"))
      else
      end
    end
    if (not docstring or (docstring == "")) then
      if (module_info.type == "function-module") then
        do end (io.stderr):write("WARNING: file '", module_info.file, "' exports undocumented value\n")
      else
        do end (io.stderr):write("WARNING: in file '", module_info.file, "' undocumented exported value '", func, "'\n")
      end
      return nil
    elseif arglist then
      check_function_arglist(func, arglist, docstring, module_info, hash_set(), config["ignored-args-patterns"])
      return run_tests_for_fn(func, docstring, module_info, config.sandbox)
    else
      return nil
    end
  end
  check_function = check_function0
  local test
  do
    local v_33_auto
    local function test0(...)
      local module_info, config = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "test"))
        else
        end
      end
      local error_3f = false
      do
        local _1066_ = module_info.type
        if (_1066_ == "function-module") then
          local fname
          do
            local _1067_ = next(module_info["f-table"])
            fname = _1067_
          end
          local docstring = (module_info["documented?"] and module_info.description)
          local arglist = module_info.arglist
          error_3f = check_function(fname, docstring, arglist, module_info, config)
        elseif true then
          local _ = _1066_
          local funcs = keys(module_info.items)
          for _0, func in ipairs(funcs) do
            local val_97_auto = module_info.items[func]
            if val_97_auto then
              local _let_1068_ = val_97_auto
              local docstring = _let_1068_["docstring"]
              local arglist = _let_1068_["arglist"]
              local res = check_function(func, docstring, arglist, module_info, config)
              error_3f = (error_3f or res)
            else
            end
          end
        else
        end
      end
      if error_3f then
        do end (io.stderr):write("Errors in module ", module_info.module, "\n")
        return os.exit(1)
      else
        return nil
      end
    end
    v_33_auto = test0
    doctest["test"] = v_33_auto
    test = v_33_auto
  end
  return doctest
end
package.preload["parser"] = package.preload["parser"] or function(...)
  local function _927_()
    return "#<namespace: parser>"
  end
  --[[ "A module that evaluates Fennel code and obtains documentation for each
  item in the module.  Supports sandboxing." ]]
  local _local_926_ = {setmetatable({}, {__fennelview = _927_, __name = "namespace"}), require("fennel"), require("fennel.compiler"), require("cljlib"), require("markdown")}, nil
  local parser = _local_926_[1]
  local _local_988_ = _local_926_[2]
  local dofile = _local_988_["dofile"]
  local metadata = _local_988_["metadata"]
  local compiler = _local_926_[3]
  local _local_989_ = _local_926_[4]
  local get_in = _local_989_["get-in"]
  local _local_990_ = _local_926_[5]
  local gen_function_signature = _local_990_["gen-function-signature"]
  local gen_item_documentation = _local_990_["gen-item-documentation"]
  local gen_item_signature = _local_990_["gen-item-signature"]
  local sandbox_module
  local function sandbox_module0(...)
    local module, file = ...
    do
      local cnt_68_auto = select("#", ...)
      if (2 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "sandbox-module"))
      else
      end
    end
    local function _992_()
      do end (io.stderr):write(("ERROR: access to '" .. module .. "' module detected in file: " .. file .. " while loading\n"))
      return os.exit(1)
    end
    return setmetatable({}, {__index = _992_})
  end
  sandbox_module = sandbox_module0
  local create_sandbox
  do
    local v_33_auto
    local function create_sandbox0(...)
      local _993_ = select("#", ...)
      if (_993_ == 0) then
        return error(("Wrong number of args (%s) passed to %s"):format(0, "create-sandbox"))
      elseif (_993_ == 1) then
        local file = ...
        return create_sandbox0(file, {})
      elseif (_993_ == 2) then
        local file, overrides = ...
        local env
        local function _994_()
          do end (io.stderr):write("ERROR: IO detected in file: ", file, " while loading\n")
          return os.exit(1)
        end
        env = {assert = assert, bit32 = bit32, collectgarbage = collectgarbage, coroutine = coroutine, dofile = dofile, error = error, getmetatable = getmetatable, ipairs = ipairs, math = math, next = next, pairs = pairs, pcall = pcall, rawequal = rawequal, rawlen = rawlen, require = require, select = select, setmetatable = setmetatable, string = string, table = table, tonumber = tonumber, tostring = tostring, type = type, unpack = unpack, utf8 = utf8, xpcall = xpcall, load = nil, loadfile = nil, loadstring = nil, rawget = nil, rawset = nil, module = nil, arg = {}, print = _994_, os = sandbox_module("os", file), debug = sandbox_module("debug", file), package = sandbox_module("package", file), io = sandbox_module("io", file)}
        env._G = env
        for k, v in pairs(overrides) do
          env[k] = v
        end
        return env
      elseif true then
        local _ = _993_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "create-sandbox"))
      else
        return nil
      end
    end
    v_33_auto = create_sandbox0
    parser["create-sandbox"] = v_33_auto
    create_sandbox = v_33_auto
  end
  local function_name_from_file
  local function function_name_from_file0(...)
    local file = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "function-name-from-file"))
      else
      end
    end
    local sep = (package.config):sub(1, 1)
    return string.gsub(string.gsub(file, (".*" .. sep), ""), "%.fnl$", "")
  end
  function_name_from_file = function_name_from_file0
  local get_module_docs
  local function get_module_docs0(...)
    local _1001_ = select("#", ...)
    if (_1001_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "get-module-docs"))
    elseif (_1001_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "get-module-docs"))
    elseif (_1001_ == 2) then
      local module, config = ...
      return get_module_docs0({}, module, config, nil)
    elseif (_1001_ == 3) then
      return error(("Wrong number of args (%s) passed to %s"):format(3, "get-module-docs"))
    elseif (_1001_ == 4) then
      local docs, module, config, parent = ...
      for id, val in pairs(module) do
        if (string.sub(id, 1, 1) ~= "_") then
          local _1002_ = type(val)
          if (_1002_ == "table") then
            get_module_docs0(docs, val, config, id)
          elseif true then
            local _ = _1002_
            local _1003_
            if parent then
              _1003_ = (parent .. "." .. id)
            else
              _1003_ = id
            end
            docs[_1003_] = {docstring = metadata:get(val, "fnl/docstring"), arglist = metadata:get(val, "fnl/arglist")}
          else
          end
        else
        end
      end
      return docs
    elseif true then
      local _ = _1001_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "get-module-docs"))
    else
      return nil
    end
  end
  get_module_docs = get_module_docs0
  local module_from_file
  local function module_from_file0(...)
    local file = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "module-from-file"))
      else
      end
    end
    local sep = (package.config):sub(1, 1)
    local module = string.gsub(string.gsub(file, sep, "."), "%.fnl$", "")
    return module
  end
  module_from_file = module_from_file0
  local require_module
  local function require_module0(...)
    local file, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (2 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "require-module"))
      else
      end
    end
    local env
    if config.sandbox then
      env = create_sandbox(file)
    else
      env = nil
    end
    local _1011_, _1012_ = pcall(dofile, file, {useMetadata = true, env = env, allowedGlobals = false}, module_from_file(file))
    if ((_1011_ == true) and true) then
      local _3fmodule = _1012_
      local module = (_3fmodule or {})
      return type(module), module, "functions"
    elseif (_1011_ == false) then
      local _1013_, _1014_ = pcall(dofile, file, {useMetadata = true, env = "_COMPILER", scope = compiler.scopes.compiler, allowedGlobals = false}, module_from_file(file))
      if ((_1013_ == true) and (nil ~= _1014_)) then
        local module = _1014_
        return type(module), module, "macros"
      elseif ((_1013_ == false) and (nil ~= _1014_)) then
        local msg = _1014_
        return false, msg
      else
        return nil
      end
    else
      return nil
    end
  end
  require_module = require_module0
  local warned = {}
  local module_info
  do
    local v_33_auto
    local function module_info0(...)
      local file, config = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "module-info"))
        else
        end
      end
      local _1018_, _1019_, _1020_ = require_module(file, config)
      if ((_1018_ == "table") and (nil ~= _1019_) and (nil ~= _1020_)) then
        local module = _1019_
        local module_type = _1020_
        local _1021_
        if (module_type == "macros") then
          _1021_ = {}
        else
          _1021_ = module
        end
        return {module = (get_in(config, {"modules-info", file, "name"}) or file), file = file, type = module_type, ["f-table"] = _1021_, requirements = get_in(config, {"test-requirements", file}, ""), version = (get_in(config, {"modules-info", file, "version"}) or config["project-version"]), description = get_in(config, {"modules-info", file, "description"}), copyright = (get_in(config, {"modules-info", file, "copyright"}) or config["project-copyright"]), license = (get_in(config, {"modules-info", file, "license"}) or config["project-license"]), items = get_module_docs(module, config), ["doc-order"] = (get_in(config, {"modules-info", file, "doc-order"}) or get_in(config, {"project-doc-order", file}) or {})}
      elseif ((_1018_ == "function") and (nil ~= _1019_)) then
        local _function = _1019_
        local docstring = metadata:get(_function, "fnl/docstring")
        local arglist = metadata:get(_function, "fnl/arglist")
        local fname = function_name_from_file(file)
        return {module = get_in(config, {"modules-info", file, "name"}, file), file = file, ["f-table"] = {[fname] = _function}, type = "function-module", requirements = get_in(config, {"test-requirements", file}, ""), ["documented?"] = not not docstring, description = (get_in(config, {"modules-info", file, "description"}, "") .. "\n" .. gen_function_signature(fname, arglist, config) .. "\n" .. gen_item_documentation(docstring, config["inline-references"])), arglist = arglist, items = {}}
      elseif ((_1018_ == false) and (nil ~= _1019_)) then
        local err = _1019_
        do end (io.stderr):write("Error loading ", file, "\n", err, "\n")
        return nil
      elseif true then
        local _ = _1018_
        do end (io.stderr):write("Error loading ", file, "\nunhandled error!\n", tostring(_))
        return nil
      else
        return nil
      end
    end
    v_33_auto = module_info0
    parser["module-info"] = v_33_auto
    module_info = v_33_auto
  end
  return parser
end
package.preload["markdown"] = package.preload["markdown"] or function(...)
  local function _929_()
    return "#<namespace: markdown>"
  end
  --[[ "Functions for generating Markdown" ]]
  local _local_928_ = {setmetatable({}, {__fennelview = _929_, __name = "namespace"}), require("cljlib")}, nil
  local markdown = _local_928_[1]
  local _local_930_ = _local_928_[2]
  local apply = _local_930_["apply"]
  local concat = _local_930_["concat"]
  local conj = _local_930_["conj"]
  local distinct = _local_930_["distinct"]
  local keys = _local_930_["keys"]
  local reduce = _local_930_["reduce"]
  local seq = _local_930_["seq"]
  local sort = _local_930_["sort"]
  local string_3f = _local_930_["string?"]
  local gen_info_comment
  local function gen_info_comment0(...)
    local lines, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (2 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-info-comment"))
      else
      end
    end
    if config["insert-comment"] then
      return conj(lines, "", ("<!-- Generated with Fenneldoc " .. config["fenneldoc-version"]), "     https://gitlab.com/andreyorst/fenneldoc -->", "")
    else
      return lines
    end
  end
  gen_info_comment = gen_info_comment0
  local gen_function_signature_2a
  local function gen_function_signature_2a0(...)
    local lines, item, arglist, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (4 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-function-signature*"))
      else
      end
    end
    local val_100_auto = (config["function-signatures"] and arglist and table.concat(arglist, " "))
    if val_100_auto then
      local arglist0 = val_100_auto
      local function _934_(...)
        if (arglist0 == "") then
          return ""
        else
          return " "
        end
      end
      return conj(lines, "Function signature:", "", "```", ("(" .. item .. _934_(...) .. arglist0 .. ")"), "```", "")
    else
      return lines
    end
  end
  gen_function_signature_2a = gen_function_signature_2a0
  local gen_license_info
  local function gen_license_info0(...)
    local lines, license, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (3 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-license-info"))
      else
      end
    end
    if (config["insert-license"] and license) then
      return conj(lines, ("License: " .. license), "")
    else
      return lines
    end
  end
  gen_license_info = gen_license_info0
  local gen_copyright_info
  local function gen_copyright_info0(...)
    local lines, copyright, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (3 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-copyright-info"))
      else
      end
    end
    if (config["insert-copyright"] and copyright) then
      return conj(lines, copyright, "")
    else
      return lines
    end
  end
  gen_copyright_info = gen_copyright_info0
  local extract_inline_code_references
  local function extract_inline_code_references0(...)
    local docstring = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "extract-inline-code-references"))
      else
      end
    end
    local tbl_17_auto = {}
    local i_18_auto = #tbl_17_auto
    for s in docstring:gmatch("`([%a_][^`']-)'") do
      local val_19_auto = s
      if (nil ~= val_19_auto) then
        i_18_auto = (i_18_auto + 1)
        do end (tbl_17_auto)[i_18_auto] = val_19_auto
      else
      end
    end
    return tbl_17_auto
  end
  extract_inline_code_references = extract_inline_code_references0
  local gen_cross_links
  local function gen_cross_links0(...)
    local docstring, toc, mode = ...
    do
      local cnt_68_auto = select("#", ...)
      if (3 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-cross-links"))
      else
      end
    end
    local docstring0 = docstring
    for _, item in ipairs(extract_inline_code_references(docstring0)) do
      local pat = item:gsub("([().%+-*?[^$])", "%%%1")
      local _943_ = mode
      if (_943_ == "link") then
        local _944_ = toc[item]
        if (nil ~= _944_) then
          local link_id = _944_
          docstring0 = docstring0:gsub(("`" .. pat .. "'"), ("[`" .. item .. "`](" .. link_id .. ")"))
        elseif true then
          local _0 = _944_
          docstring0 = docstring0:gsub(("`" .. pat .. "'"), ("`" .. item .. "`"))
        else
          docstring0 = nil
        end
      elseif (_943_ == "code") then
        docstring0 = docstring0:gsub(("`" .. pat .. "'"), ("`" .. item .. "`"))
      elseif true then
        local _0 = _943_
        docstring0 = docstring0
      else
        docstring0 = nil
      end
    end
    return docstring0
  end
  gen_cross_links = gen_cross_links0
  local remove_test_skip
  local function remove_test_skip0(...)
    local docstring = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "remove-test-skip"))
      else
      end
    end
    if string.match(docstring, "\n?%s*```%s*fennel[ \9]+:skip%-test") then
      local _948_ = string.gsub(docstring, "(\n?%s*```%s*fennel)[ \9]+:skip%-test", "%1")
      return _948_
    else
      return docstring
    end
  end
  remove_test_skip = remove_test_skip0
  local gen_item_documentation_2a
  local function gen_item_documentation_2a0(...)
    local lines, docstring, toc, mode = ...
    do
      local cnt_68_auto = select("#", ...)
      if (4 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-item-documentation*"))
      else
      end
    end
    local _951_
    if string_3f(docstring) then
      _951_ = gen_cross_links(remove_test_skip(docstring):gsub("# ", "### "), toc, mode)
    else
      _951_ = "**Undocumented**"
    end
    return conj(lines, _951_, "")
  end
  gen_item_documentation_2a = gen_item_documentation_2a0
  local sorter
  local function sorter0(...)
    local config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "sorter"))
      else
      end
    end
    local _954_ = config["doc-order"]
    if (_954_ == "alphabetic") then
      return nil
    elseif (_954_ == "reverse-alphabetic") then
      local function _955_(_241, _242)
        return (_241 > _242)
      end
      return _955_
    else
      local function _956_(...)
        local func = _954_
        return (type(func) == "function")
      end
      if ((nil ~= _954_) and _956_(...)) then
        local func = _954_
        return func
      elseif (nil ~= _954_) then
        local _else = _954_
        do end (io.stderr):write("Unsupported sorting algorithm: '", _else, "'\nSupported algorithms: alphabetic, reverse-alphabetic, or function.\n")
        return os.exit(-1)
      elseif (_954_ == nil) then
        return nil
      else
        return nil
      end
    end
  end
  sorter = sorter0
  local get_ordered_items
  local function get_ordered_items0(...)
    local module_info, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (2 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "get-ordered-items"))
      else
      end
    end
    local ordered_items = (module_info["doc-order"] or {})
    local sorted_items = sort(sorter(config), keys(module_info.items))
    return distinct(concat(ordered_items, sorted_items))
  end
  get_ordered_items = get_ordered_items0
  local heading_link
  local function heading_link0(...)
    local heading = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "heading-link"))
      else
      end
    end
    local link = string.lower(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(heading, "%.", ""), " ", "-"), "[^%w-]", ""), "[-]+", "-"), "^[-]*(.+)[-]*$", "%1"))
    if ("" ~= link) then
      return ("#" .. link)
    else
      return nil
    end
  end
  heading_link = heading_link0
  local toc_table
  local function toc_table0(...)
    local items = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "toc-table"))
      else
      end
    end
    local toc = {}
    local seen_headings = {}
    for _, item in ipairs(items) do
      local _962_ = heading_link(item)
      if (nil ~= _962_) then
        local heading = _962_
        local id = seen_headings[heading]
        local link
        local function _963_(...)
          if id then
            return ("-" .. id)
          else
            return ""
          end
        end
        link = (heading .. _963_(...))
        do end (seen_headings)[heading] = ((id or 0) + 1)
        do end (toc)[item] = link
      else
      end
    end
    return toc
  end
  toc_table = toc_table0
  local gen_toc
  local function gen_toc0(...)
    local lines, toc, ordered_items, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (4 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-toc"))
      else
      end
    end
    if (config.toc and toc and next(toc)) then
      local lines0
      if (config.toc and toc and next(toc)) then
        lines0 = conj(lines, "**Table of contents**", "")
      else
        lines0 = lines
      end
      local lines1
      if (config.toc and toc and next(toc)) then
        local function _967_(lines2, item)
          local _968_ = toc[item]
          if (nil ~= _968_) then
            local link = _968_
            return conj(lines2, ("- [`" .. item .. "`](" .. link .. ")"))
          elseif true then
            local _ = _968_
            return conj(lines2, ("- `" .. item .. "`"))
          else
            return nil
          end
        end
        lines1 = reduce(_967_, lines0, seq(ordered_items))
      else
        lines1 = lines0
      end
      return conj(lines1, "")
    else
      return nil
    end
  end
  gen_toc = gen_toc0
  local gen_items_doc
  local function gen_items_doc0(...)
    local lines, ordered_items, toc, module_info, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (5 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-items-doc"))
      else
      end
    end
    local function _973_(lines0, item)
      local _974_ = module_info.items[item]
      if (nil ~= _974_) then
        local info = _974_
        return gen_item_documentation_2a(gen_function_signature_2a(conj(lines0, ("## `" .. item .. "`")), item, info.arglist, config), info.docstring, toc, config["inline-references"])
      elseif (_974_ == nil) then
        print(("WARNING: Could not find '" .. item .. "' in " .. module_info.module))
        return lines0
      else
        return nil
      end
    end
    return reduce(_973_, lines, seq(ordered_items))
  end
  gen_items_doc = gen_items_doc0
  local module_version
  local function module_version0(...)
    local module_info = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "module-version"))
      else
      end
    end
    local _977_ = module_info.version
    if (nil ~= _977_) then
      local version = _977_
      return (" (" .. version .. ")")
    elseif true then
      local _ = _977_
      return ""
    else
      return nil
    end
  end
  module_version = module_version0
  local capitalize
  local function capitalize0(...)
    local str = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "capitalize"))
      else
      end
    end
    return (string.upper(str:sub(1, 1)) .. str:sub(2, -1))
  end
  capitalize = capitalize0
  local module_heading
  local function module_heading0(...)
    local file = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "module-heading"))
      else
      end
    end
    local function _982_(...)
      local _981_ = string.gsub(file, ".*/", "")
      return _981_
    end
    return ("# " .. capitalize(_982_(...)))
  end
  module_heading = module_heading0
  local gen_markdown
  do
    local v_33_auto
    local function gen_markdown0(...)
      local module_info, config = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-markdown"))
        else
        end
      end
      local ordered_items = get_ordered_items(module_info, config)
      local toc_table1 = toc_table(ordered_items)
      local lines = {(module_heading(module_info.module) .. module_version(module_info))}
      local lines0
      if module_info.description then
        lines0 = conj(lines, gen_cross_links(module_info.description, toc_table1, config["inline-references"]))
      else
        lines0 = lines
      end
      local lines1 = gen_items_doc(gen_toc(conj(lines0, ""), toc_table1, ordered_items, config), ordered_items, toc_table1, module_info, config)
      local lines2
      if ((module_info.copyright or module_info.license) and (config["insert-copyright"] or config["insert-license"])) then
        lines2 = gen_license_info(gen_copyright_info(conj(lines1, "", "---", ""), module_info.copyright, config), module_info.license, config)
      else
        lines2 = lines1
      end
      return table.concat(gen_info_comment(lines2, config), "\n")
    end
    v_33_auto = gen_markdown0
    markdown["gen-markdown"] = v_33_auto
    gen_markdown = v_33_auto
  end
  local gen_item_documentation
  do
    local v_33_auto
    local function gen_item_documentation0(...)
      local docstring, mode = ...
      do
        local cnt_68_auto = select("#", ...)
        if (2 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-item-documentation"))
        else
        end
      end
      return table.concat(gen_item_documentation_2a({}, docstring, {}, mode), "\n")
    end
    v_33_auto = gen_item_documentation0
    markdown["gen-item-documentation"] = v_33_auto
    gen_item_documentation = v_33_auto
  end
  local gen_function_signature
  do
    local v_33_auto
    local function gen_function_signature0(...)
      local _function, arglist, config = ...
      do
        local cnt_68_auto = select("#", ...)
        if (3 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "gen-function-signature"))
        else
        end
      end
      return table.concat(gen_function_signature_2a({}, _function, arglist, config), "\n")
    end
    v_33_auto = gen_function_signature0
    markdown["gen-function-signature"] = v_33_auto
    gen_function_signature = v_33_auto
  end
  return markdown
end
package.preload["writer"] = package.preload["writer"] or function(...)
  local function _1073_()
    return "#<namespace: writer>"
  end
  --[[ "Functions related to writing generated documentation into respecting files." ]]
  local _local_1072_ = {setmetatable({}, {__fennelview = _1073_, __name = "namespace"})}, nil
  local writer = _local_1072_[1]
  local file_exists_3f
  local function file_exists_3f0(...)
    local path = ...
    do
      local cnt_68_auto = select("#", ...)
      if (1 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "file-exists?"))
      else
      end
    end
    if (("./" == path) or ("../" == path)) then
      return true
    else
      local _1075_, _1076_, _1077_ = os.rename(path, path)
      if ((_1075_ == true) and true and (_1077_ == 13)) then
        local _ = _1076_
        return true
      elseif ((_1075_ == true) and true and true) then
        local _ = _1076_
        local _0 = _1077_
        return true
      elseif true then
        local _ = _1075_
        return false
      else
        return nil
      end
    end
  end
  file_exists_3f = file_exists_3f0
  local create_dirs_from_path
  local function create_dirs_from_path0(...)
    local file, module_info, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (3 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "create-dirs-from-path"))
      else
      end
    end
    local sep = (package.config):sub(1, 1)
    local path = (config["out-dir"] .. sep .. file:gsub(("[^" .. sep .. "]+.fnl$"), ""))
    local fname = (string.gsub(string.gsub((module_info.module or file), (".*[" .. sep .. "]+"), ""), ".fnl$", "") .. ".md")
    local p = ""
    for dir in path:gmatch(("[^" .. sep .. "]+")) do
      p = (p .. dir .. sep)
      if not file_exists_3f(p) then
        local _1081_, _1082_, _1083_ = os.execute(("mkdir " .. p))
        if ((_1081_ == nil) and true and (nil ~= _1083_)) then
          local _ = _1082_
          local code = _1083_
          return nil, p
        else
        end
      else
      end
    end
    return string.gsub((p .. sep .. fname), ("[" .. sep .. "]+"), sep)
  end
  create_dirs_from_path = create_dirs_from_path0
  local write_docs
  do
    local v_33_auto
    local function write_docs0(...)
      local docs, file, module_info, config = ...
      do
        local cnt_68_auto = select("#", ...)
        if (4 ~= cnt_68_auto) then
          error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "write-docs"))
        else
        end
      end
      local _1087_, _1088_ = create_dirs_from_path(file, module_info, config)
      if (nil ~= _1087_) then
        local path = _1087_
        local _1089_, _1090_, _1091_ = io.open(path, "w")
        if (nil ~= _1089_) then
          local f = _1089_
          local file0 = f
          local function close_handlers_10_auto(ok_11_auto, ...)
            file0:close()
            if ok_11_auto then
              return ...
            else
              return error(..., 0)
            end
          end
          local function _1093_()
            return file0:write(docs)
          end
          return close_handlers_10_auto(_G.xpcall(_1093_, (package.loaded.fennel or debug).traceback))
        elseif ((_1089_ == nil) and (nil ~= _1090_) and (nil ~= _1091_)) then
          local msg = _1090_
          local code = _1091_
          do end (io.stderr):write(("Error opening file '" .. path .. "': " .. msg .. " (" .. code .. ")\n"))
          return os.exit(code)
        else
          return nil
        end
      elseif ((_1087_ == nil) and (nil ~= _1088_)) then
        local dir = _1088_
        do end (io.stderr):write(("Error creating directory '" .. dir .. "\n"))
        return os.exit(-1)
      else
        return nil
      end
    end
    v_33_auto = write_docs0
    writer["write-docs"] = v_33_auto
    write_docs = v_33_auto
  end
  return writer
end
--[[ "main ns" ]]
local _local_1_ = {setmetatable({}, {__fennelview = _2_, __name = "namespace"}), require("config"), require("argparse"), require("doctest"), require("parser"), require("markdown"), require("writer")}, nil
local fenneldoc = _local_1_[1]
local _local_1096_ = _local_1_[2]
local process_config = _local_1096_["process-config"]
local _local_1097_ = _local_1_[3]
local process_args = _local_1097_["process-args"]
local _local_1098_ = _local_1_[4]
local test = _local_1098_["test"]
local _local_1099_ = _local_1_[5]
local module_info = _local_1099_["module-info"]
local _local_1100_ = _local_1_[6]
local gen_markdown = _local_1100_["gen-markdown"]
local _local_1101_ = _local_1_[7]
local write_docs = _local_1101_["write-docs"]
local process_file
do
  local v_33_auto
  local function process_file0(...)
    local file, config = ...
    do
      local cnt_68_auto = select("#", ...)
      if (2 ~= cnt_68_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_68_auto, "process-file"))
      else
      end
    end
    local _1103_ = module_info(file, config)
    if (nil ~= _1103_) then
      local module = _1103_
      if (config.mode ~= "doc") then
        test(module, config)
      else
      end
      local markdown = gen_markdown(module, config)
      if (config.mode ~= "check") then
        return write_docs(markdown, file, module, config)
      else
        return nil
      end
    elseif true then
      local _ = _1103_
      return (io.stderr):write("skipping ", file, "\n")
    else
      return nil
    end
  end
  v_33_auto = process_file0
  fenneldoc["process-file"] = v_33_auto
  process_file = v_33_auto
end
local files, config = process_args(process_config(FENNELDOC_VERSION))
for _, file in ipairs(files) do
  process_file(file, config)
end
return nil
