return {
  -- Neovim DAP
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui", -- UI for nvim-dap.
  },
  keys = {
    { "<leader>dc", ":DapContinue<CR>", mode = "n", desc = "DapContinue", {} },
    { "<leader>dn", ":DapStepOver<CR>", mode = "n", desc = "DapStepOver", {} },
    { "<leader>di", ":DapStepInto<CR>", mode = "n", desc = "DapStepInto", {} },
    { "<leader>do", ":DapStepOut<CR>", mode = "n", desc = "DapStepInto", {} },
    { "<leader>db", ":DapToggleBreakpoint<CR>", desc = "DapToggleBreakpoint" },
  },
  config = function()
    local dap = require("dap")

    -- Use nvim-dap events to open/close dap-ui windows automatically.
    local dapui = require("dapui")
    dapui.setup()
    vim.keymap.set("n", "<leader>dui", dapui.toggle)
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

    -- Keymaps for debugger.
    vim.keymap.set("n", "<leader>dC", function()
      dap.clear_breakpoints()
      -- require("notify")("Breakpoints cleared", "warn")
    end)

    -- C++ (begin)
    dap.adapters.lldb = {
      type = "executable",
      command = "lldb-vscode", -- Use absolute path if necessary.
      name = "lldb",
    }
    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},

        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        -- runInTerminal = false,
      },
    }
    -- C++ (end)
  end,
}
