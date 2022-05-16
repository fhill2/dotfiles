local entries = {}

local function a(t)
  table.insert(entries, t)
end

a({
  title = "this is a result in the omnimenu",
  desc = "desc here",
  action = function()
    dump("omnimenu trig")
  end,
})

a({
  title = "send to old - dry run",
  desc = "this desc",
  action = function()
    require("util.old.init").test()
  end,
})

a({
  title = "python - retab",
  desc = "this desc",
  action = function()
    -- set noexpandtab --> converts spaces to tabs
    -- set expandtab --> converts tabs to spaces
    -- my default: expandtab --> converting tabs to spaces
    vim.cmd("retab!")
  end,
})

-- a{
--   title = "python - quickfix only errors",
--   --desc = "this desc",
--   action = function()
--     require"util.python".quickfix_only_errors()
--   end
-- }

a({
  title = "run - unlock parser",
  --desc = "this desc",
  action = function()
    require("util.run.init").unlock_parser()
  end,
})

a({
  title = "run - lock parser - default no ft - RUN RAW OUTPUT",
  action = function()
    require("util.run.init").lock_parser("default")
  end,
})

a({
  title = "lsp set log level - vim.lsp.set_log_level(1) or 'debug'",
  action = function()
    vim.lsp.set_log_level(1)
  end,
})


a({
  title = "lsp print servers",
  action = function()
    require"lsp/util".print_lsp_servers()
  end,
})

a({
  title = "sniprun REPL toggle",
  action = function()
    require"plugin.sniprun.repl".toggle()
  end,
})
a({
  title = "send to old - DRY run - print output path",
  action = function()
    require"util.old.init".test()
  end,
})


a({
  title = "Telescope - builtin",
  action = function()
    require"util.old.init".test()
    require"telescope.builtin"
  end,
})

-- maybe to add
-- ["<leader>h"] = { name = "+help" },
-- ["<leader>ht"] = { "<cmd>:Telescope builtin<cr>", "Telescope" },
-- ["<leader>hc"] = { "<cmd>:Telescope commands<cr>", "Commands" },
-- ["<leader>hh"] = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
-- ["<leader>hm"] = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
-- ["<leader>hk"] = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
-- ["<leader>hs"] = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
-- ["<leader>hl"] = { [[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor" },
-- ["<leader>hf"] = { "<cmd>:Telescope filetypes<cr>", "File Types" },
-- ["<leader>ho"] = { "<cmd>:Telescope vim_options<cr>", "Options" },
-- ["<leader>ha"] = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
-- ["<leader>hp"] = { name = "+packer" },
-- ["<leader>hpp"] = { "<cmd>PackerSync<cr>", "Sync" },
-- ["<leader>hps"] = { "<cmd>PackerStatus<cr>", "Status" },
-- ["<leader>hpi"] = { "<cmd>PackerInstall<cr>", "Install" },
-- ["<leader>hpc"] = { "<cmd>PackerCompile<cr>", "Compile" },



return entries
