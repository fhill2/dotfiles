----- only startup config here
local telescope = require "telescope"
local fb_actions = require "telescope".extensions.file_browser.actions
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local my_actions = require "plugin.telescope.actions"
local my_utils = require "plugin.telescope.util"

_G.current_editor_win = 1000
_G.telescope_get_current_editor_win = function()
  local c_win = vim.api.nvim_get_current_win()
  if vim.tbl_contains(require "plugin.telescope.util".get_editor_wins_no_previewer(), c_win) then
    _G.current_editor_win = c_win
  end
end
vim.cmd([[autocmd WinEnter * lua _G.telescope_get_current_editor_win()]])



-- load my layout strats into telescope layout_strategies table
-- require "plugin.telescope.layout_strategies"



require "telescope".setup({
  defaults = {
    -- border = true,
    -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        layout_strategy = "flex",
        layout_config = {
          height = 0.99,
          width = 0.99,
          prompt_position = "bottom",
          preview_cutoff = 1,
          anchor = "S",
          -- preview_height = 15,
        },
        prompt_prefix = " ",
        sorting_strategy = "descending",
        cache_picker = {
          num_pickers = 20,
        },
    dynamic_preview_title = true,
    cache_picker     = {
      num_pickers = 20,
    },
    -- toggle_focus_previewer and toggle_focus_picker dont work here
    mappings         = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-o>"] = my_actions.resize,
        ["<C-k>"] = actions.move_selection_previous,
        -- ["<C-Space>"] = my_actions.toggle_focus_picker,
        ["<S-CR>"] = actions.select_horizontal,
        -- ["<C-a>"] = my_actions.toggle_focus_previewer,
        ["<C-n>"] = fb_actions.create,
        ["<C-x>"] = fb_actions.remove,
        ["<S-n>"] = fb_actions.create_from_prompt,
        ["<C-v>"] = fb_actions.move,
        ["<F1>"] = actions.which_key,
        ["<C-p>"]= require("telescope.actions.layout").toggle_preview,
        ["<C-r>"] = fb_actions.rename, -- modified
        ["<C-w>"] = actions.send_selected_to_qflist,
        ["<C-q>"] = actions.send_to_qflist,
        ["<C-.>"] = my_actions.close_or_resume,
        -- ["<C-w>"] = my_actions.goto_cwd,
        -- ["<C-h>"] = fb_actions.sort_by_date
        -- ["<C-_>"] = my_actions.which_key,
        -- ['<CR>'] = telescope_custom_actions.multi_selection_open,
      },
      n = {
        ["<C-Space>"] = my_actions.close_picker,
        ["<F1>"] = actions.which_key,
        ["<C-w>"] = actions.send_selected_to_qflist,
        ["<C-q>"] = actions.send_to_qflist,
        -- ["<C-a>"] = my_actions.toggle_focus_previewer,
        -- ["<C-h>"] = fb_actions.sort_by_date
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

    },
    fzf = {
      fuzzy = false, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = false, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    file_browser = {
      -- path_display = { absolute = true }, 
      depth       = false,
      add_dirs    = true,
      hidden = true,
      cwd_to_path = true,
      mappings    = {
        ["i"] = {
          -- ["<A-c>"] = fb_actions.create,
          -- ["<S-CR>"] = fb_actions.create_from_prompt,
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
          ["<C-1>"] = fb_actions.sort_by_date_once,
          ["<C-2>"] = my_actions.fb_change_depth,
          -- ["<C-2>"] = fb_actions.sort_by_size
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

-- require"telescope".setup{
--   extensions = {
--     file_browser = {
--       grouped = "asdasdasd",
--       depth = false,
--     }
--   }
-- }

telescope.load_extension("fzy_native")
telescope.load_extension("file_browser")
--telescope.load_extension("fzf")

telescope.load_extension("repo")
telescope.load_extension("frecency")
-- telescope.load_extension("ui-select")
telescope.load_extension("zoxide")
telescope.load_extension('gh')


-- replace functions with my own
-- require"plugin.telescope.replace"


--telescope.load_extension('snippets')
--telescope.load_extension("cheat")
--telescope.load_extension("bookmarks")
--telescope.load_extension("projects")





-------- OLD


-- vim.cmd([[autocmd User TelescopePreviewerLoaded lua _G.telescope_find_pre()]])

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
