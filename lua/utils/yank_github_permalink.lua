local M = {}

-- Yank GitHub permalink to clipboard for current line or visual selection
function M.yank_github_permalink()
  -- Capture line numbers before async operations (they might change during execution)
  local start_line, end_line
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then -- visual mode (v, V, or ^V)
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")
    -- Ensure start_line <= end_line
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
  else -- normal mode
    start_line = vim.fn.line(".")
    end_line = start_line
  end

  local file_path = vim.uv.fs_realpath(vim.fn.expand("%"))
  if not file_path or file_path == "" then
    vim.notify("⚠️ Not a file buffer", vim.log.levels.ERROR)
    return
  end

  -- Check if we're in a git repository.
  vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }, function(result)
    local is_git_repo = result.stdout and result.stdout:gsub("%s+$", "") or ""
    if result.code ~= 0 or is_git_repo ~= "true" then
      vim.schedule(function()
        vim.notify("⚠️ Not in a git repository", vim.log.levels.ERROR)
      end)
      return
    end

    vim.system({ "git", "ls-files", "--full-name", "--", file_path }, { text = true }, function(ls_result)
      if ls_result.code ~= 0 or not ls_result.stdout or ls_result.stdout == "" then
        vim.schedule(function()
          vim.notify("⚠️ File not tracked in repository", vim.log.levels.ERROR)
        end)
        return
      end
      local rel_path = ls_result.stdout:gsub("%s+$", "")

      -- Check for uncommitted changes in this file.
      vim.system({ "git", "diff", "--quiet", "HEAD", "--", file_path }, {}, function(diff_result)
        if diff_result.code ~= 0 then
          vim.schedule(function()
            vim.notify("⚠️ File has uncommitted changes!", vim.log.levels.ERROR)
          end)
          return
        end

        -- Get SHA of the last commit that touched this file.
        vim.system({ "git", "log", "-1", "--pretty=format:%H", "--", file_path }, { text = true }, function(log_result)
          if log_result.code ~= 0 or not log_result.stdout or log_result.stdout == "" then
            vim.schedule(function()
              vim.notify("⚠️ Could not get commit SHA for this file", vim.log.levels.ERROR)
            end)
            return
          end
          local sha = log_result.stdout:gsub("%s+$", "")

          -- Check if the commit that last touched the file exists on remote.
          vim.system({ "git", "branch", "-r", "--contains", sha }, { text = true }, function(branch_result)
            if branch_result.code ~= 0 or not branch_result.stdout or branch_result.stdout == "" then
              vim.schedule(function()
                vim.notify("⚠️ Last change to this file is not pushed to remote!", vim.log.levels.ERROR)
              end)
              return
            end

            -- Get current branch for remote configuration
            vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }, function(branch_name_result)
              local branch = branch_name_result.stdout and branch_name_result.stdout:gsub("%s+$", "") or "main"

              -- Get remote URL information
              vim.system({ "git", "config", "branch." .. branch .. ".remote" }, { text = true }, function(remote_result)
                local remote = remote_result.stdout and remote_result.stdout:gsub("%s+$", "") or ""
                remote = remote ~= "" and remote or "origin"

                vim.system({ "git", "remote", "get-url", remote }, { text = true }, function(url_result)
                  if url_result.code ~= 0 or not url_result.stdout then
                    vim.schedule(function()
                      vim.notify("⚠️ Could not get remote URL", vim.log.levels.ERROR)
                    end)
                    return
                  end
                  local remote_url = url_result.stdout:gsub("%s+$", "")
                  -- Convert SSH URL to HTTPS and strip .git suffix
                  remote_url = remote_url:gsub("^git@(.-):", "https://%1/"):gsub("%.git$", "")

                  vim.schedule(function()
                    -- Construct GitHub URL with line number or range
                    local url
                    if start_line == end_line then
                      url = remote_url .. "/blob/" .. sha .. "/" .. rel_path .. "#L" .. start_line
                    else
                      url = remote_url .. "/blob/" .. sha .. "/" .. rel_path .. "#L" .. start_line .. "-L" .. end_line
                    end

                    -- Yank to clipboard and notify
                    vim.fn.setreg("+", url)
                    vim.notify("✓ GitHub permalink copied to clipboard:\n" .. url, vim.log.levels.INFO)
                  end)
                end)
              end)
            end)
          end)
        end)
      end)
    end)
  end)
end

return M
