-- snacks.nvim - Collection of small QoL plugins
-- Required for enhanced opencode.nvim features
-- See: https://github.com/folke/snacks.nvim
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Only enable the modules we need for opencode.nvim
    -- Keeps things minimal and focused

    -- Enhanced input prompt (used by opencode.ask())
    input = {
      enabled = true,
      -- Clean, minimal floating window for prompts
      win = {
        relative = 'cursor',
        row = -3,
        col = 0,
        width = 60,
        border = 'rounded',
        title_pos = 'left',
      },
    },

    -- Enhanced picker (used by opencode.select())
    picker = {
      enabled = true,
      -- VSCode-like layout with preview
      layout = {
        preset = 'vscode',
      },
    },

    -- Enhanced terminal management (used by opencode provider)
    terminal = {
      enabled = true,
      win = {
        position = 'right',
        border = 'rounded',
      },
    },
    scroll = {
      enabled = true,
      -- Ultra-smooth scrolling configuration
      animate = {
        duration = { step = 15, total = 250 }, -- Longer, smoother animation
        easing = "outQuart", -- Smooth deceleration curve
      },
      -- Scroll speed and behavior
      spamming = 10, -- Higher threshold for smoother handling of rapid scrolls
      -- Filter which windows get smooth scrolling
      filter = function(buf)
        return vim.b[buf].snacks_scroll ~= false
      end,
    },
    -- Disable other snacks modules we don't need
    bigfile = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    styles = {},
  },
}
