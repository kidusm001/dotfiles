-- opencode.nvim - AI assistant integration for Neovim
-- See: https://github.com/NickvanDyke/opencode.nvim
return {
  'NickvanDyke/opencode.nvim',
  version = '*',
  dependencies = {
    {
      'folke/snacks.nvim',
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...) return require('opencode').snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          require('snacks.terminal').open('opencode --port', {
            win = {
              position = 'right',
              enter = false,
              on_win = function(win)
                require('opencode.terminal').setup(win.win)
              end,
            },
          })
        end,
        stop = function()
          require('snacks.terminal').get('opencode --port'):close()
        end,
        toggle = function()
          require('snacks.terminal').toggle('opencode --port', {
            win = {
              position = 'right',
              enter = false,
              on_win = function(win)
                require('opencode.terminal').setup(win.win)
              end,
            },
          })
        end,
      },
    }

    vim.o.autoread = true

    -- Ask opencode with context (most common workflow)
    vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask opencode about selection/cursor' })

    -- Ask opencode (empty prompt, no auto-submit)
    vim.keymap.set({ 'n', 'x' }, '<leader>oA', function()
      require('opencode').ask()
    end, { desc = 'Ask opencode (empty prompt)' })

    -- Select from prompt library, commands, or provider controls
    vim.keymap.set({ 'n', 'x' }, '<leader>ox', function()
      require('opencode').select()
    end, { desc = 'Execute opencode action (picker)' })

    -- Toggle opencode terminal
    vim.keymap.set({ 'n', 't' }, '<leader>ot', function()
      require('opencode').toggle()
    end, { desc = 'Toggle opencode terminal' })

    -- Operator mapping for Vim-style workflows
    vim.keymap.set({ 'n', 'x' }, 'go', function()
      return require('opencode').operator '@this '
    end, { desc = 'Add range to opencode', expr = true })

    -- Operator for current line (double 'o')
    vim.keymap.set('n', 'goo', function()
      return require('opencode').operator '@this ' .. '_'
    end, { desc = 'Add current line to opencode', expr = true })

    -- Scroll opencode output from Neovim
    vim.keymap.set('n', '<leader>ou', function()
      require('opencode').command 'session.half.page.up'
    end, { desc = 'Scroll opencode up' })

    vim.keymap.set('n', '<leader>od', function()
      require('opencode').command 'session.half.page.down'
    end, { desc = 'Scroll opencode down' })

    -- Jump to first/last message in session
    vim.keymap.set('n', '<leader>og', function()
      require('opencode').command 'session.first'
    end, { desc = 'Jump to first message' })

    vim.keymap.set('n', '<leader>oG', function()
      require('opencode').command 'session.last'
    end, { desc = 'Jump to last message' })

    -- Session management
    vim.keymap.set('n', '<leader>on', function()
      require('opencode').command 'session.new'
    end, { desc = 'New opencode session' })

    vim.keymap.set('n', '<leader>oi', function()
      require('opencode').command 'session.interrupt'
    end, { desc = 'Interrupt opencode session' })

    vim.keymap.set('n', '<leader>oc', function()
      require('opencode').command 'session.compact'
    end, { desc = 'Compact opencode session' })

    -- Undo/Redo in opencode session
    vim.keymap.set('n', '<leader>oh', function()
      require('opencode').command 'session.undo'
    end, { desc = 'Undo in opencode session' })

    vim.keymap.set('n', '<leader>or', function()
      require('opencode').command 'session.redo'
    end, { desc = 'Redo in opencode session' })

    -- Which-key integration
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add {
        { '<leader>o', group = '[O]pencode' },
        { '<leader>oa', desc = 'Ask (with context)' },
        { '<leader>oA', desc = 'Ask (empty)' },
        { '<leader>ox', desc = 'Select action' },
        { '<leader>ot', desc = 'Toggle terminal' },
        { '<leader>ou', desc = 'Scroll up' },
        { '<leader>od', desc = 'Scroll down' },
        { '<leader>og', desc = 'Jump to first' },
        { '<leader>oG', desc = 'Jump to last' },
        { '<leader>on', desc = 'New session' },
        { '<leader>oi', desc = 'Interrupt' },
        { '<leader>oc', desc = 'Compact session' },
        { '<leader>oh', desc = 'Undo' },
        { '<leader>or', desc = 'Redo' },
      }
    end
  end,
}
