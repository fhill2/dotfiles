-- https://github.com/dcampos/nvim-snippy/wiki/Loading-VSCode-snippets
local friendly_snippets_template = {
    sources = {
        vscode = {
            -- When adding vscode snippets:
            -- snippet-converter.nvim uses vim.api.nvim_get_runtime_file("*/*json", true) to find vscode snippets under all runtime path dirs
            -- this means runtime_dir/snippets/*.json is found by snippet-converter, BUT runtime_dir/src/snippets is not found...
            "./friendly-snippets/snippets/",

            -- as vscode-es7-javascript-react-snippets are not in the directory structure supported by runtime path
            -- use absolute filepath, which does not try to find the snippet file in runtime path.
            -- EDIT: these were added to friendly-snippets
        },
    },
    output = {
        snipmate = {
            vim.fn.stdpath("data") .. "/site/snippets",
        },
    },
}

require("snippet_converter").setup({
    templates = { friendly_snippets_template },
})
