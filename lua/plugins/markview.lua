return {
  "OXY2DEV/markview.nvim",
  lazy = true,
  config = {
    experimental = {
      check_rtp = true,
      check_rtp_msg = false,
    },
  },
  opts = {
    preview = {
      filetypes = { --[[ "markdown", ]]
        "codecompanion",
      }, -- Enable this just for  CodeCompanion. We use Markdown Preview for Md files.
      ignore_buftypes = {},

      condition = function(buffer)
        local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt
        if bt == "nofile" and ft == "codecompanion" then
          return true
        elseif bt == "nofile" then
          return false
        else
          return true
        end
      end,
    },
  },
}
