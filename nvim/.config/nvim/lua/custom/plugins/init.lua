-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'XXiaoA/atone.nvim',
    cmd = 'Atone',
    opts = {}, -- your configuration here
  },

  -- Seamless navigation between Neovim splits and tmux panes
  -- Works with tmux plugin 'christoomey/vim-tmux-navigator' (already configured in tmux.conf)
  {
    'christoomey/vim-tmux-navigator',
    lazy = false, -- Load immediately for seamless navigation
  },

  -- File explorer: Edit your filesystem like a buffer
  -- NOTE: oil.nvim commented out to try mini.files
  -- Uncomment below to use oil.nvim instead of mini.files
  -- {
  --   'stevearc/oil.nvim',
  --   lazy = false, -- Load immediately for best experience
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  --   opts = {
  --     -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  --     default_file_explorer = true,
  --     columns = {
  --       'icon',
  --       -- 'permissions',
  --       -- 'size',
  --       -- 'mtime',
  --     },
  --     -- Skip confirmation for simple operations
  --     skip_confirm_for_simple_edits = false,
  --     -- Keymaps in oil buffer
  --     keymaps = {
  --       ['g?'] = 'actions.show_help',
  --       ['<CR>'] = 'actions.select',
  --       ['<C-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open in vertical split' },
  --       ['<C-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open in horizontal split' },
  --       ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open in new tab' },
  --       ['<C-p>'] = 'actions.preview',
  --       ['<C-c>'] = 'actions.close',
  --       ['<C-l>'] = 'actions.refresh',
  --       ['-'] = 'actions.parent',
  --       ['_'] = 'actions.open_cwd',
  --       ['`'] = 'actions.cd',
  --       ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = 'CD to oil directory (tab scope)' },
  --       ['gs'] = 'actions.change_sort',
  --       ['gx'] = 'actions.open_external',
  --       ['g.'] = 'actions.toggle_hidden',
  --       ['g\\'] = 'actions.toggle_trash',
  --     },
  --     use_default_keymaps = true,
  --     view_options = {
  --       -- Show files and directories that start with "."
  --       show_hidden = false,
  --       -- Natural sorting of file names
  --       natural_order = true,
  --       case_insensitive = false,
  --     },
  --   },
  --   config = function(_, opts)
  --     require('oil').setup(opts)
  --
  --     -- Keymap to open oil in parent directory (vim-vinegar style)
  --     vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  --
  --     -- Optional: Open oil in a floating window
  --     vim.keymap.set('n', '<leader>-', function()
  --       require('oil').toggle_float()
  --     end, { desc = 'Open parent directory (float)' })
  --   end,
  -- },
}
