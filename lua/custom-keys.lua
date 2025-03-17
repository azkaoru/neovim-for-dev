
vim.api.nvim_set_var('mapleader', ',')

local map = vim.api.nvim_set_keymap


-- map the key n to run the command :NvimTreeToggle
--map('n', 'm', [[:NvimTreeToggle<CR>]], {})


local wk = require("which-key")
	wk.add({

	{ "m", "[[:NvimTreeToggle<CR>]]", desc="Toggle NvimTree"},
-- null-ls keymappings
{ "<space>f", ":lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>", desc ="CODE FORMAT",mode= "n"},
	{ "<leader>s",  group = "LSPSAGA" }, -- group
{ "<leader>sgh",  "<cmd>Lspsaga hover_doc<CR>",desc="SAGA Hover Doc",mode= "n"},
{ "<leader>sgf", "<cmd>Lspsaga lsp_finder<CR>",desc="SAGA LSP Finder",mode= "n"},
{ "<leader>sgp", "<cmd>Lspsaga peek_definition<CR>",desc="SAGA peek_definition",mode= "n"},
{ "<leader>sgc", "<cmd>Lspsaga code_action<CR>",desc="SAGA code_action",mode= "n"},
{ "<leader>sgr", "<cmd>Lspsaga rename<CR>",desc="SAGA rename",mode= "n"},
{ "<leader>sgdl", "<cmd>Lspsaga show_line_diagnostics<CR>",desc="SAGA show_line_diagnostics",mode= "n"},
{ "<leader>sgdc", "<cmd>Lspsaga show_cursor_diagnostics<CR>",desc="SAGA show_cursor_diagnostics",mode= "n"},
{ "<leader>sgdf", "<cmd>Lspsaga show_buf_diagnostics<CR>",desc="SAGA show_cursor_diagnostics",mode= "n"},
{ "<leader>sgdn", "<cmd>Lspsaga diagnostic_jump_next<CR>",desc="SAGA diagnostic_jump_next",mode= "n"},
{ "<leader>sgdp", "<cmd>Lspsaga diagnostic_jump_prev<CR>",desc="SAGA diagnostic_jump_prev",mode= "n"},
{ "<leader>sgci", "<cmd>Lspsaga incoming_calls<CR>", desc="SAGA incoming_calls",mode= "n"},
{ "<leader>sgco", "<cmd>Lspsaga outgoing_calls<CR>", desc="SAGA outgoing_calls",mode= "n"},
	{ "<leader>t",  group = "TOGGLE" }, -- group
{ "<leader>tt", "<cmd>Lspsaga term_toggle<CR>",desc="SAGA Toggle Term UI",mode= "n"},

-- CopilotChat.nvim keymappings
--{ '<leader>cco', ':CopilotChat<CR>', { noremap = true, silent = true })
	{ "<leader>c",  group = "Copilot" }, -- group
{ "<leader>cco", ":CopilotChat<CR>", desc="CopilotChat",mode= "n"},
--map('i', '<C-c>', '<Plug>(copilot-chat)', { noremap = false, silent = true })

-- Copilot.nvim keymappings
--map('i', '<C-g>', 'copilot#Accept("<CR>")', { noremap = false, silent = true })


	{ "<leader>r",  group = "RUN" }, -- group
})
