local M = {}

local location_methods = {
  ["textDocument/definition"] = true,
  ["textDocument/declaration"] = true,
  ["textDocument/typeDefinition"] = true,
  ["textDocument/implementation"] = true,
  ["textDocument/references"] = true,
}

local function normalize_uri(uri, workspace)
  if type(uri) ~= "string" or not uri:match("^file://") then
    return uri
  end
  local path = vim.uri_to_fname(uri)
  if not path:match("/execroot/[^/]+/") then
    return uri
  end
  local resolved = vim.uv.fs_realpath(path)
  -- Only follow aliases back into this workspace; dependencies stay in the cache.
  if not resolved or resolved == path or resolved:sub(1, #workspace + 1) ~= workspace .. "/" then
    return uri
  end
  return vim.uri_from_fname(resolved)
end

local function normalize_result(result, workspace)
  if type(result) ~= "table" then
    return result
  end
  local field = result.uri and "uri" or result.targetUri and "targetUri"
  if field then
    local uri = normalize_uri(result[field], workspace)
    if uri == result[field] then
      return result
    end
    local location = vim.deepcopy(result)
    location[field] = uri
    return location
  end
  return vim.tbl_map(function(location)
    return normalize_result(location, workspace)
  end, result)
end

-- Adapt clangd navigation replies at its transport boundary, before native or
-- picker handlers consume them. Requests and other server messages pass through.
---@param rpc vim.lsp.rpc.Client
---@param root_dir? string
---@return vim.lsp.rpc.Client
function M.wrap_rpc(rpc, root_dir)
  local workspace = root_dir and vim.fs.root(root_dir, { "WORKSPACE", "WORKSPACE.bazel", "MODULE.bazel" })
  workspace = workspace and vim.uv.fs_realpath(workspace)
  if not workspace then
    return rpc
  end

  local request = rpc.request
  rpc.request = function(method, params, callback, ...)
    if location_methods[method] and callback then
      local handler = callback
      callback = function(err, result, ...)
        if not err then
          result = normalize_result(result, workspace)
        end
        return handler(err, result, ...)
      end
    end
    return request(method, params, callback, ...)
  end
  return rpc
end

return M
