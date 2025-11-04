-- Package manager for LSP servers, DAP servers, linters, and formatters.
return {
  "williamboman/mason.nvim",
  lazy = true,
  build = ":MasonUpdate",
  config = function()
    local mason = require("mason")
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
  end,
}
