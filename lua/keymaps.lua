local opts = {
  -- Define common options.
  noremap = true, -- non-recursive
  silent = true,  -- do not show message
}

----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Normal mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>nv', ':e ~/.config/nvim/<CR>', opts) -- Edit neovim settings.

vim.keymap.set('n', '<leader>w', ':w<CR>', opts)
vim.keymap.set('n', '<leader>qq', ':q<CR>', opts)
vim.keymap.set('n', '<leader>qa', ':qa<CR>', opts)
vim.keymap.set('n', '<leader>bd', ':bd<CR>', opts)

vim.keymap.set('n', 'zZ', 'zszH', opts) -- Center cursor on middle of screen horizontal.
vim.keymap.set('n', 'n', 'nzzzv', opts) -- Keeps next search term in middle of screen.
vim.keymap.set('n', 'N', 'Nzzzv', opts) -- Keeps previous search term in middle of screen.

vim.keymap.set('n', '<leader>nn', ':set nonumber norelativenumber<CR>:set signcolumn=no<CR>', opts)
vim.keymap.set('n', '<leader>sn', ':set number relativenumber<CR>:set signcolumn=yes<CR>', opts)
vim.keymap.set('n', '<leader>san', ':set number norelativenumber<CR>:set signcolumn=yes<CR>', opts)

vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', opts)                   -- Switch panes left.
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', opts)                   -- Switch panes down.
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', opts)                   -- Switch panes up.
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', opts)                   -- Switch panes right.

vim.keymap.set('n', '<leader>rp', '1<C-G>', opts)                     -- Show file fullpath.
vim.keymap.set('n', '<leader>yrp', ':let @+=expand("%:p")<CR>', opts) -- Yank current file's full path into system clipboard.


----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Insert mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set('i', 'jj', '<Esc>', opts)
vim.keymap.set('i', 'yy', '<Esc>', opts)

----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Visual mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set('v', '<Down>', ":m '>+1<CR>gv=gv", opts)  -- For Colemak layout. This might ruin existing prev-word motion, but don't really use that for line visuals anyways.
vim.keymap.set('v', '<Up>', ":m '<-2<CR>gv=gv", opts)  -- For Colemak layout. This might ruin existing prev-end-of-word motion, but don't really use that for line visuals anyways.
vim.keymap.set('x', '/', "<Esc>/\\%V", opts) -- Search in visual range.
vim.keymap.set('x', '<leader>p', "\"_dP")    -- Paste without yanking replaced text into register.


----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Terminal mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set('t', "jj", "<C-\\><C-n>", opts)
