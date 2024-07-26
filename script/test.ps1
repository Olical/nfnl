$env:XDG_CONFIG_HOME = "$PWD/.test-config"
$env:XDG_STATE_HOME = "$PWD/.test-config/state"

rm -for -rec $env:XDG_STATE_HOME -erroraction 'silentlycontinue'

# This really just sets up the shada file I think?
# We don't actually use secure read in Windows CI due to a suspected Neovim bug.
# See thread for more info https://github.com/Olical/nfnl/pull/42
nvim --headless .nfnl.fnl -c trust -c qa

nvim --headless -c 'let g:_nfnl_dev_config_secure_read = v:false' -c 'PlenaryBustedDirectory lua\\spec'
