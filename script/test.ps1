$env:XDG_CONFIG_HOME = "$PWD/.test-config"
$env:XDG_STATE_HOME = "$PWD/.test-config/state"

rm -for -rec $env:XDG_STATE_HOME -erroraction 'silentlycontinue'

$env:NFNL_USE_SECURE_READ = "false"
nvim --headless -c 'PlenaryBustedDirectory lua\\spec'
