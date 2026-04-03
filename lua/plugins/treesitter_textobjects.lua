return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "master",
  dependencies = "nvim-treesitter/nvim-treesitter",
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
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
          },
          include_surrounding_whitespace = false,
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@call.outer",
            ["if"] = "@call.inner",
            ["am"] = "@function.outer",
            ["im"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["a="] = "@assignment.outer",
            ["i="] = "@assignment.inner",
            ["l="] = "@assignment.lhs",
            ["r="] = "@assignment.rhs",
            ["a:"] = "@property.outer",
            ["i:"] = "@property.inner",
            ["l:"] = "@property.lhs",
            ["r:"] = "@property.rhs",
            ["at"] = "@comment.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@call.outer",
            ["]m"] = "@function.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
            ["]s"] = { query = "@local.scope", query_group = "locals" },
            ["]z"] = { query = "@fold", query_group = "folds" },
          },
          goto_next_end = {
            ["]F"] = "@call.outer",
            ["]M"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]I"] = "@conditional.outer",
            ["]L"] = "@loop.outer",
          },
          goto_previous_start = {
            ["[f"] = "@call.outer",
            ["[m"] = "@function.outer",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
          },
          goto_previous_end = {
            ["[F"] = "@call.outer",
            ["[M"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[I"] = "@conditional.outer",
            ["[L"] = "@loop.outer",
          },
        },
      },
    })

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- This is needed to make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}