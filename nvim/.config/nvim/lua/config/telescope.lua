local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ hidden=true}) end)
vim.keymap.set('n', '<leader>pp', builtin.git_files, { desc = 'Telescope Git find' })
vim.keymap.set('n', '<leader>pd', builtin.live_grep)
