return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "clangd",
      "lua_ls",
      "pyright",
      "bashls",
      "starpls", -- Bazel LSP
      "rust_analyzer",
    },
    -- Activation is owned by the explicit server list in nvim_lspconfig.lua.
    automatic_enable = false,
  },
}
