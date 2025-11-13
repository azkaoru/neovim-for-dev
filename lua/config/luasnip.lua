  local luasnip = require "luasnip"
  local s = luasnip.snippet
  local t = luasnip.text_node
  local i = luasnip.insert_node

  luasnip.config.set_config {
    history = false,
    updateevents = "TextChanged,TextChangedI",
  }

  -- Load VSCode snippets from friendly-snippets
  require("luasnip/loaders/from_vscode").lazy_load()

  -- Add custom snippets directly
  luasnip.add_snippets("sh", {
    s("heredoc", {
      t("cat << 'EOF'"),
      t({"", ""}),
      i(1, "content here"),
      t({"", "EOF"}),
    }),
    s("heredoc_file", {
      t("cat << 'EOF' > "),
      i(1, "filename"),
      t({"", ""}),
      i(2, "content here"),
      t({"", "EOF"}),
    }),
    s("heredoc_append", {
      t("cat << 'EOF' >> "),
      i(1, "filename"),
      t({"", ""}),
      i(2, "content here"),
      t({"", "EOF"}),
    }),
  })
