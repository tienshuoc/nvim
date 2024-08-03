local opts = {
  -- Define common options.
  noremap = true, -- non-recursive
  silent = true, -- do not show message
}

----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Normal mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>nv", ":e ~/.config/nvim/<CR>", opts) -- Edit neovim settings.

opts["desc"] = "Write file."
vim.keymap.set("n", "<leader>w", ":w<CR>", opts)
opts["desc"] = "Quit file."
vim.keymap.set("n", "<leader>qq", ":q<CR>", opts)
opts["desc"] = "Quit all."
vim.keymap.set("n", "<leader>qa", ":qa<CR>", opts)
opts["desc"] = "Close buffer."
vim.keymap.set("n", "<leader>bd", ":bd<CR>", opts)
opts["desc"] = "Close tab."
vim.keymap.set("n", "<leader>tc", ":tabc<CR>", opts)
opts["desc"] = "Switch to previous buffer."
vim.keymap.set("n", "<leader>tt", "<C-^>", opts) -- Switch to previous buffer.

opts["desc"] = "Center cursor on middle of screen horizontal."
vim.keymap.set("n", "zZ", "zszH", opts)
opts["desc"] = "Keeps next search term in middle of screen."
vim.keymap.set("n", "n", "nzzzv", opts)
opts["desc"] = "Keeps previous search term in middle of screen."
vim.keymap.set("n", "N", "Nzzzv", opts)

opts["desc"] = "Toggle relative number."
vim.keymap.set("n", "<leader>trn", ":set relativenumber!<CR>:set signcolumn=yes<CR>", opts)

opts["desc"] = "Toggle line wrap."
vim.keymap.set("n", "<leader>tw", ":set wrap!<CR>", opts)

vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", opts) -- Switch panes left.
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", opts) -- Switch panes down.
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", opts) -- Switch panes up.
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", opts) -- Switch panes right.

opts["desc"] = "Show file fullpath."
vim.keymap.set("n", "<leader>rp", "1<C-G>", opts)
opts["desc"] = "Yank current file's full path into system clipboard."
vim.keymap.set("n", "<leader>yrp", ':let @+=expand("%:p")<CR>', opts)

opts["desc"] = "Close quickfix list."
vim.keymap.set("n", "<leader>ccl", ":ccl<CR>", opts)

-- Go to window by index.
vim.keymap.set("n", "<leader>1", "1<C-W>w", { noremap = true, desc = "Move to window 1." })
vim.keymap.set("n", "<leader>2", "2<C-W>w", { noremap = true, desc = "Move to window 2." })
vim.keymap.set("n", "<leader>3", "3<C-W>w", { noremap = true, desc = "Move to window 3." })
vim.keymap.set("n", "<leader>4", "4<C-W>w", { noremap = true, desc = "Move to window 4." })
vim.keymap.set("n", "<leader>5", "5<C-W>w", { noremap = true, desc = "Move to window 5." })
vim.keymap.set("n", "<leader>6", "6<C-W>w", { noremap = true, desc = "Move to window 6." })

vim.keymap.set("n", "c", '"_c') -- Don't let change text action yank anything into registers.

----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Insert mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set("i", "jj", "<Esc>", opts)
vim.keymap.set("i", "yy", "<Esc>", opts)

----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Visual mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("x", "/", "<Esc>/\\%V", opts) -- Search in visual range.
opts["desc"] = "Paste without yanking replaced text into register."
vim.keymap.set("x", "<leader>p", '"_dP')

----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Terminal mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set("t", "jj", "<C-\\><C-n>", opts)
