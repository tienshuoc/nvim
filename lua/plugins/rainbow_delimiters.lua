return {
  -- Color Brackets
  "HiPhish/rainbow-delimiters.nvim",
  cond = not vim.g.is_large_file_on_startup,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
