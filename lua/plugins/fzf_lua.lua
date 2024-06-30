return {
  "ibhagwan/fzf-lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>ss",
      "<cmd> FzfLua lsp_document_symbols<cr>",
      mode = "n",
      { noremap = true, desc = "Search document symbols." },
    },
  },
  config = function()
    local actions = require("fzf-lua.actions")
    require("fzf-lua").setup({})
  end,
}
