$env:XDG_CONFIG_HOME = "$PWD/.test-config"
$env:XDG_STATE_HOME = "$PWD/.test-config/state"

rm -for -rec $env:XDG_STATE_HOME -erroraction 'silentlycontinue'

nvim --headless -c 'let g:_nfnl_dev_config_secure_read = v:false' -c 'PlenaryBustedDirectory lua\\spec'
