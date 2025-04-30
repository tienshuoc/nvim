return {
  "benlubas/wrapping-paper.nvim",
  dependencies = "MunifTanjim/nui.nvim", -- UI component library for Neovim
  keys = {
    {
      "gww", -- overrides neovim default `gww` behavior which formats line to fit within `textwidth`
      mode = { "n" },
      function()
        require("wrapping-paper").wrap_line()
      end,
      { desc = "Fake wrap current line." },
    },
  },
}
