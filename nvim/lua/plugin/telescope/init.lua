----- only startup config here
--local strats = require("telescope.pickers.layout_strategies")
--strats.vertical_scoped = require("plugin.telescope.vertical_scoped")
--strats.btm_or_scoped = function(...) -- picker, columns, lines, layout_config)
----  if TelescopeGlobalState.persistent then
--return strats.vertical_scoped(...)

---- end
----    return strats.bottom_pane(...)
--end

--local my_actions = require("plugin.telescope.actions")

--local telescope = require("telescope")
local telescope = require "telescope"
local fb_actions = require "telescope._extensions.file_browser.actions"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local my_actions = require "plugin.telescope.actions"
local my_utils = require "plugin.telescope.util"
local fb_actions = require "telescope".extensions.file_browser.actions



-- _G.telescope_previewer_loaded = function()
--   local utils = require "telescope.utils"
--   local state = require "telescope.state"
--   local popup = require "plenary.popup"
--   -- find picker from the only telescope prompt existing
--   local picker = my_utils.find_picker()
--
--   --if self.previewer._title_fn() == "nonFloat Previewer" then
--   local status = state.get_status(picker.prompt_bufnr)
--   if not picker.old_preview_win then
--     picker.old_preview_win = status.preview_win
--   end
--
--   local startup = picker.old_preview_win == status.preview_win
--   if startup then
--     vim.keymap.set("n", "<C-Space>", my_actions.toggle_picker, { noremap = true, silent = true })
--     vim.keymap.set("n", "<C-a>", my_actions.toggle_previewer, { noremap = true, silent = true })
--
--     local nonfloat_preview_win
--
--     -- recalculate_layout() with no previewer extras
--     local line_count = vim.o.lines - vim.o.cmdheight
--     if vim.o.laststatus ~= 0 then
--       line_count = line_count - 1
--     end
--
--
--
--     -- spawn new window if there is only 1 window open in the current tab
--     local initial_editor_wins = my_utils.get_editor_wins()
--     if #initial_editor_wins <= 1 then
--       vim.api.nvim_buf_call(vim.api.nvim_win_get_buf(initial_editor_wins[1]), function()
--         vim.cmd("vert sbuffer")
--       end)
--     end
--     local editor_wins = my_utils.get_editor_win_info()
--
--     nonfloat_preview_win = editor_wins[#editor_wins].winnr
--     -- save editor buf to temporarily switch to preview
--     picker.previewer.state.last_editor_buf = vim.api.nvim_win_get_buf(nonfloat_preview_win)
--
--     picker.previewer._teardown = vim.deepcopy(picker.previewer.teardown)
--     picker.previewer.teardown = function(self)
--       -- all bufs opened by previewer are closed (apart from optionally last), switch the last editor bufnr there instead
--       vim.api.nvim_win_set_buf(nonfloat_preview_win, picker.previewer.state.last_editor_buf)
--       -- so close_windows() doesnt try and close the preview_window
--       status.preview_win = nil
--       picker.previewer._teardown(self)
--     end
--
--     local nonfloat_preview_info = editor_wins[#editor_wins]
--
--     -- clear the original autocmds created
--     vim.api.nvim_clear_autocmds {
--       group = "PickerInsert",
--       event = "BufLeave",
--       buffer = status.prompt_bufnr,
--     }
--     my_utils.merge_status({ preview_win = nonfloat_preview_win })
--     picker.preview_win = nonfloat_preview_win
--
--     -- fake picker without previewer set, so layout can calculated based on no floating previewer
--     -- local fake_picker = vim.deepcopy(my_utils.find_picker())
--     local fake_picker = setmetatable({ previewer = false }, { __index = picker })
--     local popup_opts = picker.get_window_options(fake_picker, vim.o.columns - nonfloat_preview_info.w, line_count)
--     popup.move(status.prompt_win, popup_opts.prompt)
--     popup.move(status.results_win, popup_opts.results)
--
--     -- Remove preview after the prompt and results are moved
--     vim.defer_fn(function()
--
--       -- local picker = my_utils.find_picker()
--       utils.win_delete("preview_win", status.preview_win, true)
--       utils.win_delete("preview_win", status.preview_border_win, true)
--       if vim.api.nvim_buf_is_valid(picker.previewer.state.bufnr) then
--         vim.api.nvim_win_set_buf(nonfloat_preview_win, picker.previewer.state.bufnr)
--       end
--     end, 0)
--
--   end
--   --my_utils.merge_status({ preview_win = nonfloat_preview_win })
-- end
--

-- vim.cmd([[autocmd User TelescopePreviewerLoaded lua _G.telescope_previewer_loaded()]])


-- vim.cmd([[autocmd User TelescopePreviewerLoaded lua _G.telescope_find_pre()]])

_G.current_editor_win = 1000
_G.telescope_get_current_editor_win = function()
  local c_win = vim.api.nvim_get_current_win()
  if vim.tbl_contains(require "plugin.telescope.util".get_editor_wins_no_previewer(), c_win) then
    _G.current_editor_win = c_win
  end
end
vim.cmd([[autocmd WinEnter * lua _G.telescope_get_current_editor_win()]])

-- vim.api.nvim_create_autocmd("BufLeave", {
--   -- buffer = prompt_bufnr,
--   group = "PickerInsert",
--   -- nested = true,
--   -- once = true,
--   callback = function()
--     -- require("telescope.pickers").on_close_prompt(prompt_bufnr)
--     dump("bufleaveee")
--     -- _G.telescope_last_editor_win()
--     my_utils.telescope_last_editor_win()
--   end,
-- })
--

-- load my layout strats into telescope layout_strategies table
require "plugin.telescope.layout_strategies"


-- local previewers = require("telescope.previewers")
-- --local Previewer = require("telescope.previewers")
-- local my_previewers = require "plugin.telescope.previewers"
--
-- local new_maker = function(filepath, bufnr, opts)
--   local picker = action_state.get_current_picker(bufnr)
--   opts = opts or {}
--   -- if opts.use_ft_detect == nil then opts.use_ft_detect = true end
--   --opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)
--   opts.winid = 1000
--   previewers.buffer_previewer_maker(filepath, bufnr, opts)
-- end
--

require "telescope".setup({
  defaults = {
    layout_strategy  = "horizontal",
    layout_config    = {
      height = 0.4,
      width = 0.99,
      prompt_position = "bottom",
      anchor = "S",
    },
    prompt_prefix    = " ",
    sorting_strategy = "ascending",
    cache_picker     = {
      num_pickers = 20,
    },
    mappings         = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-o>"] = my_actions.resize,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-Space>"] = my_actions.toggle_picker,
        ["<C-a>"] = my_actions.toggle_previewer,
        ["<C-h>"] = fb_actions.sort_by_date
        -- ["<C-_>"] = my_actions.which_key,
        -- ['<CR>'] = telescope_custom_actions.multi_selection_open,
      },
      n = {
        ["<C-Space>"] = my_actions.close_picker,
        ["<C-h>"] = fb_actions.sort_by_date
      }
    },
    -- path_display = {
    --   --smart = true, -- too slow
    --   truncate = 3,
    -- },
    --path_display     = { absolute = true },
    --buffer_previewer_maker = new_maker,
    --buffer_previewer = my_previewer,
    -- file_previewer   = my_previewers.cat.new,
    -- grep_previewer   = my_previewers.vimgrep.new
  },
  --file_sorter = require "telescope.sorters".get_fzy_sorter({ fzy_mod = native_load_mod }),
  --file_ignore_patterns = {},
  --generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

  extensions = {
    -- these extra sorter are mutually exclusive
    -- fzf takes precedence as it is loaded after with load_extension()
    -- make sure there is only 1 override per sorter
    fzy_native = {
      override_generic_sorter = true, -- conf.generic_sorter() will load ffi fzy native
      override_file_sorter = true, -- conf.file_sorter() will load ffi fzy native
      file_browser = {
        mappings = {
          ["n"] = {
            ["<C-h>"] = fb_actions.sort_by_date
          },
          ["i"] = {
            ["<C-h>"] = fb_actions.sort_by_date
          }
        }
      }
    },
    fzf = {
      fuzzy = false, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = false, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    file_browser = {
      path_display = { absolute = true }, -- remove fb_finders.browse_files = function(opts) path_display = {tail} for it to work, this setting overrides all my personal path_display config
      hidden = true,

      --browse_files = require "telescope.builtin".find_files,
      depth       = false,
      add_dirs    = true,
      cwd_to_path = true,
      mappings    = {
        ["i"] = {
          -- ["<A-c>"] = fb_actions.create,
          -- ["<S-CR>"] = fb_actions.create_from_prompt,
          ["<C-r>"] = fb_actions.rename, -- modified
          -- ["<A-m>"] = fb_actions.move,
          -- ["<A-y>"] = fb_actions.copy,
          -- ["<A-d>"] = fb_actions.remove,
          -- ["<C-o>"] = fb_actions.open,
          -- ["<C-g>"] = fb_actions.goto_parent_dir,
          -- ["<C-e>"] = fb_actions.goto_home_dir,
          -- ["<C-w>"] = fb_actions.goto_cwd,
          -- ["<C-t>"] = fb_actions.change_cwd,
          -- ["<C-f>"] = fb_actions.toggle_browser,
          -- ["<C-h>"] = fb_actions.toggle_hidden,
          -- ["<C-s>"] = fb_actions.toggle_all,
        },
        -- ["n"] = {
        --   ["c"] = fb_actions.create,
        --   ["r"] = fb_actions.rename,
        --   ["m"] = fb_actions.move,
        --   ["y"] = fb_actions.copy,
        --   ["d"] = fb_actions.remove,
        --   ["o"] = fb_actions.open,
        --   ["g"] = fb_actions.goto_parent_dir,
        --   ["e"] = fb_actions.goto_home_dir,
        --   ["w"] = fb_actions.goto_cwd,
        --   ["t"] = fb_actions.change_cwd,
        --   ["f"] = fb_actions.toggle_browser,
        --   ["h"] = fb_actions.toggle_hidden,
        --   ["s"] = fb_actions.toggle_all,
        -- },
      }
    }
  },
  pickers = {
    --    find_files = {
    --      layout_strategy = "bottom_pane",
    --    },
    file_browser = {
      -- attach_mappings = function()
      --   print("attach mappings ran")
      -- end
    },
    find_files = {
      --attach_mappings = attach_mappings,
      -- layout_config   = {
      --   height = 0.4,
      --   -- width = function() return 0.8 end,
      --   -- width = resolve.resolve_width(),
      --   width = 0.99,
      --   prompt_position = "bottom",
      --   anchor = "S",
      -- },
    },
  }
})

