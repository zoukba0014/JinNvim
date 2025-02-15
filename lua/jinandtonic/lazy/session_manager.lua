return {
    'Shatur/neovim-session-manager',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local Path = require('plenary.path')
        local config = require('session_manager.config')
        require('session_manager').setup({
            sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- 设置sessions保存路径
            autoload_mode = config.AutoloadMode.LastSession,             -- 自动加载最后一次的session
            autosave_last_session = true,                                -- 自动保存最后一次的session
            autosave_ignore_not_normal = true,                           -- 不保存不正常的buffers
            autosave_ignore_dirs = {},                                   -- 不保存特定目录的session
            autosave_ignore_filetypes = {                                -- 不保存特定文件类型的session
                'gitcommit',
                'gitrebase',
            },
            autosave_ignore_buftypes = {},    -- 不保存特定buffer类型的session
            autosave_only_in_session = false, -- 只在session目录下自动保存
        })

        -- 自动保存session的autocmd
        vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
            callback = function()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    -- don't save while there are any "nofile" buffers open
                    if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
                        return
                    end
                end
                require('session_manager').save_current_session()
            end
        })
    end
}
