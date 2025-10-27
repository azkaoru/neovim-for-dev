vim.opt.termguicolors = true

require("bufferline").setup {
	highlights = {
		BufferCurrent = {
			guifg = "#ff5555", -- 赤
			guibg = "#44475a", -- 背景色（お好みで）
			gui = "bold", -- 太字にする場合
		},
		BufferVisible = {
			guifg = "#6272a4",
			guibg = "#282a36",
		},
		BufferInactive = {
			guifg = "#6272a4",
			guibg = "#282a36",
		},
	},
}
