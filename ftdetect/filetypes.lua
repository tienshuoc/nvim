vim.filetype.add({
  extension = {
    list = "list",
    log = "log",
    LOG = "log",
    report = "log",
  },
  pattern = {
    [".*_IR%.log"] = { "mlir", { priority = 10 } },
    [".*%.log%.0"] = "log",
    [".*_log"] = "log",
    [".*_LOG"] = "log",
  },
})
