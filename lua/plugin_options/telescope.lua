local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Find files.
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})  -- Grep amongst files.
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})    -- Find file in buffer list.
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

telescope.setup {
    defaults = {
        path_display = {
            shorten = {
                len = 5, exclude = { 1, -1 } -- Truncate to show 5 letters, except first and first to last.
            }
        },
        wrap_results = true, -- Enable wrap around.
    }
}
