return {
  -- Smooth scrolling.
  "karb94/neoscroll.nvim",
  config = function()
    local neoscroll = require("neoscroll")
    neoscroll.setup({
      hide_cursor = false, -- Keep the cursor visible while scrolling.
    })
    local keymap = {
      -- Use the "sine" easing function
      ["<C-u>"] = function()
        neoscroll.ctrl_u({ duration = 350, easing = "sine" })
      end,
      ["<C-d>"] = function()
        neoscroll.ctrl_d({ duration = 350, easing = "sine" })
      end,
      -- Use the "circular" easing function
      ["<C-b>"] = function()
        neoscroll.ctrl_b({ duration = 450, easing = "circular" })
      end,
      ["<C-f>"] = function()
        neoscroll.ctrl_f({ duration = 450, easing = "circular" })
      end,
    }
    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
