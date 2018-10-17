#!/bin/bash

here="$(dirname $(readlink -f $0))"

rm -f ~/.vimrc
ln -s $here/vimrc ~/.vimrc

rm -rf ~/.vim/bundle
ln -s $here/vim-bundle ~/.vim/bundle
