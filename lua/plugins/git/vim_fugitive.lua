return {
  "tpope/vim-fugitive",
  keys = {
    { "<leader>gv", ":Gvdiffsplit ", mode = "n", { noremap = true, desc = "Gvdiffsplit" } },
    {
      "<leader>gU",
      function()
        -- Check if we're in a git repository
        local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):gsub("%s+$", "")
        if is_git_repo ~= "true" then
          vim.notify("⚠️ Not in a git repository", vim.log.levels.ERROR)
          return
        end

        -- Get current commit SHA
        local sha = vim.fn.system("git rev-parse HEAD 2>/dev/null"):gsub("%s+$", "")
        if sha == "" then
          vim.notify("⚠️ Could not get commit SHA", vim.log.levels.ERROR)
          return
        end

        -- Check if commit exists on remote
        local remote_branches = vim.fn.systemlist("git branch -r --contains " .. sha .. " 2>/dev/null")
        if #remote_branches == 0 then
          vim.notify("⚠️ Commit not pushed to remote!", vim.log.levels.ERROR)
          return
        end

        -- Get current branch for remote configuration
        local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("%s+$", "")

        -- Get remote URL information
        local remote = vim.fn.system("git config branch." .. branch .. ".remote 2>/dev/null"):gsub("%s+$", "")
        remote = remote ~= "" and remote or "origin"

        local remote_url = vim.fn.system("git remote get-url " .. remote .. " 2>/dev/null"):gsub("%s+$", "")
        -- Convert SSH URL to HTTPS and strip .git suffix
        remote_url = remote_url:gsub("^git@(.-):", "https://%1/"):gsub("%.git$", "")

        -- Get relative file path from repo root
        local file_path = vim.fn.expand("%:p")
        local rel_path_output =
          vim.fn.systemlist("git ls-files --full-name -- " .. vim.fn.shellescape(file_path) .. " 2>/dev/null")
        if vim.v.shell_error ~= 0 or not rel_path_output[1] then
          vim.notify("⚠️ File not tracked in repository", vim.log.levels.ERROR)
          return
        end
        local rel_path = rel_path_output[1]

        -- Check for uncommitted changes in this file
        local is_dirty = vim.fn.system("git diff --quiet HEAD -- " .. vim.fn.shellescape(file_path) .. " 2>/dev/null")
        if vim.v.shell_error ~= 0 then
          vim.notify("⚠️ File has uncommitted changes!", vim.log.levels.ERROR)
          return
        end

        -- Construct GitHub URL with line number
        local line = vim.fn.line(".")
        local url = remote_url .. "/blob/" .. sha .. "/" .. rel_path .. "#L" .. line

        -- Yank to clipboard and notify
        vim.fn.setreg("+", url)
        vim.notify("✓ GitHub permalink copied to clipboard:\n" .. url, vim.log.levels.INFO)
      end,
      mode = "n",
      { noremap = true, desc = "Yank GitHub URL (permalink) to clipboard." },
    },
  },
}
