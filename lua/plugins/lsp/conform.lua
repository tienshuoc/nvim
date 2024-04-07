return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  -- lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- Starting to edit / New File.
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
  config = function()
    -- If formatters are not installed: run `:MasonInstall $FORMATTER`,
    -- where $FORMATTER = stylua/clang-format...
    require("conform").setup({
      formatters = {
        -- clang_format = {
        -- 	command = "clang-format",
        -- },
      },
      formatters_by_ft = {
        lua = { "stylua" }, -- Remember to set `~/.config/stylua/.stylua.toml` to use spaces for indent instead of tabs which is the default behavior.
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "prettierd", "prettier" } },
        cpp = { "clang_format" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        require("conform").format({ bufnr = args.buf, formatters = { "stylua" } })
      end,
    })
  end,
}
