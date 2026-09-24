local pending_view

return {
  "sindrets/diffview.nvim", -- Git diff page. Requires Git >= 2.31.0 to work properly.
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewLog",
  },
  keys = {
    { "<leader>gg", ":DiffviewOpen<CR>", mode = "n", silent = true, desc = "Diffview." },
  },
  opts = {
    hooks = {
      -- New diff/history requests replace the current view; unsaved index edits block replacement.
      -- SafeState keeps closing views outside Diffview's asynchronous initialization.
      view_opened = function(opened)
        local lib = require("diffview.lib")
        local previous
        for _, view in ipairs(lib.views) do
          if view ~= opened and view.tabpage and vim.api.nvim_tabpage_is_valid(view.tabpage) then
            previous = view
            break
          end
        end

        if previous then
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].modified and vim.api.nvim_buf_get_name(buf):match("^diffview://") then
              vim.api.nvim_create_autocmd("SafeState", {
                once = true,
                callback = function()
                  if
                    not vim.api.nvim_tabpage_is_valid(opened.tabpage)
                    or not vim.api.nvim_tabpage_is_valid(previous.tabpage)
                  then
                    return
                  end
                  opened:close()
                  lib.dispose_view(opened)
                  vim.api.nvim_set_current_tabpage(previous.tabpage)
                  vim.notify("Save or discard Diffview buffer edits before replacing the view", vim.log.levels.WARN)
                end,
              })
              return
            end
          end
        end

        pending_view = opened
        vim.api.nvim_create_autocmd("SafeState", {
          once = true,
          callback = function()
            if pending_view ~= opened then
              return
            end
            pending_view = nil
            if not vim.api.nvim_tabpage_is_valid(opened.tabpage) then
              return
            end
            for _, view in ipairs(vim.list_slice(lib.views)) do
              if view ~= opened and view.tabpage and vim.api.nvim_tabpage_is_valid(view.tabpage) then
                view:close()
                lib.dispose_view(view)
              end
            end
          end,
        })
      end,
      diff_buf_win_enter = function(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        if not name:match("^diffview://") then
          return
        end
        vim.b[buf].source_path = nil
        if name == "diffview://null" then
          return
        end

        -- Expose the revision's file path to generic path shortcuts.
        local view = require("diffview.lib").get_current_view()
        local layout = view and view.cur_layout
        for _, file in ipairs(layout and layout:files() or {}) do
          if file.bufnr == buf and not file.nulled then
            vim.b[buf].source_path = file.absolute_path
            return
          end
        end
      end,
    },
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      },
    },
  },
}
