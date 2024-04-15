return {
  -- Buffer Tabs
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    { "<leader>B", "<Cmd>BufferLinePick<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>D", "<Cmd>BufferLineDelete<CR>", mode = "n", { noremap = true, silent = true } },
  },
  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup({})
  end,
}
