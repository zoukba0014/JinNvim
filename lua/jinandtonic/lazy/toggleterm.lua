return {
    'akinsho/toggleterm.nvim',
    -- tag = '*',
    lazy = false,
    config = function()
        require('toggleterm').setup {
            direction = 'float', -- 'vertical' | 'horizontal' | 'window' | 'float',
            shade_terminals = true,
            start_in_insert = true,
            insert_mappings = true,
            colors = {
                terminal_background = vim.api.nvim_get_hl_by_name("Normal", true).background,
            },
        }
        vim.api.nvim_set_keymap('n', '<C-t>t', ':ToggleTerm<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<C-t>\\', [[<C-\><C-n>]], { noremap = true, silent = true })
    end,
}
