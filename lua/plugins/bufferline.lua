return {
  -- Buffer Tabs
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>bp", "<Cmd>BufferLinePick<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>bc", "<Cmd>BufferLinePickClose<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>bh", "<Cmd>BufferLineCyclePrev<CR>", mode = "n", { noremap = true, silent = true } },
  },
  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup({})
  end,
}
