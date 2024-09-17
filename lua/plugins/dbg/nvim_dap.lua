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
    -- Keymaps for debugger.
    vim.keymap.set("n", "<leader>dC", function()
      require("dap").clear_breakpoints()
      -- require("notify")("Breakpoints cleared", "warn")
    end, { desc = "Clear breakpoints." })

    local dap = require("dap")
    -- C++ (begin)
    dap.adapters.lldb = {
      type = "executable",
      command = "<PATH_TO_lldb-vscode>", -- Use absolute path if necessary.
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
        stopOnEntry = true,
        args = function()
          -- return vim.fn.input("Args to executable: ")
          -- Prompt the user for arguments to pass to the program
          local input = vim.fn.input("Program arguments: ")
          return vim.split(input, " ") -- split the input string by spaces into a table
        end,

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
