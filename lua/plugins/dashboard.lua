return {
  -- Dashboard during empty startup.
  "glepnir/dashboard-nvim",
  event = "VimEnter",
  opts = {
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
      project = {
        enable = true,
        limit = 8,
        icon = " ",
        label = " Projects",
        action = function(path)
          require("fzf-lua").files({ cwd = path })
        end,
      },
    },
  },
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
