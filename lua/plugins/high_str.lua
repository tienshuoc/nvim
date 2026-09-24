-- Manual highlights only; saved-highlight persistence is intentionally unused.
return {
  "Pocco81/HighStr.nvim",
  cmd = { "HSHighlight", "HSRmHighlight" },
  keys = {
    { "<leader>hl", ":<c-u>HSHighlight ", mode = "v", silent = false, desc = "HSHighlight" },
    { "<leader>hr", ":<c-u>HSRmHighlight<CR>", mode = { "n", "v" }, silent = true, desc = "HSRmHighlight" },
  },
  opts = {},
}
