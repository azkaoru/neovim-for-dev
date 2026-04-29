local alpha = require("alpha")
local theta = require("alpha.themes.theta")

-- Nアイコン用ハイライトグループ
vim.api.nvim_set_hl(0, "AlphaNLogo", { fg = "#87E58E" }) -- 左半分: 緑
vim.api.nvim_set_hl(0, "AlphaNLogoRight", { fg = "#E8EDA2" }) -- 右半分: 黄
-- 犬アスキーアート用: 黄
vim.api.nvim_set_hl(0, "AlphaDogArt", { fg = "#E8EDA2" })

local nvim_version = string.format("NVIM v%d.%d.%d", vim.version().major, vim.version().minor, vim.version().patch)

local n_logo = {
	[[│ ╲ ││]],
	[[││╲╲││]],
	[[││ ╲ │]],
}

-- 犬アスキーアート（環境変数 NEOVIM_STARTUP_ASCII_ART で指定されたファイルを読み込み）
local dog
local art_name = os.getenv("NEOVIM_STARTUP_ASCII_ART")
if art_name then
	local ok, mod = pcall(require, "config." .. art_name)
	if ok then
		dog = mod
	else
		vim.notify("NEOVIM_STARTUP_ASCII_ART: failed to load config/" .. art_name .. ".lua", vim.log.levels.WARN)
	end
end
if not dog then
	dog = {}
	for _ = 1, 22 do
		table.insert(dog, "")
	end
end

local sep = [[────────────────────────────────────────────]]
local open_src = [[Nvim is open source and freely distributable]]
local url_line = [[https://neovim.io]]

-- ヘッダー行を組み立て（犬 → Nアイコン → バージョン情報）
local hanzo = {}
-- 犬（先頭）
for i = 1, 22 do
	hanzo[i] = dog[i]
end
-- N アイコン + バージョン情報
hanzo[23] = [[                                   ]]
hanzo[24] = n_logo[1]
hanzo[25] = n_logo[2]
hanzo[26] = n_logo[3]
hanzo[27] = nvim_version
hanzo[28] = sep
hanzo[29] = open_src
hanzo[30] = url_line
hanzo[31] = sep

theta.header.val = hanzo

-- ハイライト設定
local header_hl = {}
-- 犬（22行）: 白ハイライト
for _ = 1, 22 do
	table.insert(header_hl, { { "AlphaDogArt", 0, -1 } })
end
-- spacer
table.insert(header_hl, {})
-- N アイコン: 左半分=緑, 右半分(╲以降)=黄
table.insert(header_hl, { { "AlphaNLogo", 0, 4 }, { "AlphaNLogoRight", 4, -1 } })
table.insert(header_hl, { { "AlphaNLogo", 0, 6 }, { "AlphaNLogoRight", 6, -1 } })
table.insert(header_hl, { { "AlphaNLogo", 0, 7 }, { "AlphaNLogoRight", 7, -1 } })
-- バージョン情報
table.insert(header_hl, { { "AlphaNLogoRight", 0, -1 } }) -- NVIM vX.Y.Z (黄色)
table.insert(header_hl, {}) -- separator
table.insert(header_hl, {}) -- Nvim is open source...
table.insert(header_hl, {}) -- https://neovim.io
table.insert(header_hl, {}) -- separator
theta.header.opts.hl = header_hl

-- Quick Links ボタン: 実際の leader キーを使用
local ld = vim.g.mapleader or ","
local db = require("alpha.themes.dashboard")
theta.buttons.val = {
	{ type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
	{ type = "padding", val = 1 },
	db.button("m", "  Open Tree Folder", "<cmd>NvimTreeToggle<CR>"),
	db.button("e", "  New file", "<cmd>ene<CR>"),
	db.button(ld .. " f f", "󰈞  Find file", "<cmd>Telescope find_files<CR>"),
	db.button(ld .. " f g", "󰊄  Live grep", "<cmd>Telescope live_grep<CR>"),
	db.button("c", "  Configuration", "<cmd>exe 'cd' stdpath('config')<CR>"),
	db.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
	db.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
}

alpha.setup(theta.config)
