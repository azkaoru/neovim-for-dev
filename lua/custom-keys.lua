vim.api.nvim_set_var('mapleader', ',')

local map = vim.api.nvim_set_keymap

-- map the key n to run the command :NvimTreeToggle
map('n', 'm', [[:NvimTreeToggle<CR>]], {})

map('n', '<C-d>', [[:NvimTreeToggle<CR> :lua require'dapui'.toggle()<CR>]], {})

-- telescope keymappings
map('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>', {})
-- search files, even hidden ones
map('n', '<leader>ff', ':lua require"telescope.builtin".find_files({no_ignore=true, hidden=false})<CR>', {})
-- ripgrep files, respects gitignore
map('n', '<leader>fg', ':lua require"telescope.builtin".live_grep()<CR>', {})
map('n', '<leader>fd', ':lua require"telescope.builtin".lsp_definitions()<CR>', {})
map('n', '<leader>fr', '<cmd>Telescope lsp_references<CR>', {})


-- nvim-dap keymappings
-- Press f5 to debug
map('n', '<F5>', [[:lua require'dap'.continue()<CR>]], {})
-- Press CTRL + b to toggle regular breakpointTelescope diagnostics
map('n', '<C-b>', [[:lua require'dap'.toggle_breakpoint()<CR>]], {})
-- Press CTRL + c to toggle Breakpoint with Condition
map('n', '<C-c>', [[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>]], {})
-- Press CTRL + l to toggle Logpoint
map('n', '<C-l>', [[:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log Point Msg: '))<CR>]], {})
-- Pressing F7 to step over
map('n', '<F7>', [[:lua require'dap'.step_over()<CR>]], {})
-- Pressing si to step into
map('n', '<leader>si', [[:lua require'dap'.step_into()<CR>]], {})
-- Pressing so to step out
map('n', '<leader>so', [[:lua require'dap'.step_out()<CR>]], {})
-- Press F6 to open REPL
map('n', '<F6>', [[:lua require'dap'.repl.open()<CR>]], {})
-- Press dl to run last ran configuration (if you used f5 before it will re run it etc)
map('n', 'dl', [[:lua require'dap'.run_last()<CR>]], {})

-- Press Ctrl+d to toggle debug mode, will remove NvimTree also
map('n', '<C-d>', [[:NvimTreeToggle<CR> :lua require'dapui'.toggle()<CR>]], {})


-- null-ls keymappings
map('n', '<leader>lf', ':lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>', {})


-- diagnostics keymappings
map('n', '<leader>dd', ':lua require"telescope.builtin".diagnostics()<CR>', {})

-- lspsaga keymappings
map("n", "gh",  "<cmd>Lspsaga hover_doc<CR>",{})
map('n', 'gf', '<cmd>Lspsaga lsp_finder<CR>',{})
map("n", "gd", "<cmd>Lspsaga peek_definition<CR>",{})
map("n", "gca", "<cmd>Lspsaga code_action<CR>",{})
map("n", "gr", "<cmd>Lspsaga rename<CR>",{})
map("n", "gdd", "<cmd>Lspsaga show_line_diagnostics<CR>",{})
map("n", "gdc", "<cmd>Lspsaga show_cursor_diagnostics<CR>",{})
map("n", "gdb", "<cmd>Lspsaga show_buf_diagnostics<CR>",{})
map("n", "gdn", "<cmd>Lspsaga diagnostic_jump_next<CR>",{})
map("n", "gdp", "<cmd>Lspsaga diagnostic_jump_prev<CR>",{})
map('n', '<leader>gic', '<cmd>Lspsaga incoming_calls<CR>', {})
map('n', '<leader>goc', '<cmd>Lspsaga outgoing_calls<CR>', {})
map("n", '<leader>gtt', "<cmd>Lspsaga term_toggle<CR>",{})
