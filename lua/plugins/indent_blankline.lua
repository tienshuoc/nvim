--- Indent Blankline ---
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  opts = {
    indent = {
      char = "│",
    },
    exclude = {
      filetypes = {
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "log",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
}
