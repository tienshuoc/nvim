local M = {}

function M.yank_line_ref(opts)
  local path = opts.realpath and vim.uv.fs_realpath(vim.fn.expand("%")) or vim.fn.expand("%")
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  if start_line <= 0 or end_line <= 0 or start_line == end_line then
    start_line = vim.fn.line(".")
    end_line = start_line
  end

  local ref
  if start_line == end_line then
    ref = string.format("%s:%d", path, start_line)
  else
    ref = string.format("%s:%d-%d", path, start_line, end_line)
  end

  vim.fn.setreg("+", ref)
  vim.notify(opts.msg .. "\n" .. ref)
end

return M

