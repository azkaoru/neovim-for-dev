local function relative_filepath()
  local full_path = vim.fn.expand("%:p")  -- 現在のバッファのフルパス
  local cwd = vim.fn.getcwd()
  local rel_path = vim.fn.fnamemodify(full_path, ":.")  -- cwd 相対パス
  return rel_path
end

local navic = require "nvim-navic"
require("lualine").setup {
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				function()
					local filename = vim.fn.expand('%:t')
					if filename == '' then
						return '[No Name]'
					end
					return '📝 ' .. relative_filepath()
				end,
				on_click = function(_, _, _) -- ← クリックイベントを定義
					local path = vim.fn.expand('%:p')
					vim.fn.setreg('+', path)
					vim.notify('Copied: ' .. path, vim.log.levels.INFO)
				end,
			},
		},
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
}
