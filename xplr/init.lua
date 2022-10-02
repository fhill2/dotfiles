version = "0.19.0"
local home = os.getenv("HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path .. ";" .. xpm_path .. "/?.lua;" .. xpm_path .. "/?/init.lua"

os.execute(
  string.format(
    "[ -e '%s' ] || git clone '%s' '%s'",
    xpm_path,
    xpm_url,
    xpm_path
  )
)


-- xpm plugin manager
require("xpm").setup({
  plugins = {
    -- Let xpm manage itself
    'dtomvan/xpm.xplr',
    'sayanarijit/preview-tabbed.xplr',
    'sayanarijit/dual-pane.xplr',
  },
  auto_install = true,
  auto_cleanup = true,
})


require("dual-pane").setup{
  active_pane_width = { Percentage = 70 },
  inactive_pane_width = { Percentage = 30 },
}

-- -- preview-tabbed
-- package.path = home
-- .. "/.config/xplr/plugins/?/init.lua;"
-- .. home
-- .. "/.config/xplr/plugins/?.lua;"
-- .. package.path

require("preview-tabbed").setup{
  mode = "action",
  key = "p",
  fifo_path = "/tmp/xplr.fifo",
  previewer = "/usr/share/nnn/plugins/preview-tui"
  -- previewer = os.getenv("HOME") .. "/.config/nnn/plugins/preview-tabbed",
}
