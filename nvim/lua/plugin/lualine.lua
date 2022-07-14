
-- https://github.com/folke/tokyonight.nvim
-- use tokyonight colors inside other plugins
--local colors = require("tokyonight.colors").setup({}) -- pass in any of the config options as explained above
--local utils = require("tokyonight.util")
--aplugin.background = colors.bg_dark
--aplugin.my_error = util.brighten(colors.red1, 0.3)
local colors = require"material.colors"

local rep = function(s)
  return s:gsub('/home/f1','~')
end
--https://github.com/glepnir/galaxyline.nvim/issues/12
local get_pwd = function()
 --pwd = vim.cmd([[pwd]])
 --return pwd
 return rep(vim.fn.getcwd())
 end

local lualine_lsp_enabled = false

 -- https://github.com/NTBBloodbath/galaxyline.nvim/blob/main/lua/galaxyline/providers/lsp.lua
 --https://github.com/neovim/nvim-lspconfig/blob/64bd3b95345f2dbedc83a3d9a472662c48b3e940/lua/lspconfig/ui/lspinfo.lua
local get_lsp_client = function()
    local clients = vim.lsp.buf_get_clients()
      if next(clients) == nil then
             lualine_lsp_enabled = false
             return "No Lsp"
      end


    -- merge lsp servers with the same root
    clt_map = {}
    for _, client in pairs(clients) do
      local root = client.workspaceFolders and rep(client.workspaceFolders[1].name) or "single-file"
      if clt_map[root] then
        clt_map[root] = clt_map[root] .. "+" .. client.name
      else
        clt_map[root] = client.name
      end
    end

    -- display/format output string
    local out = ""
    local clt_map_len = vim.tbl_count(clt_map)
    i=1
    for k, v in pairs(clt_map) do
      out = out .. v .. ":" .. k
      if i ~= clt_map_len then out = out .. '    ' end
      i=i+1
    end

    if string.len(out) > 0 then
      lualine_lsp_enabled = true
    return out 
    else
      lualine_lsp_enabled = false
      return "No Lsp"
    end
end



local ts_enabled = function()
  local cbuf = vim.api.nvim_get_current_buf()
  local lang = require("nvim-treesitter.parsers").get_buf_lang(cbuf)
  if vim.api.nvim_win_get_config(0).zindex == nil and vim.api.nvim_buf_get_name(cbuf) ~= "" then
    if vim._ts_has_language(lang) then
      --vim.cmd("syntax off")
      return true
    else
      --vim.cmd("syntax on")
      return false
    end
  end
end

local pyright_venv = function()

  local clients = {}
  --local icon = component.icon or ' '

  for _, client in pairs(vim.lsp.buf_get_clients()) do
    if client.name == "pyright" then
      -- Check if lsp was initialized with py_lsp
      if client.config.settings.python["pythonPath"] ~= nil then
        --local venv_name = client.config.settings.python.venv_name
        local venv_name = client.config.settings.python.pythonPath
        return venv_name
        --clients[#clients+1] = client.name .. '('.. venv_name .. ')'
      else
        return "no Venv"

      end
    end
  end

  return table.concat(clients, ' ')
  --return "ASD"
end

local get_ts = function() return 'TS' end

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'material',
    component_separators = '',
    section_separators = '',
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      {
        'filename',
        file_status = true,      -- Displays file status (readonly status, modified status)
        path = 3,                -- 0: Just the filename
        -- 1: Relative path
        -- 2: Absolute path
        -- 3: Absolute path, with tilde as the home directory

        shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
        -- for other components. (terrible name, any suggestions?)
        symbols = {
          modified = '[+]',      -- Text to show when the file is modified.
          readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
        },
        color = { fg = colors.magenta },
      },
      {''},
      {
        get_pwd, 
        icon = '',
        color = { fg = colors.blue, gui='italic,bold' },
      },
      {
        get_lsp_client,
        icon = '',
        --color = {fg = colors.red },
        color = function(section) return { fg = lualine_lsp_enabled and colors.green or colors.red, gui='italic,bold'}  end,
      },
      {
        get_ts,
        icon = '',
        color = function(section) return { fg = ts_enabled() and colors.green or colors.red, gui='italic,bold' }  end,
      },
      {
        pyright_venv,
        icon = '',
      }
    },
    --lualine_d = {}, -- you cant do this, there is only a,b,c,x,y,z
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  -- inactive_sections = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = {'filename'},
  --   lualine_x = {'location'},
  --   lualine_y = {},
  --   lualine_z = {}
  -- },
  tabline = {},
  extensions = {}
}



-- TOKYONIGHT colors - NIGHT version
-- {
--   bg = "#24283b",
--   bg_dark = "#1f2335",
--   bg_float = "#24283b",
--   bg_highlight = "#292e42",
--   bg_popup = "#1f2335",
--   bg_search = "#3d59a1",
--   bg_sidebar = "#24283b",
--   bg_statusline = "#1f2335",
--   bg_visual = "#364A82",
--   black = "#1D202F",
--   blue = "#7aa2f7",
--   blue0 = "#3d59a1",
--   blue1 = "#2ac3de",
--   blue2 = "#0db9d7",
--   blue5 = "#89ddff",
--   blue6 = "#B4F9F8",
--   blue7 = "#394b70",
--   border = "#1D202F",
--   border_highlight = "#3d59a1",
--   comment = "#565f89",
--   cyan = "#7dcfff",
--   dark3 = "#545c7e",
--   dark5 = "#737aa2",
--   diff = {
--     add = "#283B4D",
--     change = "#272D43",
--     delete = "#3F2D3D",
--     text = "#394b70"
--   },
--   error = "#db4b4b",
--   fg = "#c0caf5",
--   fg_dark = "#a9b1d6",
--   fg_gutter = "#3b4261",
--   fg_sidebar = "#a9b1d6",
--   git = {
--     add = "#449dab",
--     change = "#6183bb",
--     conflict = "#bb7a61",
--     delete = "#914c54",
--     ignore = "#545c7e"
--   },
--   gitSigns = {
--     add = "#266d6a",
--     change = "#536c9e",
--     delete = "#b2555b"
--   },
--   green = "#9ece6a",
--   green1 = "#73daca",
--   green2 = "#41a6b5",
--   hint = "#1abc9c",
--   info = "#0db9d7",
--   magenta = "#bb9af7",
--   magenta2 = "#ff007c",
--   none = "NONE",
--   orange = "#ff9e64",
--   purple = "#9d7cd8",
--   red = "#f7768e",
--   red1 = "#db4b4b",
--   teal = "#1abc9c",
--   terminal_black = "#414868",
--   warning = "#e0af68",
--   yellow = "#e0af68"
-- }


-- TESTS for lsp component
-- local clt = {
  --     {name = "sumneko_lua", root = "~/dev/cl/python"}, 
  --   }

  -- local clt = {
    --   {name = "sumneko_lua", root = "~/dev/cl/python"}, 
    --   {name = "null-ls", root = "~/dev/cl/python"},
    -- }

    -- local clt = {
      --   {name = "sumneko_lua", root = "~/dev/cl/python"}, 
      --   {name = "null-ls", root = "~/dev/cl"},
      -- }

      -- local clt = {
        --   {name = "sumneko_lua", root = "~/dev/cl/python"}, 
        --   {name = "null-ls", root = "~/dev/cl/python"},
        --   {name = "pyright", root = "~/dev/cl"},
        -- }
