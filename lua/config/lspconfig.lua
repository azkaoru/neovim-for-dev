	-- Require LSP config which we can use to attach gopls
	lspconfig = require "lspconfig"
	util = require "lspconfig/util"
        cmp_nvim_lsp = require "cmp_nvim_lsp"
	-- Since we installed lspconfig and imported it, we can reach
	-- gopls by lspconfig.gopls
	-- we can then set it up using the setup and insert the needed configurations
	--
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
		filetypes = { "yaml" },
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
		}
		-- on_attach = on_attach,
		-- capabilities = capabilities
	}

-- An example nvim-lspconfig capabilities setting
capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.markdown_oxide.setup {
    -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
    -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
    capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        }
    ),
    -- on_attach = on_attach -- configure your on attach config
}


lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
    root_dir = util.root_pattern(".venv"),
    cmd = { "bash", "-c", "source ~/.virtualenvs/myenv/bin/activate && ~/.virtualenvs/myenv/bin/pyright-langserver --stdio" },
    settings = {
      python = {
        pythonPath = '.venv/bin/python', -- Windowsなら .venv/Scripts/python.exe
      },
  },
}



