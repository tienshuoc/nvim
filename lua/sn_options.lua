local opts = {
   noremap = true,      -- non-recursive
   silent = true,       -- do not show message
}

vim.keymap.set('n', '<leader>tl1', ':e $SCRATCH_HOME/1tmp.list<CR>', opts)
vim.keymap.set('n', '<leader>tl2', ':e $SCRATCH_HOME/2tmp.list<CR>', opts)
vim.keymap.set('n', '<leader>tl3', ':e $SCRATCH_HOME/3tmp.list<CR>', opts)
vim.keymap.set('n', '<leader>tl4', ':e $SCRATCH_HOME/4tmp.list<CR>', opts)
