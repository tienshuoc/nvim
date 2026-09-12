return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 300,
    },
  },
  keys = {
    { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Gitsigns blame line." },
    { "[h", ":Gitsigns prev_hunk<CR>", desc = "Gitsigns prev hunk." },
    { "]h", ":Gitsigns next_hunk<CR>", desc = "Gitsigns next hunk." },
    { "<leader>gph", ":Gitsigns preview_hunk<CR>", desc = "Gitsigns preview hunk." },
    { "<leader>gsh", ":Gitsigns stage_hunk<CR>", desc = "Gitsigns stage hunk." },
    { "<leader>grh", ":Gitsigns reset_hunk<CR>", desc = "Gitsigns reset hunk." },
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { italic = true, fg = "#414550" })
    require("gitsigns").setup(opts)
  end,
}
