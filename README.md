# neovim-for-dev

support os: rocky9

* 日本後入力メモ

RockyLinux or RHEL/Centosで全角、半角キーで日本語入力の切り替えを実施する場合の手順

mozcをインストールする。

```
dnf install mozc ibus-mozc
```

リブート

```
systemctl reboot
```

以下の手順を参考に日本語(Mozc)を利用するにあたり、mozcとibus-mozcをインストールする。


https://pigeonet.hatenadiary.jp/entry/2019/01/05/020345


なお、rocky9用のmozc,ibus-mozcは存在しないため、rocky9は以下で対応する。rhel8の場合は上記の手順でインストールできた。

https://furuya7.hatenablog.com/entry/2022/06/23/142859#-----------------------------------------------------------


```
curl https://rpmfind.net/linux/fedora/linux/releases/34/Everything/x86_64/os/Packages/m/mozc-2.25.4190.102-5.fc34.x86_64.rpm -LO

curl https://rpmfind.net/linux/fedora/linux/releases/34/Everything/x86_64/os/Packages/p/protobuf-3.14.0-3.fc34.x86_64.rpm -LO

curl https://rpmfind.net/linux/fedora/linux/releases/34/Everything/x86_64/os/Packages/x/xemacs-filesystem-21.5.34-39.20200331hge2ac728aa576.fc34.noarch.rpm -LO

curl https://rpmfind.net/linux/fedora/linux/releases/34/Everything/x86_64/os/Packages/i/ibus-mozc-2.25.4190.102-5.fc34.x86_64.rpm -LO

dnf install qt5-qtbase

dnf install qt5-qtbase-gui

dnf install gtk2-2.24.33-7.el9.i686

rpm -ivh protobuf-3.14.0-3.fc34.x86_64.rpm

rpm -ivh xemacs-filesystem-21.5.34-39.20200331hge2ac728aa576.fc34.noarch.rpm

rpm -ivh mozc-2.25.4190.102-5.fc34.x86_64.rpm

rpm -ivh ibus-mozc-2.25.4190.102-5.fc34.x86_64.rpm
```

mozcとibus-mozcインストール環境後、rebootする。

上記のリンクに従い、入力ソースに日本語(Mozc)ができたら、日本語（かな）は削除して、入力ソースに以下の２項目が存在するようにする

* 日本語(ja)
* 日本語(Mozc)

この設定が、完了したら、rebootする

reboot後にターミナルから全角・半角キーで、日本語入力を行ってみる。

意図せず、ポップアップがでる場合は以下のSTEP4設定を行う。

* https://rainbow-engine.com/centos7-japanese-input/


# requirement

* neovim

fedora & rockylinux
```
curl https://github.com/neovim/neovim/releases/download/v0.8.2/nvim-linux64.tar.gz -OL
tar xzvf nvim-linux64.tar.gz
sudo mv ./nvim-linux64/bin/nvim /usr/local/bin
sudo cp -r nvim-linux64/share/nvim /usr/share/
```

rhel8 は次のエラーが発生するのでインストールできない。 

```
nvim: /lib64/libm.so.6: version `GLIBC_2.29' not found (required by nvim)
```

イカの方法でインストールできるが、この方法の場合は、pythonのsite-pakcageにインストールされるが、インストール後にnvimコマンド起動できない


* Go-Mono font


https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/Go-Mono.zip

```
curl https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/Go-Mono.zip -LO
sudo mkdir -p /usr/share/fonts/go-mono
sudo mv Go-Mono.zip  /usr/share/fonts/go-mono
cd /usr/share/fonts/go-mono
sudo unzip Go-Mono.zip
sudo fc-cache -v
```

展開したファイルを/usr/share/fonts/go-monoに展開する。そのあとにfc-cache -vを実行してgo-mono配下を読み込みされているのを確認する。

そしてrebootし、ターミナルの設定よりプロファイルを作成し、プロファイルでフォントが指定できるので、Go-Monoのフォントを指定する。

* stow

```
sudo dnf install epel-release
sudo dnf -y install stow
```

* telescope depends

** rg

```
su -
dnf config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
dnf -y install ripgrep
```

** fd

```
sudo dnf install -y fd-find
```

rhel8だとfd-findパッケージみつからない。

## install 


```
source install.sh
```

start neovim
```
nv
```


start neovim
```
nv
```

### shell development

* install formatting tools

** prettierd

```
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo  -O
sudo mv yarn.repo /etc/yum.repos.d/
su -
rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
dnf -y install yarn
yarn global add prettier
```

** shfmt

```
curl https://github.com/mvdan/sh/releases/download/v3.6.0/shfmt_v3.6.0_linux_amd64 -LO
sudo mv shfmt_v3.6.0_linux_amd64  /usr/local/bin/shfmt
sudo mv chmod +x  /usr/local/bin/shfmt
```

* diagnostics tools

** shellcheck
```
sudo dnf -y install ShellCheck
```

### ansible 

* install tools

** ansible-lint

```
pip3 install ansible-lint
```

** yamllint

```
pip3 install yamllint
```

** yamlfmt

```
curl https://github.com/google/yamlfmt/releases/download/v0.7.1/yamlfmt_0.7.1_Linux_x86_64.tar.gz -LO
tar -zxvf yamlfmt_0.7.1_Linux_x86_64.tar.gz
sudo mv yamlfmt /usr/local/bin
```

### typescript & javascript deubg

vscode-chrome-debug manual install

```
git clone https://github.com/Microsoft/vscode-chrome-debug
cd ./vscode-chrome-debug
npm install
npm run build
```

ブラウザ起動

```
google-chrome --remote-debugging-port=9222
```

typescriptのreactをデバックすると、ソースコードのマップが見つからないとメッセージが出力される。

起動したブラウザにアプリを更新すると、nvimのデバック画面のコンソールに以下のメッセージが出力される

```
Download the React DevTools for a better development experience: https://reactjs.org/link/react-devtoos
```

デバックを再開すると、デバックできるようになる。




