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


-- nvim-dap keymappings
-- Press f5 to debug
map('n', '<F5>', [[:lua require'dap'.continue()<CR>]], {})
-- Press CTRL + b to toggle regular breakpoint
map('n', '<C-b>', [[:lua require'dap'.toggle_breakpoint()<CR>]], {})
-- Press CTRL + c to toggle Breakpoint with Condition
map('n', '<C-c>', [[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>]], {})
-- Press CTRL + l to toggle Logpoint
map('n', '<C-l>', [[:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log Point Msg: '))<CR>]], {})
-- Pressing F10 to step over
map('n', '<F10>', [[:lua require'dap'.step_over()<CR>]], {})
-- Pressing F11 to step into
map('n', '<F11>', [[:lua require'dap'.step_into()<CR>]], {})
-- Pressing F12 to step out
map('n', '<F12>', [[:lua require'dap'.step_out()<CR>]], {})
-- Press F6 to open REPL
map('n', '<F6>', [[:lua require'dap'.repl.open()<CR>]], {})
-- Press dl to run last ran configuration (if you used f5 before it will re run it etc)
map('n', 'dl', [[:lua require'dap'.run_last()<CR>]], {})

-- Press Ctrl+d to toggle debug mode, will remove NvimTree also
map('n', '<C-d>', [[:NvimTreeToggle<CR> :lua require'dapui'.toggle()<CR>]], {})
