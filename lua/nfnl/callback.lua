-- [nfnl] Compiled from fnl/nfnl/callback.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local nvim = autoload("nfnl.nvim")
local compile = autoload("nfnl.compile")
local config = autoload("nfnl.config")
local function fennel_buf_write_post_callback_fn(root_dir, cfg)
  local function _2_(ev)
    return compile["into-file"]({["root-dir"] = root_dir, cfg = cfg, path = ev.file, source = nvim["get-buf-content-as-string"](ev.buf)})
  end
  return _2_
end
local function fennel_filetype_callback(ev)
  local file_path = fs["full-path"](ev.file)
  if not file_path:find("^%w+://") then
    local file_dir = fs.basename(file_path)
    local _let_3_ = config["find-and-load"](file_dir)
    local config0 = _let_3_["config"]
    local root_dir = _let_3_["root-dir"]
    local cfg = _let_3_["cfg"]
    if config0 then
      local function _4_(_241)
        return fs["join-path"]({root_dir, _241})
      end
      return vim.api.nvim_create_autocmd({"BufWritePost"}, {group = vim.api.nvim_create_augroup(("nfnl-dir-" .. root_dir), {}), pattern = core.map(_4_, cfg({"source-file-patterns"})), callback = fennel_buf_write_post_callback_fn(root_dir, cfg)})
    else
      return nil
    end
  else
    return nil
  end
end
return {["fennel-filetype-callback"] = fennel_filetype_callback}
