return {
  -- Dashboard during empty startup.
  "glepnir/dashboard-nvim",
  cond = not vim.g.is_large_file_on_startup,
  event = "VimEnter",
  config = function()
    require("dashboard").setup({
      -- config
      theme = "hyper", -- 'hyper', 'doom'
      config = {
        -- header = {
        -- "Welcome"
        -- }
        shortcut = {
          { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
          {
            desc = " NeoVim dotfiles",
            group = "Files",
            action = ":cd ~/.config/nvim | :e ~/.config/nvim",
            key = "d",
          },
        },
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
