<#
.SYNOPSIS
  neovim-for-dev のネイティブ Windows 用インストーラ（install.sh の PowerShell 版）。

.DESCRIPTION
  Neovim の設定一式を %LOCALAPPDATA%\nvim に配置し、Java(jdtls)用の jar 群を展開する。
  既定ではシンボリックリンクで配置する（リポジトリ側を編集すると即反映される）。
  シンボリックリンク作成には「Windows の開発者モード」を有効化しておくこと（管理者権限が不要になる）。
  開発者モードを使わない/使えない場合は -Copy を付けてコピー配置にする。

.PARAMETER Copy
  シンボリックリンクではなくコピーで配置する。

.EXAMPLE
  # 開発者モード有効の環境（推奨）
  powershell -ExecutionPolicy Bypass -File .\install.ps1

.EXAMPLE
  # コピー配置
  powershell -ExecutionPolicy Bypass -File .\install.ps1 -Copy
#>
[CmdletBinding()]
param(
  [switch]$Copy
)

$ErrorActionPreference = "Stop"

# ---- パス定義（Neovim on Windows の既定。config=%LOCALAPPDATA%\nvim, data=%LOCALAPPDATA%\nvim-data）----
$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$LocalAppData = $env:LOCALAPPDATA
$NvimConfig  = Join-Path $LocalAppData "nvim"
$NvimData    = Join-Path $LocalAppData "nvim-data"
$JdtlsWork   = Join-Path $LocalAppData "java-dev"   # lua/utils/platform.lua の java_dev_dir() と一致させる

Write-Host "==> 設定配置先: $NvimConfig"
Write-Host "==> データ配置先: $NvimData"
Write-Host "==> Java 作業ディレクトリ: $JdtlsWork"

# ---- 既存設定の削除（data ディレクトリは保持してプラグインの再DLを避ける）----
if (Test-Path $NvimConfig) {
  Write-Host "==> 既存の $NvimConfig を削除します"
  Remove-Item -Recurse -Force $NvimConfig
}
New-Item -ItemType Directory -Force -Path $NvimConfig | Out-Null
New-Item -ItemType Directory -Force -Path $NvimData   | Out-Null

# ---- 開発者モード判定（シンボリックリンク配置時のみ必要）----
function Test-DeveloperMode {
  try {
    $key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    $val = (Get-ItemProperty -Path $key -Name AllowDevelopmentWithoutDevLicense -ErrorAction Stop).AllowDevelopmentWithoutDevLicense
    return ($val -eq 1)
  } catch {
    return $false
  }
}

$UseLink = -not $Copy
if ($UseLink -and -not (Test-DeveloperMode)) {
  Write-Warning "開発者モードが無効です。シンボリックリンクには開発者モード（または管理者権限）が必要です。"
  Write-Warning "コピー配置に切り替えます（再編集を反映するには再実行が必要）。-Copy で明示できます。"
  $UseLink = $false
}

# ---- リンク/コピー対象の選定（.git / *.md / *.sh / *.ps1 は除外。install.sh のループ相当）----
$excludeExact = @(".git")
Get-ChildItem -Force -Path $ScriptDir | ForEach-Object {
  $base = $_.Name
  if ($excludeExact -contains $base) { return }
  if ($base -like "*.md")  { return }
  if ($base -like "*.sh")  { return }
  if ($base -like "*.ps1") { return }

  $target = Join-Path $NvimConfig $base
  if ($UseLink) {
    New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName -Force | Out-Null
    Write-Host "Linked  $base -> $target"
  } else {
    Copy-Item -Recurse -Force -Path $_.FullName -Destination $target
    Write-Host "Copied  $base -> $target"
  }
}

# ---- PowerShell プロファイルに環境設定を追記（install.sh の ~/.bashrc_neovim_dev 相当）----
$profileSnippet = @'
# >>> neovim-for-dev >>>
$env:EDITOR = "nvim"
function nv { nvim @args }
# <<< neovim-for-dev <<<
'@
if (-not (Test-Path $PROFILE)) {
  New-Item -ItemType File -Force -Path $PROFILE | Out-Null
}
if (-not (Select-String -Path $PROFILE -SimpleMatch "neovim-for-dev" -Quiet)) {
  Add-Content -Path $PROFILE -Value $profileSnippet
  Write-Host "==> PowerShell プロファイルに nv エイリアスと EDITOR を追記しました: $PROFILE"
} else {
  Write-Host "==> PowerShell プロファイルは既に設定済みです"
}

