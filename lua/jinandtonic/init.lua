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
            -- 3
            buffer = e.buf,
            callback = function()
                -- 4 + 5
                vim.lsp.buf.format { async = false, id = e.data.client_id }
            end,
        })
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25