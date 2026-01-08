return {
  "hrsh7th/nvim-cmp",
  cond = not vim.g.is_large_file_on_startup,
  event = { "InsertEnter" },
  lazy = true,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- Provides LSP (Language Server Protocol) completion sources.
    "hrsh7th/cmp-buffer", -- Provides completion sources from the text in your current buffer.
    "hrsh7th/cmp-path", -- Provides completion sources for file system paths.
    "hrsh7th/cmp-nvim-lsp-signature-help", -- Shows function signatures and highlights the current parameter.
    {
      "L3MON4D3/LuaSnip", -- The primary snippet engine.
      lazy = true,
      dependencies = {
        {
          "rafamadriz/friendly-snippets", -- Snippet collection for a set of different programming languages.
          lazy = true,
        },
      },
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- Provides a completion source for LuaSnip within nvim-cmp.
    "onsails/lspkind.nvim", -- Adds VSCode-like icons to the completion menu.
    "windwp/nvim-autopairs", -- Automatically adds closing brackets, parentheses, quotes, etc..
    "alexander-born/cmp-bazel", -- Provides completion for Bazel targets and package files.
  },
  config = function()
    -- =================================================================
    --  1. REQUIRE AND SETUP INDIVIDUAL PLUGINS
    -- =================================================================
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    -- Loads vscode style snippets from installed plugins (e.g. friendly-snippets).
    require("luasnip.loaders.from_vscode").lazy_load()

    -- =================================================================
    --  2. SETUP NVIM-CMP
    -- =================================================================
    cmp.setup({
      -- Configure how nvim-cmp interacts with the snippet engine.
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- Do not pre-select the first item in the completion menu.
      -- Have to explicitly navigate to an item to select it.
      preselect = cmp.PreselectMode.None,
      completion = {
        -- This ensures that the menu appears but doesn't auto-select anything.
        completeopt = "menu,menuone,preview,noselect",
      },

      -- Configure the appearance of the completion and documentation windows
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      -- =================================================================
      --  3. KEY MAPPINGS
      -- =================================================================
      mapping = cmp.mapping.preset.insert({
        -- Scroll up and down in the documentation window
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        -- Manually trigger completion.
        ["<C-s>"] = cmp.mapping.complete(),

        -- Enter key mapping.
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- If a snippet is expandable, expand it.
            if luasnip.expandable() then
              luasnip.expand()
            -- If an item is selected in the completion menu, confirm it.
            elseif cmp.get_selected_entry() then
              cmp.confirm({ select = true })
            -- Otherwise, close the completion window and fallback to a new line.
            else
              cmp.close()
              fallback()
            end
          else
            -- If the completion window is not visible, just insert a new line
            fallback()
          end
        end),

        -- Tab and Shift-Tab for navigating the completion menu and snippets.
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- If the completion menu is visible, select the next item.
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            -- If inside an active snippet, jump to the next placeholder.
            luasnip.jump(1)
          else
            -- Otherwise, fallback to a literal tab character
            fallback()
          end
        end, { "i", "s" }), -- This mapping works in insert and select mode.

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- If the completion menu is visible, select the previous item.
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            -- If inside an active snippet, jump to the previous placeholder.
            luasnip.jump(-1)
          else
            -- Otherwise, fallback.
            fallback()
          end
        end, { "i", "s" }), -- This mapping works in insert and select mode.
      }),

      -- =================================================================
      --  4. COMPLETION SOURCES
      -- =================================================================
      -- These are the different sources nvim-cmp will use for suggestions.
      -- The order matters, as it determines the priority of the suggestions.
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- Highest priority: Language Server.
        { name = "luasnip" }, -- Snippets.
        { name = "buffer" }, -- Words from the current file.
        { name = "path" }, -- File system paths.
        { name = "bazel" }, -- Bazel targets.
        { name = "nvim_lsp_signature_help" }, -- Function signatures.
      }),

      -- =================================================================
      --  5. FORMATTING & INTEGRATIONS
      -- =================================================================

      -- Configure lspkind for VSCode-like pictograms in the completion menu
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text", -- Show icon and text
          maxwidth = 50, -- Truncate long entries
          ellipsis_char = "...",
          show_labelDetails = true,
        }),
      },

    })

    -- =================================================================
    --  6. NVIM-AUTOPAIRS INTEGRATION
    -- =================================================================
    -- Integrate with nvim-autopairs to automatically add () after function completion
    -- This event fires after a completion is "confirmed" (i.e., you selected it).
    local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if ok then
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  end,
}
