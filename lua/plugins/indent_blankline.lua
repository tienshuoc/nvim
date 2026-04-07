--- Indent Blankline ---
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  opts = {
    indent = {
      char = "│",
    },
    scope = {
      -- This is the indentation level where variables or functions are accessible, NOT the current indentation level.
      enabled = true,
    },
    exclude = {
      filetypes = {
        "help",
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
