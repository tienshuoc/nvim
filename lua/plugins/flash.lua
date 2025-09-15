return {
  "folke/flash.nvim",
  cond = not vim.g.is_large_file_on_startup,
  lazy = true,
  ---@type Flash.Config
  opts = {
    labels = { "tnseriaodhplfuwybjqgmvkcxz" },
    modes = {
      char = {
        enabled = false, -- turn off flash for `t`, `f`, `T`, `F`
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" }, -- Currently conflicts with nvim-surround
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
