local M = {}

-- Yank GitHub permalink to clipboard for current line or visual selection
function M.yank_github_permalink()
  -- Check if we're in a git repository.
  local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):gsub("%s+$", "")
  if is_git_repo ~= "true" then
    vim.notify("⚠️ Not in a git repository", vim.log.levels.ERROR)
    return
  end

  -- Get relative file path from repo root.
  local file_path = vim.uv.fs_realpath(vim.fn.expand("%"))
  if file_path == "" then
    vim.notify("⚠️ Not a file buffer", vim.log.levels.ERROR)
    return
  end
  local rel_path_output =
    vim.fn.systemlist("git ls-files --full-name -- " .. vim.fn.shellescape(file_path) .. " 2>/dev/null")
  if vim.v.shell_error ~= 0 or not rel_path_output[1] then
    vim.notify("⚠️ File not tracked in repository", vim.log.levels.ERROR)
    return
  end
  local rel_path = rel_path_output[1]

  -- Check for uncommitted changes in this file.
  vim.fn.system("git diff --quiet HEAD -- " .. vim.fn.shellescape(file_path) .. " 2>/dev/null")
  -- Getting the exit code from the previous command.
  if vim.v.shell_error ~= 0 then
    vim.notify("⚠️ File has uncommitted changes!", vim.log.levels.ERROR)
    return
  end

  -- Get SHA of the last commit that touched this file.
  local sha = vim.fn
    .system("git log -1 --pretty=format:%H -- " .. vim.fn.shellescape(file_path) .. " 2>/dev/null")
    :gsub("%s+$", "")
  if sha == "" then
    vim.notify("⚠️ Could not get commit SHA for this file", vim.log.levels.ERROR)
    return
  end

  -- Check if the commit that last touched the file exists on remote.
  local remote_branches = vim.fn.systemlist("git branch -r --contains " .. sha .. " 2>/dev/null")
  if #remote_branches == 0 then
    vim.notify("⚠️ Last change to this file is not pushed to remote!", vim.log.levels.ERROR)
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

  -- Determine line range based on mode
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
end

return M
