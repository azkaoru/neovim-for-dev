vim.g.maplocalleader = ","	
require("which-key").setup()
	local wk = require("which-key")
	wk.add({
-- telescope
		{ "<leader>f",  group = "FIND" }, -- group
{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc= "Find file", mode ="n"},
{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep",mode = "n"},
{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer",mode = "n"},
{ "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Find mark",mode = "n"},
{ "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "Find references (LSP)",mode = "n"},
{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find symbols (LSP)",mode = "n"},
{ "<leader>fc", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Find incoming calls (LSP)",mode = "n"},
{ "<leader>fo", "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "Find outgoing calls (LSP)",mode = "n"},
{ "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", desc = "Find implementations (LSP)",mode = "n"},
{ "<leader>fx", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Find errors (LSP)",mode = "n"},
{ "<leader>ft", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Find type definications (LSP)",mode = "n"},

-- trouble
		{ "<leader>x",  group = "ERRORS" }, -- group
{ "<leader>xx", "<cmd>TroubleToggle<cr>", desc= "Display errors",mode = "n"},
{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc= "Display workspace errors",mode = "n"},
{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc= "Display document errors",mode = "n"},

-- symbols-outline
{ "<leader>o", "<cmd>SymbolsOutline<cr>", desc= "Show symbols",mode = "n"},

-- nvim-tree
--{ "<leader>tt", "<cmd>NvimTreeToggle<cr>", desc= "File Browser Toggle Switch",mode = "n"},
{ "<leader>nf", "<cmd>NvimTreeFindFileToggle<cr>", desc= "Find file in browser",mode = "n"},

-- vim-test
		{ "<leader>v",  group = "TEST" }, -- group
{ "<leader>vt", "<cmd>TestNearest<cr>", desc= "Test nearest",mode = "n"},
{ "<leader>vf", "<cmd>TestFile<cr>", desc= "Test file",mode = "n"},
{ "<leader>vs", "<cmd>TestSuite<cr>", desc= "Test suite",mode = "n"},
{ "<leader>vl", "<cmd>TestLast<cr>", desc= "Test last",mode = "n"},
{ "<leader>vg", "<cmd>TestVisit<cr>", desc= "Go to test",mode = "n"},

-- nvim-dap
		{ "<leader>b",  group = "BREAKPOINTS" }, -- group
{ "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc= "Set breakpoint",mode = "n"},
{ "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc= "Set conditional breakpoint",mode = "n"},
{ "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", desc= "Set log point",mode = "n"},
{ "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>", desc= "Clear breakpoints",mode = "n"},
{ "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>", desc= "List breakpoints",mode = "n"},

		{ "<leader>d",  group = "DEBUG" }, -- group
{ "<F7>", "<cmd>lua require'dap'.step_over()<cr>", desc= "Step over",mode = "n"},
{ "<F8>", "<cmd>lua require'dap'.step_into()<cr>", desc= "Step into",mode = "n"},
{ "<F9>", "<cmd>lua require'dap'.continue()<cr>", desc= "Continue",mode = "n"},
{ "<F10>", "<cmd>lua require'dap'.step_out()<cr>", desc= "Step out",mode = "n"},
{ "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", desc= "Disconnect",mode = "n"},
{ "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", desc= "Terminate",mode = "n"},
{ "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc= "Open REPL",mode = "n"},
{ "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc= "Run last",mode = "n"},
{ "<leader>di", function() require"dap.ui.widgets".hover() end, desc= "Variables",mode = "n"},
{ "<leader>d?", function() local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes) end, desc= "Scopes",mode = "n"},
{ "<leader>df", "<cmd>Telescope dap frames<cr>", desc= "List frames",mode = "n"},
{ "<leader>dh", "<cmd>Telescope dap commands<cr>", desc= "List commands",mode = "n"},

		{ "<leader>w",  proxy = "<c-w>",                 group = "windows" }, -- proxy to window mappings
		{
			"<leader>b",
			group = "buffers",
			expand = function()
				return require("which-key.extras").expand.buf()
			end
		},
		{
			-- Nested mappings are allowed and can be added in any order
			-- Most attributes can be inherited or overridden on any level
			-- There's no limit to the depth of nesting
			mode = { "n", "v" },      -- NORMAL and VISUAL mode
			{ "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
			{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
		},

		-- lsp
		{ "<leader>l",  group = "LSP" }, -- group
                { "<leader>lf",function() vim.lsp.buf.format { async = true } end, desc= "CODE FORMAT",mode = "n"},
	})

