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
    end
})

autocmd('LspAttach', {
    group = JinAndTonic,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help() end, opts)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = e.buf,
            callback = function()
                -- 如果是 Python 文件，直接格式化（基于 pattern）
                if vim.bo[e.buf].filetype == "python" then
                    vim.lsp.buf.format({ async = false })
                    -- 如果有特定的 client_id，使用它格式化（基于 buffer）
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
