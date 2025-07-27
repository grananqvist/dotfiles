return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          runner = "pytest",
          -- python = ".venv/bin/python",
          args = {
            "--override-ini",
            "addopts=-n0", -- replace addopts with “-n1”
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        if vim.fn.has("win32") == 1 then
          require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
        else
          require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/bin/python"))
        end

        local dap_python = require("dap-python")

        --dap_python.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
        dap_python.test_runner = "pytest"

        dap_python.test_runners.pytest = function(classnames, methodname)
          -- 1) coerce to list
          local names = {}
          if type(classnames) == "string" then
            names = { classnames }
          elseif type(classnames) == "table" then
            for _, v in ipairs(classnames) do
              table.insert(names, v)
            end
          end

          -- 2) append method if present
          if methodname and #methodname > 0 then
            table.insert(names, methodname)
          end

          -- 3) get current file relative to cwd
          local file = vim.fn.expand("%:.") -- e.g. "tests/test_mod.py"

          -- 4) build the full node-id
          local nodeid = file
          if #names > 0 then
            nodeid = nodeid .. "::" .. table.concat(names, "::")
          end

          -- 5) return pytest + your exact flags
          return "pytest",
            {
              "--disable-warnings",
              "--maxfail=1",
              "-n",
              "1", -- ← uncomment for one xdist worker
              nodeid,
            }
        end
      end,
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, { "python" })
    end,
  },
  -- Using default Lazyvim options for debug UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
}
