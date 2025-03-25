#!/usr/bin/sh

export VIMRUNTIME="/usr/share/nvim/runtime"
NVIM_DEV=~/.config/nvim-dev
export NVIM_DEV

rm -rf $NVIM_DEV



mkdir -p $NVIM_DEV/share
mkdir -p $NVIM_DEV/nvim


stow --restow --target=$NVIM_DEV/nvim .

#alias nv='XDG_DATA_HOME=$NVIM_DEV/share XDG_CONFIG_HOME=$NVIM_DEV nvim'
alias nv='XDG_CONFIG_HOME=$NVIM_DEV nvim'

export nv 

# コピー&ペーストにosのclipboardを利用するためにDISPLAYを設定
export DISPLAY=":1"

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
tar -zxvf jars/jdt-language-server-1.19.0-202301090450.tar.gz -C $JDTLS_WORK/jdtls

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
