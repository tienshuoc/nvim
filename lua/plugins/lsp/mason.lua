-- Package manager for LSP servers, DAP servers, linters, and formatters.
return {
  "williamboman/mason.nvim",
  lazy = true, -- Manage loading in `nvim_lspconfig.lua`.
  build = ":MasonUpdate",
}
