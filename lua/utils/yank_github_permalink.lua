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

-- Yank GitHub permalink to clipboard for current line or visual selection.
function M.yank_github_permalink()
  -- Capture line numbers before async operations (they might change during execution).
  local start_line, end_line
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then -- visual mode (v, V, or ^V)
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")
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

  -- Phase 1: fire all independent git queries at once.
  run_all({
    { "git", "rev-parse", "--show-toplevel" }, -- 1: repo root (also the "inside repo" gate)
    { "git", "ls-files", "--full-name", "--", file_path }, -- 2: tracked path
    { "git", "diff", "--quiet", "HEAD", "--", file_path }, -- 3: uncommitted-changes gate
    { "git", "log", "-1", "--pretty=format:%H", "--", file_path }, -- 4: last commit SHA
    { "git", "rev-parse", "--abbrev-ref", "HEAD" }, -- 5: branch
  }, function(res)
    local root = strip(res[1].stdout)
    if res[1].code ~= 0 or root == "" then
      err("Not in a git repository")
      return
    end

    local rel_path = strip(res[2].stdout)
    if res[2].code ~= 0 or rel_path == "" then
      err("File not tracked in repository")
      return
    end

    if res[3].code ~= 0 then
      err("File has uncommitted changes!")
      return
    end

    local sha = strip(res[4].stdout)
    if res[4].code ~= 0 or sha == "" then
      err("Could not get commit SHA for this file")
      return
    end

    local branch = strip(res[5].stdout)
    branch = branch ~= "" and branch or "main"

    -- Phase 2: resolve the remote name for this branch (depends on branch).
    vim.system({ "git", "config", "branch." .. branch .. ".remote" }, { text = true }, function(rr)
      local remote = strip(rr.stdout)
      remote = remote ~= "" and remote or "origin"

      local remote_url, is_on_remote
      local remaining = 2

      local function finish()
        remaining = remaining - 1
        if remaining ~= 0 then
          return
        end
        if not is_on_remote then
          err("Last change to this file is not pushed to remote!")
          return
        end
        if not remote_url or remote_url == "" then
          err("Could not get remote URL")
          return
        end
        vim.schedule(function()
          local url = remote_url .. "/blob/" .. sha .. "/" .. rel_path .. "#L" .. start_line
          if start_line ~= end_line then
            url = url .. "-L" .. end_line
          end
          vim.fn.setreg("+", url)
          vim.notify("✓ GitHub permalink copied to clipboard:\n" .. url, vim.log.levels.INFO)
        end)
      end

      -- Phase 3a: cheap single-ref push check (replaces slow `git branch -r --contains`).
      vim.system({ "git", "merge-base", "--is-ancestor", sha, remote .. "/" .. branch }, {}, function(ar)
        is_on_remote = ar.code == 0
        finish()
      end)

      -- Phase 3b: remote URL (cached per root+remote).
      git_remote_url.resolve(root, remote, function(url)
        remote_url = url
        finish()
      end)
    end)
  end)
end

return M
