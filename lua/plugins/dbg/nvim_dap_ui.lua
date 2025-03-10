return {
  "rcarriga/nvim-dap-ui",
  lazy = true,
  event = "VeryLazy",
  dependencies = "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    -- Use nvim-dap events to open/close dap-ui windows automatically.
    local dapui = require("dapui")
    dapui.setup()
    vim.keymap.set("n", "<leader>dui", dapui.toggle, { desc = "Toggle DAP UI" })
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}
