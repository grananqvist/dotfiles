return {
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git navigator" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
    },
    config = function() end,
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      function create_worktree_interactive()
        local branch = vim.fn.input("Name of the new branch: ")
        local upstream_remote = vim.fn.input("Name of the upstream remote: ")
        local upstream_branch = vim.fn.input("Name of the upstream branch: ")

        require("git-worktree").create_worktree(branch, branch, "origin")
        vim.wait(500, function()
          return not vim.fn.exists("g:running_git_cmd")
        end)
        require("git-worktree").switch_worktree(branch)

        -- Fetch from upstream_remote
        vim.cmd("Git fetch " .. upstream_remote)
        vim.wait(500, function()
          return not vim.fn.exists("g:running_git_cmd")
        end)

        -- Checkout the new branch
        vim.cmd("Git checkout -b " .. branch)
        vim.cmd("Git reset --hard " .. upstream_remote .. "/" .. upstream_branch)
        vim.wait(500, function()
          return not vim.fn.exists("g:running_git_cmd")
        end)

        -- Set the upstream push branch
        vim.cmd("Git push --set-upstream origin " .. branch)
        vim.wait(500, function()
          return not vim.fn.exists("g:running_git_cmd")
        end)
      end

      vim.keymap.set(
        "n",
        "<leader>wl",
        "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
        { desc = "list worktrees" }
      )
      vim.keymap.set(
        "n",
        "<leader>wn",
        "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
        { desc = "new branch (telescope)" }
      )
      vim.keymap.set("n", "<leader>wc", "<cmd>lua create_worktree_interactive()<CR>", { desc = "new branch (prompt)" })
    end,
  },
}
