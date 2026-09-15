local M = {}

function M.get(opts)
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" or vim.bo.buftype ~= "" or not vim.uri_from_bufnr(0):match("^file://") then
    vim.notify("Path shortcuts require a named local file buffer", vim.log.levels.WARN)
    return
  end

  if not (opts and opts.realpath) then
    return vim.fn.expand("%")
  end

  local path = vim.uv.fs_realpath(name)
  if not path then
    vim.notify("Cannot resolve file path on disk: " .. name, vim.log.levels.WARN)
  end
  return path
end

return M
