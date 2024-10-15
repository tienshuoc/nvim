-- Package manager for LSP servers, DAP servers, linters, and formatters.
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- Bridges the gap btw `mason.nvim` and `lspconfig`.
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- Install and upgrade third-party tools automatically.
  },
  build = ":MasonUpdate",
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- Enable `mason` and configure icons.
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- List of servers for mason to install.
      ensure_installed = {
        "ts_ls",
        "clangd",
        "lua_ls",
        "pyright",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- "prettier", -- Prettier formatter.
        "clang-format",
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
      },
    })
  end,
}
