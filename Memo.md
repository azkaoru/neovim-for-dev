# neovim-for-dev
support os: rocky9

* 日本後入力メモ

RockyLinux or RHEL/Centosで全角、半角キーで日本語入力の切り替えを実施する場合の手順

aanthyをインストールする。
```
dnf install ibus-anthy
```

fedoraの場合で上記インストールできない場合は、ibus-mozcをインストールすること。

リブート

```
systemctl reboot
```

# 日本語化

anthyの場合

GUIのSettings -> keyboard -> input source で、日本語(anthy)を追加する。


ibuz-mozcの場合

上記のリンクに従い、入力ソースに日本語(Mozc)ができたら、日本語（かな）は削除して、入力ソースに以下の２項目が存在するようにする

* 日本語(ja)
* 日本語(Mozc)

この設定が、完了したら、rebootする

reboot後にターミナルから全角・半角キーで、日本語入力を行ってみる。

ibuz-mozcの場合

意図せず、ポップアップがでる場合は以下のSTEP4設定を行う。

* https://rainbow-engine.com/centos7-japanese-input/


# requirement

* neovim

fedora & rockylinux
```
curl https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.tar.gz -OL
tar xzvf nvim-linux64.tar.gz
sudo mv ./nvim-linux64/bin/nvim /usr/local/bin
sudo cp -r nvim-linux64/share/nvim /usr/share/
```

rhel8 は次のエラーが発生するのでインストールできない。 

```
nvim: /lib64/libm.so.6: version `GLIBC_2.29' not found (required by nvim)
```


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

** for clipboard

neovimのコピー＆ポーストは、OSのクリップボードを利用するための設定。

```
sudo dnf -y install xclip xsel
```


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

add ~/.bashrc

```
export VIMRUNTIME="/usr/share/nvim/runtime"
NVIM_DEV=~/.config/nvim-dev
export NVIM_DEV
alias nv='XDG_DATA_HOME=$NVIM_DEV/share XDG_CONFIG_HOME=$NVIM_DEV nvim'
# コピー&ペーストにosのclipboardを利用するためにDISPLAYを設定
export DISPLAY=":1"
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

### go

* intall go, gopls

goとgo langage serverであるgoplsをインストールする。

```
sudo dnf install go golang-x-tools-gopls
```

go開発時は、nvでneovim起動後、ctrl + dでdap-uiが起動する。

ctrl + b でカレントの行にブレイクポイントを設定できる。

：masonを実行して、delveをインストールする。

devleがインストール後、debug実行可能になる。

debug実行する場合は F5を実行する。

step over : ,so
step into : ,si
step out : ,sr

デバック再実行はdlで実行可能。

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



# 備忘メモ

## seach and confirm,replace

press ,fg to live grep

input search word

Press C-q to pipe for quickfix list


Press :cdo s/search word/replace word/gc


##　ターミナルでtabを複数した際のコピー

デフォルトでインストールされるvimが+clipboardではないため、tabでターミナルを複数開いてるときに、コピーして、ほかのタブでペースできない。

以下の.vimrcを作成し、,cでコピーできるようになる。ペーストは ctrl + shift + v

```
function! RangeToClipboard() range
  let [line1, col1] = getpos("'<")[1:2]
  let [line2, col2] = getpos("'>")[1:2]
  let lines = getline(line1, line2)
  " handle incl/excl last char
  let lines[-1] = lines[-1][: col2 - (&sel == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  silent exec system('xclip -sel c', lines)
endfunction

let mapleader = ","
vnoremap <leader>c :<c-u>call RangeToClipboard()<CR>
```

https://blog.dnmfarrell.com/post/how-to-copy-a-vim-buffer-to-the-clipboard/

## ターミナルでブラウザを利用する。


```
yum -y install w3m
```


webページをコピー・ペーストしない場合は、ESC + e で、vimでエディとできるようになるので、該当行をshift v で選択して、,cでコピーできる


## Github Copilotの利用。

copilot.nvimとCopilotChat.nvimをインストールした。

予めgithub cli(gh)をインストールすること。

* https://github.com/cli/cli/releases

また、github Copilotを利用するにあたり、有償で契約が必要である。


## github pullrequest Check

.bashrcに以下を追加する。

```
alias gpr='export GITHUB_TOKEN=$(gh auth token);GITHUB_REPONAME=$(ghq list | grep github.com | peco | cut -c 12- );nv -c ":Octo pr list $GITHUB_REPONAME"'
```

予めgh auth login を実行し、githubのアクセストークンを取得できる状態にしておくこと。


gprを実行すると、githubのリポジトリを選択できるようになり、選択後にpullrequestの一覧が表示される。

pullrequestの一覧から、該当のpullrequestを選択すると、該当のpullrequestの内容が表示されるので、":Octo pr changes"を実行すると変更内容が表示される。その状態で",ce"を実行すると、CopilotChatで変更内容の説明が表示される。


## Avanteの利用

source install.shを実行、You must setup copilot with either copilot.lua or copilot.vimエラーが発生した場合は、:Copilot authで認証を実施すること。

ログインに成功すると、apps.jsonが作成され、それを読み込みにいく。


## Rocky linuxのショートカット変更メモ


setting  -> keyboard

system -> アクティビティ画面を表示する -> Kana

ナビゲーション -> アプリケーションを切り替える -> 無変換

window -> 右半分に表示する -> ctrl + shift + r

window -> 左半分に表示する -> ctrl + shift + r


## 日本語入力について

キーボードの入力ソースで、日本語(anthy) と 英語 の順で追加する

ibus-setupを実行し、キーボードショートカットでZenkaku_Hankakuを指定する。これで日本語(anthy)を利用しているときは全角で切り替えることができる。

vimで作業中、日本語入力モードか、英語入力モードがどちらかを利用しているか分からなくなった場合に、画面に選択ボタンを表示させたい場合は以下を実行する(Insertボタンは普段利用しないので、Insertを割り当て)。

なお、選択画面表示後、選択するためにエンターを押さないといけないのが面倒である。

setting  -> keyboard

キーボードショートカット-> view and customize short cuts ->次の入力ソースを切り替える -> Insertをオス。

利用想定は、vim作業中で日本語で入力中(anthy利用中)にわからなくなったら、Insertで英語(en)に切り替える。



## Copilotの表示する補完の選択について、

デフォルトはTabだが、他のプラグインが候補を表示している場合に、tab  で選択できない場合があるので、<C-o>に変更している。

## 日本語入力に、ノーマルモードに戻るときに、英語入力モードに戻して、Escを押すのが面倒

<f12>を押すと、英語入力モードに戻して、ノーマルモードに戻るようにしている。
