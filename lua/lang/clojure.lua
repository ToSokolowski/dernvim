-- Clojure, Babashka and Fennel evaluation via Conjure.
-- Use an external plain-Fennel REPL, not the default Aniseed dialect.
vim.g['conjure#filetype#fennel'] = 'conjure.client.fennel.stdio'
-- Connect to project REPLs explicitly; don't silently start a bb REPL
-- while working on JVM Clojure.
vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
-- Use the working tree directly when available (no clone or update needed).
local conjure_dir = vim.fn.expand '~/dev/conjure-cider'
if vim.fn.isdirectory(conjure_dir) == 1 then
  vim.opt.runtimepath:prepend(conjure_dir)
  local after_dir = conjure_dir .. '/after'
  if vim.fn.isdirectory(after_dir) == 1 then vim.opt.runtimepath:append(after_dir) end
else
  -- SSH uses the user's GitHub credentials for the private fork.
  vim.pack.add { 'git@github.com:ToSokolowski/conjure-cider.git' }
end
