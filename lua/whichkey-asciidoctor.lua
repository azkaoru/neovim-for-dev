local wk = require("which-key")

wk.add({
	{ "<space>a", group = "ASCIIDOCTOR" }, -- group
	{ "<space>ap", ":lua require('utils.asciidoctor').gen_html()<CR>", desc = "AsciiDocプレビュー", mode = "n" },
	{ "<space>ah", ":lua require('utils.asciidoctor').gen_html()<CR>", desc = "AsciiDoc HTML生成", mode = "n" },
	{ "<space>af", ":lua require('utils.asciidoctor').gen_pdf()<CR>", desc = "AsciiDoc PDF生成", mode = "n" },
	{ "<space>al", ":lua require('utils.asciidoctor').start_live_preview()<CR>", desc = "AsciiDocライブプレビュー", mode = "n" },
	{ "<space>ai", ":lua require('utils.asciidoctor').paste_image()<CR>", desc = "画像貼り付け", mode = "n" },
})