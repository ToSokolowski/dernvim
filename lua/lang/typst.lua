-- LSP (tinymist), formatting (typstyle) and grammar (ltex_plus) are in lua/plugins/.
vim.pack.add { { src = 'https://github.com/chomosuke/typst-preview.nvim', version = vim.version.range '1.*' } }
require('typst-preview').setup {}

-- Open the PDF that tinymist exports next to the current .typ file
vim.api.nvim_create_user_command('OpenPdf', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:match '%.typ$' then
    local pdf_path = filepath:gsub('%.typ$', '.pdf')
    vim.system { 'zathura', pdf_path }
  end
end, {})
