return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  keys = {
    {
      "<leader>dui",
      function()
        require("dapui").toggle()
      end,
      desc = "Toggle DAP UI",
    },
  },
  config = function()
    local dap = require("dap")
    -- Use nvim-dap events to open/close dap-ui windows automatically.
    local dapui = require("dapui")
    dapui.setup()
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
