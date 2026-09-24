local M = {}
local providers = {}

-- Providers resolve cursor-based entries on demand.
function M.register(filetype, provider)
  providers[filetype] = provider
end

function M.get(opts)
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local source_path
  local provider = providers[vim.bo.filetype]
  if provider then
    source_path = provider(opts)
    if not source_path then
      return
    end
  elseif name == "" or vim.bo.buftype ~= "" or not vim.uri_from_bufnr(buf):match("^file://") then
    -- Virtual-buffer integrations may provide an absolute filesystem path.
    source_path = vim.b[buf].source_path
    if type(source_path) ~= "string" or source_path == "" then
      vim.notify("Path shortcuts require a named local file buffer", vim.log.levels.WARN)
      return
    end
  end

  -- Keep new/deleted paths and symlink spelling usable; only realpath needs a disk entry.
  if not (opts and opts.realpath) then
    return source_path and vim.fn.fnamemodify(source_path, ":.") or vim.fn.expand("%")
  end

  local path = vim.uv.fs_realpath(source_path or name)
  if not path then
    vim.notify("Cannot resolve file path on disk: " .. (source_path or name), vim.log.levels.WARN)
  end
  return path
end

return M
