
vim.g.sqlite_clib_path = os.getenv("NVIM_SQL")
--- only startup config here
local strats = require("telescope.pickers.layout_strategies")
strats.vertical_scoped = require("plugin.telescope.vertical_scoped")
strats.btm_or_scoped = function(...) -- picker, columns, lines, layout_config)
  --  if TelescopeGlobalState.persistent then
  return strats.vertical_scoped(...)

  -- end
  --    return strats.bottom_pane(...)
end

local my_actions = require("plugin.telescope.actions")

local telescope = require("telescope")


telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<Esc>"] = "close",
        ["<C-f>f"] = my_actions.find_files,
        ["<C-s>s"] = my_actions.live_grep,
        ["<C-a>v"] = my_actions.move_previewer_window,
      },
      n = {
        --["<C-q>"] = false,
        --["<Esc>"] = function() require'log1'.info('esc trig normal') end
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--follow", -- follow syms
      "-g",
      "!markdown-preview.nvim/*",
      --"-g",
      --"!/old/**"
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
      bottom_pane = {
        --height = 40
      },
      vertical_scoped = {
        results_height = 20,
      },
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    winblend = 0,
    border = false,
    -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    -- borderchars = {
    --   preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    --   prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    --   results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    -- },
    borderchars = {
      preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      results = false, --{ "", "│", "", "│", "┌", "┐", "┘", "└" },
    },
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    results_title = "",
    preview_title = "",
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    --layout_strategy = "btm_or_scoped",
    path_display = { truncate = 3 },
  },
  pickers = {
    find_files = {
      follow = true,
      hidden = true,
      find_command = { "fd", "-HI", "--type", "f", "-L", "-E", "result", "-E", ".git" },
    },
    live_grep = {
      max_results = 100000000,
      prompt_prefix = "Grep > ",
      layout_strategy = "bottom_pane",
    },
    grep_string = { -- uses generic sorter by default
      layout_strategy = "horizontal",
      promp_prefix = "Grep String > ",
    },
    oldfiles = {
      layout_strategy = "horizontal",
    },
  },
  extensions = {
    frecency = {
      show_scores = true,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*" },
      workspaces = {
        ["cl"] = "/home/f1/cl",
        ["test"] = "/home/f1/test",
        --["data"]    = "/home/f1/.local/nvim"
      },
      bookmarks = {
        -- Available: 'brave', 'google_chrome', 'safari', 'firefox', 'firefox_dev'
        selected_browser = "brave",

        -- Either provide a shell command to open the URL
        url_open_command = "open",

        -- Or provide the plugin name which is already installed
        -- Available: 'vim_external', 'open_browser'
        url_open_plugin = nil,
        firefox_profile_name = nil,
      },
    },
    -- fzy_native = {
    --   override_generic_sorter = true,
    --   override_file_sorter = true,
    -- },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    -- for pinned right preview opts
    p = {
      width = 40,
    },
  },
})

--require"plugin.telescope.extensions"
telescope.load_extension("fzy_native")
telescope.load_extension("fzf")
telescope.load_extension("repo")
--telescope.load_extension('snippets')
--telescope.load_extension("cheat")
--telescope.load_extension("ultisnips")
--telescope.load_extension('livetablelogger')
--telescope.load_extension('floating')
telescope.load_extension("frecency")
telescope.load_extension("file_browser")
--telescope.load_extension("bookmarks")
--telescope.load_extension("projects")




local Persist = {}
Persist.__index = Persist

function Persist:focus()
  -- original picker table has no prompt_win - prompt_win only saved to Telescope global object
  if not vim.tbl_contains({ self.preview_win, self.prompt_win, self.results_win }, vim.api.nvim_get_current_win()) then
    vim.api.nvim_set_current_win(self.prompt_win)
    f.enter_insert()
  else
    vim.api.nvim_set_current_win(self.picker.original_win_id)
  end
end

-- wrapped Telescope global state
-- when find() ends it sets
-- TelescopeGlobalState [prompt_bufnr] = setmetatable{ prompt_win etc....,  picker tbl}
-- this wraps every returned picker in my own additional picker commands
local mt = {}
mt.__newindex = function(s, k, v)
  if v == nil then
    return
  end
  if v.picker and v.picker.prompt_prefix:match(">>$") then
    rawset(s, "persist", setmetatable(v, Persist))
    vim.cmd([[autocmd! PickerInsert]])
  elseif v.picker then
    rawset(s, "temp", v)
  else
    rawset(s, k, v)
  end
end

mt.__index = function(s, k)
  for kk, v in pairs(s) do
    if v.prompt_bufnr == k then
      return rawget(s, kk)
    end
  end
end

TelescopeGlobalState = setmetatable({}, mt)
TelescopeGlobalState.global = {}