# OBSIDIAN_VAULT_PATH（install.sh の分岐相当）
if ($env:OBSIDIAN_VAULT_PATH) {
  Write-Host "OBSIDIAN_VAULT_PATH=$($env:OBSIDIAN_VAULT_PATH) を利用します"
} else {
  Write-Host "OBSIDIAN_VAULT_PATH が未設定のため obsidian.nvim はインストールされません"
  Write-Host "  利用する場合は事前に環境変数を設定してください: setx OBSIDIAN_VAULT_PATH C:\path\to\vault"
}

# ---- sonictemplate ----
$sonicSrc = Join-Path $ScriptDir "sonictemplate"
if (Test-Path $sonicSrc) {
  $sonicDst = Join-Path $env:USERPROFILE ".sonictemplate"
  if (Test-Path $sonicDst) { Remove-Item -Recurse -Force $sonicDst }
  Copy-Item -Recurse -Force -Path $sonicSrc -Destination $sonicDst
  Write-Host "==> sonictemplate を $sonicDst に配置しました"
}

# ---- Java 開発用ディレクトリ作成 ----
$jdtlsDirs = @(
  (Join-Path $JdtlsWork "jdtls"),
  (Join-Path $JdtlsWork "eclipse"),
  (Join-Path $JdtlsWork "workspace"),
  (Join-Path $JdtlsWork "projects\java-debug\com.microsoft.java.debug.plugin\target"),
  (Join-Path $JdtlsWork "projects\vscode-java-test\server"),
  (Join-Path $JdtlsWork "projects\dg-jdt-ls-decompiler"),
  (Join-Path $JdtlsWork "projects\cli-decompiler\src"),
  (Join-Path $JdtlsWork "projects\cli-decompiler\dest")
)
foreach ($d in $jdtlsDirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

$Jars = Join-Path $ScriptDir "jars"
if (Test-Path $Jars) {
  # jdtls 本体（tar.gz は Win10 1803+ 同梱の bsdtar(tar.exe) で展開）
  $jdtlsTar = Join-Path $Jars "jdt-language-server-1.19.0-202301090450.tar.gz"
  if (Test-Path $jdtlsTar) {
    Write-Host "==> jdtls を展開します"
    tar -xzf $jdtlsTar -C (Join-Path $JdtlsWork "jdtls")
  }
  # java-debug
  Copy-Item -Force -Path (Join-Path $Jars "java-debug\com.microsoft.java.debug.plugin-0.44.0.jar") `
    -Destination (Join-Path $JdtlsWork "projects\java-debug\com.microsoft.java.debug.plugin\target")
  # java-test
  Copy-Item -Force -Path (Join-Path $Jars "vscode-java-test\*.jar") `
    -Destination (Join-Path $JdtlsWork "projects\vscode-java-test\server")
  # decompiler
  Copy-Item -Force -Path (Join-Path $Jars "dg-jdt-ls-decompiler\*.jar") `
    -Destination (Join-Path $JdtlsWork "projects\dg-jdt-ls-decompiler")
  # lombok / code style / formatter
  Copy-Item -Force -Path (Join-Path $Jars "lombok.jar")                       -Destination (Join-Path $JdtlsWork "eclipse")
  Copy-Item -Force -Path (Join-Path $Jars "eclipse-java-google-style.xml")    -Destination (Join-Path $JdtlsWork "eclipse")
  Copy-Item -Force -Path (Join-Path $Jars "google-java-format-1.16.0.jar")    -Destination (Join-Path $JdtlsWork "eclipse")
  # cli decompiler
  Copy-Item -Force -Path (Join-Path $Jars "vineflower-1.10.1.jar")            -Destination (Join-Path $JdtlsWork "projects\cli-decompiler")
  Write-Host "==> Java 関連 jar を配置しました"
}

Write-Host ""
Write-Host "インストール完了。新しい PowerShell を開いて 'nv' で Neovim を起動できます。"
Write-Host "初回起動時に lazy.nvim がプラグインを取得します。続けて :TSUpdate（要 C コンパイラ）を実行してください。"
Write-Host "前提ツール（JDK17/Node/Python/ripgrep 等）は README の Windows セクションを参照してください。"
