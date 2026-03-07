-- 99 - AI Neovim Agent by ThePrimeagen
-- See: https://github.com/ThePrimeagen/99
return {
  'ThePrimeagen/99',
  dependencies = {
    'saghen/blink.compat',
  },
  config = function()
    local _99 = require('99')

    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup({
      logger = {
        level = _99.DEBUG,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
      },
      tmp_dir = './tmp',

      completion = {
        source = 'blink',
        custom_rules = {
          'scratch/custom_rules/',
        },
        files = {
          enabled = true,
          max_file_size = 102400,
          max_files = 5000,
        },
      },

      md_files = {
        'AGENT.md',
      },
    })

    -- Visual mode - send selection to AI
    vim.keymap.set('v', '<leader>9v', function()
      _99.visual()
    end, { desc = '99: Send selection to AI' })

    -- Stop all requests
    vim.keymap.set('n', '<leader>9x', function()
      _99.stop_all_requests()
    end, { desc = '99: Stop all requests' })

    -- Search - AI powered project search
    vim.keymap.set('n', '<leader>9s', function()
      _99.search()
    end, { desc = '99: AI Search' })

    -- Optional: View logs
    vim.keymap.set('n', '<leader>9l', function()
      _99.view_logs()
    end, { desc = '99: View logs' })

    -- Optional: Open last interaction
    vim.keymap.set('n', '<leader>9o', function()
      _99.open()
    end, { desc = '99: Open last interaction' })

    -- Extensions: Telescope model selector
    vim.keymap.set('n', '<leader>9m', function()
      require('99.extensions.telescope').select_model()
    end, { desc = '99: Select model' })

    -- Extensions: Telescope provider selector
    vim.keymap.set('n', '<leader>9p', function()
      require('99.extensions.telescope').select_provider()
    end, { desc = '99: Select provider' })
  end,
}
