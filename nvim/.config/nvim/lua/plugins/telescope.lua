return 
{
    'nvim-telescope/telescope.nvim', 
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 
            'nvim-telescope/telescope-fzf-native.nvim', 
            build = 'make' 
        }
    },
    opts = {
        defaults = {
            mappings = {
                i = {
                    -- In insert mode, Enter opens in a new tab
                    ["<CR>"] = function(bufnr)
                        require("telescope.actions").select_tab(bufnr)
                    end
                },
                n = {
                    -- Same in normal mode
                    ["<CR>"] = function(bufnr)
                        require("telescope.actions").select_tab(bufnr)
                    end
                }
            }
        }
    }
}
