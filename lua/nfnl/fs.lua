local autoload = require("nfnl.autoload")
local core = autoload("nfnl.core")
local str = autoload("nfnl.string")
local function basename(path)
  return vim.fn.fnamemodify(path, ":h")
end
local function file_name_root(path)
  return vim.fn.fnamemodify(path, ":r")
end
local function mkdirp(dir)
  return vim.fn.mkdir(dir, "p")
end
local function replace_extension(path, ext)
  return (file_name_root(path) .. ("." .. ext))
end
local function relglob(dir, expr)
  local dir_len = core.inc(string.len(dir))
  local function _1_(_241)
    return string.sub(_241, dir_len)
  end
  return core.map(_1_, vim.fn.globpath(dir, expr, true, true))
end
local function glob_dir_newer_3f(a_dir, b_dir, expr, b_dir_path_fn)
  local newer_3f = false
  for _, path in ipairs(relglob(a_dir, expr)) do
    if (vim.fn.getftime((a_dir .. path)) > vim.fn.getftime((b_dir .. b_dir_path_fn(path)))) then
      newer_3f = true
    else
    end
  end
  return newer_3f
end
local path_sep
do
  local os = string.lower(jit.os)
  if (("linux" == os) or ("osx" == os) or ("bsd" == os)) then
    path_sep = "/"
  else
    path_sep = "\\"
  end
end
local function findfile(name, path)
  local res = vim.fn.findfile(name, path)
  if not core["empty?"](res) then
    return res
  else
    return nil
  end
end
local function split_path(path)
  local function _5_(_241)
    return not core["empty?"](_241)
  end
  return core.filter(_5_, str.split(path, path_sep))
end
local function join_path(parts)
  return str.join(path_sep, core.concat(parts))
end
return {basename = basename, ["file-name-root"] = file_name_root, mkdirp = mkdirp, ["replace-extension"] = replace_extension, relglob = relglob, ["glob-dir-newer?"] = glob_dir_newer_3f, ["path-sep"] = path_sep, findfile = findfile, ["split-path"] = split_path, ["join-path"] = join_path}