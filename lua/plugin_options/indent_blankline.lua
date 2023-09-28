local status_ok, configs = pcall(require, "indent_blankline.configs")
if not status_ok then
    return
end

configs.setup {}

    -- -- vim.opt.list = true
    -- -- vim.opt.listchars:append "eol:↴"
    -- --
    -- require("indent_blankline").setup {
    --     show_current_context = true,
    --     -- show_end_of_line = true,
    -- }

vim.keymap.set('n', '<leader>ibld', ':IndentBlanklineDisable<CR>', { noremap = true })
vim.keymap.set('n', '<leader>ible', ':IndentBlanklineEnable<CR>', { noremap = true })