telescope.load_extension("fzy_native")
telescope.load_extension("file_browser")
--telescope.load_extension("fzf")

telescope.load_extension("repo")
telescope.load_extension("frecency")
-- telescope.load_extension("ui-select")
telescope.load_extension("zoxide")
telescope.load_extension('gh')




--telescope.load_extension('snippets')
--telescope.load_extension("cheat")
--telescope.load_extension("bookmarks")
--telescope.load_extension("projects")





-------- OLD



-- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1140280174
-- messed up bufferline
-- local attach_mappings = function(prompt_bufnr, map)
--   action_set.select:replace(
--     function(prompt_bufnr)
--       local picker = action_state.get_current_picker(prompt_bufnr)
--       local multi = picker:get_multi_selection()
--       local single = picker:get_selection()
--
--       dump(multi)
--       for _, v in ipairs(multi) do
--         action_set.edit(multi)
--       end
--       action_set.edit(single)
--       -- local str = ""
--       -- if #multi > 0 then
--       --   for i, j in pairs(multi) do
--       --     str = str .. "edit " .. j[1] .. " | "
--       --   end
--       -- end
--       -- str = str .. "edit " .. single[1]
--       -- -- To avoid populating qf or doing ":edit! file", close the prompt first
--       -- actions.close(prompt_bufnr)
--       -- vim.api.nvim_command(str)
--     end)
--   return true
-- end
-- And then to call find_files with a mapping or whatever:

