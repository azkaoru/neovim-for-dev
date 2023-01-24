# neovim-for-dev

# requirement

* neovim

```
curl https://github.com/neovim/neovim/releases/download/v0.8.2/nvim-linux64.tar.gz -OL
tar xzvf nvim-linux64.tar.gz
mv ./nvim-linux64/bin/nvim /usr/local/bin
```

* Go-Mono font

https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/Go-Mono.zip

展開したファイルを/usr/share/fonts/go-monoに展開する。そのあとにfc-cache -vを実行してgo-mono配下を読み込みされているのを確認する。

そしてrebootし、ターミナルの設定よりプロファイルを作成し、プロファイルでフォントが指定できるので、Go-Monoのフォントを指定する。


## install 

```
source install.sh
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


