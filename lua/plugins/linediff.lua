return {
  "andrewradev/linediff.vim",
  keys = {
    {
      "<leader>ld",
      ":Linediff<CR>",
      mode = { "n", "v" },
      { noremap = true, silent = true, desc = "Linediff" },
    },
  },
}
