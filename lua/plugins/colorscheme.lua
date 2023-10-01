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
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        config = function()
            require('gruvbox').setup({
                undercurl = true,
                underline = true,
                contrast = "hard",
            })
            vim.o.background = "dark" -- or "light" for light mode
            vim.cmd([[ colorscheme gruvbox ]])
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


}
