# neovim-for-dev

# requirement

* neovim

```
curl https://github.com/neovim/neovim/releases/download/v0.8.2/nvim-linux64.tar.gz -OL
tar xzvf nvim-linux64.tar.gz
sudo mv ./nvim-linux64/bin/nvim /usr/local/bin
sudo sudo -r nvim-linux64/share/nvim /usr/share/
```

* Go-Mono font

https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/Go-Mono.zip

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

## install 


```
source install.sh
```

start neovim
```
nv
```

Can't open file /share/nvim/syntax/syntax.vim

```
mkdir -p .config/nvim
export VIMRUNTIME="/usr/share/nvim/runtime"
```

reinstall
```
source install.sh
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


