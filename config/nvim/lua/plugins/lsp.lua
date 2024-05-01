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

local ruff_lsp = {
  settings = {
    -- not necessary, pytower now does not use black
    -- and config files are contained within the repo
    -- ["format.args"] = {
    --   -- these are nautilus_trader black args
    --   "--line-length=150",
    --   -- add 3.9, 3.11 when ruff supports multiple --target-version arguments on the CLI
    --   -- https://github.com/astral-sh/ruff/issues/2857
    --   "--target-version py310",
    -- },
    -- ["lint.args"] = {
    --   "--config=" .. vim.fn.stdpath("config") .. "/pyproject.toml",
    -- },
    -- logLevel = "debug",
  },
}

local rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = false,
      },
    },
  },
}

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "mypy")
    end,
  },

  -- https://stackoverflow.com/questions/76487150/how-to-avoid-cannot-find-implementation-or-library-stub-when-mypy-is-installed
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      -- opts.debug = true
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.mypy.with({
          extra_args = function()
            local config_file = vim.fn.stdpath("config") .. "/pyproject.toml"
            return { "--config-file", config_file, "--python-executable", get_venv_bin() }
          end,
        }),
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = rust_analyzer,
        -- if these keys do not exist, nvim-lspconfig will not start the lsp server upon entering the buffer
        jsonls = {},
        yamlls = {},
        -- how to disable pyright to try pylyzer
        -- https://github.com/LazyVim/LazyVim/discussions/1506
        -- pylyzer = {},
        pyright = pyright,
        ruff_lsp = ruff_lsp,
      },
    },
  },
  -- pyright autoimport missing imports
  {
    "stevanmilic/nvim-lspimport",
    keys = {
      {
        "<leader>ci",
        function()
          require("lspimport").import()
        end,
        "Lsp Import (plugin)",
      },
    },
  },

  -- all lsps defined above (keys()) will be installed when opening neovim
  { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
  -- nvim-lspconfig provides a default nvim lsp server setup with handling for setting the lsp root, and the .venv
  -- -- lspconfig/server_configurations/pyright.lua
  -- { "HallerPatrick/py_lsp.nvim", opts = {} },
}
