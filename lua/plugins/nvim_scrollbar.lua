return {
  "petertriho/nvim-scrollbar",
  cond = not vim.g.is_large_file_on_startup,
  config = function()
    require("scrollbar").setup()
  end,
}
