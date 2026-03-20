return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  dependencies = "nvim-treesitter/nvim-treesitter",
  branch = "main",
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    })

    local ts_select = require("nvim-treesitter-textobjects.select")
    local ts_move = require("nvim-treesitter-textobjects.move")
    local ts_swap = require("nvim-treesitter-textobjects.swap")

    vim.keymap.set({ "o", "x" }, "aa", function()
      ts_select.select_textobject("@parameter.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "ia", function()
      ts_select.select_textobject("@parameter.inner", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "af", function()
      ts_select.select_textobject("@call.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "if", function()
      ts_select.select_textobject("@call.inner", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "am", function()
      ts_select.select_textobject("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "im", function()
      ts_select.select_textobject("@function.inner", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "ac", function()
      ts_select.select_textobject("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "ic", function()
      ts_select.select_textobject("@class.inner", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "ai", function()
      ts_select.select_textobject("@conditional.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "ii", function()
      ts_select.select_textobject("@conditional.inner", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "al", function()
      ts_select.select_textobject("@loop.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "il", function()
      ts_select.select_textobject("@loop.inner", "textobjects")
    end)

    vim.keymap.set({ "o", "x" }, "a=", function()
      ts_select.select_textobject("@assignment.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "i=", function()
      ts_select.select_textobject("@assignment.inner", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "l=", function()
      ts_select.select_textobject("@assignment.lhs", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "r=", function()
      ts_select.select_textobject("@assignment.rhs", "textobjects")
    end)

    vim.keymap.set({ "o", "x" }, "a:", function()
      ts_select.select_textobject("@property.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "i:", function()
      ts_select.select_textobject("@property.inner", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "l:", function()
      ts_select.select_textobject("@property.lhs", "textobjects")
    end)
    vim.keymap.set({ "o", "x" }, "r:", function()
      ts_select.select_textobject("@property.rhs", "textobjects")
    end)

    vim.keymap.set({ "o", "x" }, "at", function()
      ts_select.select_textobject("@comment.outer", "textobjects")
    end)

    vim.keymap.set("n", "<leader>a", function()
      ts_swap.swap_next("@parameter.inner")
    end)
    vim.keymap.set("n", "<leader>A", function()
      ts_swap.swap_previous("@parameter.outer")
    end)

    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      ts_move.goto_next_start("@call.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]m", function()
      ts_move.goto_next_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]i", function()
      ts_move.goto_next_start("@conditional.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]l", function()
      ts_move.goto_next_start("@loop.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]s", function()
      ts_move.goto_next_start("@local.scope", "locals")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]z", function()
      ts_move.goto_next_start("@fold", "folds")
    end)

    vim.keymap.set({ "n", "x", "o" }, "]F", function()
      ts_move.goto_next_end("@call.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]M", function()
      ts_move.goto_next_end("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]C", function()
      ts_move.goto_next_end("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]I", function()
      ts_move.goto_next_end("@conditional.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]L", function()
      ts_move.goto_next_end("@loop.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      ts_move.goto_previous_start("@call.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[m", function()
      ts_move.goto_previous_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[i", function()
      ts_move.goto_previous_start("@conditional.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[l", function()
      ts_move.goto_previous_start("@loop.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "[F", function()
      ts_move.goto_previous_end("@call.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[M", function()
      ts_move.goto_previous_end("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[C", function()
      ts_move.goto_previous_end("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[I", function()
      ts_move.goto_previous_end("@conditional.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[L", function()
      ts_move.goto_previous_end("@loop.outer", "textobjects")
    end)

    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
