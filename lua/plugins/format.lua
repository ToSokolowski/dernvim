vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- No format-on-save for languages without a well standardized coding style.
    -- Java: existing codebases (e.g. Eclipse projects) have their own style; format with <leader>f.
    local disable_filetypes = { c = true, cpp = true, java = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Conform can also run multiple formatters sequentially
    python = { 'isort', 'black' },
    scala = { 'scalafmt' },
    haskell = { 'fourmolu' },

    nix = { 'alejandra' },
    typst = { 'typstyle' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    just = { 'just' },
    toml = { 'taplo' },
  },
}
vim.keymap.set('', '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })
