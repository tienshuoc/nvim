return {
  "mxsdev/nvim-dap-vscode-js",
  dependencies = {
    "mfussenegger/nvim-dap",
    {
      "microsoft/vscode-js-debug",
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out", -- Required commands to run after installation and updates.
    },
  },
  -- build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  config = function()
    require("dap-vscode-js").setup({
      node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug", -- The dap `vscode-js-debug` specified in dependencies above would be installed by lazy, need to point to it for this to work.
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
      log_console_level = vim.log.levels.ERROR, -- Logging level for output to console. Set to false to disable console output.
    })

    for _, language in ipairs({ "typescript", "javascript" }) do
      require("dap").configurations[language] = {
        {
          -- For typescript, make sure you have `sourceMap`: true enbled in tsconfig.json.
          -- This generates `.map` files to map js code to ts code. This allows debugging ts code when executing js.
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          -- program = "${file}",
          outFiles = { "${workspaceFolder}/**/dist/*.js" },
          stopOnEntry = true,
          program = "dist/day2.js",
          cwd = "${workspaceFolder}",
        },
        -- {
        --   type = "pwa-node",
        --   request = "attach",
        --   name = "Attach",
        --   processId = require("dap.utils").pick_process,
        --   cwd = "${workspaceFolder}",
        -- },
      }
    end
  end,
}
