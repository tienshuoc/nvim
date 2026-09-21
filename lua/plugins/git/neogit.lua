return {
  "NeogitOrg/neogit",
  cmd = { "Neogit", "NeogitCommit", "NeogitLogCurrent", "NeogitResetState" },
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
      desc = "Neogit.",
    },
  },
  opts = {
    integrations = {
      diffview = true,
      fzf_lua = true,
    },
  },
}
