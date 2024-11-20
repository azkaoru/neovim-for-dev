#!/usr/bin/sh

export VIMRUNTIME="/usr/share/nvim/runtime"
NVIM_DEV=~/.config/nvim-dev
export NVIM_DEV

rm -rf $NVIM_DEV

mkdir -p $NVIM_DEV/share
mkdir -p $NVIM_DEV/nvim

stow --restow --target=$NVIM_DEV/nvim .

alias nv='XDG_DATA_HOME=$NVIM_DEV/share XDG_CONFIG_HOME=$NVIM_DEV nvim'

export nv 

# コピー&ペーストにosのclipboardを利用するためにDISPLAYを設定
export DISPLAY=":1"

# copy mycustom soncictemplate
rm -fr ~/.sonictemplate
cp -pr sonictemplate ~/.sonictemplate
