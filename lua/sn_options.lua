local opts = {
  noremap = true, -- non-recursive
  silent = true, -- do not show message
}

vim.keymap.set("n", "<leader>tl1", ":e /scratch/tienshuoc/1tmp.jsonnet<CR>", opts)
vim.keymap.set("n", "<leader>tl2", ":e /scratch/tienshuoc/2tmp.jsonnet<CR>", opts)
vim.keymap.set("n", "<leader>tl3", ":e /scratch/tienshuoc/3tmp.jsonnet<CR>", opts)
vim.keymap.set("n", "<leader>tl4", ":e /scratch/tienshuoc/4tmp.jsonnet<CR>", opts)
vim.keymap.set("n", "<leader>tl5", ":e /scratch/tienshuoc/5tmp.jsonnet<CR>", opts)
vim.keymap.set("n", "<leader>tl6", ":e /scratch/tienshuoc/6tmp.jsonnet<CR>", opts)

vim.keymap.set("n", "<leader>tlo1", ":e /scratch/tienshuoc/1tmp.list<CR>", opts)
vim.keymap.set("n", "<leader>tlo2", ":e /scratch/tienshuoc/2tmp.list<CR>", opts)
vim.keymap.set("n", "<leader>tlo3", ":e /scratch/tienshuoc/3tmp.list<CR>", opts)
vim.keymap.set("n", "<leader>tlo4", ":e /scratch/tienshuoc/4tmp.list<CR>", opts)
vim.keymap.set("n", "<leader>tlo5", ":e /scratch/tienshuoc/5tmp.list<CR>", opts)
vim.keymap.set("n", "<leader>tlo6", ":e /scratch/tienshuoc/6tmp.list<CR>", opts)

vim.keymap.set("n", "<leader>mks1", ":mksession! ~/s1.vim<CR>", { noremap = true })
vim.keymap.set("n", "<leader>mks2", ":mksession! ~/s2.vim<CR>", { noremap = true })
vim.keymap.set("n", "<leader>mks3", ":mksession! ~/s3.vim<CR>", { noremap = true })
vim.keymap.set("n", "<leader>mks4", ":mksession! ~/s4.vim<CR>", { noremap = true })
vim.keymap.set("n", "<leader>mks5", ":mksession! ~/s5.vim<CR>", { noremap = true })
vim.keymap.set("n", "<leader>mks6", ":mksession! ~/s6.vim<CR>", { noremap = true })
