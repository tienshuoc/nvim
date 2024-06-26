return {
  "phaazon/hop.nvim",
  branch = "v2", -- optional but strongly recommended
  keys = {
    { "<leader>hw", ":HopWordMW<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>ha", ":HopAnywhere<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>hp", ":HopPattern<CR>", mode = "n", { noremap = true, silent = true } },
    { "<leader>hc", ":HopChar1MW<CR>", mode = "n", { noremap = true, silent = true } },
    {
      "<leader>hs",
      function()
        require("hop").hint_patterns({ multi_windows = true }, '[#,.\\[\\]{}&()"|;:!=<>?*/]')
      end,
      { noremap = true, silent = true },
      desc = "Hop symbols",
    },
  },
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require("hop").setup({ keys = "arstneioplfuwyqgjdhvkcxzb" })

    local hop = require("hop")

    local directions = require("hop.hint").HintDirection
    vim.keymap.set("", "f", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, { remap = true })
    vim.keymap.set("", "F", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { remap = true })
    vim.keymap.set("", "t", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end, { remap = true })
    vim.keymap.set("", "T", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    end, { remap = true })
  end,
}
