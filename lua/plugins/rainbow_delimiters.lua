return {
  -- Color Brackets
  "HiPhish/rainbow-delimiters.nvim",
  cond = not vim.g.is_large_file_on_startup,
  event = "VeryLazy",
  submodules = false, -- As specified on the plugin README, the submodules are not needed.
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
