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
local has_dog = false
local dog = {}
local art_name = os.getenv("NEOVIM_STARTUP_ASCII_ART")
if art_name then
	local ok, mod = pcall(require, "config." .. art_name)
	if ok then
		dog = mod
		has_dog = true
	else
		vim.notify("NEOVIM_STARTUP_ASCII_ART: failed to load config/" .. art_name .. ".lua", vim.log.levels.WARN)
	end
end

local sep = [[────────────────────────────────────────────]] -- 44 cols, 132 bytes
local open_src = [[Nvim is open source and freely distributable]] -- 44 cols, 44 bytes
local url_line = [[https://neovim.io]] -- 18 cols, 18 bytes

-- 各行を target_width 幅の中央に配置（左右均等パディング）
local target_width = 44
local function center_text(text)
	local dw = vim.fn.strdisplaywidth(text)
	if dw >= target_width then
		return text
	end
	local left = math.floor((target_width - dw) / 2)
	local right = target_width - dw - left
	return string.rep(" ", left) .. text .. string.rep(" ", right)
end

-- ヘッダー行を組み立て（犬 → Nアイコン → バージョン情報）
local hanzo = {}
local header_hl = {}

-- 犬（NEOVIM_STARTUP_ASCII_ART 指定時のみ）
if has_dog then
	for i = 1, 22 do
		table.insert(hanzo, dog[i])
		table.insert(header_hl, { { "AlphaDogArt", 0, -1 } })
	end
	-- 犬とNアイコンの間のスペーサー
	table.insert(hanzo, center_text(""))
	table.insert(header_hl, {})
end

-- N アイコン（44 cols にパディング）
table.insert(hanzo, center_text(n_logo[1]))
table.insert(hanzo, center_text(n_logo[2]))
table.insert(hanzo, center_text(n_logo[3]))
-- N アイコン hl: left pad=19 bytes オフセット
table.insert(header_hl, { { "AlphaNLogo", 19, 23 }, { "AlphaNLogoRight", 23, 33 } }) -- L1
table.insert(header_hl, { { "AlphaNLogo", 19, 25 }, { "AlphaNLogoRight", 25, 37 } }) -- L2
table.insert(header_hl, { { "AlphaNLogo", 19, 26 }, { "AlphaNLogoRight", 26, 33 } }) -- L3

-- バージョン情報
table.insert(hanzo, center_text(nvim_version))
table.insert(hanzo, sep) -- 44 cols already
table.insert(hanzo, open_src) -- 44 cols already
table.insert(hanzo, center_text(url_line))
table.insert(hanzo, sep) -- 44 cols already
table.insert(header_hl, { { "AlphaNLogoRight", 16, 28 } }) -- NVIM vX.Y.Z (黄色)
table.insert(header_hl, {}) -- separator
table.insert(header_hl, {}) -- Nvim is open source...
table.insert(header_hl, {}) -- https://neovim.io
table.insert(header_hl, {}) -- separator

theta.header.val = hanzo
theta.header.opts.hl = header_hl
theta.header.opts.position = "center" -- 中央配置を明示的に設定

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
