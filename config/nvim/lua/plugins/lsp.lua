local util = require("lspconfig.util")

-- PYRIGHT MONOREPO SETUP
-- modifying the example below:
-- -- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
local get_root_dir = function(buf_path, bufnr)
  -- if a python virtual environment is activated before opening nvim
  -- vim.env.VIRTUAL_ENV is set to the venv path, eg git_root/.venv
  if vim.env.VIRTUAL_ENV then
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
    -- otherwise no venv packages can be found
    client.config.settings.python.pythonPath = get_venv_bin()

    client.config.settings.python.venvPath = vim.env.VIRTUAL_ENV or util.path.join(vim.env.PWD, ".venv")
    client.config.settings.python.venv = get_venv_bin()
  end,
  -- root_dir = get_root_dir,
  settings = {
    useLibraryCodeForTypes = true,
    verboseOutput = true,
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        -- ignore = { "*" },
      },
    },
  },
}

local ruff = {
  autostart = false,
  on_init = function(client)
    home = vim.loop.os_homedir()
    local path = home .. "/projects/pytower/nautilus_trader/pyproject.toml"

    -- local root = get_root_dir()
    -- if string.match(root, "pytower") then
    -- there is no feedback if path does not exist

    vim.loop.fs_stat(path, function(err, stat)
      if err then
        print("ruff: " .. path .. " does not exist...")
      else
        client.config.settings.configuration = path
        client.config.settings.linelength = 100
      end
    end)
    -- end
    --
  end,
  -- init_options = {
  --   settings = {
  --     configuration = vim.fn.stdpath("config") .. "/pyproject.toml",
  --   },
  -- },
  -- not necessary, pytower now does not use black
  -- and config files are contained within the repo
  -- ["format.args"] = {
  --   -- these are nautilus_trader black args
  --   "--line-length=150",
  --   -- add 3.9, 3.11 when ruff supports multiple --target-version arguments on the CLI
  --   -- https://github.com/astral-sh/ruff/issues/2857
  --   "--target-version py310",
  -- },
  -- ["format.args"] = function()
  --   print("a function was invoked")
  --   vim.notify(get_root_dir())
  --   return "--config=" .. vim.fn.stdpath("config") .. "/pyproject.toml"
  -- end,
  --
  -- ["lint.args"] = function()
  --   print("a function was invoked")
  --   vim.notify(get_root_dir())
  --   return "--config=" .. vim.fn.stdpath("config") .. "/pyproject.toml"
  -- end,
  -- logLevel = "debug",
  -- -- },
  -- },
}

-- https://github.com/MysticalDevil/inlay-hints.nvim
-- 2 ways of debugging rust_analyzer in nvim
-- Option 1: analyse the LSP logs:
-- vim.lsp.log.set_level("DEBUG")
-- vim.lsp.log.show_filepath()
-- tail -f <filepath>
-- Option 2: analyse the tracing logs
-- https://rust-analyzer.github.io/book/contributing/index.html?highlight=tracing#logging
--
local rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      -- cmd = { "rust-analyzer", "--log-file", "/tmp/rustls.log" },
      diagnostics = {
        -- rust_analyzer will comment out code that is not "owned" by the project (included in lib.rs)
        -- this disables the diagnostic and the commenting
        disabled = { "unlinked-file" },
      },
      -- https://sourcegraph.com/github.com/zchee/.nvim/-/blob/lua/plugins/lsp/rust_analyzer.lua
      rust = {
        analyzerTargetDir = "target/rust-analyzer",
      },
      -- cargo = { targetDir = true },
    },

    -- ENABLE this to debug rust_analyzer tracing logs
    -- cmd = { "rust-analyzer", "--log-file", "/tmp/rustls.log" },
    -- env = {
    --   RUST_LOG = "debug",
    --   RA_LOG_FILE = "/tmp/rustls.log",
    --   RA_LOG = "lsp_server=debug",
    -- },
  },
}
-- checkOnSave = false,
--  inlayHints = {
--     bindingModeHints = {
--       enable = false,
--     },
--     chainingHints = {
--       enable = true,
--     },
--     closingBraceHints = {
--       enable = true,
--       minLines = 25,
--     },
--     closureReturnTypeHints = {
--       enable = "never",
--     },
--     lifetimeElisionHints = {
--       enable = "never",
--       useParameterNames = false,
--     },
--     maxLength = 25,
--     parameterHints = {
--       enable = true,
--     },
--     reborrowHints = {
--       enable = "never",
--     },
--     renderColons = true,
--     typeHints = {
--       enable = true,
--       hideClosureInitialization = false,
--       hideNamedConstructor = false,
--     },
--   },

-- note: pylyzer is unusable until it can resolve local .venv imports
-- https://github.com/mtshiba/pylyzer/issues/22
local pylyzer = {
  -- root_dir = get_root_dir,
  root_dir = function()
    return "/Users/f1/projects/pytower/pytower"
  end,
  cmd_env = { RUST_BACKTRACE = "FULL" },
}

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "mypy")
      opts.log_level = vim.log.levels.DEBUG
    end,
  },

  -- https://stackoverflow.com/questions/76487150/how-to-avoid-cannot-find-implementation-or-library-stub-when-mypy-is-installed
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      -- opts.debug = true
      -- opts.sources = vim.list_extend(opts.sources or {}, {
      --   nls.builtins.diagnostics.mypy.with({
      --     extra_args = function()
      --       local config_file = vim.fn.stdpath("config") .. "/pyproject.toml"
      --       return { "--config-file", config_file, "--python-executable", get_venv_bin() }
      --     end,
      --   }),
      -- })
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
        -- if using lazyVim, pyright cannot be disabled
        -- https://github.com/LazyVim/LazyVim/discussions/1506
        pyright = pyright,
        -- pylyzer = pylyzer,
        ruff = ruff,
      },
      -- inlay_hints = {enabled = true},
      diagnostics = {
        -- prevents diagnostics hiding in insert mode
        -- prevents diagnostics flashing on save
        -- LazyVim sets this to false by default
        update_in_insert = true,
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
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   -- the goal is to use rust_analyzer from rustup so they are updated at the same time with rustup update
  --   -- TODO: rust_analyzer is still being installed by mason-lspconfig.nvim ?
  --   opts = {
  --     -- automatic_installation=false
  --     -- better to install rust_analyzer using rustup to match with the rust version
  --     automatic_installation = false,
  --     ensure_installed = {},
  --   },
  -- },
  -- nvim-lspconfig provides a default nvim lsp server setup with handling for setting the lsp root, and the .venv
  -- -- lspconfig/server_configurations/pyright.lua
  -- { "HallerPatrick/py_lsp.nvim", opts = {} },
}
