-- Clojure, Babashka and Fennel evaluation via Conjure.
-- Use an external plain-Fennel REPL, not the default Aniseed dialect.
vim.g['conjure#filetype#fennel'] = 'conjure.client.fennel.stdio'
-- Connect to project REPLs explicitly; don't silently start a bb REPL
-- while working on JVM Clojure.
vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
vim.pack.add { 'https://github.com/Olical/conjure' }
