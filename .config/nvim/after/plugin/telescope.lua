local builtin = require('telescope.builtin')
-- " " pf - find in "all" files in "current directory"
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- CTRL P - find in "git" files only
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- " " ps - grep in files
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
