-- neovim config. goes into ~/.config/nvim/init.lua

-- Text editing features.
vim.opt.autoindent = true -- Retain indentation level for new lines.
vim.opt.smartindent = true -- Automatically indent after { and stuff.
vim.opt.expandtab = true -- Down with hard tabs!
vim.opt.tabstop = 4 -- 4 space indent by default.
vim.opt.shiftwidth = 4 -- You have to say this twice for some reason.

vim.opt.ignorecase = true -- Search ignores case by default. respect case with \C prefix.
vim.opt.smartcase = true -- Search switches to case sensitive sometimes.
vim.opt.hlsearch = false -- Do not highlight search results.

-- Key remapping. https://neovim.io/doc/user/lua/#vim.keymap
-- Ctrl+Space should probably autocomplete instead of whaveter the hell it does normally.
vim.keymap.set({"n", "v", "c"}, "<Nul>",     "") -- Disable Ctrl+Space in most modes.
vim.keymap.set({"n", "v", "c"}, "<C-Space>", "") -- Disable Ctrl+Space in most modes.
vim.keymap.set("i", "<Nul>",     "<C-N>") -- Autocomplete
vim.keymap.set("i", "<C-Space>", "<C-N>") -- Autocomplete

vim.keymap.set("n", "Q", "") -- Nice try, Ex mode.
vim.keymap.set("n", ";", ":") -- I've never wanted to use ;.
vim.keymap.set({"n", "i", "v", "c"}, "<F1>", "") -- Hitting F1 is always an accident.

vim.keymap.set("n", "Y", "yy") -- Shift+Y should copy the entire line.

-- Reorder tabs with Ctrl+Shift+PageUp and Ctrl+Shift+PageDown.
-- FIXME: This does nothing??
vim.keymap.set("n", "<C-S-PageUp>",   ":tabmove -1<CR>")
vim.keymap.set("n", "<C-S-PageDown>", ":tabmove +1<CR>")

vim.opt.tabpagemax = 400 -- I decide when I'm opening too many tabs, thank you.

-- Enable adding words to a dictionary with zg.
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spellbook.en.utf-8.add"
