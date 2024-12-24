local M = {}

function M.setup()
	-- Require LSP config which we can use to attach gopls
	lspconfig = require "lspconfig"
	util = require "lspconfig/util"
	-- Since we installed lspconfig and imported it, we can reach
	-- gopls by lspconfig.gopls
	-- we can then set it up using the setup and insert the needed configurations
	lspconfig.gopls.setup {
		cmd = { "gopls", "serve" },
		filetypes = { "go", "gomod" },
		root_dir = util.root_pattern("go.work", "go.mod", ".git"),
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	}
	--lspconfig.tsserver.setup {}
	lspconfig.ts_ls.setup {}

	lspconfig.lua_ls.setup {}

	lspconfig.bashls.setup {}

	lspconfig.ansiblels.setup {
		filetypes = { "yaml"},
		settings = {
			ansible = {
				ansible = {
					path = "ansible"
				},
				executionEnvironment = {
					enabled = false
				},
				python = {
					interpreterPath = "python"
				},
				validation = {
					enabled = true,
					lint = {
						enabled = true,
						path = "ansible-lint"
					}
				}
			}
		},
 -- on_attach = on_attach,
 -- capabilities = capabilities
	}
end

return M
