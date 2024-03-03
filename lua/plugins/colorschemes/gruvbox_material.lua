return {
    'sainnhe/gruvbox-material',
    config = function()
        vim.g.gruvbox_material_dim_inactive_windows = 1
        vim.g.gruvbox_material_background = 'soft'           -- 'hard', 'medium', 'soft'
        vim.g.gruvbox_material_foreground = 'material'       -- 'material', 'mix', 'original'
        vim.g.gruvbox_material_statusline_style = 'original' -- 'default', 'mix', 'original'
        vim.g.gruvbox_material_transparent_background = 0    -- 0, 1, 2 (statsline also transparent)
        vim.g.gruvbox_material_ui_contrast =
        'high'                                               -- 'low', 'high' (contrast of line numbers, indent lines, etc)

        vim.g.gruvbox_material_enable_bold = 1
        vim.g.gruvbox_material_enable_italic = 1

        vim.g.gruvbox_material_diagnostic_text_highlight = 1

        vim.o.background = "dark"
    end,

}
