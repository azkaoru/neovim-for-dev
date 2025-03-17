-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------
	-- vim-marked
	vim.keymap.set("n", "<leader>mo", "<cmd>MarkedOpen<cr>", { desc = "Open marked" })

	-- vim-pencil
	vim.keymap.set("n", "<leader>qc", "<Plug>ReplaceWithCurly", { desc = "Curl quotes" })
	vim.keymap.set("n", "<leader>qs", "<Plug>ReplaceWithStraight", { desc = "Straighten quotes" })

	-- telescope
	vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find file" })
	vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
	vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffer" })
	vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Find mark" })
	vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { desc = "Find references (LSP)" })
	vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find symbols (LSP)" })
	vim.keymap.set("n", "<leader>fc", "<cmd>Telescope lsp_incoming_calls<cr>", { desc = "Find incoming calls (LSP)" })
	vim.keymap.set("n", "<leader>fo", "<cmd>Telescope lsp_outgoing_calls<cr>", { desc = "Find outgoing calls (LSP)" })
	vim.keymap.set("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Find implementations (LSP)" })
	vim.keymap.set("n", "<leader>fx", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Find errors (LSP)" })
	vim.keymap.set("n", "<leader>ft", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		{ desc = "Find type definications (LSP)" })

	-- trouble
	vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Display errors" })
	vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
		{ desc = "Display workspace errors" })
	vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
		{ desc = "Display document errors" })

	-- symbols-outline
	vim.keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<cr>", { desc = "Show symbols" })

	-- nvim-tree
	--vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<cr>", "File Browser Toggle Switch")
	vim.keymap.set("n", "<leader>fft", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Find file in browser" })

	-- vim-test
	vim.keymap.set("n", "<leader>vt", "<cmd>TestNearest<cr>", { desc = "Test nearest" })
	vim.keymap.set("n", "<leader>vf", "<cmd>TestFile<cr>", { desc = "Test file" })
	vim.keymap.set("n", "<leader>vs", "<cmd>TestSuite<cr>", { desc = "Test suite" })
	vim.keymap.set("n", "<leader>vl", "<cmd>TestLast<cr>", { desc = "Test last" })
	vim.keymap.set("n", "<leader>vg", "<cmd>TestVisit<cr>", { desc = "Go to test" })

	-- nvim-dap
	vim.keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = "Set breakpoint" })
	vim.keymap.set("n", "<leader>bc",
		"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
		{ desc = "Set conditional breakpoint" })
	vim.keymap.set("n", "<leader>bl",
		"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
		{ desc = "Set log point" })
	vim.keymap.set("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>", { desc = "Clear breakpoints" })
	vim.keymap.set("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>", { desc = "List breakpoints" })


	vim.keymap.set("n", "<F7>", "<cmd>lua require'dap'.step_over()<cr>", { desc = "Step over" })
	vim.keymap.set("n", "<F8>", "<cmd>lua require'dap'.step_into()<cr>", { desc = "Step into" })
	vim.keymap.set("n", "<F9>", "<cmd>lua require'dap'.continue()<cr>", { desc = "Continue" })
	vim.keymap.set("n", "<F10>", "<cmd>lua require'dap'.step_out()<cr>", { desc = "Step out" })
	vim.keymap.set("n", "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", { desc = "Disconnect" })
	vim.keymap.set("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", { desc = "Terminate" })
	vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", { desc = "Open REPL" })
	vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", { desc = "Run last" })
	vim.keymap.set("n", "<leader>di", function() require "dap.ui.widgets".hover() end, { desc = "Variables" })
	vim.keymap.set("n", "<leader>d?",
		function()
			local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes)
		end, { desc = "Scopes" })
	vim.keymap.set("n", "<leader>df", "<cmd>Telescope dap frames<cr>", { desc = "List frames" })
	vim.keymap.set("n", "<leader>dh", "<cmd>Telescope dap commands<cr>", { desc = "List commands" })

