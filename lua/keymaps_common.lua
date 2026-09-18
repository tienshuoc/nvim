-- Editor mappings shared by standalone Neovim and the VS Code extension.
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>w", ":w<CR>", vim.tbl_extend("force", opts, { desc = "Write file." }))

vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", opts)

-- Cursor centering
vim.keymap.set(
  "n",
  "zZ",
  "zszH",
  vim.tbl_extend("force", opts, { desc = "Center cursor on middle of screen horizontal." })
)

vim.keymap.set("c", "<CR>", function()
  local cmdtype = vim.fn.getcmdtype()
  return (cmdtype == "/" or cmdtype == "?") and "<CR>zzzv" or "<CR>"
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
