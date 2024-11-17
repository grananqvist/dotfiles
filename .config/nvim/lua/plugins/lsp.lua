return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "rust_analyzer", "ruff_lsp", "pyright" },
    })

    -- LSPs to add
    -- dockerls
    -- docker_compose_language_service
    -- eslint
    -- html
    -- jsonls
    -- yamlls
    -- tsserver
    -- lua_ls
    -- ruff_lsp
    require("lspconfig").rust_analyzer.setup({})
    require("lspconfig").pyright.setup({})
  end,
}
