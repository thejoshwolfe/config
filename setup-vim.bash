#!/usr/bin/env bash

here="$(dirname $(readlink -f $0))"

which-q() {
    which &> /dev/null "$@"
}

# classic vim
if which-q vim; then
    ln -sf $here/vimrc ~/.vimrc

    mkdir -p ~/.vim/pack/plugins
    rm -f ~/.vim/pack/plugins/start || exit 1
    ln -s $here/vim-bundle ~/.vim/pack/plugins/start
fi

# neovim
if which-q nvim; then
    mkdir -p ~/.config/nvim
    ln -sf $here/nvim.lua ~/.config/nvim/init.lua
fi
