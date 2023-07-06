-- [nfnl] Compiled from fnl/nfnl/init.fnl by https://github.com/Olical/nfnl, do not edit.
local autoload = require("nfnl.autoload")
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local nvim = autoload("nfnl.nvim")
local compile = autoload("nfnl.compile")
local config = autoload("nfnl.config")
local notify = autoload("nfnl.notify")
local function fennel_buf_write_post_callback_fn(root_dir, cfg)
  local function _1_(ev)
    return compile["into-file"]({["root-dir"] = root_dir, cfg = cfg, path = ev.file, source = nvim["get-buf-content-as-string"](ev.buf)})
  end
  return _1_
end
local function fennel_filetype_callback(ev)
  local file_path = fs["full-path"](ev.file)
  local file_dir = fs.basename(file_path)
  local _let_2_ = config["find-and-load"](file_dir)
  local config0 = _let_2_["config"]
  local root_dir = _let_2_["root-dir"]
  local cfg = _let_2_["cfg"]
  if config0 then
    local function _3_(_241)
      return fs["join-path"]({root_dir, _241})
    end
    return vim.api.nvim_create_autocmd({"BufWritePost"}, {group = vim.api.nvim_create_augroup(("nfnl-dir-" .. root_dir), {}), pattern = core.map(_3_, cfg({"source_file_patterns"})), callback = fennel_buf_write_post_callback_fn(root_dir, cfg)})
  else
    return nil
  end
end
local function setup()
  vim.api.nvim_create_autocmd({"Filetype"}, {group = vim.api.nvim_create_augroup("nfnl-setup", {}), pattern = "fennel", callback = fennel_filetype_callback})
  if ("fennel" == vim.o.filetype) then
    return fennel_filetype_callback({file = vim.fn.expand("%"), buf = vim.api.nvim_get_current_buf()})
  else
    return nil
  end
end
local function compile_all_files(dir)
  local dir0 = (dir or vim.fn.getcwd())
  local _let_6_ = config["find-and-load"](dir0)
  local config0 = _let_6_["config"]
  local root_dir = _let_6_["root-dir"]
  local cfg = _let_6_["cfg"]
  if config0 then
    return notify.info("Compilation complete.\n", compile["all-files"]({["root-dir"] = root_dir, cfg = cfg}))
  else
    return notify.warn("No .nfnl configuration found.")
  end
end
return {setup = setup, ["compile-all-files"] = compile_all_files}
