-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Auto-reload files changed on disk (e.g. by a coding agent) even while the
-- nvim pane stays focused. Neovim only reloads on `:checktime`, and LazyVim
-- only runs that on focus change. This also checks after the cursor pauses for
-- `updatetime` (~200ms in LazyVim), so a live edit shows up without switching
-- panes. `checktime` is just a stat() per buffer, so the cost is negligible.
-- The getcmdwintype() guard avoids running it while in the command-line window.
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if getcmdwintype() == '' | checktime | endif",
})
