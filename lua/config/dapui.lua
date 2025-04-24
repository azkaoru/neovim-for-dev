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

  -- manual install 
  dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/vscode-chrome-debug/out/src/chromeDebug.js" }
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


dap.adapters.bashdb = {
  type = 'executable';
  command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter';
  name = 'bashdb';
}


dap.configurations.sh = {
  {
    type = 'bashdb';
    request = 'launch';
    name = "Launch file";
    showDebugOutput = true;
    pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb';
    pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir';
    trace = true;
    file = "${file}";
    program = "${file}";
    cwd = '${workspaceFolder}';
    pathCat = "cat";
    pathBash = "/bin/bash";
    pathMkfifo = "mkfifo";
    pathPkill = "pkill";
    args = {};
    env = {};
    terminalKind = "integrated";
  }
}

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ansible
dap.adapters.ansible = {
  type = "executable",
  command = "python3.11", -- or "/path/to/virtualenv/bin/python",
  args = { "-m", "ansibug", "dap" },
}

local ansibug_configurations = {
  {
    type = "ansible",
    request = "launch",
    name = "Debug playbook",
    playbook = "${file}"
  },
}

dap.configurations["yaml.ansible"] = ansibug_configurations



  require("dap-vscode-js").setup ({
    node_path = "node",
    debugger_path = DEBUGGER_PATH,
    -- debugger_cmd = { "js-debug-adapter" },
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
  })

  for _, language in ipairs { "typescript", "javascript" } do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Jest Tests",
        -- trace = true, -- include debugger info
        runtimeExecutable = "node",
        runtimeArgs = {
          "./node_modules/jest/bin/jest.js",
          "--runInBand",
        },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
    }
  end

  for _, language in ipairs { "typescriptreact", "javascriptreact" } do
    dap.configurations[language] = {
      {
        type = "chrome",
        name = "Attach - Remote Debugging",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        -- webRoot = "${workspaceFolder}",
        webRoot = "${workspaceRoot}",
      },
      {
        type = "pwa-chrome",
        name = "Launch Chrome",
        request = "launch",
        url = "http://localhost:3000",
      },
    }
  end

  -- Setup DapUI
  -- set it up see more configs in their repo
local dap, dapui = require("dap"), require("dapui")

-- local config = {
--   sidebar = {
--     elements = {
--       {
--         id = "scopes",
--         size = 0.25, -- Can be float or integer > 1
--       },
--       { id = "breakpoints", size = 0.25 },
--     },
--     size = 40,
--     position = "left", -- Can be "left", "right", "top", "bottom"
-- },
-- tray = {
-- elements = {},
  -- },
  -- }

dapui.setup({
  icons = { expanded = "", collapsed = "" },
  layouts = {
    {
      elements = {
        { id = "watches", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "scopes", size = 0.25 },
      },
      size = 100,
      position = "right",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.20,
      position = "bottom",
    },
  },
})

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
  --local map = vim.api.nvim_set_keymap

  -- map the key n to run the command :NvimTreeToggle
  --map('n', 'm', [[:NvimTreeToggle<CR>]], {})

  -- nvim-dap keymappings
  -- Press f5 to debug
  --map('n', '<F5>', [[:lua require'dap'.continue()<CR>]], {})
  -- Press CTRL + b to toggle regular breakpoint
  --map('n', '<C-b>', [[:lua require'dap'.toggle_breakpoint()<CR>]], {})


  -- nvim-dap keymappings
  -- Press f5 to debug
  --map('n', '<F5>', [[:lua require'dap'.continue()<CR>]], {})
  -- Press CTRL + b to toggle regular breakpoint
  --map('n', '<C-b>', [[:lua require'dap'.toggle_breakpoint()<CR>]], {})
  -- Press CTRL + c to toggle Breakpoint with Condition
  --map('n', '<C-c>', [[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>]], {})
  -- Press CTRL + l to toggle Logpoint
  --map('n', '<C-l>', [[:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log Point Msg: '))<CR>]], {})
  -- Pressing F10 to step over
  --map('n', '<F10>', [[:lua require'dap'.step_over()<CR>]], {})
  -- Pressing F11 to step into
  --map('n', '<F11>', [[:lua require'dap'.step_into()<CR>]], {})
  -- Pressing F12 to step out
  --map('n', '<F12>', [[:lua require'dap'.step_out()<CR>]], {})
  -- Press F6 to open REPL
  --map('n', '<F6>', [[:lua require'dap'.repl.open()<CR>]], {})
  -- Press dl to run last ran configuration (if you used f5 before it will re run it etc)
  --map('n', 'dl', [[:lua require'dap'.run_last()<CR>]], {})

  -- Press Ctrl+d to toggle debug mode, will remove NvimTree also
  --map('n', '<C-d>', [[:NvimTreeToggle<CR> :lua require'dapui'.toggle()<CR>]], {})

