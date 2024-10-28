local M = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",
    },

    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("baba-lsp-attach", { clear = true }),
        callback = function(event)
          ---@param keys string
          ---@param func function
          ---@param desc string
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local telescope_builtin = require("telescope.builtin")

          -- Jump to the definition of the word under your cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-T>
          map("gd", telescope_builtin.lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          -- Useful when your language has ways of declaring types without an actual implementation.
          map("gI", telescope_builtin.lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your curson.
          -- Useful when you're not sure what type a variable is and you want to see
          -- the definition of its *type*, not where it was *defined*.
          map("<leader>D", telescope_builtin.lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          -- Symbols are things like variables, functions, types, etc.
          map("<leader>ds", telescope_builtin.lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          -- Similar to document symbols, except searches over your whole project.
          map("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          -- Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

          -- Opens a popup that displays documentation about the word under your cursor.
          -- See `:help K` for why this keymap
          map("H", vim.lsp.buf.hover, "Hover Documentation")

          vim.keymap.set({ "n", "i" }, "<C-h>", vim.lsp.buf.signature_help, { buffer = event.buf, desc = "LSP: Show Signature information" })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          -- See `:help CursorHold` for information about when this is executed.
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = {
        clangd = {},
        basedpyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },
        ruff_lsp = {},
        -- tsserver = {},

        tailwindcss = {},
        -- biome = {},
        eslint = {},
        prismals = {},

        dockerls = {},
        docker_compose_language_service = {},
        cmake = {},
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,

                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
            },
          },
        },
      }

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format lua code
        "ruff", -- Used to format python code
        "prettier",
        "prettierd",
        "clang-format",
        "sql-formatter",
      })

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            require("lspconfig")[server_name].setup({
              cmd = server.cmd,
              settings = server.settings,
              filetypes = server.filetypes,
              capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
            })
          end,
        },
      })
      -- require("lspconfig").tsserver.setup({
      --   commands = {
      --     OrganizeImports = {
      --       organize_imports,
      --       description = "Organize Imports",
      --     },
      --   },
      -- })
    end,
  },
  {
    -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufEnter" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_after_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = {
          "ruff_format", -- To run the Ruff formatter
          "ruff_fix", -- To fix lint errors
        },
        javascript = { { "prettier" } },
        typescript = { { "prettier" } },
        javascriptreact = { { "prettier" } },
        typescriptreact = { { "prettier" } },
        markdown = {
          { "prettierd", "prettier" },
        },
        c = { "clang-format" },
        sql = { "sql_formatter" },
      },
      formatters = {
        sql_formatter = {
          prepend_args = function()
            return { "-c", vim.fn.getcwd() .. "/sql_formatter.json" }
          end,
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      print("After seup Before create command")

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        print("FormatDiable!")
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        print("FormatEnable!")
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },
  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
      },
      "saadparwaiz1/cmp_luasnip",

      -- Adds other completion capabilities.
      -- nvim-cmp does not ship with all sources by default. They are split
      -- into multiple repos for maintenance purpose.
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",

      -- If you want to add a bunch of pre-configured snippets,
      -- you can use this plugin to help you. It even has snippets
      -- for various frameworks/libraries/etc. but you will have to
      -- set up the ones that are useful for you.
      -- 'rafamadriz/friendly-snippets'
    },
    config = function()
      -- See `:help cmp`
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          ["<C-k>"] = function()
            if cmp.visible() then
              cmp.close()
            else
              cmp.complete()
            end
          end,

          -- <c-l> will move you to the right of each of the expansion locations/
          -- <c-h> is similar, except moving you backwards.
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable(-1) then
              luasnip.expand_or_jump(-1)
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
        },
      })
    end,
  },
  {
    -- LSP messages
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          expose_as_code_action = {
            "organize_imports",
            "sort_imports",
          },
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },
}

return M
