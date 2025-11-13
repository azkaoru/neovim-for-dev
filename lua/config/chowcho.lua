require('chowcho').setup {
  -- Must be a single character. The length of the array is the maximum number of windows that can be moved.
  labels = { "A", "B", "C", "D", "E", "F", "G", "H", "I" },
  use_exclude_default = true,
  ignore_case = true,
  exclude = function(buf, win)
    -- exclude noice.nvim's cmdline_popup
    local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if bt == "nofile" and (ft == "noice" or ft == "vim") then
      return true
    end
    return false
  end,
  selector = {
    float = {
      border_style = "rounded",
      icon_enabled = true,
      color = {
        label = {
          active = "#c8cfff",
          inactive = "#ababab",
        },
        text = {
          active = "#fefefe",
          inactive = "#d0d0d0",
        },
        border = {
          active = "#b400c8",
          inactive = "#fefefe",
        },
      },
      zindex = 1,
    },
    statusline = {
      color = {
        label = {
          active = "#fefefe",
          inactive = "#d0d0d0",
        },
        background = {
          active = "#3d7172",
          inactive = "#203a3a",
        },
      },
    },
  },
}
