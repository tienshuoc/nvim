local opts = {
   noremap = true,      -- non-recursive
   silent = true,       -- do not show message
}

vim.keymap.set('n', '<leader>otl1', ':e $SCRATCH_HOME/1tmp.list<CR>', opts)
vim.keymap.set('n', '<leader>otl2', ':e $SCRATCH_HOME/2tmp.list<CR>', opts)
vim.keymap.set('n', '<leader>otl3', ':e $SCRATCH_HOME/3tmp.list<CR>', opts)
vim.keymap.set('n', '<leader>otl4', ':e $SCRATCH_HOME/4tmp.list<CR>', opts)
