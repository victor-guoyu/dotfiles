-- Send fzf-lua's LSP requests (gd, gr, gI, gy, ...) asynchronously.
--
-- fzf-lua's default is a blocking `vim.lsp.buf_request_sync` with a 5s
-- timeout: the editor freezes, then fails with "Error executing
-- 'textDocument/references': timeout" whenever the server is slower than that.
-- gopls is, for its first few minutes in a large workspace (grafana's go.work
-- spans dozens of modules) while it loads and indexes packages; requests wait
-- behind that and only answer once it finishes.
--
-- Async opens the picker at once and fills it as the server answers. jump1
-- still applies: a single result closes the picker and jumps straight there.
return {
  "ibhagwan/fzf-lua",
  opts = {
    lsp = {
      async_or_timeout = true,
    },
  },
}
