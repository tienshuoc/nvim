return {
  -- Git plugins.
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>dt', ':Git difftool -y<CR>', mode = 'n', { noremap = true, silent = true } },
      { '<leader>gs', vim.cmd.Git,            mode = 'n', { noremap = true, silent = true } }
    }
  },
  {
    "sindrets/diffview.nvim",     -- Git diff page.
  },
  {
    'whiteinge/diffconflicts',     -- Git diff conflicts.
  }
}
