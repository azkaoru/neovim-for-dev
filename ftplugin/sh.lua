-- Shell filetype settings
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

-- Ensure filetype is set to sh for shell scripts
if vim.bo.filetype == '' then
  vim.bo.filetype = 'sh'
end