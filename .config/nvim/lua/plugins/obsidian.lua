-- Obsidian.nvim: Integrate Obsidian vault management into Neovim
-- Plugin repository: https://github.com/epwalsh/obsidian.nvim
-- This brings Obsidian's note-taking features directly into your editor
return {
  "epwalsh/obsidian.nvim",

  -- Use the latest stable version (lazy.nvim will fetch the most recent release tag)
  version = "*",

  -- Lazy loading strategy:
  -- "VeryLazy" event loads shortly after startup (doesn't block initial UI)
  -- This ensures keybindings are available immediately when you need them
  -- while still keeping startup fast
  event = "VeryLazy",

  -- Dependencies: plugins that obsidian.nvim requires to function properly
  dependencies = {
    "nvim-lua/plenary.nvim",           -- Lua utility functions (file I/O, async, etc.)
    "nvim-telescope/telescope.nvim",    -- Fuzzy finder (for searching notes and tags)
    "nvim-treesitter/nvim-treesitter",  -- Better syntax parsing (for markdown)
  },

  -- Plugin configuration options (passed to require("obsidian").setup())
  opts = {
    -- Workspaces: Define multiple Obsidian vaults
    -- Each workspace is an independent vault with its own notes and configuration
    -- You can switch between them using :ObsidianWorkspace <name>
    workspaces = {
      {
        name = "work",
        -- iCloud corporate vault for work-related notes
        path = "/Users/fgranqvist/Library/Mobile Documents/com~apple~icloud~applecorporate/Documents/obsidian",
      },
      {
        name = "personal",
        -- iCloud personal vault for personal notes
        path = "/Users/fgranqvist/Library/Mobile Documents/iCloud~md~obsidian/Documents/Personal",
      },
    },

    -- Daily notes configuration
    -- Daily notes are a core Obsidian feature for journaling and time-based note-taking
    daily_notes = {
      folder = "daily",                -- Store daily notes in <vault>/daily/ subdirectory
      date_format = "%Y-%m-%d",        -- Filename format: 2025-12-21.md
      alias_format = "%B %-d, %Y",     -- Human-readable alias: December 21, 2025
      template = nil,                  -- No template by default (can set to a template note path)
    },

    -- Completion settings
    -- Note: nvim-cmp integration is disabled since this config uses blink.cmp instead
    -- Obsidian still provides completion data that other completion engines can use
    completion = {
      nvim_cmp = false,                -- Disabled: using blink.cmp, not nvim-cmp
      min_chars = 2,                   -- Start suggesting after typing 2 characters
    },

    -- Buffer-local keymaps (only active in markdown files within vaults)
    -- These override or extend default Vim behaviors with Obsidian-specific actions
    mappings = {
      -- "gf" is Vim's default "go to file" - here we make it Obsidian-aware
      -- This allows gf to work with both regular file paths AND [[wiki-links]]
      ["gf"] = {
        action = function()
          -- gf_passthrough tries Obsidian link following first, falls back to Vim's default
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },

      -- Toggle checkbox states: [ ] -> [x] -> [>] -> [~] -> [ ]
      -- Useful for task management within notes
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },

      -- Smart Enter key behavior
      -- On a link: follow it | On a checkbox: toggle it | Otherwise: normal newline
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    -- Note ID generation function
    -- Called when creating a new note to generate a unique identifier
    -- Format: <timestamp>-<slugified-title> (e.g., 1703012345-my-note-title)
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        -- Convert title to URL-friendly slug:
        -- 1. Replace spaces with hyphens
        -- 2. Remove special characters (keep only alphanumeric and hyphens)
        -- 3. Convert to lowercase
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- No title provided: generate a random 4-character suffix (A-Z)
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      -- Prepend Unix timestamp to ensure uniqueness and chronological ordering
      return tostring(os.time()) .. "-" .. suffix
    end,

    -- Frontmatter generation function
    -- Frontmatter is the YAML metadata at the top of markdown files
    -- This function determines what metadata to include when creating/updating notes
    note_frontmatter_func = function(note)
      -- Add the note's title as an alias (allows linking by title even if filename differs)
      if note.title then
        note:add_alias(note.title)
      end

      -- Start with core metadata
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      -- Preserve any custom metadata from the note
      -- This ensures you don't lose custom fields when the frontmatter is regenerated
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- Enable frontmatter in all notes
    -- Frontmatter provides structure and makes notes more queryable
    disable_frontmatter = false,

    -- Templates configuration
    -- Templates are reusable note structures stored in <vault>/templates/
    templates = {
      folder = "templates",            -- Location for template files
      date_format = "%Y-%m-%d",        -- {{date}} placeholder format
      time_format = "%H:%M",           -- {{time}} placeholder format
      substitutions = {},              -- Custom {{variable}} substitutions (empty by default)
    },

    -- URL opener function
    -- Called when following external links (http://, https://)
    -- Uses macOS 'open' command to open URLs in default browser
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url }) -- jobstart runs command asynchronously (non-blocking)
    end,

    -- Advanced URI features
    -- Obsidian has a URI scheme (obsidian://open?vault=...) for deep linking
    use_advanced_uri = false,          -- Disabled: we're working directly with files
    open_app_foreground = false,       -- Don't bring Obsidian app to foreground when opening

    -- Picker configuration (Telescope integration)
    -- The picker is used for selecting notes, searching, etc.
    picker = {
      name = "telescope.nvim",         -- Use Telescope as the picker UI
      mappings = {
        new = "<C-x>",                 -- Create new note from picker (Ctrl-x)
        insert_link = "<C-l>",         -- Insert link to selected note (Ctrl-l)
      },
    },

    -- Note sorting in pickers
    sort_by = "modified",              -- Sort by last modified date (most recent first)
    sort_reversed = true,              -- Reverse order: newest at top

    -- Search performance limit
    -- Maximum lines to search in a single note (prevents performance issues with huge notes)
    search_max_lines = 1000,

    -- Note opening behavior
    open_notes_in = "current",         -- Open notes in current buffer (alternatives: "vsplit", "hsplit")

    -- UI customization: syntax highlighting and special character rendering
    -- This makes Obsidian markdown elements visually distinct and appealing
    ui = {
      enable = true,                   -- Enable enhanced UI rendering
      update_debounce = 200,           -- Wait 200ms after typing before updating UI (performance)

      -- Checkbox rendering: map markdown syntax to display characters
      -- Each state has a unique icon and highlight group
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },       -- [ ] = To-do
        ["x"] = { char = "", hl_group = "ObsidianDone" },       -- [x] = Done
        [">"] = { char = "", hl_group = "ObsidianRightArrow" }, -- [>] = Forwarded/Rescheduled
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },      -- [~] = Cancelled
      },

      -- Markdown element rendering
      bullets = { char = "•", hl_group = "ObsidianBullet" },            -- List bullets
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" }, -- External link indicator
      reference_text = { hl_group = "ObsidianRefText" },                -- [[wiki links]]
      highlight_text = { hl_group = "ObsidianHighlightText" },          -- ==highlighted text==
      tags = { hl_group = "ObsidianTag" },                              -- #tags
      block_ids = { hl_group = "ObsidianBlockID" },                     -- ^block-id

      -- Highlight group color definitions
      -- These define the visual appearance of Obsidian elements
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },              -- Orange for todos
        ObsidianDone = { bold = true, fg = "#89ddff" },              -- Cyan for completed
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },        -- Orange for forwarded
        ObsidianTilde = { bold = true, fg = "#ff5370" },             -- Red for cancelled
        ObsidianBullet = { bold = true, fg = "#89ddff" },            -- Cyan for bullets
        ObsidianRefText = { underline = true, fg = "#c792ea" },      -- Purple underlined for links
        ObsidianExtLinkIcon = { fg = "#c792ea" },                    -- Purple for external links
        ObsidianTag = { italic = true, fg = "#89ddff" },             -- Cyan italic for tags
        ObsidianBlockID = { italic = true, fg = "#89ddff" },         -- Cyan italic for block IDs
        ObsidianHighlightText = { bg = "#75662e" },                  -- Yellow background for highlights
      },
    },

    -- Attachments (images, PDFs, etc.)
    -- Configuration for how to handle embedded files in notes
    attachments = {
      img_folder = "assets/imgs",      -- Store images in <vault>/assets/imgs/

      -- Function to generate markdown syntax for embedded images
      -- Called when pasting or inserting an image
      img_text_func = function(client, path)
        -- Convert to vault-relative path for portability
        path = client:vault_relative_path(path) or path
        -- Generate standard markdown image syntax: ![filename](path)
        return string.format("![%s](%s)", path.name, path)
      end,
    },
  },

  -- Config function: runs after the plugin loads
  -- This is where we set up custom keybindings
  config = function(_, opts)
    -- Initialize the plugin with the options defined above
    require("obsidian").setup(opts)

    -- Keybindings: All under <leader>o prefix for easy discoverability
    -- The "desc" parameter shows up in which-key and :help menus

    -- Vault navigation and switching
    vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch notes" })
    vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace work<cr>", { desc = "Switch to work vault" })
    vim.keymap.set("n", "<leader>op", "<cmd>ObsidianWorkspace personal<cr>", { desc = "Switch to personal vault" })

    -- Note creation and management
    vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
    vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })

    -- Search and discovery
    vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search notes" })
    vim.keymap.set("n", "<leader>og", "<cmd>ObsidianTags<cr>", { desc = "Search tags" })
    vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })

    -- Daily notes
    vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "Open today's note" })
    vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Open yesterday's note" })
    vim.keymap.set("n", "<leader>om", "<cmd>ObsidianTomorrow<cr>", { desc = "Open tomorrow's note" })
    vim.keymap.set("n", "<leader>od", "<cmd>ObsidianDailies<cr>", { desc = "Open daily notes picker" })

    -- Link navigation
    vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link under cursor" })

    -- Templates
    vim.keymap.set("n", "<leader>oi", "<cmd>ObsidianTemplate<cr>", { desc = "Insert template" })

    -- Checkboxes
    vim.keymap.set("n", "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>", { desc = "Toggle checkbox" })

    -- Visual mode mappings: operate on selected text
    vim.keymap.set("v", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "Link selection to note" })
    vim.keymap.set("v", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = "Link selection to new note" })
    vim.keymap.set("v", "<leader>oe", "<cmd>ObsidianExtractNote<cr>", { desc = "Extract selection to new note" })

    -- External app integration
    vim.keymap.set("n", "<leader>oO", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian app" })
  end,
}
