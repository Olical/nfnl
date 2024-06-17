$env:XDG_CONFIG_HOME = "$PWD/.test-config"

nvim --headless -c 'edit .nfnl.fnl' -c trust -c qa
nvim --headless -c 'PlenaryBustedDirectory lua/spec'
