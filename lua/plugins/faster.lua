-- faster.nvim: per-buffer feature disabling for large files (treesitter, LSP,
-- syntax, filetype, indent_blankline, illuminate, lualine, mini_clue + custom
-- gitsigns/colorizer/cmp). Buffer/global option tweaks and startup minimal-plugin
-- loading live in utils/handle_large_file.lua.
return {
  "pteroctopus/faster.nvim",
  lazy = false, -- load at startup so its BufReadPre autocmds catch the first read
  config = function()
    -- Custom features for plugins not covered by faster.nvim built-ins. faster
    -- calls enable()/disable() with NO args, operating on the current (large)
    -- buffer. All bodies are pcall-guarded so a missing/unloaded plugin is a no-op.
    local custom_features = {
      -- gitsigns: computes a diff on attach -> expensive on huge files.
      gitsigns = {
        on = true,
        defer = true, -- run at BufReadPost, after gitsigns would attach
        disable = function()
          pcall(vim.cmd, "Gitsigns detach")
        end,
        enable = function()
          pcall(vim.cmd, "Gitsigns attach")
        end,
      },
      -- colorizer: scans the buffer for color codes and highlights them.
      colorizer = {
        on = true,
        defer = true,
        disable = function()
          pcall(vim.cmd, "ColorizerDetachFromBuffer")
        end,
        enable = function()
          pcall(vim.cmd, "ColorizerAttachToBuffer")
        end,
      },
      -- nvim-cmp: completion triggering while editing a large buffer.
      cmp = {
        on = true,
        defer = false,
        disable = function()
          local ok, cmp = pcall(require, "cmp")
          if ok then
            cmp.setup.buffer({ enabled = false })
          end
        end,
        enable = function()
          local ok, cmp = pcall(require, "cmp")
          if ok then
            cmp.setup.buffer({ enabled = true })
          end
        end,
      },
    }

    require("faster").setup({
      behaviours = {
        bigfile = {
          on = true,
          -- MB; derived from handle_large_file so there is one threshold to edit
          filesize = require("utils.handle_large_file").config.size_threshold / (1024 * 1024),
          pattern = "*",
          features_disabled = {
            -- faster.nvim built-ins
            "illuminate", -- vim_illuminate
            "matchparen",
            "lsp",
            "treesitter",
            "indent_blankline",
            "vimopts",
            "syntax",
            "filetype",
            "lualine",
            "mini_clue",
            -- custom features defined below
            "gitsigns",
            "colorizer",
            "cmp",
          },
          extra_patterns = {},
        },
        fastmacro = {
          on = true,
          features_disabled = { "lualine", "mini_clue" },
        },
      },
      features = custom_features,
    })
  end,
}
