return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
          pyright = { enabled = false },
          basedpyright = {
            settings = {
              basedpyright = {
                analysis = {
                  typeCheckingMode = "standard",
                  inlayHints = {
                    variableTypes = false,
                    functionReturnTypes = false,
                    parameterNames = false,
                  },
                },
              },
            },
          },
          ruff = { enabled = true },
          ruff_lsp = { enabled = true },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }

      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup autoformat
      LazyVim.format.register(LazyVim.lsp.formatter())

      -- setup keymaps
      LazyVim.lsp.on_attach(function(client, buffer)
        require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      LazyVim.lsp.setup()
      LazyVim.lsp.on_dynamic_capability(require("lazyvim.plugins.lsp.keymaps").on_attach)

      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      if vim.fn.has("nvim-0.10") == 1 then
        -- inlay hints
        if opts.inlay_hints.enabled then
          LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
            if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end)
        end

        -- code lens
        if opts.codelens.enabled and vim.lsp.codelens then
          LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = vim.lsp.codelens.refresh,
            })
          end)
        end
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            local icons = LazyVim.config.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end

      if LazyVim.lsp.is_enabled("denols") and LazyVim.lsp.is_enabled("vtsls") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        LazyVim.lsp.disable("vtsls", is_deno)
        LazyVim.lsp.disable("denols", function(root_dir, config)
          if not is_deno(root_dir) then
            config.settings.deno.enable = false
          end
          return false
        end)
      end

      require("lspconfig").sourcekit.setup({
        --cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
        --cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
        cmd = { "xcrun", "sourcekit-lsp" },
        capabilities = vim.deepcopy(capabilities),
        --capabilities = {
        --  workspace = {
        --    didChangeWatchedFiles = {
        --      dynamicRegistration = true,
        --    },
        --  },
        --},
        root_dir = function(fname)
          -- Use default root patterns for Swift projects
          return require("lspconfig.util").root_pattern("*.xcodeproj", "*.xcworkspace", "Package.swift")(fname)
            or require("lspconfig.util").find_git_ancestor(fname)
        end,
        flags = {
          debounce_text_changes = 150, -- Reduce debounce frequency to help large projects
        },
        handlers = {
          ["textDocument/definition"] = vim.lsp.with(vim.lsp.handlers["textDocument/definition"], {
            timeout = 10000, -- 10 seconds
          }),
          ["textDocument/documentHighlight"] = vim.lsp.with(vim.lsp.handlers["textDocument/documentHighlight"], {
            timeout = 10000, -- 10 seconds
          }),
        },
        on_new_config = function(config, root)
          -- Add environment variables to target the correct toolchain/SDK
          print("setting env vars for sourcekit")
          config.cmd_env = {
            SDKROOT = vim.fn.system("xcrun --sdk iphoneos.internal --show-sdk-path"):gsub("\n", ""),
            DEVELOPER_DIR = "/Applications/Xcode.app/Contents/Developer",
            SWIFT_EXEC = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift",
            SOURCEKIT_TOOLCHAIN_PATH = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain",
          }
        end,
      })
    end,
  },

  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-tree.lua", -- (optional) to manage project files
      "stevearc/oil.nvim", -- (optional) to manage project files
      "nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
    },
    config = function()
      require("xcodebuild").setup({
        integrations = {
          pymobiledevice = {
            enabled = true,
          },
        },
      })
      vim.keymap.set("n", "<leader>N", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })
      vim.keymap.set("n", "<leader>nf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" })

      vim.keymap.set("n", "<leader>nb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
      vim.keymap.set("n", "<leader>nB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
      vim.keymap.set("n", "<leader>nr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })

      vim.keymap.set("n", "<leader>nt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
      vim.keymap.set("v", "<leader>nt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
      vim.keymap.set("n", "<leader>nT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" })
      vim.keymap.set("n", "<leader>n.", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" })

      vim.keymap.set("n", "<leader>nl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
      vim.keymap.set("n", "<leader>nc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
      vim.keymap.set(
        "n",
        "<leader>nC",
        "<cmd>XcodebuildShowCodeCoverageReport<cr>",
        { desc = "Show Code Coverage Report" }
      )
      vim.keymap.set("n", "<leader>ne", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
      vim.keymap.set("n", "<leader>ns", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })

      vim.keymap.set("n", "<leader>nd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
      vim.keymap.set("n", "<leader>np", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
      --vim.keymap.set("n", "<leader>nq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })

      vim.keymap.set("n", "<leader>nx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
      vim.keymap.set("n", "<leader>na", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })
    end,
  },
}
