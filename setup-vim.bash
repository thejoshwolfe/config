#!/usr/bin/env bash

here="$(dirname $(readlink -f $0))"

rm -f ~/.vimrc
ln -s $here/vimrc ~/.vimrc

mkdir -p ~/.vim/pack/plugins
rm -f ~/.vim/pack/plugins/start || exit 1
ln -s $here/vim-bundle ~/.vim/pack/plugins/start
