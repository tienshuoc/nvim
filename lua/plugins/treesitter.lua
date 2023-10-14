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
        "typescript", "cpp", "jsonc", "markdown", "gitcommit", "bash", "javascript", "python",
        "lua",
      },
      -- sync_install = true,
      -- auto_install = true,
      highlight = {
        enable = true,
      },
      -- TSX Context Commentstring
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    })
  end,
}
