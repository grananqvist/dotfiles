return {
  {
    "tpope/vim-fugitive",
    config = function() end,
  },
  {
    "polarmutex/git-worktree.nvim",
    version = "^2",
    config = function()
      local Hooks = require("git-worktree.hooks")
      local config = require("git-worktree.config")
      local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

      local function on_switch(path, prev_path)
        local cur_win = vim.api.nvim_get_current_win()
        vim.notify("Moved from " .. prev_path .. "\nto " .. path)
        update_on_switch(path, prev_path)

        -- Defer for 100ms, then try again
        vim.defer_fn(function()
          if vim.fn.isdirectory(path) == 1 then
            vim.api.nvim_set_current_dir(path)
            vim.cmd("Neotree reveal " .. vim.fn.fnameescape(path))
            vim.api.nvim_set_current_win(cur_win)
          else
            vim.notify("Worktree directory not ready yet: " .. path, vim.log.levels.WARN)
          end
        end, 100)
      end
      Hooks.register(Hooks.type.SWITCH, on_switch)

      --Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
      --  local cur_win = vim.api.nvim_get_current_win()

      --  vim.notify("Moved from " .. prev_path .. "\nto " .. path)
      --  update_on_switch(path, prev_path)

      --  vim.api.nvim_set_current_dir(path)
      --  vim.cmd("Neotree reveal " .. vim.fn.fnameescape(path))
      --  -- go back to the original window
      --  vim.api.nvim_set_current_win(cur_win)
      --end)

      Hooks.register(Hooks.type.DELETE, function()
        vim.cmd(config.update_on_change_command)
      end)

      function create_worktree_interactive()
        local branch = vim.fn.input("Name of the new branch: ")
        local upstream_remote = vim.fn.input("Name of the upstream remote: ")
        local upstream_branch = vim.fn.input("Name of the upstream branch: ")

        local git_root = vim.fn.systemlist("git rev-parse --git-common-dir")[1]
        vim.fn.chdir(git_root)

        vim.notify("change to dir " .. git_root)

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
        -- Reset the new branch
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

      --[[
      function create_worktree_interactive()
        local branch = vim.fn.input("Name of the new branch: ")
        local upstream_remote = vim.fn.input("Name of the upstream remote: ")
        local upstream_branch = vim.fn.input("Name of the upstream branch: ")

        -- cd to repo root
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        vim.fn.chdir(git_root)

        -- 1) make sure we have the upstream branch locally
        vim.cmd("Git fetch " .. upstream_remote .. " " .. upstream_branch)
        vim.wait(500, function()
          return not vim.fn.exists("g:running_git_cmd")
        end)

        -- 2) create a worktree, branching off upstream/<branch>
        require("git-worktree").create_worktree(branch, upstream_branch, upstream_remote)
        vim.wait(500, function()
          return not vim.fn.exists("g:running_git_cmd")
        end)

        -- 3) switch into it
        require("git-worktree").switch_worktree(branch)

        -- 4) set the push‑upstream to origin/<branch>
        vim.cmd("Git push --set-upstream origin " .. branch)
        vim.wait(500, function()
          return not vim.fn.exists("g:running_git_cmd")
        end)
      end
      ]]

      -- Keep the same keymaps
      vim.keymap.set("n", "<leader>wl", function()
        require("telescope").extensions.git_worktree.git_worktree()
      end, { desc = "list worktrees" })

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
