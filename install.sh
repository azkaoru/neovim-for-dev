#!/bin/sh -x

export VIMRUNTIME="/usr/share/nvim/runtime"
NVIM_CONFIG=~/.config/nvim
NVIM_DATA=~/.local/share/nvim
export DISPLAY=":1"  # コピー&ペーストにosのclipboardを利用するためにDISPLAYを設定
export EDITOR="nvim"

rm -fr  $NVIM_CONFIG
rm -fr  $NVIM_DATA
mkdir -p $NVIM_CONFIG
mkdir -p $NVIM_DATA

# GNU Stow を使って、現在のディレクトリにある設定を $NVIM_CONFIG にシンボリックリンクする
# stowがインストールされていない場合は、ln -sでシンボリックリンクを作成する
if type -P stow > /dev/null 2>&1; then
    stow --restow --target="$NVIM_CONFIG" .
else
    # stowが利用できない場合は、手動でシンボリックリンクを作成
    SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
    ln -sf "$SCRIPT_DIR/init.lua" "$NVIM_CONFIG/init.lua"
    ln -sf "$SCRIPT_DIR/ftplugin" "$NVIM_CONFIG/ftplugin"
    ln -sf "$SCRIPT_DIR/lua" "$NVIM_CONFIG/lua"
fi

# nvimをnvで起動するエイリアス
alias nv='nvim'

# bashrcで読み込むための設定
cat <<EOF > ~/.bashrc_neovim_dev
export VIMRUNTIME="/usr/share/nvim/runtime"
export EDITOR="nvim"
export DISPLAY="$DISPLAY"
alias nv='nvim'
EOF

ADD_LINE="source ~/.bashrc_neovim_dev"

# 既に .bashrc に存在するか確認
if ! grep -Fxq "$ADD_LINE" ~/.bashrc; then
    echo $ADD_LINE >> ~/.bashrc
fi

#
# copy soncictemplate用のファイルをコピー
#
rm -fr ~/.sonictemplate
cp -pr sonictemplate ~/.sonictemplate

#
# Java開発用の設定
#
export JDTLS_WORK=~/.local/share/java-dev
rm -fr $JDTLS_WORK
mkdir -p $JDTLS_WORK/jdtls
mkdir -p $JDTLS_WORK/eclipse
mkdir -p $JDTLS_WORK/workspace
mkdir -p $JDTLS_WORK/projects/java-debug/com.microsoft.java.debug.plugin/target/
mkdir -p $JDTLS_WORK/projects/vscode-java-test/server
mkdir -p $JDTLS_WORK/projects/dg-jdt-ls-decompiler
mkdir -p $JDTLS_WORK/projects/cli-decompiler/src
mkdir -p $JDTLS_WORK/projects/cli-decompiler/dest
#
# install jdtls
#
tar -zxf jars/jdt-language-server-1.19.0-202301090450.tar.gz -C $JDTLS_WORK/jdtls 
#
# install java-debug
#
cp jars/java-debug/com.microsoft.java.debug.plugin-0.44.0.jar  $JDTLS_WORK/projects/java-debug/com.microsoft.java.debug.plugin/target
#
# install java-test
#
cp jars/vscode-java-test/*.jar  $JDTLS_WORK/projects/vscode-java-test/server
#
# install dg-jdt-ls-decompiler
#
cp jars/dg-jdt-ls-decompiler/*.jar  $JDTLS_WORK/projects/dg-jdt-ls-decompiler
#
# install lombok
#
cp jars/lombok.jar  $JDTLS_WORK/eclipse
#
# install code style
#
cp jars/eclipse-java-google-style.xml $JDTLS_WORK/eclipse
#
# install java format
#
cp jars/google-java-format-1.16.0.jar $JDTLS_WORK/eclipse
#
# install  cli decompiler
#
cp jars/vineflower-1.10.1.jar $JDTLS_WORK/projects/cli-decompiler

# copy mycustom soncictemplate
rm -fr ~/.sonictemplate
cp -pr sonictemplate ~/.sonictemplate

echo "After installation, you can launch your development instance of Neovim with: nv"
