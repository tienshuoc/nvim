return {
    -- Neovim DAP
    'mfussenegger/nvim-dap',
    config = function()
        local dap = require('dap')

        -- Keymaps for debugger.
        vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end)
        vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end)
        vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end)
        vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end)
        vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end)
        vim.keymap.set("n", "<leader>dC", function()
            dap.clear_breakpoints()
            require("notify")("Breakpoints cleared", "warn")
        end)
    end,
}
