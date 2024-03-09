local commander = require "commander"

commander.add {
  {
    desc = "toggle lsp",
    cmd = function()
      local buf = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients { bufnr = buf }
      if not vim.tbl_isempty(clients) then
        vim.cmd "LspStop"
      else
        vim.cmd "LspStart"
      end
    end,
  },
}

return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    config = function()
      require("mason").setup {
        ui = {
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = " 󰚌",
          },
        },
        max_concurrent_installers = 10,
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          -- "bashls",
          -- "clangd",
          -- "neocmake", -- 功能全面，如果需要，可以细看
          -- "dockerls",
          -- "autotools-language-server", -- make
          -- "marksman",
          -- "pyright",
          -- "taplo",
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("lspconfig").lua_ls.setup {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      }
    end,
  },
}
