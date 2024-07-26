$env:XDG_CONFIG_HOME = "$PWD/.test-config"
$env:XDG_STATE_HOME = "$PWD/.test-config/state"

rm -for -rec $env:XDG_STATE_HOME -erroraction 'silentlycontinue'

nvim --headless .nfnl.fnl -c trust -c qa
nvim --headless -c 'PlenaryBustedDirectory lua\\spec'
