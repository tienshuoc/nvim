-- Yank a shareable github permalink url for the current file + line to clipboard register.
vim.keymap.set("n", "<leader>gU", function()
  local url = "" -- Add remote repository url here.
    .. vim.fn["fugitive#RevParse"]("HEAD")
    .. "/"
    .. vim.fn.expand("%")
    .. "#L"
    .. vim.fn.line(".")
  vim.fn.setreg("+", url)
  vim.cmd.echo('"' .. url .. '"')
end, { desc = "Yank GitHub URL to clipboard (permalink)." })

return {
  "tpope/vim-fugitive",
  lazy = false,
  keys = {
    { "<leader>gg", ":Git difftool -y<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>gs", vim.cmd.Git, mode = "n", { noremap = true, silent = true } },
  },
}
