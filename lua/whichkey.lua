local wk = require("which-key")
wk.add({
	-- telescope
	{ "<leader>f",  group = "FIND" }, -- group
	{ "<leader>ff", "<cmd>Telescope find_files<cr>",                                                           desc = "Find file",                     mode = "n" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>",                                                            desc = "Grep",                          mode = "n" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>",                                                              desc = "Find buffer",                   mode = "n" },
	{ "<leader>fm", "<cmd>Telescope marks<cr>",                                                                desc = "Find mark",                     mode = "n" },
	{ "<leader>fr", "<cmd>Telescope lsp_references<cr>",                                                       desc = "Find references (LSP)",         mode = "n" },
	{ "<leader>5", "<cmd>Telescope lsp_references<cr>",                                                       desc = "Find references (LSP)",         mode = "n" },
	{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",                                                 desc = "Find symbols (LSP)",            mode = "n" },
	{ "<leader>fc", "<cmd>Telescope lsp_incoming_calls<cr>",                                                   desc = "Find incoming calls (LSP)",     mode = "n" },
	{ "<leader>fo", "<cmd>Telescope lsp_outgoing_calls<cr>",                                                   desc = "Find outgoing calls (LSP)",     mode = "n" },
	{ "<leader>fi", "<cmd>Telescope lsp_implementations<cr>",                                                  desc = "Find implementations (LSP)",    mode = "n" },
	{ "<leader>4", "<cmd>Telescope lsp_implementations<cr>",                                                  desc = "Find implementations (LSP)",    mode = "n" },
	{ "<leader>fd", "<cmd>Telescope diagnostics<cr>",                                                  desc = "Find Diagnostics (LSP)",             mode = "n" },
	{ "<leader>fx", 
		function()
		   require "telescope.builtin".diagnostics({ severity = vim.diagnostic.severity.ERROR })
		end,
	desc = "Find errors (LSP)",             mode = "n" },

	{ "<leader>fX", 
		function()
		   require "telescope.builtin".diagnostics({ severity = vim.diagnostic.severity.WARN })
		end,
	desc = "Find warns (LSP)",             mode = "n" },
	{ "<leader>ft", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                                        desc = "Find type definications (LSP)", mode = "n" },

	-- trouble
	{ "<leader>x",  group = "ERRORS" }, -- group
	{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                                                     desc = "Display error (Trouble Diagnostics)",                mode = "n" },
	{ "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                                        desc = "Display buffers errors (Trouble Buffer Diagnostics)",                mode = "n" },
	-- { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",                                            desc = "Display workspace errors",      mode = "n" },
	{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",                                             desc = "Display document errors",       mode = "n" },

	-- symbols-outline
	{ "<space>o",   "<cmd>SymbolsOutline<cr>",                                                                 desc = "Show symbols",                  mode = "n" },

	-- nvim-tree
	--{ "<leader>tt", "<cmd>NvimTreeToggle<cr>", desc= "File Browser Toggle Switch",mode = "n"},
	-- { "<leader>nf", "<cmd>NvimTreeFindFileToggle<cr>", desc= "Find file in browser",mode = "n"},

	-- vim-test
	{ "<space>v",   group = "TEST" }, -- group
	{ "<space>vt",  "<cmd>TestNearest<cr>",                                                                    desc = "Test nearest",                  mode = "n" },
	{ "<space>vf",  "<cmd>TestFile<cr>",                                                                       desc = "Test file",                     mode = "n" },
	{ "<space>vs",  "<cmd>TestSuite<cr>",                                                                      desc = "Test suite",                    mode = "n" },
	{ "<space>vl",  "<cmd>TestLast<cr>",                                                                       desc = "Test last",                     mode = "n" },
	{ "<space>vg",  "<cmd>TestVisit<cr>",                                                                      desc = "Go to test",                    mode = "n" },

	-- nvim-dap
	{ "<leader>b",  group = "BREAKPOINTS" }, -- group
	{ "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>",                                           desc = "Set breakpoint",                mode = "n" },
	{ "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",        desc = "Set conditional breakpoint",    mode = "n" },
	{ "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", desc = "Set log point",                 mode = "n" },
	{ "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>",                                           desc = "Clear breakpoints",             mode = "n" },
	{ "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>",                                                 desc = "List breakpoints",              mode = "n" },

	{ "<leader>d",  group = "DEBUG" }, -- group
	{ "<F7>",       "<cmd>lua require'dap'.step_over()<cr>",                                                   desc = "Step over",                     mode = "n" },
	{ "<F8>",       "<cmd>lua require'dap'.step_into()<cr>",                                                   desc = "Step into",                     mode = "n" },
	{ "<F9>",       "<cmd>lua require'dap'.continue()<cr>",                                                    desc = "Continue",                      mode = "n" },
	{ "<F10>",      "<cmd>lua require'dap'.step_out()<cr>",                                                    desc = "Step out",                      mode = "n" },
	{ "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>",                                                  desc = "Disconnect",                    mode = "n" },
	{ "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>",                                                   desc = "Terminate",                     mode = "n" },
	{ "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>",                                                 desc = "Open REPL",                     mode = "n" },
	{ "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>",                                                    desc = "Run last",                      mode = "n" },
	{ "<leader>di", function() require "dap.ui.widgets".hover() end,                                           desc = "Variables",                     mode = "n" },
	{ "<space>d",  group = "DAPUI" }, -- group
	{ "<space>dt", "<cmd>lua require('dapui').toggle()<cr>",                                                    desc = "DAPUI toggle",                      mode = "n" },
	{ "<space>dc", "<cmd>lua require('dapui').close('sidebar')<cr>",                                                    desc = "DAPUI close",                      mode = "n" },
	{
		"<leader>d?",
		function()
			local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes)
		end,
		desc = "Scopes",
		mode = "n"
	},
	{ "<leader>df", "<cmd>Telescope dap frames<cr>", desc = "List frames", mode = "n" },
	{ "<leader>dh", "<cmd>Telescope dap commands<cr>", desc = "List commands", mode = "n" },

	-- { "<leader>w",  proxy = "<c-w>",                 group = "windows" }, -- proxy to window mappings
	-- {
	-- 	"<leader>b",
	-- 	group = "buffers",
	-- 	expand = function()
	-- 		return require("which-key.extras").expand.buf()
	-- 	end
	-- },
	-- {
	-- 	mode = { "n", "v" },      -- NORMAL and VISUAL mode
	-- 	{ "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
	-- 	{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
	-- },

	-- lspsaga
	{ "<leader>s", group = "LSPSAGA" }, -- group
	{ "<leader>sgh", "<cmd>Lspsaga hover_doc<CR>", desc = "SAGA Hover Doc", mode = "n" },
	{ "<leader>sgf", "<cmd>Lspsaga lsp_finder<CR>", desc = "SAGA LSP Finder", mode = "n" },
	{ "<leader>sgp", "<cmd>Lspsaga peek_definition<CR>", desc = "SAGA peek_definition", mode = "n" },
	{ "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "SAGA code_action", mode = "n" },
	{ "<leader>sgr", "<cmd>Lspsaga rename<CR>", desc = "SAGA rename", mode = "n" },
	{ "<leader>sgdl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "SAGA show_line_diagnostics", mode = "n" },
	{ "<leader>sgdc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "SAGA show_cursor_diagnostics", mode = "n" },
	{ "<leader>sgdf", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "SAGA show_cursor_diagnostics", mode = "n" },
	{ "<leader>sgdn", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "SAGA diagnostic_jump_next", mode = "n" },
	{ "<leader>sgdp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "SAGA diagnostic_jump_prev", mode = "n" },
	{ "<leader>sgci", "<cmd>Lspsaga incoming_calls<CR>", desc = "SAGA incoming_calls", mode = "n" },
	{ "<leader>sgco", "<cmd>Lspsaga outgoing_calls<CR>", desc = "SAGA outgoing_calls", mode = "n" },
	{ "<space>t", group = "Terminal" }, -- group
	{ "<space>tt", "<cmd>ToggleTerm<CR>", desc = "ターミナルを開く", mode = "n" },
	{ "<leader>t", group = "Terminal" }, -- group
	{ "<leader>tt",   "<cmd>Lspsaga term_toggle<CR>",                                                              desc = "Toggl Term UI",           mode = "n" },

	-- lsp
	{ "<leader>g", group = "Go to" }, -- group
	{ '<leader>gg', vim.lsp.buf.definition, desc = "Go to definition", mode = "n" },
	{ "<leader>gd", vim.lsp.buf.declaration, desc = "Go to declaration", mode = "n" },
	{ '<leader>gi', vim.lsp.buf.implementation, desc = "Go to implementation", mode = "n" },

	{ "<leader>l", group = "LSP" }, -- group
	{ "<leader>lf", function() vim.lsp.buf.format { async = true } end, desc = "CODE FORMAT", mode = "n" },
	{ '<leader>lh', vim.lsp.buf.hover, desc = "Hover text", mode = "n" },
	{ '<leader>ls', vim.lsp.buf.signature_help, desc = "Show signature", mode = "n" },
	{ '<leader>lawf', vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder", mode = "n" },
	{ '<leader>lrwf', vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder", mode = "n" },
	{
		'<space>lwf',
		function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end,
		desc = "List workspace folders",
		mode = "n"
	},
	{ '<leader>3', vim.lsp.buf.type_definition, desc = "Jump to type definition", mode = "n" },
	{ '<leader>2', vim.lsp.buf.rename, desc = "Rename", mode = "n" },
	{ '<leader>1', vim.lsp.buf.code_action, desc = "Code Action", mode = "n" },

	-- no-neck plugin
	{ "<leader>z", group = "Zen" }, -- group
	{ "<leader>zz", "<cmd>ZenMode<CR>", desc = "全画面表示", mode = "n" },
	-- oil plugins
	{ "<leader>o", group = "Oil" }, -- group
	{ "<leader>oo", function() require("oil").open() end, desc = "Oil current buffer's directory", mode = "n" },
	{ "<leader>oh", function() require("oil").open("~/.") end, desc = "Oil home directory", mode = "n" },

	-- namu plugins
	{ "<leader>n", group = "NAMU" }, -- group
	{ "<leader>ns", "<cmd>Namu symbols<CR>", desc = "Jump to LSP symbol", mode = "n" },

	-- namu plugins
	--{ "<space>w", group = "Window Move" }, -- group
	{ "<leader>m", "<cmd>Chowcho<CR>", desc = "chowcho Window Move", mode = "n" },

	-- vim-doge
	{ "<space>D", group = "doge" }, -- group
	{ "<space>Dg", "<cmd>DogeGenerate<CR>", desc = "DogeGenerate docgen", mode = "n" },
	-- CopilotChat.nvim keymappings
	--{ '<leader>cco', ':CopilotChat<CR>', { noremap = true, silent = true })
	{ "<leader>c", group = "Copilot" }, -- group
	{ "<leader>cco", ":CopilotChatOpen<CR>", desc = "CopilotChatを開く", mode = "n" },

	{ "<space>s", group = "STEP DEBUG" }, -- group
         { "<space>so", "<cmd>lua require'dap'.step_over()<cr>", desc= "Step over",mode = "n"},
         { "<space>si", "<cmd>lua require'dap'.step_into()<cr>", desc= "Step into",mode = "n"},
          { "<space>sc", "<cmd>lua require'dap'.continue()<cr>", desc= "Continue",mode = "n"},
         { "<space>st", "<cmd>lua require'dap'.step_out()<cr>", desc= "Step out",mode = "n"},

})


require("CopilotChat").setup({
	show_help = "yes",
	prompts = {
		Explain = {
			prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
			mapping = '<leader>cce',
			description = "コードの説明をお願いする",
		},
		Review = {
			prompt = '/COPILOT_REVIEW コードを日本語でレビューしてください。',
			mapping = '<leader>ccr',
			description = "コードのレビューをお願いする",
		},
		Fix = {
			prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
			mapping = '<leader>ccf',
			description = "コードの修正をお願いする",
		},
		Optimize = {
			prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
			mapping = '<leader>cco',
			description = "コードの最適化をお願いする",
		},
		Docs = {
			prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
			mapping = '<leader>ccd',
			description = "コードのドキュメント作成をお願いする",
		},
		Tests = {
			prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
			mapping = '<leader>cct',
			description = "テストコード作成をお願いする",
		},
		FixDiagnostic = {
			prompt = 'コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。',
			mapping = '<leader>ccdm',
			description = "コードの修正をお願いする",
			selection = require('CopilotChat.select').diagnostics,
		},
		Commit = {
			prompt =
			'実装差分に対するコミットメッセージを日本語で記述してください。',
			mapping = '<leader>ccmc',
			description = "コミットメッセージの作成をお願いする",
			selection = require('CopilotChat.select').gitdiff,
		},
		CommitStaged = {
			prompt =
			'ステージ済みの変更に対するコミットメッセージを日本語で記述してください。',
			mapping = '<leader>ccms',
			description = "ステージ済みのコミットメッセージの作成をお願いする",
			selection = function(source)
				return require('CopilotChat.select').gitdiff(source, true)
			end,
		},
	},
	mappings = {
		-- Use tab for completion
		complete = {
			insert = "", -- Explicitly set an empty string. It lets regular copilot plugin overrides CopilotChat.nvim
		}
	}
})
