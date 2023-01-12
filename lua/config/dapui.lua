local M = {}

function M.setup()
  -- fetch the dap plugin
  local dap = require('dap')
  -- Add adapter to delve
  dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
      command = 'dlv',
      args = {'dap', '-l', '127.0.0.1:${port}'},
    }
  }

  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "delve",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages 
    {
      type = "delve",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    }
  }
  -- Setup DapUI
  local dapui = require('dapui')
  -- set it up see more configs in their repo
  dapui.setup()

  -- dap fires events, we can listen on them to open UI on certain events
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  -- fetch keymap
  local map = vim.api.nvim_set_keymap

  -- map the key n to run the command :NvimTreeToggle
  map('n', 'm', [[:NvimTreeToggle<CR>]], {})

  -- nvim-dap keymappings
  -- Press f5 to debug
  map('n', '<F5>', [[:lua require'dap'.continue()<CR>]], {})
  -- Press CTRL + b to toggle regular breakpoint
  map('n', '<C-b>', [[:lua require'dap'.toggle_breakpoint()<CR>]], {})


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


end

return M
