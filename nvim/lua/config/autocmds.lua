-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Auto-reload files changed on disk (e.g. by a coding agent) even while the
-- nvim pane stays focused. Neovim only reloads on `:checktime`, and LazyVim
-- only runs that on focus change. This also checks after the cursor pauses for
-- `updatetime` (~200ms in LazyVim), so a live edit shows up without switching
-- panes. `checktime` is just a stat() per buffer, so the cost is negligible.
-- The getcmdwintype() guard avoids running it while in the command-line window.
-- `CursorHoldI` is deliberately NOT included: running `checktime` in insert
-- mode lets a reload swap the buffer out from under the cursor mid-keystroke.
-- Modified buffers are skipped too -- for those `checktime` has to ask what to
-- do, and a prompt every `updatetime` while typing is both noisy and easy to
-- dismiss the wrong way. Unmodified buffers still reload promptly, which is the
-- case this autocmd exists for.
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function(ev)
    if vim.fn.getcmdwintype() ~= "" then
      return
    end
    if vim.bo[ev.buf].modified or vim.bo[ev.buf].buftype ~= "" then
      return
    end
    vim.cmd("checktime")
  end,
})
