-- プラットフォーム抽象化モジュール
--
-- OS 依存（パス区切り・ホーム・Python 実行ファイル名・JDK 配置等）を一箇所に集約する。
-- 各設定ファイルからは `local platform = require("utils.platform")` で利用する。
-- Linux/macOS では従来どおりの値を返し、Windows ではネイティブ Windows 向けの値を返す。

local M = {}

local uv = vim.uv or vim.loop

M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
M.is_mac = vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1
M.is_linux = (not M.is_windows) and (not M.is_mac)

-- ホームディレクトリ。Windows は HOME 未設定が普通なので os_homedir を使う。
function M.home()
  return uv.os_homedir() or vim.fn.expand("~")
end

-- Neovim のデータディレクトリ (Linux: ~/.local/share/nvim, Windows: %LOCALAPPDATA%\nvim-data)
function M.data_dir()
  return vim.fn.stdpath("data")
end

-- キャッシュディレクトリ (一時ファイル用途。Linux の /tmp 代替)
function M.cache_dir()
  return vim.fn.stdpath("cache")
end

-- パス連結。vim.fs.joinpath のラッパ（OS の区切り文字を吸収）。
function M.join(...)
  return vim.fs.joinpath(...)
end

-- java 開発用ワークディレクトリ。
-- Linux/macOS は既存 install.sh と同じ ~/.local/share/java-dev を維持（回帰防止）。
-- Windows は %LOCALAPPDATA%\java-dev（install.ps1 が同じ場所を作成する）。
function M.java_dev_dir()
  if M.is_windows then
    local base = os.getenv("LOCALAPPDATA") or M.join(M.home(), "AppData", "Local")
    return M.join(base, "java-dev")
  end
  return M.join(M.home(), ".local", "share", "java-dev")
end

-- venv の Python 実行ファイルパスを返す（Windows: Scripts\python.exe, 他: bin/python）。
-- root を省略すると実行ファイル名のみを判定に使う。
function M.python_exe(root)
  if root and root ~= "" then
    if M.is_windows then
      return M.join(root, "Scripts", "python.exe")
    end
    return M.join(root, "bin", "python")
  end
  return M.is_windows and "python" or "python3"
end

-- venv / カレント / システムの順に Python 実行ファイルを解決する。
-- (lua/config/lspconfig.lua の get_python_path を共通化したもの)
function M.resolve_python()
  local venv = os.getenv("VIRTUAL_ENV")
  if venv then
    local p = M.python_exe(venv)
    if vim.fn.executable(p) == 1 then
      return p
    end
  end

  local cwd = vim.fn.getcwd()
  for _, name in ipairs({ ".venv", "venv" }) do
    local p = M.python_exe(M.join(cwd, name))
    if vim.fn.executable(p) == 1 then
      return p
    end
  end

  -- システムの python
  local sys = vim.fn.exepath("python3")
  if sys == nil or sys == "" then
    sys = vim.fn.exepath("python")
  end
  return (sys ~= nil and sys ~= "") and sys or "python"
end

-- 実行ファイル名の解決。PATH 上に見つからなければ name をそのまま返す。
function M.exe(name)
  local found = vim.fn.exepath(name)
  if found ~= nil and found ~= "" then
    return found
  end
  return name
end

return M
