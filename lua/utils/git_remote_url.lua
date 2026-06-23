local M = {}

-- Cache resolved remote URLs per repo root: cache[repo_root][remote] = https_url.
-- Remote URLs are stable for a repo, so skip re-spawning `git remote get-url`.
local cache = {}

local function strip(s)
  return s and s:gsub("%s+$", "") or ""
end

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
  vim.system({ "git", "remote", "get-url", remote }, { text = true }, function(r)
    if r.code ~= 0 or not r.stdout then
      cb(nil)
      return
    end
    local url = M.to_https(strip(r.stdout))
    cache[root] = cache[root] or {}
    cache[root][remote] = url
    cb(url)
  end)
end

return M
