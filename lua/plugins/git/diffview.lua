return {
  "sindrets/diffview.nvim", -- Git diff page. Requires Git >= 2.31.0 to work properly.
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewLog",
  },
  keys = {
    { "<leader>gg", ":DiffviewOpen<CR>", mode = "n", silent = true, desc = "Diffview." },
  },
  opts = {
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      },
    },
  },
}
