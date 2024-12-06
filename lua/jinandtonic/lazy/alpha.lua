return {
    {
        'goolord/alpha-nvim',
        dependencies = { 'echasnovski/mini.icons', 'nvim-lua/plenary.nvim' },
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                "   ▗▖▗▄▄▄▖▗▖  ▗▖ ▗▄▖ ▗▖  ▗▖▗▄▄▄▗▄▄▄▖▗▄▖ ▗▖  ▗▖▗▄▄▄▖ ▗▄▄▖",
                "   ▐▌  █  ▐▛▚▖▐▌▐▌ ▐▌▐▛▚▖▐▌▐▌  █ █ ▐▌ ▐▌▐▛▚▖▐▌  █  ▐▌",
                "   ▐▌  █  ▐▌ ▝▜▌▐▛▀▜▌▐▌ ▝▜▌▐▌  █ █ ▐▌ ▐▌▐▌ ▝▜▌  █  ▐▌",
                "▗▄▄▞▘▗▄█▄▖▐▌  ▐▌▐▌ ▐▌▐▌  ▐▌▐▙▄▄▀ █ ▝▚▄▞▘▐▌  ▐▌▗▄█▄▖▝▚▄▄▖",
            }

            require 'alpha'.setup(dashboard.config)
        end
    },
}
