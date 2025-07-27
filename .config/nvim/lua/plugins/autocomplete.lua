return {
  "saghen/blink.cmp",
  dependencies = {
    "Kaiser-Yang/blink-cmp-avante",
  },
  opts = function(_, opts)
    opts.sources.default = vim.list_extend({ "avante" }, opts.sources.default)

    -- 3) Ensure `.providers` exists, then add your "avante" provider
    opts.sources.providers = opts.sources.providers or {}
    opts.sources.providers.avante = {
      module = "blink-cmp-avante",
      name = "Avante",
      opts = {
        -- any options that blink-cmp-avante expects…
        -- e.g. max_items = 10, priority = 500, etc.
      },
    }

    -- Tab browsing not default keybind.
    opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    })
  end,
  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
}
