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
-- vim.keymap.set("n", "<leader>daa", ':lua attach_to_ansibug()<CR>')


local wk = require("which-key")
	wk.add({
-- ansibug
{ "<leader>daa", ":lua attach_to_ansibug()<CR>", desc= "Ansible Attach", mode ="n"},
})

