local M = {}

function M.setup()
	-- Indicate first time installation
	local packer_bootstrap = false

	-- packer.nvim configuration
	local conf = {
		profile = {
			enable = true,
			threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
		display = {
			open_fn = function()
				return require("packer.util").float { border = "rounded" }
			end,
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are changes in this file
	local function packer_init()
		local fn = vim.fn
		local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			packer_bootstrap = fn.system {
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			}
			vim.cmd [[packadd packer.nvim]]
		end
		vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
	end

	-- Plugins
	local function plugins(use)
		use { "wbthomason/packer.nvim" }

		-- Load only when require
		use { "nvim-lua/plenary.nvim", module = "plenary" }

		-- Colorscheme
		use {
			"sainnhe/everforest",
			config = function()
				vim.cmd "colorscheme everforest"
			end,
		}

		-- Startup screen
		--use {
		--  "goolord/alpha-nvim",
		--  config = function()
		--    require("config.alpha").setup()
		--  end,
		--}

		-- Better Netrw
		use { "tpope/vim-vinegar" }

		-- Git
		use {
			"TimUntersberger/neogit",
			cmd = "Neogit",
			config = function()
				require("config.neogit").setup()
			end,
		}

		-- WhichKey
		--    use {
		--      "folke/which-key.nvim",
		--      event = "VimEnter",
		--      config = function()
		--        require("config.whichkey").setup()
		--      end,
		--    }

		-- IndentLine
		use {
			"lukas-reineke/indent-blankline.nvim",
			event = "BufReadPre",
			config = function()
				require("config.indentblankline").setup()
			end,
		}

		-- Better icons
		use {
			"kyazdani42/nvim-web-devicons",
			module = "nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup { default = true }
			end,
		}

		-- Better Comment
		use {
			"numToStr/Comment.nvim",
			keys = { "gc", "gcc", "gbc" },
			config = function()
				require("Comment").setup {}
			end,
		}

		-- Better surround
		use { "tpope/vim-surround", event = "InsertEnter" }

		-- Motions
		use { "andymass/vim-matchup", event = "CursorMoved" }
		use { "wellle/targets.vim", event = "CursorMoved" }
		use { "unblevable/quick-scope", event = "CursorMoved", disable = false }
		use { "chaoren/vim-wordmotion", opt = true, fn = { "<Plug>WordMotion_w" } }

		use {
			"phaazon/hop.nvim",
			cmd = { "HopWord", "HopChar1" },
			config = function()
				require("hop").setup {}
			end,
			disable = true,
		}
		use {
			"ggandor/lightspeed.nvim",
			keys = { "s", "S", "f", "F", "t", "T" },
			config = function()
				require("lightspeed").setup {}
			end,
		}

		-- Markdown
		use {
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
			ft = "markdown",
			cmd = { "MarkdownPreview" },
		}

		-- Status line
		use {
			"nvim-lualine/lualine.nvim",
			after = "nvim-treesitter",
			config = function()
				require("config.lualine").setup()
			end,
			wants = "nvim-web-devicons",
		}
		use {
			"SmiteshP/nvim-gps",
			requires = "nvim-treesitter/nvim-treesitter",
			module = "nvim-gps",
			wants = "nvim-treesitter",
			config = function()
				require("nvim-gps").setup()
			end,
		}

		-- Treesitter
		use {
			"nvim-treesitter/nvim-treesitter",
			opt = true,
			event = "BufRead",
			run = ":TSUpdate",
			config = function()
				require("config.treesitter").setup()
			end,
			requires = {
				{ "nvim-treesitter/nvim-treesitter-textobjects" },
			},
		}

		-- FZF
		-- use { "junegunn/fzf", run = "./install --all", event = "VimEnter" } -- You don't need to install this if you already have fzf installed
		-- use { "junegunn/fzf.vim", event = "BufEnter" }

		-- FZF Lua
		--use {
		--  "ibhagwan/fzf-lua",
		--  event = "BufEnter",
		--  wants = "nvim-web-devicons",
		--}

		-- nvim-tree
		use {
			"kyazdani42/nvim-tree.lua",
			wants = "nvim-web-devicons",
			-- cmd = { "NvimTreeToggle", "NvimTreeClose" },
			config = function()
				require("config.nvimtree").setup()
			end,
		}

		-- Buffer line
		use {
			"akinsho/nvim-bufferline.lua",
			event = "BufReadPre",
			wants = "nvim-web-devicons",
			config = function()
				require("config.bufferline").setup()
			end,
		}


		-- Telescope used to fuzzy search files
		use {
			'nvim-telescope/telescope.nvim', branch = '0.1.x',
			requires = { { 'nvim-lua/plenary.nvim' } }
		}

		-- User interface
		use {
			"stevearc/dressing.nvim",
			event = "BufEnter",
			config = function()
				require("dressing").setup {
					select = {
						backend = { "telescope", "fzf", "builtin" },
					},
				}
			end,
			disable = true,
		}

		-- Completion
		use {
			"ms-jpq/coq_nvim",
			branch = "coq",
			event = "InsertEnter",
			opt = true,
			run = ":COQdeps",
			config = function()
				require("config.coq").setup()
			end,
			requires = {
				{ "ms-jpq/coq.artifacts",  branch = "artifacts" },
				{ "ms-jpq/coq.thirdparty", branch = "3p",       module = "coq_3p" },
			},
			disable = true,
		}

		-- lspkind
		use {
			'onsails/lspkind-nvim',
			event = 'BufEnter',
		}

		use {
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			opt = true,
			config = function()
				require("config.cmp").setup()
			end,
			wants = { "LuaSnip" },
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-calc",
				"hrsh7th/cmp-emoji",
				"hrsh7th/cmp-vsnip",
				"ray-x/cmp-treesitter",
				"saadparwaiz1/cmp_luasnip",
				"f3fora/cmp-spell",
				{
					"L3MON4D3/LuaSnip",
					wants = "friendly-snippets",
					config = function()
						require("config.luasnip").setup()
					end,
				},
				"rafamadriz/friendly-snippets",
				disable = false,
			},
		}

		-- Auto pairs
		use {
			"windwp/nvim-autopairs",
			wants = "nvim-treesitter",
			module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
			config = function()
				require("config.autopairs").setup()
			end,
		}

		-- Auto tag
		use {
			"windwp/nvim-ts-autotag",
			wants = "nvim-treesitter",
			event = "InsertEnter",
			config = function()
				require("nvim-ts-autotag").setup { enable = true }
			end,
		}

		-- End wise
		use {
			"RRethy/nvim-treesitter-endwise",
			wants = "nvim-treesitter",
			event = "InsertEnter",
			disable = false,
		}

		-- Mason
		use {
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		}
		use {
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup()
			end,
		}
		use {
			'neovim/nvim-lspconfig',
			config = function()
				require("config.lspconfig").setup()
			end,
		}

		-- DAP for debugging
		use { 'mfussenegger/nvim-dap' }

		-- DAP for javascript
		use { "mxsdev/nvim-dap-vscode-js" }

		use {
			"microsoft/vscode-js-debug",
			opt = true,
			run = "npm install --legacy-peer-deps && npm run compile",
		}

		-- UI for DAP
		use {
			"rcarriga/nvim-dap-ui",
			requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
			config = function()
				require("config.dapui").setup()
			end,
		}

		-- Dracula theme for styling
		use {
			'Mofiqul/dracula.nvim',
			config = function()
				vim.cmd [[colorscheme dracula]]
			end,
		}


		use {
			'jose-elias-alvarez/null-ls.nvim',
			--requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("config.null-ls").setup()
			end,
		}

		use {
			'MunifTanjim/prettier.nvim',
			config = function()
				require("config.prettierd").setup()
			end,
		}

		-- trouble.nvim
		use {
			"folke/trouble.nvim",
			event = "BufReadPre",
			wants = "nvim-web-devicons",
			cmd = { "TroubleToggle", "Trouble" },
			config = function()
				require("trouble").setup {
					use_diagnostic_signs = true,
				}
			end,
		}

		use {
			'glepnir/lspsaga.nvim',
			branch = "main",
			config = function()
				require('config.lspsaga').setup()
			end,
		}

		-- quickrun
		use {
			"thinca/vim-quickrun",
			requires = { { "lambdalisue/vim-quickrun-neovim-job" } },
			setup = function()
				vim.g.quickrun_config = {
					["_"] = {
						["runner"] = "neovim_job",
						["outputter/buffer/opener"] = "new",
						["outputter/buffer/close_on_empty"] = 1,
					},
					["docgen"] = {
						["command"] = "asciidoctor",
						["exec"] = "%c %s;xdg-open %S:r.html",
					},
					["docview"] = {
						["command"] = "xdg-open",
						["exec"] = "%c %s:r.html",
					},
					["rust"] = {
						["exec"] = "cargo run",
					},
				}

				vim.keymap.set("n", "<leader>r", "<Nop>")
				vim.keymap.set("n", "<leader>rr", ":QuickRun<CR>", { silent = true })
			end,
		}

		-- vim-sonictemplate
		use {
			"mattn/vim-sonictemplate",
			setup = function()
				vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.sonictemplate"
			end,
		}

		--  toggleterm
		use {
			"akinsho/toggleterm.nvim",
			config = function()
				require("toggleterm").setup({
					size = 20,
					open_mapping = [[<c-\>]],
				})
				--vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { silent = true })
			end,
		}
		use {
			"goolord/alpha-nvim",
			-- dependencies = { 'echasnovski/mini.icons' },
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function()
				--require('config.alpha-default').setup()
				require('config.alpha-mycustom').setup()
			end,
		}

		use {
			"github/copilot.vim",
		}
		use {
			"CopilotC-Nvim/CopilotChat.nvim",
			branch = "canary",
			dependencies = {
				{ "github/copilot.lua" }, -- or github/copilot.vim
				{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			},
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {
				debug = true, -- Enable debugging
				-- See Configuration section for rest
			},
			config = function()
				require("config/copilot-chat").setup()
			end,
		}

		use {
			'pwntester/octo.nvim',
			requires = {
				'nvim-lua/plenary.nvim',
				'nvim-telescope/telescope.nvim',
				-- OR 'ibhagwan/fzf-lua',
				'nvim-tree/nvim-web-devicons',
			},
			config = function()
				require "octo".setup()
			end
		}
                use {
                      "rachartier/tiny-inline-diagnostic.nvim",
                      -- event = "LspAttach", -- Or `LspAttach`
                      priority = 1000, -- needs to be loaded in first
                      config = function()
                          require('tiny-inline-diagnostic').setup()
                      end
                }


		-- use {
		-- 	"zbirenbaum/copilot.lua",
		-- 	cmd = "Copilot",
		-- 	config = function()
		-- 		require("copilot").setup({
		-- 					suggestion = { enabled = false },
		-- 					panel = { enabled = false },
		-- 		})
		-- 	end,
		-- }
		-- use {
		-- 	"zbirenbaum/copilot-cmp",
		-- 	after = { "copilot.lua"},
		-- 	config = function()
		-- 		require("copilot_cmp").setup()
		-- 	end
		-- }
		-- Bootstrap Neovim
		if packer_bootstrap then
			print "Restart Neovim required after installation!"
			require("packer").sync()
		end
	end

	-- Init and start packer
	packer_init()
	local packer = require "packer"
	packer.init(conf)
	packer.startup(plugins)
end

return M
