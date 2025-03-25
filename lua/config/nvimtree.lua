
local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end

  -- disable netrw at the very start of your init.lua (strongly advised)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- set termguicolors to enable highlight groups
  vim.opt.termguicolors = true

  -- empty setup using defaults
  require("nvim-tree").setup({
    view = { 
      adaptive_size = true,
    },
  })

-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
