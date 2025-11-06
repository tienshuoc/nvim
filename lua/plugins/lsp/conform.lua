return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- When saving file s/t can trigger format on save.
  cmd = { "ConformInfo" },
  dependencies = {
    "williamboman/mason.nvim",
  },
  keys = {
    {
      "<leader>F",
      function()
        require("conform").format({
          timeout_ms = 3000,
          -- LSP formatting is used when no other formatters are available.
          lsp_fallback = true,
        })
      end,
      mode = { "n", "v" },
      desc = "Format current buffer.",
    },
  },
  opts = {
    formatters = {
      -- Self-defined formatters.
      jsonnet_indent4 = {
        command = "jsonnetfmt",
        args = {
          "--indent",
          "4",
          "-",
        },
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- Use a sub-list to run only the first available formatter
      javascript = { "prettierd", "prettier" },
      cpp = { "clang-format" },
      jsonnet = { "jsonnet_indent4" },
      sh = { "shfmt" },
      bzl = { "buildifier" },
    },
    format_on_save = function(bufnr)
      if vim.bo.filetype ~= "lua" and vim.bo.filetype ~= "jsonnet" then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  },
}
