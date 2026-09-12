local git = require("utils.git")

local M = {}

-- Cache resolved remote URLs per repo root: cache[repo_root][remote] = https_url.
-- Keep the session cache so repeated link requests avoid another Git process.
local cache = {}

-- Convert SSH URL to HTTPS and strip .git suffix.
function M.to_https(remote_url)
  return (remote_url:gsub("^git@(.-):", "https://%1/"):gsub("%.git$", ""))
end

-- Resolve the HTTPS URL for `remote` in repo at `root`, calling cb(url|nil).
-- Cached per (root, remote); cache hits invoke cb synchronously.
function M.resolve(root, remote, cb)
  local hit = cache[root] and cache[root][remote]
  if hit then
    cb(hit)
    return
  end
  git.run(root, { "remote", "get-url", remote }, function(r)
    local url = r.code == 0 and M.to_https(git.strip(r.stdout))
    if not url or url == "" then
      cb(nil)
      return
    end
    cache[root] = cache[root] or {}
    cache[root][remote] = url
    cb(url)
  end)
end

return M
