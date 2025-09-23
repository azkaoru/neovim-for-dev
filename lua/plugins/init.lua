local function is_fedora()
	local f = io.open("/etc/os-release", "r")
	if not f then return false end
	local content = f:read("*a")
	f:close()
	return content:match("Fedora") ~= nil
end

local vscode_js_debug_build_cmd = "npm install --legacy-peer-deps && npm run compile"

if is_fedora() then
	vscode_js_debug_build_cmd = false -- Fedora の場合は build をスキップ
end

return {
	-- Load only when require
	{ "nvim-lua/plenary.nvim" },

	-- Colorscheme
	-- {
	-- 	"sainnhe/everforest",
	-- 	config = function()
	-- 		vim.cmd "colorscheme everforest"
	-- 	end,
	-- },

	-- Startup screen
	--{
	--  "goolord/alpha-nvim",
	--  config = function()
	--    require("config.alpha").setup()
	--  end,
	--},

	-- Better Netrw
	{ "tpope/vim-vinegar" },

	-- Git
	{
		"TimUntersberger/neogit",
		cmd = "Neogit",
		config = function()
			require("config/neogit")
		end,
	},

	-- WhichKey
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		-- event = "VimEnter",
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'echasnovski/mini.icons',
		},

		keys = {
			{
				"<leader>vK",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		dependencies = {
			'echasnovski/mini.icons',
		}
		-- config = function()
		--                require("which-key").setup()
		-- 	require("config/whichkey")
		-- end,
	},

	-- IndentLine
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		config = function()
			require("config.indentblankline")
		end,
	},

	-- Better icons


	-- Better Comment
	{
		"numToStr/Comment.nvim",
		-- keys = { "gc", "gcc", "gbc" },
		config = function()
			require("Comment").setup {}
		end,
	},
	-- Better surround
	{ "tpope/vim-surround",     event = "InsertEnter" },

	-- Motions
	{ "andymass/vim-matchup",   event = "CursorMoved" },
	{ "wellle/targets.vim",     event = "CursorMoved" },
	{ "unblevable/quick-scope", event = "CursorMoved", disable = false },
	{ "chaoren/vim-wordmotion", lazy = true,           fn = { "<Plug>WordMotion_w" } },

	{
		"phaazon/hop.nvim",
		cmd = { "HopWord", "HopChar1" },
		config = function()
			require("hop").setup {}
		end,
		enabled = false,
	},
	{
		"ggandor/lightspeed.nvim",
		-- keys = { "s", "S", "f", "F", "t", "T" },
		config = function()
			require("lightspeed").setup {}
		end,
	},

	-- Markdown
	--{
	--	"iamcco/markdown-preview.nvim",
	--	build = function()
	--		vim.fn["mkdp#util#install"]()
	--	end,
	--	ft = "markdown",
	--	cmd = { "MarkdownPreview" },
	--},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config       = function()
			require("config.lualine")
		end,
	},
	{
		"SmiteshP/nvim-gps",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-gps").setup()
		end,
	},
	{
		'stevearc/oil.nvim',
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		config = function()
			require('oil').setup()
		end,
		-- Optional dependencies
		--dependencies = { { "echasnovski/mini.icons", opts = {} } },
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	},


	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		event = "BufRead",
		build = ":TSUpdate",
		config = function()
			require("config.treesitter")
		end,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
		},
	},

	-- FZF
	-- { "junegunn/fzf", build = "./install --all", event = "VimEnter" } -- You don't need to install this if you already have fzf installed
	-- { "junegunn/fzf.vim", event = "BufEnter" },

	-- FZF Lua
	--{
	--  "ibhagwan/fzf-lua",
	--  event = "BufEnter",
	--  dependencies = {"nvim-web-devicons",
	--},

	-- nvim-tree
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- cmd = { "NvimTreeToggle", "NvimTreeClose" },
		config = function()
			require("config.nvimtree")
		end,
	},

	-- Buffer line
	-- {
	-- 	"akinsho/nvim-bufferline.lua",
	-- 	event = "BufReadPre",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = function()
	-- 		require("config.bufferline")
	-- 	end,
	-- },


	-- Telescope used to fuzzy search files
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	-- User interface
	{
		"stevearc/dressing.nvim",
		event = "BufEnter",
		config = function()
			require("dressing").setup {
				select = {
					backend = { "telescope", "fzf", "builtin" },
				},
			}
		end,
		enabled = false,
	},

	-- Completion
	{
		"ms-jpq/coq_nvim",
		branch = "coq",
		event = "InsertEnter",
		lazy = true,
		build = ":COQdeps",
		config = function()
			require("config.coq")
		end,
		dependencies = {
			{ "ms-jpq/coq.artifacts",  branch = "artifacts" },
			{ "ms-jpq/coq.thirdparty", branch = "3p" },
		},
		enabled = false,
	},


	-- lspkind
	{
		'onsails/lspkind.nvim',
	},

	{
		'hrsh7th/cmp-nvim-lsp',
	},


	{
		"hrsh7th/nvim-cmp",
		-- event = "InsertEnter",
		event = { "InsertEnter", "CmdlineEnter" },
		lazy = true,
		config = function()
			require("config.cmp")
			require("config.luasnip")
		end,
		dependencies = {
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
			'L3MON4D3/LuaSnip',
			'rafamadriz/friendly-snippets'
		},
	},

	-- { "hrsh7th/vim-vsnip",},
	-- {
	-- 	'L3MON4D3/LuaSnip',
	-- 	build = 'make install_jsregexp',
	-- 	dependencies = {
	-- 		'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets',
	-- 	},
	-- 	config = function()
	-- 		require("config.luasnip")
	-- 	end,
	-- },

	-- Auto pairs
	{
		"windwp/nvim-autopairs",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		-- module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
		config = function()
			require("config.autopairs")
		end,
	},

	-- Auto tag
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup { enable = true }
		end,
	},

	-- End wise
	{
		"RRethy/nvim-treesitter-endwise",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "InsertEnter",
		disable = false,
	},

	-- Mason
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup()
		end,
	},

	{
		'neovim/nvim-lspconfig',
		config = function()
			require("config.lspconfig")
		end,

	},

	-- DAP for debugging
	{ 'mfussenegger/nvim-dap' },

	-- DAP for javascript
	{ "mxsdev/nvim-dap-vscode-js" },

	{
		"microsoft/vscode-js-debug",
		lazy = true,
		-- build = "npm install --legacy-peer-deps && npm run compile",
		-- build = false,
		build = vscode_js_debug_build_cmd,

	},

	-- UI for DAP
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("config.dapui")
		end,
	},

	-- Dracula theme for styling
	{
		'Mofiqul/dracula.nvim',
		config = function()
			vim.cmd [[colorscheme dracula-soft]]
		end,
	},


	{
		--'jose-elias-alvarez/null-ls.nvim',
		'nvimtools/none-ls.nvim',
		--dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.null-ls")
		end,
	},

	{
		'MunifTanjim/prettier.nvim',
		config = function()
			require("config.prettierd")
		end,
	},

	-- trouble.nvim
	{
		"folke/trouble.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble" },
		config = function()
			require("trouble").setup {
				use_diagnostic_signs = true,
			}
		end,
	},

	{
		'glepnir/lspsaga.nvim',
		branch = "main",
		config = function()
			require('config.lspsaga')
		end,
	},

	-- quickbuild
	--{
	--		"thinca/vim-quickbuild",
	-- dependencies =  { "lambdalisue/vim-quickbuild-neovim-job" } ,
	--		setup = function()
	--			vim.g.quickbuild_config = {
	--				    ["_"] = {
	--					    ["buildner"] = "neovim_job",
	--					    ["outputter/buffer/opener"] = "new",
	--					    ["outputter/buffer/close_on_empty"] = 1,
	--				    },
	--				    ["docgen"] = {
	--					    ["command"] = "asciidoctor",
	--					    ["exec"] = "%c %s;xdg-open %S:r.html",
	--				    },
	--				    ["docview"] = {
	--					    ["command"] = "xdg-open",
	--					    ["exec"] = "%c %s:r.html",
	--				    },
	--				    ["rust"] = {
	--					    ["exec"] = "cargo build",
	--				    },
	--			    },
	--
	--			 vim.keymap.set("n", "<leader>r", "<Nop>")
	--			vim.keymap.set("n", "<leader>rr", ":QuickRun<CR>", { silent = true })
	--		end,
	--	},

	-- vim-sonictemplate
	{
		"mattn/vim-sonictemplate",
		-- setup = function()
		config = function()
			vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.sonictemplate"
		end,
	},

	--  toggleterm
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("config/toggleterm")
		end,
	},
	{
		"goolord/alpha-nvim",
		-- dependencies = { 'echasnovski/mini.icons' },
		dependencies = { 'nvim-tree/nvim-web-devicons'
		},
		config = function()
			-- require('config.alpha-mycustom')
			require('config.alpha-hanzo')
			-- require'alpha'.setup(require'alpha.themes.startify'.config)
		end,
	},

	{
		'pwntester/octo.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			-- OR 'ibhagwan/fzf-lua',
			'nvim-tree/nvim-web-devicons',
		},
		config = function()
			require "octo".setup()
		end
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		-- event = "LspAttach", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require('tiny-inline-diagnostic').setup()
		end
	},


	{
		"github/copilot.vim",
		-- config       = function()
		-- 	require("copilot").setup()
		-- end
	},
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	config = function()
	-- 		require("copilot").setup({
	-- 			filetypes = {
	-- 				["*"] = true, -- 全てのファイルタイプで補完を有効化
	-- 				-- 必要に応じて特定のファイルタイプを無効化
	-- 				-- yaml = false,
	-- 				-- markdown = false,
	-- 			},
	-- 			suggestion = { enabled = true },
	-- 			panel = { enabled = true },
	-- 			-- copilot_node_command = 'node'
	-- 		})
	-- 	end,
	-- },
	{
		"zbirenbaum/copilot-cmp",
		event        = "InsertEnter",
		--	dependencies = { "zbirenbaum/copilot.lua", "hrsh7th/nvim-cmp" },
		dependencies = { "github/copilot.vim", "hrsh7th/nvim-cmp" },
		config       = function()
			require("copilot_cmp").setup()
		end
	},


	-- {
	-- 	"github/copilot.vim",
	-- 	cmd = "Copilot",
	-- 	config = function()
	-- 		vim.g.copilot_no_tab_map = true
	--
	-- 		local keymap = vim.keymap.set
	-- 		-- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
	-- 		keymap(
	-- 			"i",
	-- 			"<CR>",
	-- 			'copilot#Accept("<CR>")',
	-- 			{ silent = true, expr = true, script = true, replace_keycodes = false },
	-- 		)
	-- 		keymap("i", "<C-j>", "<Plug>(copilot-next)")
	-- 		keymap("i", "<C-k>", "<Plug>(copilot-previous)")
	-- 		keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
	-- 		keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
	-- 	end,
	-- },
	--


	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			--{ "zbirenbaum/copilot.lua" },
			{ "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		lazy = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		config = function()
			require("config/copilot-chat")
		end,
	},



	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({
				chunk = {
					enable = true,
					style = "#81A1C1",
				},
				indent = {
					enable = true,
				},
				line_num = {
					enable = true,
					style = "#81A1C1",
				},
			})
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup()
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = { "nvim-web-devicons" },
		opts = {
			animation = false,
			sidebar_filetypes = {
				["no-neck-pain"] = {},
			},
		},
	},

	-- {
	-- 	"rainbowhxch/accelerated-jk.nvim",
	-- 	config = function()
	-- 		require("accelerated-jk").setup()
	-- 		vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)")
	-- 		vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)")
	-- 	end,
	-- },
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		-- dependencies = { "goolord/alpha-nvim" },
		config = function()
			require("no-neck-pain").setup({
				buffers = {
					right = {
						enabled = false,
					},
					left = {
						enabled = false,
					},
					-- scratchPad = {
					-- 	enabled = true,
					-- 	location = "~/notes",
					-- },
					-- bo = {
					-- 	filetype = "md",
					-- },
				},
				autocmds = {
					enableOnVimEnter = false,
					enableOnTabEnter = true,
					reloadOnColorSchemeChange = true,
				},
			})
			--vim.keymap.set("n", "<leader>z", "<cmd>NoNeckPain<CR>")
		end,
	},
	{
		'ethanholz/nvim-lastplace',
		config = function()
			require 'nvim-lastplace'.setup {}
		end,


	},


	{
		"bassamsdata/namu.nvim",
		event = { "BufRead" },
		config = function()
			require("namu").setup()
		end,
	},
	-- {
	-- 	"kkoomen/vim-doge",
	-- 	run = ":call doge#install()",
	-- 	config = function()
	-- 		-- 設定があればここに追加
	-- 		--vim.g.doge_enable_mappings = 1
	-- 		--vim.g.doge_mapping_comment_jump_forward = "<C-j>"
	-- 		--vim.g.doge_mapping_comment_jump_backward = "<C-k>"
	-- 	end,
	-- },
	{
		"tkmpypy/chowcho.nvim",
		config = function()
			require("config/chowcho")
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},

	},

	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
	-- 	opts = {
	-- 		-- add any opts here
	-- 		-- for example
	-- 		-- provider = "openai",
	-- 		provider = "copilot",
	-- 		openai = {
	-- 			endpoint = "https://api.openai.com/v1",
	-- 			model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
	-- 			timeout = 30000, -- timeout in milliseconds
	-- 			temperature = 0, -- adjust if needed
	-- 			max_tokens = 4096,
	-- 			-- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
	-- 		},
	-- 	},
	-- 	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- 	build = "make",
	-- 	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"stevearc/dressing.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		--- The below dependencies are optional,
	-- 		"echasnovski/mini.pick", -- for file_selector provider mini.pick
	-- 		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
	-- 		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
	-- 		"ibhagwan/fzf-lua", -- for file_selector provider fzf
	-- 		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
	-- 		"zbirenbaum/copilot.lua", -- for providers='copilot'
	-- 		{
	-- 			-- support for image pasting
	-- 			"HakonHarnes/img-clip.nvim",
	-- 			event = "VeryLazy",
	-- 			opts = {
	-- 				-- recommended settings
	-- 				default = {
	-- 					embed_image_as_base64 = false,
	-- 					prompt_for_file_name = false,
	-- 					drag_and_drop = {
	-- 						insert_mode = true,
	-- 					},
	-- 					-- required for Windows users
	-- 					use_absolute_path = true,
	-- 				},
	-- 			},
	-- 		},
	-- 		{
	-- 			-- Make sure to set this up properly if you have lazy=true
	-- 			'MeanderingProgrammer/render-markdown.nvim',
	-- 			opts = {
	-- 				file_types = { "markdown", "Avante" },
	-- 			},
	-- 			ft = { "markdown", "Avante" },
	-- 		},
	-- 	},
	-- },

	{ 'mfussenegger/nvim-jdtls' },

	{
		"rainbowhxch/accelerated-jk.nvim",
		config = function()
			require("accelerated-jk").setup()
		end,
	},
	{
		'gen740/SmoothCursor.nvim',
		config = function()
			require('smoothcursor').setup({
				fancy = {
					enable = true, }
			})
		end
	},
	{
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup()
		end
	},
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
		end
	},
	{ 'echasnovski/mini.ai',    version = '*' },
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},

}
