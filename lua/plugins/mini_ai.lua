return {
  "nvim-mini/mini.ai",
  version = "*",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    local spec_treesitter = require("mini.ai").gen_spec.treesitter
    require("mini.ai").setup({
      n_lines = 200, -- Number of lines within which textobject is searched
      custom_textobjects = {
        f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
        p = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
        m = spec_treesitter({ a = "@method.outer", i = "@method.inner" }),
        o = spec_treesitter({
          a = { "@conditional.outer", "@loop.outer" },
          i = { "@conditional.inner", "@loop.inner" },
        }),
      },
    })
  end,
}
