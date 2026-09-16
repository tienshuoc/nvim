-- Package manager for LSP servers, DAP servers, linters, and formatters.
return {
  "williamboman/mason.nvim",
  lazy = true,
  build = ":MasonUpdate",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
