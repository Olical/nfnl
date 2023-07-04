local autoload = require("nfnl.autoload")
local core = autoload("nfnl.core")
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
return {basename = basename, ["file-name-root"] = file_name_root, mkdirp = mkdirp, ["replace-extension"] = replace_extension, relglob = relglob, ["glob-dir-newer?"] = glob_dir_newer_3f, ["path-sep"] = path_sep}
