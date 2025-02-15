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
