-- Package manager for LSP servers, DAP servers, linters, and formatters.
return {
  "williamboman/mason.nvim",
  lazy = false, -- Initialize commands and tool PATH during startup.
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
