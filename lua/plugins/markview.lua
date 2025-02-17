return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = {
    preview = {
      filetypes = { --[[ "markdown", ]]
        "codecompanion",
      }, -- Enable this just for  CodeCompanion. We use Markdown Preview for Md files.
      ignore_buftypes = {},
    },
  },
}
