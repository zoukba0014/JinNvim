return {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false,   -- This plugin is already lazy
    config = function()
        vim.lsp.inlay_hint.enable(true)
        vim.g.rustaceanvim = {
            server = {
                settings = {
                    ['rust-analyzer'] = {
                        checkOnSave = {
                            command = "check"
                        },
                        procMacro = {
                            enable = true
                        },
                        cargo = {
                            loadOutDirsFromCheck = true,
                            allFeatures = true,
                        },
                        inlayHints = {
                            enable = true,
                            typeHints = {
                                enable = true,
                            },
                            parameterHints = {
                                enable = true,
                            },
                        },
                    }
                }
            }
        }
    end
}
