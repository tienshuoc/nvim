local M = {}

-- Remove Git's line terminator without trimming whitespace from filenames.
function M.strip(s)
  return ((s or ""):gsub("\n$", ""))
end

function M.error(message)
  vim.notify("⚠️ " .. message, vim.log.levels.ERROR)
end

-- Use a captured directory for every process; callbacks may safely use Neovim APIs.
function M.run(cwd, args, callback)
  local cmd = vim.list_extend({ "git", "--literal-pathspecs" }, args)
  vim.system(cmd, { cwd = cwd, text = true }, vim.schedule_wrap(callback))
end

function M.run_all(cwd, commands, callback)
  local results = {}
  local remaining = #commands
  for i, args in ipairs(commands) do
    M.run(cwd, args, function(result)
      results[i] = result
      remaining = remaining - 1
      if remaining == 0 then
        callback(results)
      end
    end)
  end
end

-- Capture the source buffer and selection before any asynchronous work.
function M.capture()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local path = name ~= "" and vim.uv.fs_realpath(name)
  local stat = path and vim.uv.fs_stat(path)
  if vim.bo[buf].buftype ~= "" or not stat or stat.type ~= "file" then
    M.error("Not a file buffer")
    return
  end
  if vim.bo[buf].modified then
    M.error("Buffer has unsaved changes; save it before creating a GitHub link")
    return
  end

  local line = vim.fn.line(".")
  local start_line, end_line = line, line
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    start_line = vim.fn.line("v")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
  end

  return {
    buf = buf,
    name = name,
    path = path,
    cwd = vim.fs.dirname(path),
    changedtick = vim.api.nvim_buf_get_changedtick(buf),
    line = line,
    start_line = start_line,
    end_line = end_line,
  }
end

function M.copy(context, url, label)
  if
    not vim.api.nvim_buf_is_loaded(context.buf)
    or vim.api.nvim_buf_get_name(context.buf) ~= context.name
    or vim.api.nvim_buf_get_changedtick(context.buf) ~= context.changedtick
    or vim.bo[context.buf].modified
  then
    M.error("Buffer changed while creating the GitHub link; try again")
    return
  end
  vim.fn.setreg("+", url)
  vim.notify("✓ " .. label .. " copied to clipboard:\n" .. url, vim.log.levels.INFO)
end

return M
