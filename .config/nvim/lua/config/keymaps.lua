-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Some useful existing keymaps:
-- <leader>uw - toggle word wrap

local opts = { noremap = true, silent = true }

-- How to delete default LazyVim keymaps
--vim.keymap.del("n", "<leader>w|")

-- Map the Option key to the Alt key
vim.api.nvim_set_var("mac_option_as_meta", true)

-- Fast exit insert mode
vim.keymap.set("i", "kj", "<ESC>", opts)

-- Use tab to jump between blocks, because it's easier
vim.keymap.set({ "n", "v" }, "<tab>", "%")

-- Key Mappings
vim.keymap.set("n", "<CR>", "o<Esc>", opts) -- Use enter to create new lines w/o entering insert mode

-- Quicker window movement
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Clear highlight search
vim.keymap.set("n", "<leader>uh", "<Cmd>nohlsearch<CR><C-l>", opts)

-- Color scheme switch between light and dark. Good for outside vs inside.
vim.keymap.set("n", "<Leader>uo", "<Cmd>set background=light<CR>:colorscheme PaperColor<CR>", opts)
vim.keymap.set("n", "<Leader>uO", "<Cmd>set background=dark<CR>:colorscheme NeoSolarized<CR>", opts)

-- Resize with arrows
vim.keymap.set("n", "<S-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<S-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<S-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- iterate tabs
vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)

-- Toggle line wrapping
vim.keymap.set("n", "<leader>W", ":set invwrap<CR>", opts) -- toggle wrapping lines

-- saving, already enabled
--vim.keymap.set("n", "<C-s>", ":wa<CR>", opts)
--vim.keymap.set("i", "<C-s>", "<ESC>:wa<CR>", opts)

-- quickfix
vim.keymap.set("n", "<C-n>", ":cnext<CR>", opts)
vim.keymap.set("n", "<C-u>", ":cprev<CR>", opts)

-- quickfix useful actions
-- Search in files, add results to quickfix
-- <leader>st "search for some text" <C-q>

-- leap settings
vim.keymap.set("n", "-", "<Plug>(leap-forward)", opts)
vim.keymap.set("n", "_", "<Plug>(leap-backward)", opts)

-- Neo-tree
-- TODO: set neo-tree relative line numbers
vim.keymap.set("n", "<C-b>", "<cmd>Neotree toggle<CR>", opts)

-- Harpoon navigation. Needs to be here to override lazyvim bindings
vim.keymap.set("n", "<M-h>", ":Telescope harpoon marks<cr>", {})
vim.keymap.set("n", "<M-j>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", {})
vim.keymap.set("n", "<M-k>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", {})
vim.keymap.set("n", "<M-l>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", {})
vim.keymap.set("n", "<M-ö>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", {})
