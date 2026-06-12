-- Auto-manage 'hlsearch': on for search keys (/ ? n N * # <CR>), off on any
-- other normal-mode key. Keeps highlight while grep-navigating, clears the
-- persistent redraw cost in large files without manual :noh.
-- From https://www.reddit.com/r/neovim/comments/zc720y/ (Mhalter3378's version).
local M = {}

function M.setup()
  local search_keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
  vim.on_key(function(_, typed)
    -- Only react to physically typed keys: `typed` is empty for keys produced
    -- by mapping expansion (e.g. n -> nzzzv), whose z/v would otherwise turn
    -- the highlight right back off.
    if typed == "" or vim.fn.mode() ~= "n" then
      return
    end
    local new_hlsearch = vim.tbl_contains(search_keys, vim.fn.keytrans(typed))
    if vim.o.hlsearch ~= new_hlsearch then
      vim.o.hlsearch = new_hlsearch
    end
  end, vim.api.nvim_create_namespace("auto_hlsearch"))
end

return M
