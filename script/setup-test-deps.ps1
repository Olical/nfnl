$PACK_DIR = "./.test-config/nvim/pack/nfnl-tests/start"

mkdir $PACK_DIR -erroraction 'silentlycontinue'
git clone https://github.com/nvim-lua/plenary.nvim.git $PACK_DIR/plenary.nvim
git clone https://github.com/nvim-lua/plenary.nvim.git $PACK_DIR/fennel.vim

$LINK_TARGET = $GITHUB_WORKSPACE ?? $PWD
echo $LINK_TARGET
new-item -path $PACK_DIR/nfnl -itemtype Junction -value $LINK_TARGET -force
