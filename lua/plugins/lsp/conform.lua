return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- When saving file s/t can trigger format on save.
  cmd = { "ConformInfo" },
  dependencies = {
    "mason-org/mason.nvim",
  },
  keys = {
    {
      "<leader>F",
      function()
        local range
        local mode = vim.fn.mode()
        if mode == "V" or mode == "\22" then
          -- Format complete lines, including the final selected character.
          local first, last = vim.fn.line("v"), vim.fn.line(".")
          first, last = math.min(first, last), math.max(first, last)
          range = { start = { first, 0 }, ["end"] = { last, #vim.fn.getline(last) } }
        end
        require("conform").format({
          range = range,
          timeout_ms = 3000,
          -- LSP formatting is used when no other formatters are available.
          lsp_format = "fallback",
        })
      end,
      mode = { "n", "v" },
      desc = "Format buffer or selection.",
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
