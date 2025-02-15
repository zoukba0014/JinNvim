return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'gruvbox',                                  -- 自动匹配 Neovim 主题色
                    component_separators = { left = '|', right = '|' }, -- 组件分隔符
                    section_separators = { left = '', right = '' },     -- 区块分隔符（如不需要留空）
                },
                sections = {
                    lualine_a = { 'mode' },                               -- 左侧模式（NORMAL/INSERT/VISUAL）
                    lualine_b = { 'branch' },                             -- 显示 Git 分支
                    lualine_c = { 'filename' },                           -- 当前文件名
                    lualine_x = { 'encoding', 'fileformat', 'filetype' }, -- 文件编码、格式、类型
                    lualine_y = { 'progress' },                           -- 光标位置（行:列）
                    lualine_z = { 'location' }                            -- 光标行位置百分比
                }
            }
        end
    }
}
