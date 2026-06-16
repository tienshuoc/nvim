return {
  -- Buffer Tabs
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>pp", "<Cmd>BufferLinePick<CR>", mode = "n", noremap = true, silent = true, desc = "Buffer Pick" },
    {
      "<leader>bc",
      "<Cmd>BufferLinePickClose<CR>",
      mode = "n",
      noremap = true,
      silent = true,
      desc = "Buffer Pick + Close",
    },
    {
      "<leader>bs",
      ":vs<CR><Cmd>BufferLinePick<CR>",
      mode = "n",
      noremap = true,
      silent = true,
      desc = "Buffer Pick + Vertical Split",
    },
  },
  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup({})
  end,
}
