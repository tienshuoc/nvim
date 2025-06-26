return {
  "aymericbeaumet/vim-symlink",
  cond = not vim.g.is_large_file_on_startup,
  dependencies = { "moll/vim-bbye" },
}
