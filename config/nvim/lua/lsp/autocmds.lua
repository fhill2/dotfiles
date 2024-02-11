local M = {}

local autocmd = vim.api.nvim_create_autocmd
local lsp_augroup = vim.api.nvim_create_augroup("MyLocalLSPGroup", {})

M.attach = function(client, bufnr)
    autocmd("LspDetach", {
        group = lsp_augroup,
        buffer = bufnr,
        callback = function()
            vim.api.nvim_del_augroup_by_id(lsp_augroup)
        end,
        desc = "Delete lsp autocmds after detaching client",
    })
end

return M
