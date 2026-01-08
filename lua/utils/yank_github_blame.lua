local M = {}

-- Helper to get remote URL
local function get_remote_url(callback)
  vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }, function(branch_result)
    local branch = branch_result.stdout and branch_result.stdout:gsub("%s+$", "") or "main"

    vim.system({ "git", "config", "branch." .. branch .. ".remote" }, { text = true }, function(remote_result)
      local remote = remote_result.stdout and remote_result.stdout:gsub("%s+$", "") or ""
      remote = remote ~= "" and remote or "origin"

      vim.system({ "git", "remote", "get-url", remote }, { text = true }, function(url_result)
        if url_result.code ~= 0 or not url_result.stdout then
          callback(nil)
          return
        end

        local remote_url = url_result.stdout:gsub("%s+$", "")
        -- Convert SSH URL to HTTPS and strip .git suffix
        remote_url = remote_url:gsub("^git@(.-):", "https://%1/"):gsub("%.git$", "")
        callback(remote_url)
      end)
    end)
  end)
end

-- Yank GitHub PR or commit URL for the line under cursor based on git blame
function M.yank_github_blame()
  local line_number = vim.fn.line(".")
  local file_path = vim.uv.fs_realpath(vim.fn.expand("%"))

  if not file_path or file_path == "" then
    vim.notify("⚠️ Not a file buffer", vim.log.levels.ERROR)
    return
  end

  -- Check if we're in a git repository
  vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }, function(result)
    local is_git_repo = result.stdout and result.stdout:gsub("%s+$", "") or ""
    if result.code ~= 0 or is_git_repo ~= "true" then
      vim.schedule(function()
        vim.notify("⚠️ Not in a git repository", vim.log.levels.ERROR)
      end)
      return
    end

    -- Get git blame for the current line
    vim.system({
      "git",
      "blame",
      "-L",
      line_number .. "," .. line_number,
      "--porcelain",
      file_path,
    }, { text = true }, function(blame_result)
      if blame_result.code ~= 0 or not blame_result.stdout or blame_result.stdout == "" then
        vim.schedule(function()
          vim.notify("⚠️ This line has not been committed yet", vim.log.levels.ERROR)
        end)
        return
      end

      -- Extract SHA from porcelain format (first line contains the SHA)
      local sha = blame_result.stdout:match("^(%x+)")
      if not sha or sha:match("^0+$") then
        vim.schedule(function()
          vim.notify("⚠️ This line has not been committed yet", vim.log.levels.ERROR)
        end)
        return
      end

      -- Now we have the SHA, get remote URL and commit message in parallel
      local remote_url, commit_message
      local completed = 0

      local function try_finish()
        completed = completed + 1
        if completed == 2 then
          if not remote_url then
            vim.schedule(function()
              vim.notify("⚠️ Could not get remote URL", vim.log.levels.ERROR)
            end)
            return
          end

          -- Look for PR number patterns: (#123), GH-123, or "Merge pull request #123"
          local pr_number = commit_message:match("#(%d+)")
            or commit_message:match("GH%-(%d+)")
            or commit_message:match("pull request #(%d+)")

          vim.schedule(function()
            local url
            if pr_number then
              url = remote_url .. "/pull/" .. pr_number
              vim.fn.setreg("+", url)
              vim.notify("✓ GitHub PR URL copied to clipboard:\n" .. url, vim.log.levels.INFO)
            else
              url = remote_url .. "/commit/" .. sha
              vim.fn.setreg("+", url)
              vim.notify("✓ GitHub commit URL copied to clipboard:\n" .. url, vim.log.levels.INFO)
            end
          end)
        end
      end

      -- Get remote URL
      get_remote_url(function(url)
        remote_url = url
        try_finish()
      end)

      -- Get commit message
      vim.system({ "git", "log", "-1", "--pretty=format:%s", sha }, { text = true }, function(msg_result)
        commit_message = msg_result.stdout and msg_result.stdout:gsub("%s+$", "") or ""
        try_finish()
      end)
    end)
  end)
end

return M
