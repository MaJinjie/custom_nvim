return {
  -- autopairing of (){}[] etc
  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- setup cmp for autopairs
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  -- -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find "Windows")
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = { "rafamadriz/friendly-snippets" },
    -- config
    config = function()
      local luasnip = require "luasnip"
      local types = require "luasnip.util.types"

      -- setup
      luasnip.config.setup {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "●", "GruvboxOrange" } },
            },
          },
          [types.insertNode] = {
            active = {
              virt_text = { { "●", "GruvboxBlue" } },
            },
          },
        },
      }

      -- set snippets path
      require("luasnip.loaders.from_vscode").lazy_load { paths = vim.ctx.path.snippets }

      -- autocmds
      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
            luasnip.unlink_current()
          end
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- sources
      {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "dmitmel/cmp-cmdline-history",
        "hrsh7th/cmp-cmdline",
        "andersevenrud/cmp-tmux",
        "tamago324/cmp-zsh",
      },
      -- icons
      "onsails/lspkind.nvim",
      -- snippets engine
      "saadparwaiz1/cmp_luasnip",
      -- autopairing of (){}[] etc
      "windwp/nvim-autopairs",
      -- -- snippets
      "L3MON4D3/LuaSnip",
    },
    config = function(_, opts)
      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()
      local lspkind = require "lspkind"
      local luasnip = require "luasnip"
      -- highlight
      -- gray
      vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
      -- blue
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "CustomCmpMatch" })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CustomCmpFuzzyMatch" })
      -- sources
      local set_sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      })

      -- autocmds
      vim.api.nvim_create_autocmd("BufReadPre", {
        callback = function(t)
          local sources = set_sources
          local ft = vim.api.nvim_buf_get_option(t.buf, "filetype")
          if ft == "tmux" then
            sources[#sources + 1] = { name = "tmux", group_index = 2 }
          end
          if ft == "zsh" then
            sources[#sources + 1] = { name = "zsh", group_index = 2 }
          end
          cmp.setup.buffer {
            sources = sources,
          }
        end,
      })

      -- function

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end
      -- mappgins
      local mappings = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-d>"] = function(fallback) -- toggle doc
          if cmp.visible_docs() then
            cmp.close_docs()
          else
            cmp.open_docs()
          end
        end,
        ["<C-e>"] = cmp.mapping.close_docs(),
        ["<CR>"] = cmp.mapping.confirm { select = false },
        ["<C-i>"] = function(fallback)
          if cmp.visible() then
            if #cmp.get_entries() == 1 then
              cmp.confirm { select = true }
            else
              cmp.select_next_item { behavior = cmp.SelectBehavior.InsertEnter }
            end
          elseif luasnip.expand_or_jumpable() then -- when local , -> expand_or_locally_jumpable
            luasnip.expand_or_jump(1)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end,
        ["<C-o>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.InsertEnter }
          elseif luasnip.expand_or_jumpable() then -- when local , -> expand_or_locally_jumpable
            luasnip.jump(-1)
          else
            fallback()
          end
        end,
      }
      mappings["<S-tab>"] = mappings["<C-o>"]

      -- function
      local select_mappings = function(modes, ...)
        modes = type(modes) == "table" and modes or { modes }
        local mps = {}
        for _, key in pairs { ... } do
          mps[key] = cmp.mapping(mappings[key], modes)
        end
        return mps
      end

      -- setup
      cmp.setup {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },

        completion = {
          completeopt = "menu,menuone",
          -- keyword_length = 3,
        },
        window = {
          completion = cmp.config.window.bordered {
            scrolloff = 2,
            border = "shadow",
            zindex = 8,
            winhighlight = "Normal:CustomCmpNormal,FloatBorder:FloatBorder,CursorLine:CustomCmpCursor,Search:None",
          },
          documentation = {
            border = "shadow",
            winhighlight = "Normal:CmpDoc",
          },
        },

        -- cmdline completion from down to up
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
        mapping = select_mappings({ "i", "s" }, "<CR>", "<C-b>", "<C-f>", "<C-o>", "<C-i>", "<C-e>", "<C-d>"),
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol_text",
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
            },
          },
        },
        sources = set_sources,
        sorting = defaults.sorting,
      }
      -- cmdline
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = select_mappings({ "c" }, "<CR>", "<C-o>", "<C-i>"),
        completion = { completeopt = "menu,menuone,noselect" },
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ ":", "@" }, {
        completion = { completeopt = "menu,menuone,noselect" },
        mapping = select_mappings({ "c" }, "<CR>", "<C-o>", "<C-i>"),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
          -- { name = "cmdline_history" },
        }),
      })
    end,
  },
}
