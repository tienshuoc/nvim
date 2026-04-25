return {
  -- Dashboard during empty startup.
  "glepnir/dashboard-nvim",
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
        project = { enable = true, limit = 8, icon = " ", label = " Projects", action = "FzfLua files cwd=" },
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
