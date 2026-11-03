-- Metals manages its own LSP client, so it isn't in the servers table in plugins/lsp.lua.
-- It also handles Java files inside sbt/Mill builds; other Java goes to jdtls (lang/java.lua).
local M = {}

M.root_markers = { 'build.sbt', 'build.sc', 'build.mill' }

---@param buf integer
function M.is_project(buf) return vim.fs.root(buf, M.root_markers) ~= nil end

vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/mfussenegger/nvim-dap' }
vim.pack.add { 'https://github.com/scalameta/nvim-metals' }

local metals_config = require('metals').bare_config()

-- Integration with blink.cmp
metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()

-- Enables debugging support
metals_config.on_attach = function() require('metals').setup_dap() end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('nvim-metals', { clear = true }),
  pattern = { 'scala', 'sbt', 'java' },
  callback = function(ev)
    if vim.bo[ev.buf].filetype == 'java' and not M.is_project(ev.buf) then return end
    require('metals').initialize_or_attach(metals_config)
  end,
})

return M
