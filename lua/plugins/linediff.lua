return {
  "andrewradev/linediff.vim",
  lazy = false,
  keys = {
    {
      "<leader>ld",
      ":Linediff<CR>",
      mode = { "n", "v" },
      noremap = true,
      silent = true,
      desc = "Linediff",
    },
  },
}
