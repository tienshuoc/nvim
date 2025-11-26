return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  cond = not vim.g.is_large_file_on_startup,
  cmd = "Leet",
  lazy = true,
  -- build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  dependencies = {
    "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- configuration goes here
    lang = "python3",
  },
}
