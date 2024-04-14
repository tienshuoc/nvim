return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-tree/nvim-tree.lua" },
  -- keys = {
  --   "n",
  --   "<leader>fs",
  --   require("auto-session.session-lens").search_session,
  --   { noremap = true },
  -- },
  config = function()
    require("auto-session").setup({
      log_level = "error",

      cwd_change_handling = {
        restore_upcoming_session = true, -- already the default, no need to specify like this, only here as an example
        pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
      },
    })
    -- Restore NvimTreee session if there is one.
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "NvimTree*",
      callback = function()
        local view = require("nvim-tree.view")
        local is_visible = view.is_visible()

        local api = require("nvim-tree.api")
        if not is_visible then
          api.tree.open()
        end
      end,
    })
  end,
}
