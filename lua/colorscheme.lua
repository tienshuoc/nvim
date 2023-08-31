local colorscheme = 'dracula'

-- monokai_pro
-- nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
-- dracula, dracula-soft
-- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
-- onehalflight, onehalfdark
-- kanagawa, kanagawa-wave, kanagawa-lotus, kanagawa-dragon

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end
