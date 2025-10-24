return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        -- ❌ 不再使用 null-ls / none-ls，这两行保持注释或删除
        -- "jose-elias-alvarez/null-ls.nvim",
        -- "nvimtools/none-ls.nvim",
    },

    config = function()
        -- === Conform：用 black 做 Python 格式化 ===
        require("conform").setup({
            formatters_by_ft = {
                python = { "black" }, -- 需要系统或 mason 安装 black
            },
            -- 可选：保存自动格式化
            format_on_save = function(bufnr)
                -- 仅当 LSP 未提供 format 或你偏好使用 conform 时开启
                return { lsp_fallback = true, async = false, timeout_ms = 15000 }
            end,
            -- -- 对 black 做更细配置
            -- formatters = {
            --     black = {
            --         -- 明确指定 mason 安装的 black（也可以换成 "black" 用系统的）
            --         command = "/Users/jin/.local/share/nvim/mason/bin/black",
            --         -- 走 stdin（Conform 默认就是 true；black 支持 "-"）
            --         stdin = true,
            --         args = { "-q", "-" },
            --         -- 把 cwd 设为项目根，避免黑盒地扫磁盘导致偶发变慢
            --         cwd = util.root_file({ "pyproject.toml", "setup.cfg", "requirements.txt", ".git" }),
            --         -- 单独的 formatter 级别超时（毫秒）
            --         timeout = 15000,
            --     },
            -- },
        })

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
                -- 可选：加上 ruff_lsp 用于 Python 诊断（不负责格式化）
                -- "ruff_lsp",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup({
                        on_attach = function(client, _)
                            -- 让格式化交给 Conform（black）
                            client.server_capabilities.documentFormattingProvider = false
                        end,
                        capabilities = capabilities,
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

                -- 如果启用 ruff_lsp，可这样细化：
                -- ["ruff_lsp"] = function()
                --   require("lspconfig").ruff_lsp.setup({
                --     capabilities = capabilities,
                --     on_attach = function(client, _)
                --       -- ruff 仅诊断，避免与 black/Conform 冲突
                --       client.server_capabilities.documentFormattingProvider = false
                --     end,
                --   })
                -- end,
            }
        })

        -- ❌ 移除 / 注释掉 null-ls 相关段落
        -- local null_ls = require("null-ls")
        -- null_ls.setup({ ... })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>']     = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>']     = cmp.mapping.select_next_item(cmp_select),
                ['<CR>']      = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
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
