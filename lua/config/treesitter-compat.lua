-- Neovim 0.12 互換パッチ for nvim-treesitter (master ブランチ)
--
-- nvim-treesitter の master ブランチは Neovim 0.10/0.11 のみ対応で 0.12 非対応。
-- (リポジトリは 2026-04-03 にアーカイブ済みで修正は入らない)
-- Neovim 0.12 ではクエリの predicate/directive ハンドラに渡る capture が
-- 「単一ノード」ではなく「ノードのリスト (TSNode[])」になった
-- (runtime/lua/vim/treesitter/query.lua の `captures: table<integer, TSNode[]>`)。
-- master の query_predicates.lua は `local node = match[id]` と単一ノードを前提に
-- しているため、リスト(テーブル)に対して node:range() を呼んで
--   E5108: attempt to call method 'range' (a nil value)
-- でクラッシュする。markdown のコードフェンス言語判定
-- (set-lang-from-info-string!) を vim-matchup が CursorMoved で発火させて顕在化していた。
--
-- ここでは壊れている predicate/directive を force=true で上書き再登録し、
-- capture がリストでも単一ノードでも動くよう正規化する。
-- 参考: nvim-treesitter#8636, nvim-treesitter#8618, neovim#39032

local query = require "vim.treesitter.query"

-- 元実装(query_predicates.lua)が先に登録されているように保証する
pcall(require, "nvim-treesitter.query_predicates")

-- capture を単一ノードに正規化する。
-- 0.12: match[id] は {TSNode, ...} (テーブル)。0.10/0.11: TSNode (userdata)。
local function pick(value)
  if type(value) == "table" then
    return value[#value]
  end
  return value
end

local opts = { force = true, all = false }

local function err(str)
  vim.api.nvim_err_writeln(str)
end

local function valid_args(name, pred, count, strict_count)
  local arg_count = #pred - 1
  if strict_count then
    if arg_count ~= count then
      err(string.format("%s must have exactly %d arguments", name, count))
      return false
    end
  elseif arg_count < count then
    err(string.format("%s must have at least %d arguments", name, count))
    return false
  end
  return true
end

-- nth?
query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
  if not valid_args("nth?", pred, 2, true) then
    return
  end
  local node = pick(match[pred[2]])
  local n = tonumber(pred[3])
  if node and node:parent() and node:parent():named_child_count() > n then
    return node:parent():named_child(n) == node
  end
  return false
end, opts)

-- is?
query.add_predicate("is?", function(match, _pattern, bufnr, pred)
  if not valid_args("is?", pred, 2) then
    return
  end
  local locals = require "nvim-treesitter.locals"
  local node = pick(match[pred[2]])
  local types = { unpack(pred, 3) }
  if not node then
    return true
  end
  local _, _, kind = locals.find_definition(node, bufnr)
  return vim.tbl_contains(types, kind)
end, opts)

-- kind-eq?
query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
  if not valid_args(pred[1], pred, 2) then
    return
  end
  local node = pick(match[pred[2]])
  local types = { unpack(pred, 3) }
  if not node then
    return true
  end
  return vim.tbl_contains(types, node:type())
end, opts)

-- set-lang-from-mimetype!
local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}
query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
  local node = pick(match[pred[2]])
  if not node then
    return
  end
  local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
  local configured = html_script_type_languages[type_attr_value]
  if configured then
    metadata["injection.language"] = configured
  else
    local parts = vim.split(type_attr_value, "/", {})
    metadata["injection.language"] = parts[#parts]
  end
end, opts)

-- set-lang-from-info-string!  (今回のクラッシュの直接原因)
local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  uxn = "uxntal",
  ts = "typescript",
}
local function get_parser_from_markdown_info_string(injection_alias)
  local m = vim.filetype.match { filename = "a." .. injection_alias }
  return m or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end
query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
  local node = pick(match[pred[2]])
  if not node then
    return
  end
  local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
  metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
end, opts)

-- downcase!
query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
  local id = pred[2]
  local node = pick(match[id])
  if not node then
    return
  end
  local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
  if not metadata[id] then
    metadata[id] = {}
  end
  metadata[id].text = string.lower(text)
end, opts)
