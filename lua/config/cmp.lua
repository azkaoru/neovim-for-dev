local cmp = require('cmp')

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

local luasnip = require "luasnip"

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end

	local line, col = unpack(vim.api.nvim_win_get_cursor(0))

	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup {

	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			--vim_item.kind = require("lspkind").presets.default[vim_item.kind] ..
			--    " " .. vim_item.kind

			-- vim_item.kind が nil なら空文字にする
			local kind_text = vim_item.kind or ""
			local kind_icon = ""
			if kind_text ~= "" then
				kind_icon = require("lspkind").presets.default[kind_text] or ""
			end
			vim_item.kind = kind_icon .. " " .. kind_text

			-- set a name for each source
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				nvim_lsp_signature_help = "[Signature]",
				buffer = "[Buffer]",
				ultisnips = "[UltiSnips]",
				luasnip = "[LuaSnip]",
				-- vsnip = "[Vsnip]",
				nvim_lua = "[Lua]",
				cmp_tabnine = "[TabNine]",
				look = "[Look]",
				path = "[Path]",
				spell = "[Spell]",
				calc = "[Calc]",
				emoji = "[Emoji]",
				copilot = "[Copilot]"
			})[entry.source.name]
			return vim_item
		end
	},
	mapping = {
		['<C-n>'] = cmp.mapping.select_prev_item(),
		-- ['<Tab>'] = cmp.mapping.select_next_item(),
		-- copilot_cmp setting
		["<Tab>"] = vim.schedule_wrap(function(fallback)
			if cmp.visible() and has_words_before() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true
		}),
	},
	-- snippet = {expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
			-- vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	sources = {
		{ name = 'buffer' }, { name = 'nvim_lsp' }, { name = 'nvim_lsp_signature_help' },
		{ name = "ultisnips" }, { name = "luasnip" },
		{ name = "nvim_lua" }, { name = "look" }, { name = "path" },
		{ name = 'cmp_tabnine' }, { name = "calc" }, { name = "spell" },
		{ name = "emoji" }, { name = "copilot" }, { name = "copilot-chat" }
	},
	completion = { completeopt = 'menu,menuone,noinsert' },
	window = {
		documentation = cmp.config.window.bordered()
	},
}

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline({
		["<C-n>"] = { c = cmp.mapping.select_next_item() },
		["<C-p>"] = { c = cmp.mapping.select_prev_item() },
		["<CR>"]  = { c = cmp.mapping.confirm() },
	}),
	sources = {
		{ name = "buffer" },
	},
})


cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({
    ["<C-Space>"] = { c = cmp.mapping.complete() },
    ["<C-n>"]     = { c = cmp.mapping.select_next_item() },
    ["<C-p>"]   = { c = cmp.mapping.select_prev_item() },
    ["<CR>"]      = { c = cmp.mapping.confirm() },
  }),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
    { name = "buffer" }, -- ← これで :%s/ でもバッファ補完できる
  }),
  completion = { autocomplete = false },
})


cmp.setup.filetype("copilot-chat", {
	sources = {
		{ name = "snippets" },
		{ name = "copilot" },
		{ name = "buifer" },
	},
})



-- Auto pairs
local cmp_autopairs = require "nvim-autopairs.completion.cmp"
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
print('config.cmp end')
