return {
  "rcarriga/nvim-dap-ui",
  event = "VeryLazy",
  dependencies = "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    -- Use nvim-dap events to open/close dap-ui windows automatically.
    local dapui = require("dapui")
    dapui.setup()
    vim.keymap.set("n", "<leader>dui", dapui.toggle, { desc = "Toggle DapUI" })
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
  end,
}
