local M = {}

local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end

function M.setup()
  -- disable netrw at the very start of your init.lua (strongly advised)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- set termguicolors to enable highlight groups
  vim.opt.termguicolors = true

  -- empty setup using defaults
  require("nvim-tree").setup({
    -- deprecated 
    -- open_on_setup = true,
    -- ignore_buffer_on_setup = true,
  })

  vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
end

return M
