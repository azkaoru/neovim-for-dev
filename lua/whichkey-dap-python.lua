function attach_to_debugpy()
	local dap = require('dap')
	dap.configurations.python = {
		{
			type = 'python',
			request = 'attach',
			name = "Attach Remote",
			mode = "remote",
			connect = { host = "localhost", port = 5678 },
			pathMappings = { { localRoot = "${workspaceFolder}", remoteRoot = "/opt/barbican" } }
		},
	}
	dap.continue()
end

-- attach
-- vim.keymap.set("n", "<leader>daa", ':lua attach_to_ansibug()<CR>')


local wk = require("which-key")
wk.add({
	-- ansibug
	{ "<leader>dap", ":lua attach_to_debugpy()<CR>", desc = "Python Attach debugpy", mode = "n" },
})
