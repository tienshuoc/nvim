return {
  -- Atom's One Dark and Light theme.
  "navarasu/onedark.nvim",
  config = function()
    require("onedark").setup({
      style = "cool", -- 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
    })
  end,
}
