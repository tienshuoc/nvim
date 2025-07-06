return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "ibhagwan/fzf-lua",
  },
  keys = {
    {
      "<leader>ng",
      mode = { "n" },
      function()
        require("neogit").open({ kind = "tab" })
      end,
      { desc = "Neogit." },
    },
  },
  opts = {
    -- Show message with spinning animation when a git command is running.
    process_spinner = false,
  },
}
