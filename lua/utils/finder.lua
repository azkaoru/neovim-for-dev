local M = {}

-- Find a file either using git files or search the filesystem.
function M.find_files()
  local fzf = require "fzf-lua"
  -- git 管理下かどうかは終了コードで判定する（system() の戻り値は文字列なので
  -- `== true` 比較は常に偽になっていた。OS 非依存のバグ修正）。
  vim.fn.system({ "git", "rev-parse", "--is-inside-work-tree" })
  if vim.v.shell_error == 0 then
    fzf.git_files()
  else
    fzf.files()
  end
end

-- Custom find buffers function.
function M.find_buffers()
  local results = {}
  local buffers = vim.api.nvim_list_bufs()

  for _, buffer in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local filename = vim.api.nvim_buf_get_name(buffer)
      table.insert(results, filename)
    end
  end

  vim.ui.select(results, { prompt = "Find buffer:" }, function(selected)
    if selected then
      vim.api.nvim_command("buffer " .. selected)
    end
  end)
end

return M
