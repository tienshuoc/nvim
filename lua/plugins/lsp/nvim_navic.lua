return {
  -- A simple statusline/winbar component that uses LSP to show current node context.
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  opts = {
    lsp = {
      auto_attach = true,
    },
  },
  config = function(_, opts)
    require("nvim-navic").setup(opts)
    -- Used to enable LSP symbol information on winbar

    -- need to show per-buffer
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  end,
}
