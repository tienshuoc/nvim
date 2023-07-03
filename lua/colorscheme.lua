local colorscheme = 'nightfox'

-- monokai_pro
-- nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end
