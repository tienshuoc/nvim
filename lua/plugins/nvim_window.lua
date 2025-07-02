return {
  "yorickpeterse/nvim-window",
  keys = {
    { "<leader>nw", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
  },
  config = true,
  opts = {
    chars = {
      "t",
      "n",
      "e",
      "i",
      "o",
      "s",
      "s",
      "r",
      "a",
      "l",
      "p",
      "h",
      "d",
      "u",
      "f",
      "y",
      "w",
    },
  },
}
