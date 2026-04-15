return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  cmd = "Leet",
  lazy = true,
  dependencies = {
    "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter", -- marking treesitter as dependency for html syntax
  },
  opts = {
    -- configuration goes here
    lang = "python3",
  },
}
