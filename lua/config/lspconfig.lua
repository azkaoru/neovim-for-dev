local function find_root(markers)
  local cwd = vim.fn.getcwd()
  local root = vim.fs.dirname(vim.fs.find(markers, { upward = true, path = cwd })[1])
  return root or cwd
end

-- nvim-cmpのcapabilitiesを取得するため、または全体設定を容易にするためにlspconfigをロードします。
-- local lspconfig = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
--local util = lspconfig.util -- lspconfigをロードすれば util はその中にあります。

-- 共通の capabilities を定義
-- capabilitiesはLSPクライアント（Neovim）がサポートする機能を示します。
-- cmp_nvim_lspを使うことで、補完機能に必要な設定が自動的に追加されます。
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- on_attach 関数を定義
-- on_attach は LSP がバッファにアタッチされたときに一度だけ実行される関数で、
-- ここで LSP 固有のキーマッピングなどを設定します。
-- 便宜上、ここではダミー関数を使用していますが、実際は適切な内容に置き換えてください。
local on_attach = function(client, bufnr)
    -- 例: キーマッピングを設定
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    
    -- LSP クライアント共通の処理（診断、フォーマット、キーマップなど）を記述
end

-- =============================================================================
-- 1. LSP サーバーごとの設定定義と有効化
-- =============================================================================

-- ****************************
-- gopls (Go)
-- ****************************
vim.lsp.config('gopls', {
    cmd = { "gopls", "serve" },
    filetypes = { "go", "gomod" },
    root_dir = find_root({"go.work", "go.mod", ".git"}),
    -- 共通の on_attach と capabilities を設定
    --on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})
vim.lsp.enable('gopls')

