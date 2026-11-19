-- CUE support: treesitter highlighting, the CUE language server, and
-- `cue fmt` on save.
--
-- LazyVim ships no `lang.cue` extra, so the three pieces are wired by hand.
-- The LSP is the CUE CLI itself (`cue lsp`), installed with Homebrew rather
-- than Mason: it is the same binary that runs `cue vet` / `cue export` from
-- the shell, and its version should match the one the project is built with.
-- Filetype detection for *.cue is built into Neovim.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- opts_extend on the LazyVim spec, so this appends rather than replaces.
    opts = { ensure_installed = { "cue" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cue = { mason = false },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cue = { "cue_fmt" },
      },
    },
  },
}
