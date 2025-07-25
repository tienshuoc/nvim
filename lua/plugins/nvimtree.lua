return {
  -- Nvim Tree (file explorer)
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Icons.
  },
  keys = {
    {
      "<leader>nt",
      function()
        require("nvim-tree.api").tree.toggle()
      end,
      mode = "n",
      { noremap = true, silent = true },
    },
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
      renderer = {
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
      },
      git = {
        enable = false,
      },
    })
  end,
}
