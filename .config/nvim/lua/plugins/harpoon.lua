local opts = { silent = true, expr = true }
return {
  "ThePrimeagen/harpoon",
  config = function()
    vim.keymap.set(
      "n",
      "<leader>hh",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      { desc = "Show harpoon menu" }
    )
    vim.keymap.set(
      "n",
      "<leader>ha",
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      { desc = "Add to harpoon menu" }
    )
    vim.keymap.set("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = "Goto prev file" })
    vim.keymap.set("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = "Goto next file" })
  end,
}
