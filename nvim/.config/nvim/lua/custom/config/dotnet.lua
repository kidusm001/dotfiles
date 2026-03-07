-- .NET Development Configuration
-- This file configures C# LSP, formatting, and filetype settings

local function setup()
  -- Configure Roslyn LSP with nice-to-have settings
  vim.lsp.config('roslyn', {
    settings = {
      ['csharp|inlay_hints'] = {
        csharp_enable_inlay_hints_for_implicit_variable_types = true,
        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      },
      ['csharp|code_lens'] = {
        dotnet_enable_references_code_lens = true,
        dotnet_enable_tests_code_lens = true,
      },
      ['csharp|formatting'] = {
        dotnet_organize_imports_on_format = true,
      },
    },
  })

  -- Add C# to conform formatters
  require('conform').setup({
    formatters_by_ft = {
      cs = { 'csharpier' },
    },
    formatters = {
      csharpier = {
        command = 'dotnet',
        args = { 'csharpier', '--write-stdout' },
        stdin = true,
      },
    },
  })

  -- Set C# indentation (4 spaces like your global default)
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Set C# indentation to 4 spaces',
    group = vim.api.nvim_create_augroup('csharp-indent', { clear = true }),
    pattern = 'cs',
    callback = function()
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.shiftwidth = 4
    end,
  })

  -- Light bulb for code actions
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = vim.api.nvim_create_augroup('csharp-code-actions', { clear = true }),
    callback = function()
      local ctx = { diagnostics = vim.diagnostic.get(0) }
      local params = vim.lsp.util.make_range_params()
      params.context = ctx

      local timeout = 300
      local lsp_clients = vim.lsp.get_active_clients({ bufnr = 0 })
      for _, client in ipairs(lsp_clients) do
        if client.supports_method('textDocument/codeAction', params) then
          vim.defer_fn(function()
            local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout)
            if result and next(result) then
              local actions = result[1].result
              if actions and #actions > 0 then
                vim.opt_local.signcolumn = 'yes'
                vim.cmd.sign_define('LightBulb', { text = '💡', texthl = 'LspCodeAction' })
                vim.cmd.sign_place(0, 'csharp-code-actions', 'LightBulb', 0, { bufnr = 0, lnum = vim.fn.line('.') })
                return
              end
            end
            pcall(vim.cmd.sign_unplace, 'csharp-code-actions', { buffer = 0 })
          end, timeout)
          break
        end
      end
    end,
  })
end

-- Setup after plugins are loaded
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyDone',
  callback = function()
    setup()
  end,
})

return {}
