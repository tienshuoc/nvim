return {
    {
        -- monokai_pro
        'tanvirtin/monokai.nvim',
    },
    {
        -- nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
        'EdenEast/nightfox.nvim'
    },
    {'projekt0n/github-nvim-theme'},
    {
      'sainnhe/gruvbox-material',
      config = function()
        vim.g.gruvbox_material_dim_inactive_windows = 1
        vim.g.gruvbox_material_background = 'soft' -- 'hard', 'medium', 'soft'
        vim.g.gruvbox_material_foreground = 'material' -- 'material', 'mix', 'original'
        vim.g.gruvbox_material_statusline_style = 'original' -- 'default', 'mix', 'original'
        vim.g.gruvbox_material_transparent_background = 0 -- 0, 1, 2 (statsline also transparent)
        vim.g.gruvbox_material_ui_contrast = 'high' -- 'low', 'high' (contrast of line numbers, indent lines, etc)

        vim.g.gruvbox_material_enable_bold = 1
        vim.g.gruvbox_material_enable_italic = 1

        vim.g.gruvbox_material_diagnostic_text_highlight = 1

        vim.o.background = "dark"
        vim.cmd([[ colorscheme gruvbox-material ]])
      end,

    },
    -- {
    --     'ellisonleao/gruvbox.nvim',
    --     priority = 1000,
    --     config = function()
    --         require('gruvbox').setup({
    --             undercurl = true,
    --             underline = true,
    --             contrast = "hard",
    --         })
    --         vim.o.background = "dark"
    --         vim.cmd([[ colorscheme gruvbox ]])
    --     end,
    -- },
    {
      -- Edge Dark (default, aura, neon), Edge Light
      'sainnhe/edge',
      dependencies = {
        'nvim-treesitter/nvim-treesitter'
      },
      config = function()
        vim.g.edge_dim_inactive_windows = 1
        vim.g.edge_enable_italic = 1
        vim.o.background = "dark"
        vim.g.edge_style = 'aura'
        vim.g.edge_transparent_background = 0
        -- vim.cmd([[ colorscheme edge ]])

      end,

    },
    {
        'sainnhe/sonokai',
        config = function()
            vim.g.sonokai_enable_italics = 1
            vim.g.sonokai_dim_ianctive_windows = 1
            vim.g.sonokai_diagnostic_text_hightlight = 1
            vim.g.sonokai_style = 'default' -- 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
            -- vim.cmd([[ colorscheme sonokai ]])
        end,
    },
    {
        -- dracula, dracula-soft
        'Mofiqul/dracula.nvim'
    },
    {
        -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
        'catppuccin/nvim'
    },
    {
        -- kanagawa, kanagawa-wave, kanagawa-lotus, kanagawa-dragon
        'rebelot/kanagawa.nvim'
    },
    {
        -- PaperColor (:set background=dark/light)
        'NLKNguyen/papercolor-theme'
    },
    {
        -- vscode (:set background=dark/light)
        'Mofiqul/vscode.nvim'
    },
    {
        -- onehalflight, onehalfdark
        "sonph/onehalf",
        rtp = "vim/",
        config = function()
            -- vim.cmd("colorscheme onehalflight")
        end,
    },
    {
        -- rose-pine-main, rose-pine-dark, rise-pine-moon, rose-pine-dawn, rose-pine
        'rose-pine/neovim', name = 'rose-pine',
        config = function()
            -- vim.o.background = "light" -- or "light" for light mode
            -- vim.cmd([[ colorscheme rose-pine ]])
        end,
    },
    {
      -- Oceanic, Deep Ocean, Palenight, Lighter, Darker
      'marko-cerovac/material.nvim',
      config = function()
          vim.g.material_style = 'Palenight'
          -- vim.cmd([[ colorscheme material ]])
      end,
    },



}
