function attach_to_ansibug()
  local dap = require('dap')
  dap.configurations.ansible = {
    {
      type = 'ansible';
      request = 'attach';
      name = "Attach to the process";
      port = '34419';
    },
  }
  dap.continue()
end

-- attach
vim.keymap.set("n", "<leader>daa", ':lua attach_to_ansidug()<CR>')
