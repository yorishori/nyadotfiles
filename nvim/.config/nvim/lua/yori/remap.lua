vim.g.mapleader = " "

local map = vim.keymap.set

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
 
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })
 
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
 
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

