return {
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- Install and upgrade third-party tools automatically.
  -- VeryLazy so its setup() (which requires the mason-nvim-dap/mason-lspconfig
  -- mapping modules and thus drags in the whole DAP stack) runs after startup
  -- instead of blocking it.
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    local mason_tool_installer = require("mason-tool-installer")
    mason_tool_installer.setup({
      -- Disable the mason-nvim-dap integration: its name->package mapping is
      -- required unconditionally by setup(), which dragged the whole DAP stack
      -- into every session at VeryLazy. With it off, mason-nvim-dap loads only
      -- when nvim-dap does (on a debug keymap). No DAP tools are listed here
      -- anyway -- codelldb is installed via mason-nvim-dap when debugging.
      integrations = { ["mason-nvim-dap"] = false },
      ensure_installed = {
        -- "prettier", -- Prettier formatter.
        "clang-format",
        "stylua", -- lua formatter (use v2.0.0 b/c of GLibc compatability issues), run `MasonInstall stylua@v2.0.0`
        "isort", -- python formatter
        "black", -- python formatter
        "shfmt", -- bash formatter
        "pylint",
        "eslint_d",
        "buildifier", -- bazel formatter
      },
    })
  end,
}
