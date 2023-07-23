local status_ok, configs = pcall(require, "indent_blankline.configs")
if not status_ok then
    return
end

configs.setup {}

vim.keymap.set('n', '<leader>ibld', ':IndentBlanklineDisable<CR>', { noremap = true })
vim.keymap.set('n', '<leader>ible', ':IndentBlanklineEnable<CR>', { noremap = true })
