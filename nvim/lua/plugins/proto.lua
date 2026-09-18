-- Protobuf support: treesitter highlighting, the Buf language server, and
-- `buf format` on save.
--
-- LazyVim ships no `lang.proto` extra, so all four pieces are wired by hand.
-- The LSP is the Buf CLI itself (`buf lsp serve`), installed with Homebrew
-- rather than Mason — the same binary runs `buf lint` / `buf generate` from
-- the shell, and mason-lspconfig has no mapping for `buf_ls` anyway.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- opts_extend on the LazyVim spec, so this appends rather than replaces.
    opts = { ensure_installed = { "proto" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        buf_ls = { mason = false },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        proto = { "buf" },
      },
    },
  },

  -- buf's own config files aren't detected as `buf-config` automatically, and
  -- buf_ls claims that filetype alongside `proto`. Registering them gets
  -- schema-aware diagnostics in buf.yaml / buf.gen.yaml; the treesitter
  -- mapping keeps them highlighted as the YAML they are.
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({
        filename = {
          ["buf.yaml"] = "buf-config",
          ["buf.gen.yaml"] = "buf-config",
          ["buf.work.yaml"] = "buf-config",
          ["buf.lock"] = "buf-config",
        },
      })
      vim.treesitter.language.register("yaml", "buf-config")
    end,
  },
}
