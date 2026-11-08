-- [[ Plugins: Neovim's built-in vim.pack (Neovim 0.12+) ]]
assert(vim.fn.has 'nvim-0.12' == 1, 'This configuration requires Neovim 0.12+ (vim.pack)')
-- Inspect: :lua vim.pack.update(nil, { offline = true })
-- Update:  :lua vim.pack.update()
-- Plugins load eagerly; each module adds its dependencies before their consumers.
-- vim.pack.add is idempotent, so a shared dependency may be listed in several modules.

require 'plugins.ui'
require 'plugins.editor'
require 'plugins.git'
require 'plugins.telescope'
require 'plugins.completion'
require 'plugins.lsp'
require 'plugins.format'
require 'plugins.treesitter'
require 'plugins.ai'
require 'plugins.debug'
require 'plugins.obsidian'

require 'lang.clojure'
require 'lang.scala'
require 'lang.java'
require 'lang.typst'
