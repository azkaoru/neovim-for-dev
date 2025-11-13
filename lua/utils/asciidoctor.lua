-- AsciiDoctorプレビュー用ユーティリティ関数

local M = {}

-- HTML生成関数
function M.gen_html()
  local input = vim.fn.expand("%:p")
  local timestamp = os.time()
  local html_out = "/tmp/asciidoc_" .. timestamp .. ".html"
  
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
      vim.fn.jobstart({ "xdg-open", html_out })
    end
  })
end

-- PDF生成関数（asciidoctor-pdf版）
function M.gen_pdf()
  local input = vim.fn.expand("%:p")
  local timestamp = os.time()
  local pdf_out = "/tmp/asciidoc_" .. timestamp .. ".pdf"
  
  -- 日本語フォントディレクトリを指定
  local font_dir = "/usr/share/fonts/google-noto-sans-cjk-vf-fonts"
  local font_name = "NotoSansCJK-VF"
  
  -- デバッグ情報表示
  print("PDF生成開始...")
  print("使用フォント: " .. font_name)
  print("フォントディレクトリ: " .. font_dir)
  print("出力PDF: " .. pdf_out)
  
  vim.fn.jobstart({
    "asciidoctor-pdf", 
    "-a", "toc",
    "-a", "sectanchors",
    "-a", "pdf-fontsdir=" .. font_dir,
    "-a", "pdf-font=" .. font_name,
    "-a", "pdf-style=default",
    "-a", "encoding=UTF-8",
    "-o", pdf_out, 
    input 
  }, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        print("✅ PDF生成成功: " .. pdf_out)
        -- PDFビューアで開く
        vim.fn.jobstart({ "xdg-open", pdf_out })
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

-- 画像貼り付け関数
function M.paste_image()
  local timestamp = os.time()
  local img_name = "img_" .. timestamp .. ".png"
  local img_path = "./images/" .. img_name
  
  -- imagesディレクトリがなければ作成
  vim.fn.mkdir("./images", "p")
  
  -- クリップボードから画像を保存（Linuxの場合）
  vim.fn.jobstart({
    "xclip", 
    "-selection", "clipboard", 
    "-t", "image/png", 
    "-o", img_path
  }, {
    on_exit = function()
      -- AsciiDocの画像マクロを挿入
      local line = vim.fn.line(".")
      local img_macro = string.format("image::%s[]", img_name)
      vim.fn.append(line, { img_macro, "" })
    end
  })
end

return M
