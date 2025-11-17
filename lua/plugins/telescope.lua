local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then
    return tail
  end
  return string.format("%s\t\t%s", tail, parent)
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
      vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "CursorLine" })
    end)
  end,
})
--- Telescope (fuzzy finder) ---
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true<cr>",
      mode = "n",
      { noremap = true, desc = "Telescope buffers" },
    }, -- Find files in buffer list.
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- Custom action to open all selected files or current file
    local function multi_select_open(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local multi_selection = picker:get_multi_selection()

      if #multi_selection > 0 then
        -- Open all selected files
        actions.close(prompt_bufnr)
        for _, entry in ipairs(multi_selection) do
          vim.cmd(string.format("edit %s", entry.path or entry.filename))
        end
      else
        -- No selections, open current file under cursor
        actions.select_default(prompt_bufnr)
      end
    end

    telescope.setup({
      defaults = { -- Default configuration for telescope.
        -- path_display = {
        --   filename_first = {
        --     reverse_directories = false,
        --   },
        --   shorten = {
        --     len = 5,
        --     exclude = { 1, -1 }, -- Truncate to show 5 letters, except first and first to last.
        --   },
        -- },
        path_display = filename_first, -- This is going to be native soon in the Release, using a custom func for now to do this.
        wrap_results = true, -- Enable wrap around.
        mappings = {
          i = {
            ["<C-u>"] = false, -- Allow Ctrl-U to clear in insert mode.
            ["<C-h>"] = "which_key",
            ["<CR>"] = multi_select_open,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          },
          n = {
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<CR>"] = multi_select_open,
          },
        },
        file_ignore_patterns = {
          "package%-lock.json",
          "package.json",
          "yarn.lock",
          "bazel-cache",
        },
      },
    })
  end,
}
