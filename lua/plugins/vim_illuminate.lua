return {
  "RRethy/vim-illuminate",
  cond = not vim.g.is_large_file_on_startup,
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
}
