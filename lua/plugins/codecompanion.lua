return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "sambacloud",
          slash_commands = {
            ["file"] = {
              -- Location to the slash command in CodeCompanion
              callback = "strategies.chat.slash_commands.file",
              description = "Select a file using Fzf-Lua",
              opts = {
                provider = "fzf_lua", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
                contains_code = true,
              },
            },
            ["buffer"] = {
              callback = "strategies.chat.slash_commands.buffer",
              description = "Select a buffer using Fzf-Lua",
              opts = {
                provider = "fzf_lua",
                contains_code = true,
              },
            },
          },
        },
        inline = {
          adapter = "sambacloud",
        },
        agent = {
          adapter = "sambacloud",
        },
      },
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "llama3.2",
              },
            },
          })
        end,
        sambacloud = function()
          -- Remember to add "$XDG_CONFIG_HOME/shh_my_api_keys.lua" with :
          -- return {
          --           sambacloud_api_key = "some_api_key",
          --       }
          local ok, api_keys = pcall(require, "shh_my_api_keys")
          local api_key = ok and api_keys.sambacloud_api_key or nil
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://api.sambanova.ai",
              api_key = api_key,
              chat_url = "/v1/chat/completions", -- This is already the default. Just being explicit.
            },
            schema = {
              model = {
                default = "Meta-Llama-3.1-8B-Instruct",
              },
            },
          })
        end,
      },
      opts = {
        language = "English", -- This comes with the default system prompt.
        --   system_prompt = function(opts) -- Override default system prompt.
        --     return "My new system prompt"
        --   end,
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "telescope", -- default|telescope|mini_pick
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
      },
    })
    vim.keymap.set({ "n", "v" }, "<leader>cct", function()
      require("codecompanion").toggle()
    end, { noremap = true, desc = "Toggle CodeCompanionChat" })
    vim.keymap.set(
      { "n", "v" },
      "<leader>ccb",
      ":CodeCompanion /buffer ",
      { noremap = true, desc = "CodeCompanion /buffer" } -- "ga": Accept change, "gr": Reject change.
    )
  end,
}
