local M = {}

function M.yank_line_ref(opts)
  local path = opts.realpath and vim.uv.fs_realpath(vim.fn.expand("%")) or vim.fn.expand("%")

  -- Normal mode yanks the cursor line; visual mode yanks the live selection
  -- (line("v") is the selection's other end, line(".") the cursor).
  local start_line, end_line
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then -- visual (v, V, or ^V)
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
  else
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

