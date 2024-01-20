-- Note: Neovim 10.0+ supports OSC52 natively, there's no need for this plugin.
-- Shares a SSH vim's clipboard with local clipboard.
return {
    'ojroques/nvim-osc52',
    branch = main,
    lazy = false,
    config = function()
        vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
        vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
        vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)
    end
}
