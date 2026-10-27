-- Jsonnet support: treesitter highlighting, Grafana's jsonnet-language-server,
-- and `jsonnetfmt` on save.
--
-- LazyVim ships no `lang.jsonnet` extra, so the pieces are wired by hand, as
-- for proto. Neovim already detects .jsonnet and .libsonnet as `jsonnet`.
--
-- Mason installs both: they are `go install` builds, so they need the Go that
-- install.sh puts on PATH through mise.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- opts_extend on the LazyVim spec, so this appends rather than replaces.
    opts = { ensure_installed = { "jsonnet" } },
  },

  -- mason-lspconfig installs the server for jsonnet_ls on its own.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonnet_ls = {},
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "jsonnetfmt" } },
  },

  -- A CLI formatter rather than the server's formatting, for the reason in
  -- conform.lua: jsonnetfmt exits non-zero on a parse error, so conform leaves
  -- a half-typed buffer alone instead of applying whatever came back.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        jsonnet = { "jsonnetfmt" },
      },
    },
  },
}
