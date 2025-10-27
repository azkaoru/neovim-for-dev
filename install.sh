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


# rhel10やrockylinux10でstowが利用できない場合があるので、手動でシンボリックリンクを作成する
#stow --restow --target="$NVIM_CONFIG" .
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# .git を除外してリンク作成
for item in "$SCRIPT_DIR"/* "$SCRIPT_DIR"/.*; do
    base=$(basename "$item")
    # . と .. と .git は除外
    if [[ "$base" == "." || "$base" == ".." || "$base" == ".git" || "$base" == *.md  || "$base" == *.sh ]]; then
        continue
    fi
    ln -sf "$item" "$NVIM_CONFIG/$base"
    echo "Linked $base -> $NVIM_CONFIG/$base"
done

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
