return {
  "sindrets/diffview.nvim", -- Git diff page.
  lazy = false, -- Requires Git >= 2.31.0 to work properly.
  keys = {
    { "<leader>gg", ":DiffviewOpen<CR>", mode = "n", { noremap = true, silent = true } },
  },
  config = function()
    require("diffview").setup({
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    })
  end,
}
