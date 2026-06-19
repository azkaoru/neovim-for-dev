-- AsciiDoctorプレビュー用ユーティリティ関数

local platform = require("utils.platform")

local M = {}

-- 生成物の一時出力先（OS 非依存。Linux の /tmp 直書きを廃止）
local function tmp_out(name)
  return platform.join(platform.cache_dir(), name)
end

-- 生成したファイルを OS 標準のアプリで開く（xdg-open / start / open を吸収）
local function open_file(path)
  vim.ui.open(path)
end

-- HTML生成関数
function M.gen_html()
  local input = vim.fn.expand("%:p")
  local timestamp = os.time()
  local html_out = tmp_out("asciidoc_" .. timestamp .. ".html")
  
  -- asciidoctorでHTML生成（より多くのオプション対応）
  vim.fn.jobstart({
    "asciidoctor", 
    "-a", "stylesheet=https://fonts.googleapis.com/css?family=Open+Sans",
    "-a", "linkcss", 
    "-a", "icons=font",
    "-a", "toc",
    "-a", "sectanchors",
    "-o", html_out, 
    input 
  }, {
    on_exit = function()
      -- ブラウザで開く
      open_file(html_out)
    end
  })
end

-- PDF生成関数（asciidoctor-pdf版）
function M.gen_pdf()
  local input = vim.fn.expand("%:p")
  local timestamp = os.time()
  local pdf_out = tmp_out("asciidoc_" .. timestamp .. ".pdf")

  -- 日本語フォントディレクトリ（OS 別。環境変数 ASCIIDOCTOR_FONTS_DIR で上書き可）。
  -- 見つからない場合は asciidoctor-pdf 既定フォントにフォールバックする。
  local font_dir = os.getenv("ASCIIDOCTOR_FONTS_DIR")
  if not font_dir or font_dir == "" then
    if platform.is_windows then
      font_dir = platform.join(os.getenv("WINDIR") or "C:\\Windows", "Fonts")
    elseif platform.is_mac then
      font_dir = "/Library/Fonts"
    else
      font_dir = "/usr/share/fonts/google-noto-sans-cjk-vf-fonts"
    end
  end
  local font_name = "NotoSansCJK-VF"
  local has_fonts = vim.fn.isdirectory(font_dir) == 1

  -- デバッグ情報表示
  print("PDF生成開始...")
  if has_fonts then
    print("使用フォント: " .. font_name)
    print("フォントディレクトリ: " .. font_dir)
  else
    print("カスタムフォント未検出のため既定フォントで生成します (ASCIIDOCTOR_FONTS_DIR で指定可)")
  end
  print("出力PDF: " .. pdf_out)

  local cmd = { "asciidoctor-pdf", "-a", "toc", "-a", "sectanchors" }
  -- フォントディレクトリが存在する時だけフォント指定を付与（無い環境での失敗を防ぐ）
  if has_fonts then
    vim.list_extend(cmd, { "-a", "pdf-fontsdir=" .. font_dir, "-a", "pdf-font=" .. font_name })
  end
  vim.list_extend(cmd, { "-a", "pdf-style=default", "-a", "encoding=UTF-8", "-o", pdf_out, input })

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        print("✅ PDF生成成功: " .. pdf_out)
        -- PDFビューアで開く
        open_file(pdf_out)
      else
        print("❌ PDF生成失敗 (終了コード: " .. exit_code .. ")")
        print("フォントパスを確認してください")
      end
    end
  })
end




function M.start_live_preview()
  local input = vim.fn.expand("%:p")
  local dir = vim.fn.fnamemodify(input, ":h")
  
  -- HTMLを生成
  vim.fn.jobstart({
    "asciidoctor", 
    "-a", "stylesheet=https://fonts.googleapis.com/css?family=Open+Sans",
    "-a", "linkcss", 
    "-a", "icons=font",
    "-a", "toc",
    "-a", "sectanchors",
    "-o", "index.html", 
    input 
  }, {
    on_exit = function()
      -- live-serverを起動
      vim.fn.jobstart({
        "live-server", 
        "--port=8080", 
        "--open=/index.html",
        dir
      })
    end
  })
end

-- 画像貼り付け関数（クリップボードの画像を images/ に保存し AsciiDoc マクロを挿入）
function M.paste_image()
  local timestamp = os.time()
  local img_name = "img_" .. timestamp .. ".png"
  local img_path = platform.join("images", img_name)

  -- imagesディレクトリがなければ作成
  vim.fn.mkdir("images", "p")

  -- AsciiDoc の画像マクロを挿入する共通処理
  local function insert_macro()
    local line = vim.fn.line(".")
    vim.fn.append(line, { string.format("image::%s[]", img_name), "" })
  end

  -- クリップボードから画像を保存（OS 別コマンド）
  local cmd
  if platform.is_windows then
    -- PowerShell で System.Windows.Forms 経由で画像を取り出して保存
    local ps = string.format(
      "Add-Type -AssemblyName System.Windows.Forms;" ..
      "$img=[System.Windows.Forms.Clipboard]::GetImage();" ..
      "if($img -ne $null){$img.Save('%s',[System.Drawing.Imaging.ImageFormat]::Png)}else{exit 1}",
      (vim.fn.fnamemodify(img_path, ":p")):gsub("'", "''")
    )
    cmd = { "powershell", "-NoProfile", "-Command", ps }
  elseif platform.is_mac then
    -- pngpaste が必要
    cmd = { "pngpaste", img_path }
  else
    cmd = { "xclip", "-selection", "clipboard", "-t", "image/png", "-o", img_path }
  end

  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        insert_macro()
      else
        print("❌ クリップボードから画像を取得できませんでした")
      end
    end,
  })
end

return M
