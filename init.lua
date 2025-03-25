local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)


vim.g.mapleader = ","
vim.g.maplocalleader = ","

local map = vim.api.nvim_set_keymap
-- map the key n to run the command :NvimTreeToggle
map('n', 'm', [[:NvimTreeToggle<CR>]], {})
--map('n', '<leader>tt', [[:NvimTreeToggle<CR>]], {})
map('n', '<leader>o', [[:Oil<CR>]], {})

vim.api.nvim_set_option('clipboard', 'unnamedplus')

vim.diagnostic.config({ virtual_text = false })

vim.cmd("filetype plugin on")

--vim.g.maplocalleader = "\\"

require("utils")
--require("plugins").setup()
require('lazy').setup('plugins')


require("debugging")

require("whichkey")
require("whichkey-jboss")
require("whichkey-ansible")

-- toggleterm setting
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')


-- 最初に一度だけ実行される処理
vim.api.nvim_create_autocmd("BufRead", {
-- vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		-- ここに実行したい処理を記述します
		--require("no-neck-pain").enable()
		require("zen-mode").toggle({
			window = {
				width = .40 -- width will be 85% of the editor width
		 	}
		})
                -- require("nvim-tree.api").tree.open()
	end,
})

