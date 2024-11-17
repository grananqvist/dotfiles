return {
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Undo tree" })
    end,
  },
  {
    "apple/pkl-neovim",
    lazy = true,
    ft = "pkl",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = function(_)
          vim.cmd("TSUpdate")
        end,
      },
      "L3MON4D3/LuaSnip",
    },
    build = function()
      -- Set up syntax highlighting.
      vim.cmd("TSInstall! pkl")
    end,
    config = function()
      -- Set up snippets.
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },
}
