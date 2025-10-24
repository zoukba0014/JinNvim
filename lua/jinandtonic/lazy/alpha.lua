return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "echasnovski/mini.icons",
            "nvim-telescope/telescope.nvim",
            "Shatur/neovim-session-manager",
        },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- ====== Header ======
            dashboard.section.header.val = {
                "   ▗▖▗▄▄▄▖▗▖  ▗▖ ▗▄▖ ▗▖  ▗▖▗▄▄▄▗▄▄▄▖▗▄▖ ▗▖  ▗▖▗▄▄▄▖ ▗▄▄▖",
                "   ▐▌  █  ▐▛▚▖▐▌▐▌ ▐▌▐▛▚▖▐▌▐▌  █ █ ▐▌ ▐▌▐▛▚▖▐▌  █  ▐▌",
                "   ▐▌  █  ▐▌ ▝▜▌▐▛▀▜▌▐▌ ▝▜▌▐▌  █ █ ▐▌ ▐▌▐▌ ▝▜▌  █  ▐▌",
                "▗▄▄▞▘▗▄█▄▖▐▌  ▐▌▐▌ ▐▌▐▌  ▐▌▐▙▄▄▀ █ ▝▚▄▞▘▐▌  ▐▌▗▄█▄▖▝▚▄▄▖",
            }

            -- ====== Buttons ======
            local button = dashboard.button
            dashboard.section.buttons.val = {
                button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
                button("r", "  Recent", ":Telescope oldfiles <CR>"),
                button("s", "🧩  Load session", ":SessionManager load_session<CR>"),
                button("q", "󰅚  Quit", ":qa<CR>"),
            }

            dashboard.section.footer.val = "🚀 JinAndTonic Neovim"
            dashboard.opts.layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 1 },
                dashboard.section.footer,
            }

            alpha.setup(dashboard.opts)

            ----------------------------------------------------------------
            -- ✅ 如果启动时打开的是目录，就自动显示 Alpha
            ----------------------------------------------------------------
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    local arg = vim.fn.argv(0)
                    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
                        vim.cmd("Alpha")
                        vim.cmd("cd " .. arg)
                    end
                end,
            })
        end,
    },
}
