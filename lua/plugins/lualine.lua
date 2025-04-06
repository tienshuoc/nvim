local function curr_window_index()
  return vim.api.nvim_win_get_number(0)
end

return {
  -- Lualine
  "nvim-lualine/lualine.nvim",
  dependencies = { { "nvim-tree/nvim-web-devicons", opt = true } },
  config = function()
    require("lualine").setup({
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "searchcount",
          "filename",
          {
            "diagnosticss",
            sources = { "nvim_lsp", "nvim_diagnostic", "nvim_workspace_diagnostic" }, -- Displays diagnostics for the defined severity types
            sections = { "error", "warn", "info", "hint" },

            diagnostics_color = {
              -- Same values as the general color option can be used here.
              error = "DiagnosticError", -- Changes diagnostics' error color.
              warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
              info = "DiagnosticInfo", -- Changes diagnostics' info color.
              hint = "DiagnosticHint", -- Changes diagnostics' hint color.
            },
            colored = true, -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = true, -- Show diagnostics even if there are none.
          },
        },
        lualine_c = { "diff" },
        lualine_x = {
          {
            "lsp_status",
            icon = "", -- f013
            symbols = {
              -- Standard unicode symbols to cycle through for LSP progress:
              spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
              -- Standard unicode symbol for when LSP is done:
              done = "✓",
              -- Delimiter inserted between LSP names:
              separator = " ",
            },
            -- List of LSP names to ignore (e.g., `null-ls`):
            ignore_lsp = {},
          },
          "filetype",
          "encoding",
        },
        lualine_y = { "progress" },
        lualine_z = { { "datetime", style = "%H:%M:%S | %b-%d" } },
      },
      inactive_sections = {
        -- lualine_a = { { "windows", show_filename_only = true, show_modified_status = true, mode = 1 } },
        lualine_a = { curr_window_index },
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    })
    -- Listen lsp-progress event and refresh lualine.
    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "lualine_augroup",
      pattern = "LspProgressStatusUpdated",
      callback = require("lualine").refresh,
    })
  end,
}
