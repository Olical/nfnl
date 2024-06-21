$env:XDG_CONFIG_HOME = "$PWD/.test-config"

nvim --headless -c 'edit .nfnl.fnl' -c trust -c qa -i NONE
nvim --headless -c 'PlenaryBustedDirectory lua/spec' -i NONE
