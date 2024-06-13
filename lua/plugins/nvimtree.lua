return {
  -- Nvim Tree (file explorer)
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Icons.
  },
  keys = {
    { "<leader>nt", ":NvimTreeToggle<CR>", mode = "n", { noremap = true, silent = true } },
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
        update_cwd = false,
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
    })
  end,
}
