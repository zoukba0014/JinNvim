return {
    {
        "github/copilot.vim",
        lazy = false,
        config = function()
            -- i want to change the copilot color
            -- vim.api.nvim_set_hl(0, "CopilotSuggestion", { guifg = "#928374", gui = "italic" })
            -- -- vim.cmd [[
            --     highlight CopilotSuggestion guifg=#928374 gui=italic
            -- ]]
        end,
    },
}
