return {
  -- Neovim DAP
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    {
      -- Virtual text for the debugger.
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
  },
  keys = {
    { "<leader>dc", ":DapContinue<CR>", mode = "n", desc = "DapContinue", {} },
    { "<leader>dn", ":DapStepOver<CR>", mode = "n", desc = "DapStepOver", {} },
    { "<leader>di", ":DapStepInto<CR>", mode = "n", desc = "DapStepInto", {} },
    { "<leader>do", ":DapStepOut<CR>", mode = "n", desc = "DapStepOut", {} },
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
    require("mason-nvim-dap").setup()
    -- Adapter setup
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },
      },
    }
    -- Visually highlight the stop line if highlight group rules haven't been specified.
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#E06C75", bg = "#282C34", bold = true }) -- Warmer red for better visibility
    vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61AFEF", bg = "#1E222A", italic = true }) -- Slightly darker background for contrast
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#56B6C2", bg = "#1E222A", bold = true }) -- Cyan pop-out for clarity
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

    -- setup dap config by VsCode launch.json file
    -- Default path is `~/.vscode/launch.json`
    dap.configurations.cpp = {
      {
        name = "Pick program and launch",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to program: ", vim.fn.getcwd() .. "/bazel-out/k8-dbg/bin/", "file")
        end,
        args = function()
          -- return vim.fn.input("Args to executable: ")
          -- Prompt the user for arguments to pass to the program
          local input = vim.fn.input("Program arguments: ")
          return vim.split(input, " ") -- split the input string by spaces into a table
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

    -- TODO
    -- local vscode = require("dap.ext.vscode")
    -- local json = require("plenary.json")/home/tienshuoc/.local/share/nvim/lazy/nvim-dap/doc/dap.txt
    -- vscode.json_decode = function(str)
    --   return vim.json.decode(json.json_strip_comments(str))
    -- end
  end,
}
