local git = require("utils.git")

local M = {}

-- Cache resolved remote URLs per repo root: cache[repo_root][remote] = browser_url.
-- Keep the session cache so repeated link requests avoid another Git process.
local cache = {}

-- Convert GitHub-style clone URLs to browser URLs without embedded credentials.
function M.to_https(remote_url)
  if remote_url:find("[%s?#]") then
    return
  end

  local scheme, host, path = remote_url:match("^(https?)://([^/]+)/(.+)$")
  local is_ssh = not scheme
  if is_ssh then
    host, path = remote_url:match("^ssh://([^/]+)/(.+)$")
    if not host and not remote_url:find("://", 1, true) then
      host, path = remote_url:match("^([^/]*%b[]):([^:].*)$")
      if not host then
        host, path = remote_url:match("^([^/:%[%]]+):([^:].*)$")
      end
    end
    scheme = "https"
  end
  if not host then
    return
  end

  host = host:gsub("^.*@", "")
  if is_ssh then
    host = host:gsub(":%d+$", "") -- SSH transport ports are not web ports.
    if host:lower() == "ssh.github.com" then
      host = "github.com"
    end
  end
  path = path:gsub("^/+", ""):gsub("/+$", ""):gsub("%.git$", "")
  if host == "" or path == "" then
    return
  end
  return scheme .. "://" .. host .. "/" .. path
end

-- Resolve the browser URL for `remote` in repo at `root`, calling cb(url|nil).
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
