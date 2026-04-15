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
        "rust_analyzer",
      },
      -- clangd is excluded here and started manually via a FileType autocmd
      -- in nvim_lspconfig.lua so --compile-commands-dir can be set dynamically.
      automatic_enable = {
        exclude = { "clangd" },
      },
    })
  end,
}
