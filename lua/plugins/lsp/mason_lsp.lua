return {
  "williamboman/mason-lspconfig.nvim", -- Bridges the gap btw `mason.nvim` and `lspconfig`.
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      -- List of servers for mason to install.
      ensure_installed = {
        -- "ts_ls", -- Using 'typescript toold'
        "clangd",
        "lua_ls",
        "pyright",
        "bashls",
        "starpls", -- Bazel LSP
      },
      automatic_enable = true,
    })
  end,
}
