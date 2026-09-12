local git = require("utils.git")
local git_remote_url = require("utils.git_remote_url")

local M = {}

-- Yank GitHub PR or commit URL for the line under cursor based on git blame.
function M.yank_github_blame()
  local context = git.capture()
  if not context then
    return
  end

  git.run_all(context.cwd, {
    { "rev-parse", "--show-toplevel" },
    { "rev-parse", "--abbrev-ref", "HEAD" },
    { "blame", "-L", context.line .. "," .. context.line, "--porcelain", "--", context.path },
  }, function(res)
    local root = git.strip(res[1].stdout)
    if res[1].code ~= 0 or root == "" then
      git.error("Not in a git repository")
      return
    end

    local branch = git.strip(res[2].stdout)
    branch = branch ~= "" and branch or "main"

    if res[3].code ~= 0 or not res[3].stdout or res[3].stdout == "" then
      git.error("This line has not been committed yet")
      return
    end

    -- Extract SHA from porcelain format (first line contains the SHA).
    local sha = res[3].stdout:match("^(%x+)")
    if not sha or sha:match("^0+$") then
      git.error("This line has not been committed yet")
      return
    end

    git.run_all(root, {
      { "config", "branch." .. branch .. ".remote" },
      { "log", "-1", "--pretty=format:%s", sha },
    }, function(res2)
      local remote = git.strip(res2[1].stdout)
      remote = remote ~= "" and remote or "origin"
      local commit_message = git.strip(res2[2].stdout)

      git_remote_url.resolve(root, remote, function(remote_url)
        if not remote_url then
          git.error("Could not get remote URL")
          return
        end

        -- Preserve the existing PR-number heuristic from commit subjects.
        local pr_number = commit_message:match("#(%d+)")
          or commit_message:match("GH%-(%d+)")
          or commit_message:match("pull request #(%d+)")
        if pr_number then
          git.copy(context, remote_url .. "/pull/" .. pr_number, "GitHub PR URL")
        else
          git.copy(context, remote_url .. "/commit/" .. sha, "GitHub commit URL")
        end
      end)
    end)
  end)
end

return M
