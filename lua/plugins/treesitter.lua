return {

    -- Better syntax highlighting
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        local treesitter = require('nvim-treesitter')
        treesitter.setup({
            ensure_installed = {"typescript", "cpp", "jsonc", "markdown", "gitcommit", "bash"},

            -- Color brackets
            rainbow = {
                enable = true,
                -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
                extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = nil, -- Do not enable for files with more than n lines, int
                -- colors = {}, -- table of hex strings
                -- termcolors = {} -- table of colour name strings
            },

            -- JSX Context Commentstring
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            }
        })
    end,
}
