local opts = {
  -- Define common options.
  noremap = true, -- non-recursive
  silent = true, -- do not show message
}

----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Normal mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>nv", ":e ~/.config/nvim/<CR>", opts) -- Edit neovim settings.

vim.keymap.set("n", "<leader>w", ":w<CR>", vim.tbl_extend("force", opts, { desc = "Write file." }))
vim.keymap.set({ "n", "v" }, "<leader>qq", ":<c-u>q<CR>", vim.tbl_extend("force", opts, { desc = "Quit file." }))
vim.keymap.set({ "n", "v" }, "<leader>qa", ":<c-u>qa<CR>", vim.tbl_extend("force", opts, { desc = "Quit all." }))
vim.keymap.set({ "n", "v" }, "<leader>qb", ":<c-u>bd<CR>", vim.tbl_extend("force", opts, { desc = "Close buffer." }))
vim.keymap.set({ "n", "v" }, "<leader>tc", ":<c-u>tabc<CR>", vim.tbl_extend("force", opts, { desc = "Close tab." }))
vim.keymap.set("n", "<leader>tt", "<C-^>", vim.tbl_extend("force", opts, { desc = "Switch to previous buffer." }))

vim.keymap.set(
  "n",
  "zZ",
  "zszH",
  vim.tbl_extend("force", opts, { desc = "Center cursor on middle of screen horizontal." })
)

vim.keymap.set("c", "<CR>", function()
  return vim.fn.getcmdtype() == "/" and "<CR>zzzv" or "<CR>"
end, {
  noremap = true,
  expr = true,
  desc = "Center first search result",
})

vim.keymap.set(
  "n",
  "n",
  "nzzzv",
  vim.tbl_extend("force", opts, { desc = "Keeps next search term in middle of screen." })
)
vim.keymap.set(
  "n",
  "N",
  "Nzzzv",
  vim.tbl_extend("force", opts, { desc = "Keeps previous search term in middle of screen." })
)
vim.keymap.set("n", "G", "Gzz", vim.tbl_extend("force", opts, { desc = "Keeps goto line in middle of screen." }))

vim.keymap.set(
  "n",
  "<leader>trn",
  ":set relativenumber!<CR>:set signcolumn=yes<CR>",
  vim.tbl_extend("force", opts, { desc = "Toggle relative number." })
)

vim.keymap.set("n", "<leader>tw", ":set wrap!<CR>", vim.tbl_extend("force", opts, { desc = "Toggle line wrap." }))

vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", vim.tbl_extend("force", opts, { desc = "Switch panes left." }))
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", vim.tbl_extend("force", opts, { desc = "Switch panes down." }))
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", vim.tbl_extend("force", opts, { desc = "Switch panes up." }))
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", vim.tbl_extend("force", opts, { desc = "Switch panes right." }))

vim.keymap.set("n", "<leader>rp", "1<C-G>", vim.tbl_extend("force", opts, { desc = "Show file fullpath." }))
vim.keymap.set(
  "n",
  "<leader>yrp", -- "Yank Real Path"
  ':let @+=expand("%:p")<CR>',
  vim.tbl_extend("force", opts, { desc = "Yank current file's full path into system clipboard." })
)

vim.keymap.set(
  "n",
  "<leader>ywp", -- "Yank Workspace-relative Path"
  ':let @+=expand("%")<CR>',
  vim.tbl_extend("force", opts, { desc = "Yank current file's workspace-relative path into system clipboard." })
)

vim.keymap.set(
  "n",
  "<leader>yfn", -- "Yank File Name"
  ':let @+=expand("%:t")<CR>',
  vim.tbl_extend("force", opts, { desc = "Yank current filename into system clipboard." })
)

vim.keymap.set("n", "<leader>yln", function() -- "Yank Line Number"
  local relative_path = vim.fn.expand("%")
  local line_number = vim.fn.line(".")
  vim.fn.setreg("+", string.format("%s:%d", relative_path, line_number))
end, {
  desc = "Yank relative file path with line number to clipboard (format: path:line)",
})

vim.keymap.set(
  { "n", "v" },
  "<leader>ccl",
  ":<c-u>ccl<CR>",
  vim.tbl_extend("force", opts, { desc = "Close quickfix list." })
)

-- Go to window by index.
vim.keymap.set("n", "<leader>1", "1<C-W>w", { noremap = true, desc = "Move to window 1." })
vim.keymap.set("n", "<leader>2", "2<C-W>w", { noremap = true, desc = "Move to window 2." })
vim.keymap.set("n", "<leader>3", "3<C-W>w", { noremap = true, desc = "Move to window 3." })
vim.keymap.set("n", "<leader>4", "4<C-W>w", { noremap = true, desc = "Move to window 4." })
vim.keymap.set("n", "<leader>5", "5<C-W>w", { noremap = true, desc = "Move to window 5." })
vim.keymap.set("n", "<leader>6", "6<C-W>w", { noremap = true, desc = "Move to window 6." })
vim.keymap.set("n", "<leader>7", "7<C-W>w", { noremap = true, desc = "Move to window 7." })
vim.keymap.set("n", "<leader>8", "8<C-W>w", { noremap = true, desc = "Move to window 8." })
vim.keymap.set("n", "<leader>9", "9<C-W>w", { noremap = true, desc = "Move to window 9." })

vim.keymap.set("n", "c", '"_c') -- Don't let change text action yank anything into registers.

vim.keymap.set("n", "gV", "`[v`]", { noremap = true, desc = "Select last paste area." })

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

----------------------------------------------------------------------------------------------------------------------------------------
-- ========================================================= Terminal mode ===============================================================
----------------------------------------------------------------------------------------------------------------------------------------
vim.keymap.set("t", "jj", "<C-\\><C-n>", opts)
