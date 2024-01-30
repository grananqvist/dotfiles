return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_assume_mapped = true
    vim.keymap.set("i", "<C-G>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end,
}
