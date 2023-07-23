local status_ok, configs = pcall(require, "nvim-telescope.configs")
if not status_ok then
    return
end

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})      -- Find files.
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})       -- Grep amongst files.
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})         -- Find file in buffer list.
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

configs.setup {
    defaults = {
        path_display = {
            shorten = {
                len = 5, exclude = { 1, -1 }            -- Truncate to show 5 letters, except first and first to last.
            }
        },
        wrap_results = true,                            -- Enable wrap around.
    }
}
