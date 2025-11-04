return {
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- Install and upgrade third-party tools automatically.
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
      },
    })
  end,
}
