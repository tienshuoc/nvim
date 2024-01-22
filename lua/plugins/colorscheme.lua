return {
    {
        -- monokai_pro
        'tanvirtin/monokai.nvim',
    },
    {
        -- nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
        'EdenEast/nightfox.nvim'
    },
    { 'projekt0n/github-nvim-theme' },
    {
        'sainnhe/gruvbox-material',
        config = function()
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_background = 'soft'           -- 'hard', 'medium', 'soft'
            vim.g.gruvbox_material_foreground = 'material'       -- 'material', 'mix', 'original'
            vim.g.gruvbox_material_statusline_style = 'original' -- 'default', 'mix', 'original'
            vim.g.gruvbox_material_transparent_background = 0    -- 0, 1, 2 (statsline also transparent)
            vim.g.gruvbox_material_ui_contrast =
            'high'                                               -- 'low', 'high' (contrast of line numbers, indent lines, etc)

            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_enable_italic = 1

            vim.g.gruvbox_material_diagnostic_text_highlight = 1

            vim.o.background = "dark"
            -- vim.cmd.colorscheme("gruvbox-material")
        end,

    },
    {
        -- Atom's One Dark and Light theme.
        'navarasu/onedark.nvim',
        config = function()
            require('onedark').setup({
                style = 'cool' -- 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
            })
            -- vim.cmd.colorscheme("onedark")
        end,

    },
    {
        -- Edge Dark (default, aura, neon), Edge Light
        'sainnhe/edge',
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
        },
        config = function()
            vim.g.edge_dim_inactive_windows = 1
            vim.g.edge_enable_italic = 1
            vim.g.edge_style = 'neon'
            vim.g.edge_transparent_background = 1
            -- vim.cmd.colorscheme(" edge")
        end,

    },
    {
        'sainnhe/sonokai',
        config = function()
            vim.g.sonokai_enable_italics = 1
            vim.g.sonokai_dim_ianctive_windows = 1
            vim.g.sonokai_diagnostic_text_hightlight = 1
            vim.g.sonokai_style = 'default' -- 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
            -- vim.cmd.colorscheme("sonokai")
        end,
    },
    {
        -- dracula, dracula-soft
        'Mofiqul/dracula.nvim',
        config = function()
          require('dracula').setup({
              transparent_bg = true,
          })
        end,

        
    },
    {
        -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
        'catppuccin/nvim',
        config = function()
            require('catppuccin').setup({
                transparent_background = true,
                dim_inactive = {
                    enabled = true,
                }
            })
        end,
    },
    {
        -- kanagawa, kanagawa-wave, kanagawa-lotus, kanagawa-dragon
        'rebelot/kanagawa.nvim',
        config = function()
            require('kanagawa').setup({
                dimInactive = true,
            })
        end,
    },
    {
        -- PaperColor (:set background=dark/light)
        'NLKNguyen/papercolor-theme',
        lazy = false,
        config = function()
           require('papercolor-theme').setup({
                    transparent_background = 1,
                })
          vim.cmd.colorscheme("PaperColor")
        end
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
            -- vim.cmd.colorscheme("onehalflight")
        end,
    },
    {
        -- rose-pine-main, rose-pine-dark, rise-pine-moon, rose-pine-dawn, rose-pine
        'rose-pine/neovim',
        name = 'rose-pine',
        config = function()
            -- vim.o.background = "light" -- or "light" for light mode
            -- vim.cmd.colorscheme("rose-pine")
        end,
    },
    {
        -- Oceanic, Deep Ocean, Palenight, Lighter, Darker
        'marko-cerovac/material.nvim',
        config = function()
            vim.g.material_style = 'Palenight'
            -- vim.cmd.colorscheme("material")
        end,
    },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            require("everforest").setup({
                transparent_background_level = 1,
            })
            -- vim.cmd.colorscheme("everforest")
        end,
    }
}
