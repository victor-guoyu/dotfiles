-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Option+Arrow word-wise motion. Ghostty sends <M-b>/<M-f> on macOS for
-- Option+Left/Right, so both forms are mapped to keep parity with native macOS apps.
vim.keymap.set({ "i", "n" }, "<M-Left>", "<C-Left>")
vim.keymap.set({ "i", "n" }, "<M-Right>", "<C-Right>")
vim.keymap.set({ "i", "n" }, "<M-b>", "<C-Left>")
vim.keymap.set({ "i", "n" }, "<M-f>", "<C-Right>")

-- Option+Delete deletes the previous word (macOS convention).
vim.keymap.set("i", "<M-BS>", "<C-w>")