-- https://github.com/nvim-telescope/telescope.nvim/issues/1048
-- TODO: attach_mappings instead of wait for PR
-- local telescope_custom_actions = {}
--
-- function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
--   local picker = action_state.get_current_picker(prompt_bufnr)
--
--   local num_selections = #picker:get_multi_selection()
--   if not num_selections or num_selections <= 1 then
--     actions.add_selection(prompt_bufnr)
--   end
--   actions.send_selected_to_qflist(prompt_bufnr)
--
--   local results = vim.fn.getqflist()
--   if CLI then
--     my_actions.close_or_exit(prompt_bufnr, results[1].text)
--     return
--   end
--
--   for _, result in ipairs(results) do
--     local current_file = vim.fn.bufname()
--     local next_file = vim.fn.bufname(result.bufnr)
--
--     if current_file == "" then
--       vim.api.nvim_command("edit" .. " " .. next_file)
--     else
--       vim.api.nvim_command(open_cmd .. " " .. next_file)
--     end
--   end
--
--   vim.api.nvim_command("cd .")
-- end
--
-- function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
--   telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
-- end
--
-- function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
--   telescope_custom_actions._multiopen(prompt_bufnr, "split")
-- end
--
-- function telescope_custom_actions.multi_selection_open_tab(prompt_bufnr)
--   telescope_custom_actions._multiopen(prompt_bufnr, "tabe")
-- end
--
-- function telescope_custom_actions.multi_selection_open(prompt_bufnr)
--   telescope_custom_actions._multiopen(prompt_bufnr, "edit")
-- end

-- local native_lua = vim.api.nvim_get_runtime_file("deps/fzy-lua-native/lua/native.lua", false)[1]
-- if not native_lua then
--   error("Unable to find native fzy native lua dep file. Probably need to update submodules!")
-- end
-- local native_lua_mod = loadfile(native_lua)()
-- local fuzzy_sorter = require "telescope.sorters".get_fzy_sorter({
--   fzy_mod = native_lua_mod
-- })


-- redefine actions close to nil the parts of picker so no editor windows are closed when closing telescope
-- local close = vim.deepcopy(actions.close)
-- actions.close = function(prompt_bufnr)
--   local picker = my_utils.find_picker()
--   for _, v in ipairs(picker.previewer.)
--   dump("CLOSING NOW")
--   close(prompt_bufnr)
-- end


--
-- _G.telescope_find_pre = function()
--   dump("telescope find pre")
--   -- local picker = my_utils.find_picker()
--   dump(vim.api.nvim_get_current_win())
--   -- picker.last_editor_win = vim.api.nvim_get_current_win()
--   -- dump(picker.last_editor_win)
-- end
