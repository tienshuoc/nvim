return {
    -- Lualine
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
        require('lualine').setup {
            sections = {
                lualine_z = { { 'datetime', style = '%H:%M:%S | %b-%d' } }
            }
        }
    end,
    
    ------ Integration with `coc-nav` (begin) ------
    -- `CocInstall coc-nav`
      local function breadcrumbs()
          local items = vim.b.coc_nav
          local t = { '' }
          for k, v in ipairs(items) do
              setmetatable(v, {
                  __index = function(table, key)
                      return ' '
                  end
              })
              t[#t + 1] = '%#' ..
                  (v.highlight or "Normal") ..
                  '#' .. (type(v.label) == 'string' and v.label .. ' ' or '') .. '%#Normal#' .. (v.name or '')
              if next(items, k) ~= nil then
                  t[#t + 1] = ' > '
              end
          end
          return table.concat(t)
      end
      require('lualine').setup {
          winbar = {
              lualine_c = { breadcrumbs }
          },
      }
      ------ Integration with `coc-nav` (end) ------

}
