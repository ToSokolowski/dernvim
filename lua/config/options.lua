-- DISABLE NETRW (oil.nvim handles directories)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Babashka scripts use the same tooling as Clojure source files.
vim.filetype.add { extension = { bb = 'clojure' } }

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim. Scheduled because it can increase startup-time.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

vim.o.cursorline = true
vim.o.scrolloff = 10

-- Ask to save instead of failing on operations like `:q` with unsaved changes
vim.o.confirm = true

-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float when jumping with `[d` and `]d`
  jump = { float = true },
}
