function attach_to_ansibug()
  local dap = require('dap')
  dap.configurations.yaml = {
    {
      type = 'ansible';
      request = 'attach';
      address = "tcp://localhost:34419";
      name = "Attach to the process";
    },
  }
  dap.continue()
end

-- attach
vim.keymap.set("n", "<leader>daa", ':lua attach_to_ansibug()<CR>')
