--- Indent Blankline ---
return {
  "lukas-reineke/indent-blankline.nvim",
  cond = not vim.g.is_large_file_on_startup,
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    main = "ibl",
}
