local git = require("utils.git")
local git_remote_url = require("utils.git_remote_url")

local M = {}

-- Yank GitHub permalink to clipboard for current line or visual selection.
function M.yank_github_permalink()
  local context = git.capture()
  if not context then
    return
  end

  -- Query from the file's directory so discovery and independent reads can overlap.
  git.run_all(context.cwd, {
    { "rev-parse", "--show-toplevel" },
    { "ls-files", "--full-name", "-z", "--", context.path },
    { "diff", "--quiet", "HEAD", "--", context.path },
    { "log", "-1", "--pretty=format:%H", "--", context.path },
    { "rev-parse", "--abbrev-ref", "HEAD" },
    { "rev-parse", "--symbolic-full-name", "@{upstream}" },
  }, function(res)
    local root = git.strip(res[1].stdout)
    if res[1].code ~= 0 or root == "" then
      git.error("Not in a git repository")
      return
    end

    local rel_path = (res[2].stdout or ""):match("^(.-)%z")
    if res[2].code ~= 0 or not rel_path or rel_path == "" then
      git.error("File not tracked in repository")
      return
    end

    if res[3].code ~= 0 then
      git.error("File has uncommitted changes!")
      return
    end

    local sha = git.strip(res[4].stdout)
    if res[4].code ~= 0 or sha == "" then
      git.error("Could not get commit SHA for this file")
      return
    end

    local branch = git.strip(res[5].stdout)
    branch = branch ~= "" and branch or "main"
    local upstream = res[6].code == 0 and git.strip(res[6].stdout) or ""

    git.run(root, { "config", "branch." .. branch .. ".remote" }, function(rr)
      local remote = git.strip(rr.stdout)
      remote = remote ~= "" and remote or "origin"
      local remote_ref = upstream ~= "" and upstream or "refs/remotes/" .. remote .. "/" .. branch

      local remote_url, is_on_remote
      local remaining = 2
      local function finish()
        remaining = remaining - 1
        if remaining ~= 0 then
          return
        end
        if not is_on_remote then
          git.error("Last change to this file is not pushed to remote!")
          return
        end
        if not remote_url or remote_url == "" then
          git.error("Could not get remote URL")
          return
        end
        local url = remote_url .. "/blob/" .. sha .. "/" .. vim.uri_encode(rel_path) .. "#L" .. context.start_line
        if context.start_line ~= context.end_line then
          url = url .. "-L" .. context.end_line
        end
        git.copy(context, url, "GitHub permalink")
      end

      -- Use the upstream's local tracking ref; checking a link must not trigger a fetch.
      git.run(root, { "merge-base", "--is-ancestor", sha, remote_ref }, function(ar)
        is_on_remote = ar.code == 0
        finish()
      end)
      git_remote_url.resolve(root, remote, function(url)
        remote_url = url
        finish()
      end)
    end)
  end)
end

return M
