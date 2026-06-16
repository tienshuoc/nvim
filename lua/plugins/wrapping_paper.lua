return {
  "benlubas/wrapping-paper.nvim",
  -- UI component library; lazy = true keeps it from loading until gww triggers wrapping-paper
  dependencies = { { "MunifTanjim/nui.nvim", lazy = true } },
  keys = {
    {
      "gww", -- overrides neovim default `gww` behavior which formats line to fit within `textwidth`
      mode = { "n" },
      function()
        require("wrapping-paper").wrap_line()
      end,
      desc = "Fake wrap current line.",
    },
  },
}
