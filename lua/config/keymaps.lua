-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- vim.keymap.set
-- create a vim keymap which will use leader e and with run the vim.Explorer command

vim.keymap.set("n", "<leader>fx", vim.cmd.Explore)
