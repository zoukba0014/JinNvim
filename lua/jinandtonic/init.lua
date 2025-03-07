require("jinandtonic.set")
require("jinandtonic.remap")
require("jinandtonic.lazy_init")


local augroup = vim.api.nvim_create_augroup
local JinAndTonic = augroup('JinAndTonic', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = JinAndTonic,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('BufEnter', {
    group = JinAndTonic,
    callback = function()
        vim.cmd.colorscheme("gruvbox")
        -- vim.cmd.colorscheme("catppuccin-mocha")
    end
})


autocmd('LspAttach', {
    group = JinAndTonic,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
            { buffer = e.buf, desc = "Go to definition" })
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
            { buffer = e.buf, desc = "Show hover information" })
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end,
            { buffer = e.buf, desc = "Go to declaration" })
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end,
            { buffer = e.buf, desc = "Go to implementation" })
        vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end,
            { buffer = e.buf, desc = "Go to type definition" })
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end,
            { buffer = e.buf, desc = "Show references" })
        vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help() end,
            { buffer = e.buf, desc = "Show signature help" })
        vim.keymap.set("n", "gE", function() vim.diagnostic.open_float() end,
            { buffer = e.buf, desc = "Show diagnostics in float window" })

        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = e.buf,
            callback = function()
                if vim.bo[e.buf].filetype == "python" then
                    vim.lsp.buf.format({ async = false })
                elseif e.data and e.data.client_id then
                    vim.lsp.buf.format({ async = false, id = e.data.client_id })
                end
            end,
        })
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- change the cursor when in the insert mode
vim.opt.guicursor = {
    "n-v-c-sm:block", -- Normal, Visual, Command mode: block cursor
    "i-ci-ve:ver25",  -- Insert, Command-line insert, Visual replace: vertical bar (thinner)
    "r-cr:hor20",     -- Replace mode: horizontal bar
    "o:hor50",        -- Operator-pending mode: horizontal bar
}

-- vim.api.nvim_set_hl(0, "CopilotSuggestion", {
--     fg = "#83a598",
--     -- italic = true -- 不用 gui=italic，直接用 italic = true
-- })
--
-- 添加到你的 init.lua 中的配置
-- 设置彩色缩进的颜色
-- local highlight = {
--     "RainbowRed",
--     "RainbowYellow",
--     "RainbowBlue",
--     "RainbowOrange",
--     "RainbowGreen",
--     "RainbowViolet",
--     "RainbowCyan",
-- }
--
-- local hooks = require "ibl.hooks"
-- -- 创建彩色缩进的高亮组
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
--     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
--     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
--     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
--     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
--     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
--     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
-- end)
