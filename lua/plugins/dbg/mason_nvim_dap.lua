return {
  "jay-babu/mason-nvim-dap.nvim",
  lazy = true,
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  opts = {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,
  },
  -- mason-nvim-dap is loaded when nvim-dap loads
  config = function()
    require("mason-nvim-dap").setup({
      ensure_installed = {
        "codelldb",
      },
    })
  end,
}
