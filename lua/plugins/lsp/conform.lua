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
          lsp_format = "fallback",
        })
      end,
      mode = { "n", "v" },
      desc = "Format current buffer.",
    },
  },
  opts = {
    formatters = {
      jsonnetfmt = {
        prepend_args = { "--indent", "4" },
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- Run only the first available JavaScript formatter.
      javascript = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettier" },
      cpp = { "clang-format" },
      jsonnet = { "jsonnetfmt" },
      sh = { "shfmt" },
      bzl = { "buildifier" },
    },
    format_on_save = function(bufnr)
      local filetype = vim.bo[bufnr].filetype
      if filetype ~= "lua" and filetype ~= "jsonnet" then
        return
      end
      return { bufnr = bufnr, timeout_ms = 500, lsp_format = "fallback" }
    end,
  },
}
