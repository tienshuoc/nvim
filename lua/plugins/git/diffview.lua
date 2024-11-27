return {
  "sindrets/diffview.nvim", -- Git diff page.
  lazy = true,  -- Requires Git >= 2.31.0 to work properly.
  keys = {
    { "<leader>gg", ":DiffviewOpen<CR>", mode = "n", { noremap = true, silent = true } }
  }
}
