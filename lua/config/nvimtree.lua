
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
  renderer = {
    highlight_opened_files = "name",
  },
    view = { 
      adaptive_size = true,
    },
  })

-- vim.cmd([[
--   highlight NvimTreeOpenedFile guifg=#bd93f9 gui=bold
-- ]])
--
-- local api = require("nvim-tree.api")
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     if vim.bo.filetype ~= "NvimTree" then
--       api.tree.find_file(vim.api.nvim_buf_get_name(0))
--     end
--   end,
-- })
local api = require("nvim-tree.api")

-- 現在アクティブなファイルを記録
local prev_bufname = nil

-- 色設定
local active_color = "#bd93f9" -- アクティブなファイルの色（淡い紫）
local inactive_color = "#ffffff" -- 非アクティブ（白）

-- nvim-treeのハイライトを更新
local function set_file_color(filepath, color)
  -- nvim-tree内部で指定ファイルの色を変更するAPIは直接ないため、
  -- renderer.highlight_opened_files機能を利用して再描画で反映
  -- → highlight_opened_files = "name" にしておく必要あり
  if vim.fn.filereadable(filepath) == 1 then
    api.tree.reload() -- ファイルの状態を再読込
  end
end

-- buffer切り替え時に呼ばれる
local function on_buf_enter()
  local current = vim.api.nvim_buf_get_name(0)
  if current == "" or vim.bo.filetype == "NvimTree" then
    return
  end

  -- 前のファイルを白に戻す
  if prev_bufname and prev_bufname ~= current then
    set_file_color(prev_bufname, inactive_color)
  end

  -- 新しいファイルを紫に
  set_file_color(current, active_color)

  -- nvim-tree上で選択
  api.tree.find_file(current)

  prev_bufname = current
end

-- イベント登録
vim.api.nvim_create_autocmd("BufEnter", {
  callback = on_buf_enter,
})


-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
