vim.g.mapleader = " "

local map = vim.keymap.set

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
 
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })
 
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

local opts = { noremap = true, silent = true }
local modes = { "n", "v" }
-- Vertical scrolling (10 lines at a time, cursor stays in place)
map(modes, "<A-Down>", "10<C-e>", opts)
map(modes, "<A-Up>",   "10<C-y>", opts)
map(modes, "<A-j>",    "10<C-e>", opts)
map(modes, "<A-k>",    "10<C-y>", opts)
-- Horizontal scrolling (10 characters at a time)
map(modes, "<A-Right>", "10zl", opts)
map(modes, "<A-Left>",  "10zh", opts)
map(modes, "<A-l>",     "10zl", opts)
map(modes, "<A-h>",     "10zh", opts)

map("n", "<leader>w", "<cmd>setlocal wrap!<CR>", opts)

-- Delete to black hole register (don't yank on delete)
vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true, desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { noremap = true, desc = "Delete to EOL without yanking" })
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true, desc = "Delete char without yanking" })
vim.keymap.set({ "n", "v" }, "X", '"_X', { noremap = true, desc = "Delete back char without yanking" })

-- Optional: also send change operations to black hole
vim.keymap.set({ "n", "v" }, "c", '"_c', { noremap = true, desc = "Change without yanking" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { noremap = true, desc = "Change to EOL without yanking" })

-- ── Buffers ────────────────────────────────────────────────────────────────
map("n", "<leader>bd", "<cmd>bd<cr>",         { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>enew<cr>",        { desc = "New buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Close all other buffers" })
 
-- ── Tabs ───────────────────────────────────────────────────────────────────
map("n", "<leader>tn", "<cmd>tabnew<cr>",    { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>",  { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>",   { desc = "Close all other tabs" })
map("n", "<leader>t]", "<cmd>tabnext<cr>",   { desc = "Next tab" })
map("n", "<leader>t[", "<cmd>tabprev<cr>",   { desc = "Prev tab" })
 
-- ── Diagnostics ────────────────────────────────────────────────────────────
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "<leader>dq", vim.diagnostic.setqflist,  { desc = "Send diagnostics to quickfix" })
 
-- ── Quickfix ───────────────────────────────────────────────────────────────
map("n", "<leader>qo", "<cmd>copen<cr>",  { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })

