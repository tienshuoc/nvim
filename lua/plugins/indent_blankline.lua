--- Indent Blankline ---
return {
  "lukas-reineke/indent-blankline.nvim",
  cond = not vim.g.is_large_file_on_startup,
  scope = { enabled = true },
  exclude = {
    filetypes = {
      "help",
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
    },
  },
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
  },
  main = "ibl",
}
