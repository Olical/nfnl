-- [nfnl] Compiled from fnl/nfnl/callback.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local fs = autoload("nfnl.fs")
local nvim = autoload("nfnl.nvim")
local compile = autoload("nfnl.compile")
local config = autoload("nfnl.config")
local function fennel_buf_write_post_callback_fn(root_dir, cfg)
    print('DBG: in fennel_buf_write_post_callback_fn, root_dir = ' .. vim.inspect(root_dir))
  local function _2_(ev)
    print('DBG: callback, in the callback returned by fennel_buf_write_post_callback_fn')
    local t = {["root-dir"] = root_dir, cfg = cfg, path = ev.file, source = nvim["get-buf-content-as-string"](ev.buf)}
    print('DBG: callback, fennel_buf_write_post_callback_fn, t = ' .. vim.inspect(fennel_buf_write_post_callback_fn, t))
    local t2 = compile["into-file"](t)
    print('DBG: callback, t2 = ' .. vim.inspect(t2))
    return t2
  end
  print('DBG: callback, _2_ = ' .. vim.inspect(_2_))
  return _2_
end
local function fennel_filetype_callback(ev)
  print(vim.inspect(ev))
  local file_path = fs["full-path"](ev.file)
  print(vim.inspect(file_path))
  if not file_path:find("^%w+://") then

    print(vim.inspect("DBG 1:"))
    local file_dir = fs.basename(file_path)
    local _let_3_ = config["find-and-load"](file_dir)
    local config0 = _let_3_["config"]
    print('DBG: config0' .. vim.inspect(config0))
    local root_dir = _let_3_["root-dir"]
    print('DBG: root_dir' .. vim.inspect(root_dir))
    local cfg = _let_3_["cfg"]
    print('DBG: cfg' .. vim.inspect(cfg))
    if config0 then
      local function _4_(_241)
        local t1 = fs["join-path"]({root_dir, _241})
        local t2 = vim.fs.normalize(t1)
        return t2
      end

        print('DBG: 2 = ' .. vim.inspect({"BufWritePost"}))
        print('DBG: 2 = ' .. vim.inspect({
            group = vim.api.nvim_create_augroup(("nfnl-dir-" .. root_dir), 
            {}), 
            pattern = core.map(_4_, cfg({"source-file-patterns"})), 
            callback = fennel_buf_write_post_callback_fn(root_dir, cfg)
        }))

      return vim.api.nvim_create_autocmd(
                {"BufWritePost"}, 
                {
                    group = vim.api.nvim_create_augroup(("nfnl-dir-" .. root_dir), 
                    {}), 
                    pattern = core.map(_4_, cfg({"source-file-patterns"})), 
                    callback = fennel_buf_write_post_callback_fn(root_dir, cfg)
                })
    else
      return nil
    end
  else
    return nil
  end
end
return {["fennel-filetype-callback"] = fennel_filetype_callback}
