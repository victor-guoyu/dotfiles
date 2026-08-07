-- Format Python through conform's CLI formatters rather than the ruff LSP.
--
-- LazyVim's `lang.python` extra configures no conform formatters, so with
-- `default_format_opts.lsp_format = "fallback"` every Python format-on-save was
-- served by the ruff *language server*. When the buffer is momentarily invalid
-- Python mid-edit, that path can replace the whole document with an empty edit,
-- so saving silently truncated the file.
--
-- Conform runs formatters as processes and only applies stdout when the exit
-- code is in `exit_codes` (default `{ 0 }`). `ruff format` exits 2 and prints
-- nothing on a parse error, so a bad parse now aborts the format and leaves the
-- buffer as-is.
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "ruff_organize_imports", "ruff_format" },
    },
  },
}
