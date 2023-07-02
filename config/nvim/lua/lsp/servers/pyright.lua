local M = {}

local util = require("lspconfig.util")
--https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
local function get_python_path(workspace)
  dump("GET PYTHON PATH")
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Check for a poetry.lock file
  if vim.fn.glob(util.path.join(workspace, "poetry.lock")) ~= "" then
    return util.path.join(vim.fn.trim(vim.fn.system("poetry env info -p")), "bin", "python")
  end

  -- Find and use virtualenv from pipenv in workspace directory.
  local match = vim.fn.glob(util.path.join(workspace, "Pipfile"))
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
    return util.path.join(venv, "bin", "python")
  end

  -- Fallback to system Python.
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

M = {
  on_init = function(client)
    dump("on init called")
    client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
  end,
  settings = {
    python = {
      formatting = { provider = "black" },
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
}

return M
