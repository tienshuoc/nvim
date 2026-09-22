return {
  -- Neovim DAP
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      -- Virtual text for the debugger.
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    "rcarriga/nvim-dap-ui",
  },
  keys = {
    { "<leader>dc", ":DapContinue<CR>", mode = "n", desc = "DapContinue" },
    { "<leader>dn", ":DapStepOver<CR>", mode = "n", desc = "DapStepOver" },
    { "<leader>di", ":DapStepInto<CR>", mode = "n", desc = "DapStepInto" },
    { "<leader>do", ":DapStepOut<CR>", mode = "n", desc = "DapStepOut" },
    { "<leader>db", ":DapToggleBreakpoint<CR>", desc = "DapToggleBreakpoint" },
    {
      "<leader>dC",
      function()
        require("dap").clear_breakpoints()
      end,
      desc = "Dap clear breakpoints",
    },
    {
      "<leader>dd",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      mode = "n",
      desc = "DAP set breakpoint with condition",
    },
  },
  config = function()
    local dap = require("dap")
    -- CodeLLDB 1.11+ supports stdio; Mason provides its command on PATH.
    dap.adapters.codelldb = {
      type = "executable",
      command = "codelldb",
    }
    -- Preserve theme-defined highlights and fill in missing debugger groups.
    local function set_highlights()
      vim.api.nvim_set_hl(0, "DapBreakpoint", { default = true, link = "DiagnosticError" })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    end
    set_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("dap_highlights", { clear = true }),
      callback = set_highlights,
    })
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "🚦", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = "⚠️", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapStopped",
      { text = "", texthl = "DapStoppedLine", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
    )

    -- Additional C++ launch and attach configurations.
    dap.configurations.cpp = {
      {
        name = "Pick program and launch",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to program: ", vim.fn.getcwd() .. "/bazel-out/k8-dbg/bin/", "file")
        end,
        args = function()
          local input = vim.fn.input("Program arguments: ")
          return require("dap.utils").splitstr(input)
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        sourceMap = {
          ["/proc/self/cwd"] = "${workspaceFolder}",
        },
        initCommands = {
          "settings set target.disable-aslr false",
        },
      },
      {
        name = "Attach to codelldb",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
        args = {},
        -- Optional: Add process ID if attaching to running process
      },
    }
  end,
}
