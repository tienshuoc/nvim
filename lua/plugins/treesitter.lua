return {

    -- Better syntax highlighting
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                "typescript", "cpp", "jsonc", "markdown",
                "gitcommit", "bash", "javascript", "python", "lua",
            },
            ignore_install = { "mlir" },  -- Tries to complain that you don't have "treesitter-cli", and installing it gives GLIBC problems. Back off for MLIR.
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
            },
        })
    end,
}
