-- Jsonnet support: treesitter highlighting, Grafana's jsonnet-language-server,
-- and `jsonnetfmt` on save.
--
-- LazyVim ships no `lang.jsonnet` extra, so the pieces are wired by hand, as
-- for proto. Neovim already detects .jsonnet and .libsonnet as `jsonnet`.
--
-- Both binaries come from install.sh, not Mason: Mason's packages for them are
-- `go install` builds, which fail without a Go toolchain, while upstream ships
-- prebuilt binaries for every platform we run on.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- opts_extend on the LazyVim spec, so this appends rather than replaces.
    opts = { ensure_installed = { "jsonnet" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonnet_ls = { mason = false },
      },
    },
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
