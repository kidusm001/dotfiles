-- dropbar.nvim - IDE-like breadcrumbs with drop-down menus
-- Shows file path + current symbol context (function/class/etc) in the winbar
-- See: https://github.com/Bekaboo/dropbar.nvim
return {
  'Bekaboo/dropbar.nvim',
  event = 'VeryLazy', -- Load after UI is ready for best performance
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim', -- For fuzzy finder support
  },
  opts = {
    icons = {
      enable = true, -- Use icons from nvim-web-devicons
      kinds = {
        symbols = {
          -- You can customize these icons if needed
          File = '󰈙 ',
          Folder = '󰉋 ',
          Function = '󰊕 ',
          Method = '󰊕 ',
          Class = ' ',
          Interface = ' ',
          Struct = ' ',
          Variable = '󰀫 ',
          Constant = '󰏿 ',
        },
      },
    },
    bar = {
      -- Sources to use for generating breadcrumbs
      -- Falls back to treesitter if LSP is not available
      sources = function(buf, _)
        local sources = require('dropbar.sources')
        local utils = require('dropbar.utils')

        -- Special handling for markdown files
        if vim.bo[buf].ft == 'markdown' then
          return {
            sources.path,
            sources.markdown,
          }
        end

        -- Terminal buffers
        if vim.bo[buf].buftype == 'terminal' then
          return {
            sources.terminal,
          }
        end

        -- For code files: prioritize LSP, fallback to treesitter
        return {
          sources.path,
          utils.source.fallback({
            sources.lsp,
            sources.treesitter,
          }),
        }
      end,
      hover = true, -- Highlight symbols on hover
      truncate = true, -- Auto-truncate when winbar is too long
    },
    menu = {
      preview = true, -- Preview symbols in source window on hover
      hover = true, -- Highlight menu items on hover
      quick_navigation = true, -- Auto-navigate to clickable components
      -- Window configuration for transparent, clean look
      win_configs = {
        border = 'rounded', -- Clean rounded border instead of default
        style = 'minimal',
      },
      keymaps = {
        -- Essential menu navigation keymaps
        ['q'] = '<C-w>q', -- Close menu
        ['<Esc>'] = '<C-w>q', -- Close menu
        ['<CR>'] = function()
          local menu = require('dropbar.utils.menu').get_current()
          if not menu then
            return
          end
          local cursor = vim.api.nvim_win_get_cursor(menu.win)
          local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
          if component then
            menu:click_on(component, nil, 1, 'l')
          end
        end,
        ['i'] = function()
          local menu = require('dropbar.utils.menu').get_current()
          if menu then
            menu:fuzzy_find_open() -- Open fuzzy finder
          end
        end,
      },
      scrollbar = {
        enable = true, -- Show scrollbar when menu is long
      },
    },
    fzf = {
      -- Fuzzy finder configuration (requires telescope-fzf-native)
      prompt = '%#DiagnosticInfo#  ',
      keymaps = {
        ['<CR>'] = function()
          require('dropbar.api').fuzzy_find_click()
        end,
        ['<Esc>'] = function()
          local menu = require('dropbar.utils.menu').get_current()
          if menu then
            menu:fuzzy_find_close()
          end
        end,
        ['<Up>'] = function()
          require('dropbar.api').fuzzy_find_prev()
        end,
        ['<Down>'] = function()
          require('dropbar.api').fuzzy_find_next()
        end,
        ['<C-k>'] = function()
          require('dropbar.api').fuzzy_find_prev()
        end,
        ['<C-j>'] = function()
          require('dropbar.api').fuzzy_find_next()
        end,
      },
    },
  },
  config = function(_, opts)
    require('dropbar').setup(opts)

    local dropbar_api = require('dropbar.api')

    -- Recommended keymaps
    vim.keymap.set('n', '<Leader>;', dropbar_api.pick, {
      desc = 'Pick symbols in winbar',
    })

    vim.keymap.set('n', '[;', dropbar_api.goto_context_start, {
      desc = 'Go to start of current context',
    })

    vim.keymap.set('n', '];', dropbar_api.select_next_context, {
      desc = 'Select next context',
    })

    -- Register with which-key if available
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add({
        { '<leader>;', desc = 'Pick symbols in winbar', icon = '󰆧' },
        { '[;', desc = 'Go to start of current context', icon = '󰆤' },
        { '];', desc = 'Select next context', icon = '󰆦' },
      })
    end

    -- Set transparent background and better styling
    -- Winbar (breadcrumbs bar itself)
    vim.api.nvim_set_hl(0, 'WinBar', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'WinBarNC', { bg = 'NONE' })
    
    -- Dropdown menus
    vim.api.nvim_set_hl(0, 'DropBarMenuNormalFloat', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'DropBarMenuFloatBorder', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'DropBarMenuCurrentContext', { bg = 'NONE', fg = '#7aa2f7', bold = true })
    vim.api.nvim_set_hl(0, 'DropBarMenuHoverSymbol', { bg = '#3b4261', fg = '#c0caf5' })
    
    -- Pick mode selector
    vim.api.nvim_set_hl(0, 'DropBarIconUIPickPivot', { bg = 'NONE', fg = '#ff9e64', bold = true })
    
    -- Preview
    vim.api.nvim_set_hl(0, 'DropBarPreview', { bg = 'NONE' })
  end,
}
