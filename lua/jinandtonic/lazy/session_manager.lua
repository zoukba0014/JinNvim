return {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local Path = require("plenary.path")
        local config = require("session_manager.config")
        local session_manager = require("session_manager")

        session_manager.setup({
            sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"), -- 保存路径
            autoload_mode = config.AutoloadMode.Disabled,                -- ❗ 不自动加载
            autosave_last_session = true,                                -- 自动保存最后 session
            autosave_ignore_not_normal = true,
            autosave_ignore_filetypes = { "gitcommit", "gitrebase" },
            autosave_only_in_session = false,
        })

        -- ✅ 在退出时自动保存当前 session
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
                        return
                    end
                end
                pcall(session_manager.save_current_session)
            end,
        })
    end,
}
