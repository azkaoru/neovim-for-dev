function gen_doc()
  local input = vim.fn.expand("%")
  local timestamp = os.time()
  local html_out = "/tmp/asciidoc_" .. timestamp .. ".html"

  vim.fn.jobstart({ "asciidoctor", "-o", html_out, input }, {
    on_exit = function()
      vim.fn.jobstart({ "xdg-open", html_out })
    end
  })
end

local wk = require("which-key")
	wk.add({
		{ "<space>a",  group = "Asciidoctor" }, -- group
{ "<space>ag", ":lua gen_doc()<CR>", desc= "Asciidoctor Gen Doc", mode ="n"},
})


