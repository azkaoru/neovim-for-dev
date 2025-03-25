  require('null-ls').setup({
    sources = {
      require("null-ls").builtins.formatting.shfmt, -- shell script formatting
      require("null-ls").builtins.diagnostics.shellcheck, -- shell script diagnostics
      require("null-ls").builtins.formatting.prettier,
      require("null-ls").builtins.diagnostics.ansiblelint, -- ansible diagnostics
      require("null-ls").builtins.diagnostics.yamllint, -- yaml diagnostics
      require("null-ls").builtins.formatting.yamlfmt, -- yaml formatting
      require("null-ls").builtins.diagnostics.textlint.with({ filetypes = { "markdown","asciidoc" } }),
    },
  })
