return {
  "chentoast/marks.nvim",
  cond = not vim.g.is_large_file_on_startup,
  event = "VeryLazy",
  opts = {},
}
