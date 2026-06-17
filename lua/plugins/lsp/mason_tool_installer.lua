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
