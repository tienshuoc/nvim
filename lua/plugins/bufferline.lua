return {
  -- Buffer Tabs
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>pp", "<Cmd>BufferLinePick<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>bc", "<Cmd>BufferLinePickClose<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>bm", "<Cmd>BufferLineCyclePrev<CR>", mode = "n", { noremap = true, silent = true } },
    {
      "<leader>bs",
      ":vs<CR><Cmd>BufferLinePick<CR>",
      mode = "n",
      { desc = "Buffer Pick + Vertical Split", noremap = true, silent = true },
    },
  },
  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup({})
  end,
}
