local util = require("lspconfig.util")

-- PYRIGHT MONOREPO SETUP
-- modifying the example below:
-- -- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
local get_root_dir = function(buf_path, bufnr)
  -- if a python virtual environment is activated before opening nvim
  -- vim.env.VIRTUAL_ENV is set to the venv path, eg git_root/.venv
  if vim.env.VIRTUAL_ENV then
    print(vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":h"))
    return vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":h")
  end
  -- fallback to finding the root based on the CWD of the parent shell
  -- why ? I don't want the root to be decided based on the path of the file with monorepos
  -- why not use the nvim-lspconfig default handler?
  -- the root is based on the file loaded, in monorepos this could be a nested git root
  -- pyright needs the root of the monorepo in order to load relative to it
  -- why not py_lsp.nvim?
  -- it does not modify the lsp root, only pythonPath to find imports for libraries in the .venv
  return vim.env.PWD
end

local get_venv_bin = function()
  if vim.env.VIRUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end
  return util.path.join(vim.env.PWD, ".venv", "bin", "python")
end

local pyright = {
  on_init = function(client)
    client.config.settings.python.pythonPath = get_venv_bin()
    client.config.settings.python.venvPath = vim.env.VIRTUAL_ENV or util.path.join(vim.env.PWD, ".venv")
    client.config.settings.python.venv = get_venv_bin()
  end,
  root_dir = get_root_dir,
  settings = {
    useLibraryCodeForTypes = true,
    verboseOutput = true,
  },
}

return {

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- if these keys do not exist, nvim-lspconfig will not start the lsp server upon entering the buffer
        pyright = pyright,
        jsonls = {},
        yamlls = {},
      },
    },
  },
  -- pyright autoimport missing imports
  { "stevanmilic/nvim-lspimport" },

  -- all lsps defined above (keys()) will be installed when opening neovim
  { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
  -- nvim-lspconfig provides a default nvim lsp server setup with handling for setting the lsp root, and the .venv
  -- -- lspconfig/server_configurations/pyright.lua
  -- { "HallerPatrick/py_lsp.nvim", opts = {} },
}
