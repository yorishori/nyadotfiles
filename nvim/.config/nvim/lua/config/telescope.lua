local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope Git find' })
vim.keymap.set('n', '<leader>pd', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