-- ****************************
-- ts_ls (TypeScript/JavaScript)
-- ****************************
vim.lsp.config('ts_ls', {
    --on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('ts_ls')

-- ****************************
-- lua_ls (Lua)
-- ****************************
vim.lsp.config('lua_ls', {
    --on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('lua_ls')

-- ****************************
-- bashls (Bash)
-- ****************************
vim.lsp.config('bashls', {
    --on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable('bashls')


-- ****************************
-- ansiblels (Ansible/YAML)
-- ****************************
vim.lsp.config('ansiblels', {
    filetypes = { "yaml" },
    --on_attach = on_attach,
    capabilities = capabilities,
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
})
vim.lsp.enable('ansiblels')

-- ****************************
-- markdown_oxide (Markdown)
-- ****************************
-- capabilitiesはローカルでカスタマイズしています
local markdown_caps = vim.tbl_deep_extend(
    'force',
    capabilities,
    {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    }
)

vim.lsp.config('markdown_oxide', {
    --on_attach = on_attach,
    capabilities = markdown_caps,
})
vim.lsp.enable('markdown_oxide')


-- local home = vim.loop.os_homedir()
-- lspconfig.pyright.setup {
--     capabilities = capabilities,
--     filetypes = { "python" },
--     -- root_dir = util.root_pattern(".venv"),
--     root_dir =find_root({"pyrightconfig.json", "setup.py", "pyproject.toml", ".git"}),
--
--     -- cmd = { "bash", "-c", "source ~/.virtualenvs/pyright/bin/activate && ~/.virtualenvs/pyright/bin/pyright-langserver --stdio" },
--     --cmd = { "pyright-langserver --stdio" },
--     -- cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
--     --cmd = { "bash", "-c", "source ~/.virtualenvs/pyright/bin/activate && ~/.virtualenvs/pyright/bin/pyright-langserver --stdio" },
-- 		 cmd = { "/home/hanzo/.virtualenvs/pyright/bin/pyright-langserver", "--stdio" },
--     settings = {
--       python = {
--         pythonPath = '.venv/bin/python', -- Windowsなら .venv/Scripts/python.exe
--         --pythonPath = '/usr/bin/python', -- Windowsなら .venv/Scripts/python.exe
--       },
--   },
-- }
--

-- local lspconfig = require "lspconfig"
-- local util = lspconfig.util -- lspconfigをロードすれば util はその中にあります。
-- lspconfig.pyright.setup {
--     capabilities = capabilities,
--     filetypes = { "python" },
--     -- root_dir = util.root_pattern(".venv"),
--     root_dir = util.root_pattern("pyrightconfig.json", "setup.py", "pyproject.toml", ".git"),
--
--     -- cmd = { "bash", "-c", "source ~/.virtualenvs/pyright/bin/activate && ~/.virtualenvs/pyright/bin/pyright-langserver --stdio" },
--     --cmd = { "pyright-langserver --stdio" },
--     -- cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
--     --cmd = { "bash", "-c", "source ~/.virtualenvs/pyright/bin/activate && ~/.virtualenvs/pyright/bin/pyright-langserver --stdio" },
-- 		 cmd = { "/home/hanzo/.virtualenvs/pyright/bin/pyright-langserver", "--stdio" },
--     settings = {
--       python = {
--         --pythonPath = '.venv/bin/python', -- Windowsなら .venv/Scripts/python.exe
--         pythonPath = '/usr/bin/python', -- Windowsなら .venv/Scripts/python.exe
--       },
--   },
-- }



-- Function to get Python path from venv or system
local function get_python_path()
  local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
  
  -- Check if venv-selector has set VIRTUAL_ENV
  local venv = os.getenv("VIRTUAL_ENV")
  if venv then
    local python_path
    if is_windows then
      python_path = vim.fs.joinpath(venv, "Scripts", "python.exe")
    else
      python_path = vim.fs.joinpath(venv, "bin", "python")
    end
    if vim.fn.executable(python_path) == 1 then
      return python_path
    end
  end
  
  -- Check for .venv in current directory
  local cwd = vim.fn.getcwd()
  
  if is_windows then
    local venv_path = vim.fs.joinpath(cwd, ".venv", "Scripts", "python.exe")
    if vim.fn.executable(venv_path) == 1 then
      return venv_path
    end
    local venv_alt = vim.fs.joinpath(cwd, "venv", "Scripts", "python.exe")
    if vim.fn.executable(venv_alt) == 1 then
      return venv_alt
    end
  else
    local venv_path = vim.fs.joinpath(cwd, ".venv", "bin", "python")
    if vim.fn.executable(venv_path) == 1 then
      return venv_path
    end
    local venv_alt = vim.fs.joinpath(cwd, "venv", "bin", "python")
    if vim.fn.executable(venv_alt) == 1 then
      return venv_alt
    end
  end
  
  -- Default to system python
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

-- Shared Pyright analysis settings
local pyright_analysis_settings = {
  typeCheckingMode = "basic",
  autoSearchPaths = true,
  useLibraryCodeForTypes = true,
}

vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
  settings = {
    python = {
      pythonPath = get_python_path(),
      analysis = pyright_analysis_settings,
    },
  },
}
vim.lsp.enable('pyright')

-- Autocmd to update Pyright settings when venv changes
vim.api.nvim_create_autocmd("User", {
  pattern = "VenvSelectPost",
  callback = function()
    -- Get the new Python path
    local python_path = get_python_path()
    
    -- Update settings for all Pyright clients
    for _, client in ipairs(vim.lsp.get_clients({ name = 'pyright' })) do
      -- Create new settings object preserving all existing settings
      local new_settings = vim.tbl_deep_extend("force", client.config.settings, {
        python = {
          pythonPath = python_path,
          analysis = pyright_analysis_settings,
        }
      })
      client.config.settings = new_settings
      client.notify("workspace/didChangeConfiguration", { settings = new_settings })
    end
    
    -- Notify user
    vim.notify("Pyright updated to use: " .. python_path, vim.log.levels.INFO)
  end,
})

-- ****************************
-- pyright (Python)
-- ****************************
-- local home = vim.loop.os_homedir()
-- vim.lsp.config('pyright', {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { "python" },
--     root_dir = find_root({"pyrightconfig.json", "setup.py", "pyproject.toml", ".git"}),
--     -- cmdをカスタマイズして仮想環境をアクティブ化しています
--     -- cmd = { "bash", "-c", "source ~/.virtualenvs/pyright/bin/activate && ~/.virtualenvs/pyright/bin/pyright-langserver --stdio" },
--     cmd = {  "/home/hazno/.virtualenvs/pyright/bin/pyright-langserver", "--stdio" },
--     --cmd = { "pyright-langserver --stdio" },
--     settings = {
--         python = {
--             pythonPath = '.venv/bin/python',
--         },
--     },
-- })
-- vim.lsp.enable('pyright')

-- ==========================================
-- pyright (Python)
-- ==========================================
-- local home = vim.loop.os_homedir()  -- ユーザディレクトリ取得
--
-- vim.lsp.config('pyright', {
--     cmd = { home .. '/.virtualenvs/pyright/bin/pyright-langserver', '--stdio' },
--     filetypes = { 'python' },
--     root_dir = find_root({ 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' }),
--     on_attach = on_attach,       -- 共通 on_attach を利用
--     capabilities = capabilities, -- 共通 capabilities を利用
--     settings = {
--         python = {
--             analysis = {
--                 typeCheckingMode = 'basic',    -- strict, off, basic から選択
--                 autoSearchPaths = true,
--                 useLibraryCodeForTypes = true,
--             },
--         },
--     },
-- })
--
-- vim.lsp.enable('pyright')

