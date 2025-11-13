# AGENTS.md - Neovim Development Configuration

This document provides coding guidelines and commands for agentic coding assistants working in this Neovim configuration repository.

## Build/Lint/Test Commands

### General Commands
- **Install dependencies**: `source install.sh` - Sets up Neovim configuration and Java development environment
- **Health check**: `:checkhealth` - Verify plugin and LSP configurations
- **Update plugins**: Lazy sync (via `:Lazy sync`)

### Language-Specific Commands

#### Lua (Primary Language)
- **Lint**: `nvim-lint` with default Lua LSP diagnostics
- **Format**: None configured (use LSP formatting)
- **Test single file**: No specific test runner (manual verification)

#### Java
- **Build**: `mvn compile` or `gradle build` (project-specific)
- **Test**: `:JdtTestClass` or `:JdtTestMethod` (single test via DAP)
- **Run**: `:JdtRun` (main class) or `:JdtDebug` (with breakpoints)
- **Format**: Google Java Style (configured in JDTLS)
- **Lint**: JDTLS diagnostics + Spotless (if configured)

#### Python
- **Lint**: `flake8`, `ruff` (configured in nvim-lint)
- **Format**: None configured (use LSP formatting)
- **Test single**: `:DapPython` with test class/method (DAP debugging)
- **Run**: `:DapPython` with main file

#### Go
- **Build**: `go build`
- **Test**: `go test -run TestName` (single test)
- **Run/Debug**: `:DapContinue` with delve configured
- **Format**: `gofmt` (via LSP)
- **Lint**: `gopls` diagnostics

#### JavaScript/TypeScript
- **Build**: `npm run build` or `yarn build`
- **Test**: `npm test` or `yarn test` (single test via `--testNamePattern`)
- **Debug**: `:DapContinue` with vscode-js-debug
- **Format**: `prettierd` (configured in null-ls)
- **Lint**: `ts_ls` diagnostics

#### Shell Scripts
- **Format**: `shfmt` (configured in null-ls)
- **Lint**: `shellcheck` (configured in nvim-lint)
- **Snippets**: Custom here document snippets available (`heredoc`, `heredoc_file`, `heredoc_append`, etc.)

#### Ansible/YAML
- **Format**: `yamlfmt` (configured in null-ls)
- **Lint**: `ansible-lint`, `yamllint` (configured in null-ls)

## Code Style Guidelines

### General
- **Indentation**: 2 spaces (Lua), 4 spaces (Java), tabs/spaces per language convention
- **Line length**: No strict limit, break long lines for readability
- **Comments**: Use `--` for Lua single-line, `/* */` for multi-line in other languages
- **Error handling**: Check for nil values, use proper error propagation
- **Imports**: Use `require()` for Lua modules, organize imports logically

### Lua-Specific
- **Naming**: camelCase for variables/functions, PascalCase for modules
- **Functions**: Use `local function name()` syntax
- **Tables**: Use consistent formatting with proper indentation
- **Strings**: Prefer single quotes, double quotes for strings with singles
- **Booleans**: Use `true`/`false` explicitly
- **Nil checks**: Always check `if variable ~= nil` before using

### Configuration Structure
- **Modular**: Separate config files in `lua/config/` directory
- **LSP setup**: Use `vim.lsp.config()` and `vim.lsp.enable()` pattern
- **Key mappings**: Use `vim.keymap.set()` with descriptive opts
- **Plugin setup**: Follow lazy.nvim patterns with proper dependencies
- **Error handling**: Use `pcall()` for potentially failing operations

### Java-Specific
- **Style**: Google Java Style (configured in JDTLS)
- **Imports**: Organize with JDTLS (`:JdtOrganizeImports`)
- **Code generation**: Use JDTLS extract methods/variables
- **Testing**: JUnit 5 with `@Test` annotations

### Best Practices
- **Documentation**: Add comments for complex logic, especially in Japanese for domain-specific code
- **Consistency**: Follow existing patterns in the codebase
- **Testing**: Verify configurations work before committing
- **Performance**: Be mindful of startup time, use lazy loading appropriately
- **Security**: Avoid hardcoded paths, use environment variables when possible

### File Organization
- `init.lua`: Main configuration entry point
- `lua/config/`: Plugin and LSP configurations
- `lua/lsp/`: Language server specific settings
- `ftplugin/`: Filetype-specific configurations
- `install.sh`: Setup script for development environment