return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "jose-elias-alvarez/null-ls.nvim",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                -- "rust_analyzer",
                "gopls",
                "pyright",
                "texlab",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup({
                        on_attach = function(client, _)
                            client.server_capabilities.documentFormattingProvider = false
                        end,
                    })
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["rust_analyzer"] = function()
                    return true
                end,
                -- ["rust_analyzer"] = function()
                --     local lspconfig = require("lspconfig")
                --     lspconfig.rust_analyzer.setup({
                --         capabilities = capabilities,
                --         on_attach = function(client, bufnr)
                --             vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                --         end,
                --         settings = {
                --             ['rust-analyzer'] = {
                --                 checkOnSave = {
                --                     command = "check"
                --                 },
                --                 procMacro = {
                --                     enable = true
                --                 },
                --                 cargo = {
                --                     loadOutDirsFromCheck = true
                --                 },
                --                 inlayHints = {
                --                     enable = true,
                --                     showParameterNames = true,
                --                     parameterHintsPrefix = "<- ",
                --                 },
                --             }
                --         }
                --     })
                -- end,
            }
        })

        -- null-ls
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.black,
            },
        })


        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
