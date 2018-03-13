#!/bin/bash

here="$(dirname $(readlink -f $0))"

(cd "$here" && git submodule init && git submodule update)

rm -f ~/.vimrc
ln -s $here/vimrc ~/.vimrc

rm -rf ~/.vim/bundle
ln -s $here/vim-bundle ~/.vim/bundle
