-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle hidden files in Snacks explorer
vim.keymap.set("n", "<leader>eh", function()
  require("snacks").explorer.toggle_hidden()
end, { desc = "Toggle hidden files in explorer" })
