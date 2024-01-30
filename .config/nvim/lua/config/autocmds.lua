-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Save on leaving nvim window
vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, { pattern = "*", command = "silent! wa" })
-- Adjusts the sizes of all split windows to be equal whenever the Neovim window is resized.
vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

    -- TODO: remap lazy -> <leader>L
    vim.keymap.set({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<space>lf", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
