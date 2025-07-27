return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function(_, opts)
    -- Extend the window config
    opts.window = opts.window or {}
    opts.window.position = "left"
    opts.window.width = 40

    -- Add the close_window mapping but preserve other mappings
    opts.window.mappings = opts.window.mappings or {}
    opts.window.mappings["<C-b>"] = "close_window"
    opts.event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(arg)
          vim.cmd([[
          setlocal relativenumber
        ]])
        end,
      },
    }
  end,
  config = function(_, opts)
    require("neo-tree").setup(opts)
  end,
}
