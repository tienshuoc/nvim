local git_remote_url = require("utils.git_remote_url")

local M = {}

local function strip(s)
  return s and s:gsub("%s+$", "") or ""
end

local function err(msg)
  vim.schedule(function()
    vim.notify("⚠️ " .. msg, vim.log.levels.ERROR)
  end)
end

-- Run all commands concurrently; call done(results) once every one finishes.
local function run_all(cmds, done)
  local results = {}
  local remaining = #cmds
  for i, cmd in ipairs(cmds) do
    vim.system(cmd, { text = true }, function(r)
      results[i] = r
      remaining = remaining - 1
      if remaining == 0 then
        done(results)
      end
    end)
  end
end

-- Yank GitHub PR or commit URL for the line under cursor based on git blame.
function M.yank_github_blame()
  local line_number = vim.fn.line(".")
  local file_path = vim.uv.fs_realpath(vim.fn.expand("%"))

  if not file_path or file_path == "" then
    vim.notify("⚠️ Not a file buffer", vim.log.levels.ERROR)
    return
  end

  -- Phase 1: repo root (gate + cache key), branch, and blame fire concurrently.
  run_all({
    { "git", "rev-parse", "--show-toplevel" }, -- 1: repo root
    { "git", "rev-parse", "--abbrev-ref", "HEAD" }, -- 2: branch
    { "git", "blame", "-L", line_number .. "," .. line_number, "--porcelain", file_path }, -- 3: blame
  }, function(res)
    local root = strip(res[1].stdout)
    if res[1].code ~= 0 or root == "" then
      err("Not in a git repository")
      return
    end

    local branch = strip(res[2].stdout)
    branch = branch ~= "" and branch or "main"

    if res[3].code ~= 0 or not res[3].stdout or res[3].stdout == "" then
      err("This line has not been committed yet")
      return
    end

    -- Extract SHA from porcelain format (first line contains the SHA).
    local sha = res[3].stdout:match("^(%x+)")
    if not sha or sha:match("^0+$") then
      err("This line has not been committed yet")
      return
    end

    -- Phase 2: remote name (needs branch) and commit message (needs SHA) in parallel.
    run_all({
      { "git", "config", "branch." .. branch .. ".remote" }, -- 1: remote name
      { "git", "log", "-1", "--pretty=format:%s", sha }, -- 2: commit message
    }, function(res2)
      local remote = strip(res2[1].stdout)
      remote = remote ~= "" and remote or "origin"
      local commit_message = strip(res2[2].stdout)

      -- Phase 3: remote URL (cached per root+remote).
      git_remote_url.resolve(root, remote, function(remote_url)
        if not remote_url then
          err("Could not get remote URL")
          return
        end

        -- Look for PR number patterns: (#123), GH-123, or "Merge pull request #123".
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
      end)
    end)
  end)
end

return M
