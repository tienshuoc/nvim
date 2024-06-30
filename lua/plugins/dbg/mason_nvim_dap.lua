return {
  "jay-babu/mason-nvim-dap.nvim",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  opts = {
    handlers = {
      -- function(config)
      --   -- all sources with no handler get passed here
      --
      --   -- Keep original functionality
      --   require("mason-nvim-dap").default_setup(config)
      -- end,
      -- cpp = function(config)
      --   config.adapters = {
      --     type = "executable",
      --     command = "/opt/sambanova/llvm16/bin/lldb",
      --     args = function()
      --       return vim.fn.input("Args to executable: ")
      --     end,
      --   }
      --   require("mason-nvim-dap").default_setup(config)
      -- end,
    },
    ensure_installed = {
      "codelldb",
    },
  },
}
