  --require('lspsage').setup({})

  -- 現在の全体幅の 40% 程度のウィンドウ幅を計算
local win_width = math.floor(vim.o.columns * 0.4)
-- 画面右にウィンドウを配置するため、左上の列位置は、
-- (画面幅 - ウィンドウ幅 - 適当な余白) とする
local win_col = vim.o.columns - win_width - 20
-- 行位置は好みに応じて調整。ここでは上部から 10 行目に配置する例。
local win_row = 10

  require("lspsaga").setup({
    border_style = "single",
    symbol_in_winbar = {
      enable = true,
    },
    code_action_lightbulb = {
      enable = true,
    },
    show_outline = {
      win_width = 50,
      auto_preview = false,
    },
  })

