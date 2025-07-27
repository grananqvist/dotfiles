-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Basic Settings
opt.colorcolumn = "80"
opt.visualbell = true -- stop that ANNOYING beeping
opt.clipboard = "" -- dont use system clipboard by default in vim, use * and + registers
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.pumheight = 10 -- pop up menu height
opt.showmode = true -- show mode, e.g. -- INSERT --
opt.showtabline = 2 -- always show tabs
opt.smartcase = true -- smart cvim.opt.a
opt.smartindent = true -- make indenting smarter again
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
opt.swapfile = false -- no dot backups
opt.backup = false
opt.magic = true -- Use 'magic' patterns (extended regular expressions).
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.undofile = true -- enable persistent undo
opt.updatetime = 300 -- faster completion (4000ms default)
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.wrap = false -- display lines as one long line
opt.scrolloff = 8 -- is one of my fav
opt.sidescrolloff = 8
opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
opt.ruler = true
opt.sidescroll = 1

-- Make searching better
opt.gdefault = true -- Never have to type /g at the end of search / replace again
opt.ignorecase = true -- case insensitive searching (unless specified)

opt.tabstop = 4
opt.shiftwidth = 4 -- Indents will have a width of 4
opt.softtabstop = 4 -- Sets the number of columns for a TAB
opt.expandtab = true -- Expand TABs to spaces
opt.ls = 4
opt.cursorline = true -- highlight the current line
opt.number = true -- set numbered lines
opt.relativenumber = true -- set relative numbered lines
opt.numberwidth = 4 -- set number column width to 2 {default 4}

vim.cmd([[set iskeyword+=-]])

-- HTML Editing
opt.matchpairs:append("<:>")
vim.g.html_indent_tags = "li\\|p" -- Treat <li> and <p> tags like the block tags they are
