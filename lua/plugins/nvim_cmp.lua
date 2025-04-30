return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter" },
  lazy = true,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- Source for Neovim's built-in language server client.
    "hrsh7th/cmp-buffer", -- Source for text in buffer.
    "hrsh7th/cmp-path", -- Source for file system paths.
    "hrsh7th/cmp-nvim-lsp-signature-help", -- Source for displaying function signatures with the current parameter emphasized.
    {
      "L3MON4D3/LuaSnip", -- Snippet engine for Neovim.
      lazy = true,
      dependencies = {
        {
          "rafamadriz/friendly-snippets", -- Snippets collection for a set of different programming languages.
          lazy = true,
        },
      },
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- LuaSnip completion source for `nvim-cmp`.
    "onsails/lspkind.nvim", -- VSCode-like pictograms.
    "windwp/nvim-autopairs", -- For completion to include brackets.
    "alexander-born/cmp-bazel", -- bazel target completion and package files
    {
      "tzachar/cmp-tabnine", -- Source for tabnine.
      build = "./install.sh",
    },
  },
  config = function()
    local cmp = require("cmp")

    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({
      max_lines = 1000,
      max_num_results = 20,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = "..",
      ignored_file_types = {
        -- default is not to ignore
        -- uncomment to ignore in lua:
        -- lua = true
      },
      show_prediction_strength = false,
      min_percent = 0,
    })

    -- Insert `(` after select function or method item
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- Loads vscode style snippets from installed plugins (e.g. friendly-snippets).
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- Configure how `nvim-cmp` interacts w/ snippet engine.
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
        ["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ["<C-s>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if luasnip.expandable() then
              luasnip.expand()
            else
              cmp.confirm({
                select = true,
              })
            end
          else
            fallback()
          end
        end),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "cmp_tabnine" },
        { name = "luasnip" },
        { name = "nvim_lsp_signature_help" },
        { name = "bazel" },
      }),
      -- Configure lspkind for VSCode-like pictograms in completion menu.
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
        }),
      },
    })
  end,
}
