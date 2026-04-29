local alpha = require("alpha")
local theta = require("alpha.themes.theta")

-- Nアイコン用ハイライトグループ
vim.api.nvim_set_hl(0, "AlphaNLogo", { fg = "#87E58E" })
vim.api.nvim_set_hl(0, "AlphaNLogoRight", { fg = "#E8EDA2" })

local nvim_version = string.format("NVIM v%d.%d.%d", vim.version().major, vim.version().minor, vim.version().patch)

local n_logo = {
	[[│ ╲ ││]], -- 14 bytes, 6 cols
	[[││╲╲││]], -- 18 bytes, 6 cols
	[[││ ╲ │]], -- 14 bytes, 6 cols
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

local sep = [[────────────────────────────────────────────]] -- 44 cols, 132 bytes
local open_src = [[Nvim is open source and freely distributable]] -- 44 cols, 44 bytes
local url_line = [[https://neovim.io]] -- 18 cols, 18 bytes

-- 左カラムの幅 = 44 cols（separator / open source に合わせる）
local left_width = 44
local gap = "    " -- 4 spaces between left column and dog
local dog_pad = string.rep(" ", left_width + #gap) -- 48 spaces

-- 各行の左部分（display width 44 にパディング）
local function pad_left(text)
	local dw = vim.fn.strdisplaywidth(text)
	if dw >= left_width then
		return text
	end
	return text .. string.rep(" ", left_width - dw)
end

-- N アイコン行の左パディング（それぞれバイト長が違うので個別に対応）
local n_pad = {
	string.rep(" ", 38), -- Line1: 6 cols N + 38 sp = 44 cols; bytes: 14 + 38 = 52
	string.rep(" ", 38), -- Line2: 6 cols N + 38 sp = 44 cols; bytes: 18 + 38 = 56
	string.rep(" ", 38), -- Line3: 6 cols N + 38 sp = 44 cols; bytes: 14 + 38 = 52
}

-- ヘッダー行を組み立て
local hanzo = {}
-- Lines 1-6: dog only（Nアイコンを6行下げるための空き）
for i = 1, 6 do
	hanzo[i] = dog_pad .. dog[i]
end
-- Lines 7-9: N icon + dog
hanzo[7] = n_logo[1] .. n_pad[1] .. gap .. dog[7]
hanzo[8] = n_logo[2] .. n_pad[2] .. gap .. dog[8]
hanzo[9] = n_logo[3] .. n_pad[3] .. gap .. dog[9]
-- Lines 10-14: version info + dog
hanzo[10] = pad_left(nvim_version) .. gap .. dog[10]
hanzo[11] = sep .. gap .. dog[11]
hanzo[12] = open_src .. gap .. dog[12]
hanzo[13] = pad_left(url_line) .. gap .. dog[13]
hanzo[14] = sep .. gap .. dog[14]
-- Lines 15-22: dog only
for i = 15, 22 do
	hanzo[i] = dog_pad .. dog[i]
end

theta.header.val = hanzo

-- ハイライト設定
-- 左カラムの表示幅=44, gap=4 byte, 各行の dog 開始バイト位置:
-- Line1: N(14) + pad(38) + gap(4) = 56
-- Line2: N(18) + pad(38) + gap(4) = 60
-- Line3: N(14) + pad(38) + gap(4) = 56
-- Line4: version(15) + pad(29) + gap(4) = 48
-- Line5: sep(132) + gap(4) = 136
-- Line6: open_src(44) + gap(4) = 48
-- Line7: sep(132) + gap(4) = 136
-- Line8-22: dog_pad(48) = 48

local header_hl = {}
-- Lines 1-6: dog only
for _ = 1, 6 do
	table.insert(header_hl, { { "Type", 0, -1 } })
end
-- Line 7: │ ╲ ││ → green(0-3), yellow(4-14), dog@56
table.insert(header_hl, { { "AlphaNLogo", 0, 4 }, { "AlphaNLogoRight", 4, 14 }, { "Type", 56, -1 } })
-- Line 8: ││╲╲││ → green(0-5), yellow(6-18), dog@60
table.insert(header_hl, { { "AlphaNLogo", 0, 6 }, { "AlphaNLogoRight", 6, 18 }, { "Type", 60, -1 } })
-- Line 9: ││ ╲ │ → green(0-6), yellow(7-14), dog@56
table.insert(header_hl, { { "AlphaNLogo", 0, 7 }, { "AlphaNLogoRight", 7, 14 }, { "Type", 56, -1 } })
-- Line 10: version yellow + dog Type
table.insert(header_hl, { { "AlphaNLogoRight", 0, -1 }, { "Type", 48, -1 } })
-- Line 11: dog Type (sep unhighlighted)
table.insert(header_hl, { { "Type", 136, -1 } })
-- Line 12: dog Type
table.insert(header_hl, { { "Type", 48, -1 } })
-- Line 13: URL (https://neovim.io) + dog Type
table.insert(header_hl, { { "Type", 48, -1 } })
-- Line 14: dog Type (sep unhighlighted)
table.insert(header_hl, { { "Type", 136, -1 } })
-- Lines 15-22: dog only
for _ = 15, 22 do
	table.insert(header_hl, { { "Type", 0, -1 } })
end

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
