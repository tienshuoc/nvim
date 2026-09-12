return {
  "jay-babu/mason-nvim-dap.nvim",
  lazy = true,
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  opts = {
    ensure_installed = { "codelldb" },
    automatic_installation = true,
  },
}
