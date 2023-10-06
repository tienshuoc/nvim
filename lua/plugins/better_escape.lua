return {
    -- Escape insert mode quickly with customized key combination without lag.
    'jdhao/better-escape.vim',
    event = 'InsertEnter',
    config = function()
        vim.g.better_escape_shortcut = 'jk'
        vim.g.better_escape_interval = 150  -- default 150 (ms)
    end,
}
