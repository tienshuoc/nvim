return {
  "lewis6991/gitsigns.nvim",
  cond = not vim.g.is_large_file_on_startup,
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
  },
  config = function()
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { italic = true, fg = "#414550" })
    require("gitsigns").setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    })
    ---- Keymaps
    vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Gitsigns blame line." })

    -- Navigating hunks.
    vim.keymap.set("n", "[h", ":Gitsigns prev_hunk<CR>", { desc = "Gitsigns prev hunk." })
    vim.keymap.set("n", "]h", ":Gitsigns next_hunk<CR>", { desc = "Gitsigns next hunk." })

    -- Staging hunks.
    vim.keymap.set("n", "<leader>gph", ":Gitsigns preview_hunk<CR>", { desc = "Gitsigns preview hunk." })
    vim.keymap.set("n", "<leader>gsh", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns stage hunk." })
    vim.keymap.set("n", "<leader>grh", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset hunk." })
  end,
}
