return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        disable = { "python" },
      },
      indent = {
        disable = { "python" },
      },
      incremental_selection = { disable = { "python" } },
      textobjects = { disable = { "python" } },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+worktree" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
        ["<leader>n"] = { name = "+xcode" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  { "echasnovski/mini.pairs", enabled = false },
  { "mtdl9/vim-log-highlighting" },
  { "cfdrake/vim-pbxproj" },
  {
    "terrortylor/nvim-comment",
    config = function(_, opts)
      require("nvim_comment").setup(opts)
    end,
  },
}
