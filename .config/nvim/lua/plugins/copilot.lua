return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_no_tab_map = true
    vim.keymap.set(
      "i",
      "<Plug>(vimrc:copilot-dummy-map)",
      'copilot#Accept("<CR>")',
      { silent = true, expr = true, desc = "Copilot dummy accept" }
    )
  end,
}
