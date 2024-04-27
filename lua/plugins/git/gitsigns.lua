return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  ops = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
  },
  config = function()
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { italic = true, fg = "#414550" })
    require("gitsigns").setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
      },
    })
    vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>")
  end,
}
