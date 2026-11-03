-- nvim-treesitter `main` only installs parsers and queries; highlighting and
-- indentation are enabled per buffer below. Parsers are compiled with the
-- tree-sitter CLI and gcc from the Nix wrapper into stdpath('data').
vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter' }

local parsers = {
  'bash',
  'c',
  'clojure',
  'cpp',
  'diff',
  'fennel',
  'haskell',
  'html',
  'java',
  'json',
  'just',
  'latex',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'nix',
  'python',
  'query',
  'rust',
  'scala',
  'toml',
  'typst',
  'vim',
  'vimdoc',
  'yaml',
}

-- Installs missing parsers asynchronously; already installed ones are skipped.
require('nvim-treesitter').install(parsers)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('dernvim-treesitter', { clear = true }),
  callback = function(ev)
    -- Fails quietly when no parser exists for this filetype (yet).
    if not pcall(vim.treesitter.start, ev.buf) then return end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
