-- Override markdown-preview.nvim (loaded by LazyVim's markdown extra) so the
-- preview fills the entire screen width. The plugin ships a `max-width: 900px`
-- on `#page-ctn` in app/_static/page.css; we patch that file inside `build`,
-- which re-runs on every install/update (i.e. whenever the file would reset).
local function patch_page_css()
  local path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app/_static/page.css"
  local f = io.open(path, "r")
  if not f then
    return
  end
  local content = f:read("*a")
  f:close()
  local patched = content:gsub("max%-width:%s*900px;", "max-width: none;")
  if patched == content then
    return
  end
  local w = io.open(path, "w")
  if w then
    w:write(patched)
    w:close()
  end
end

return {
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
      patch_page_css()
    end,
  },
}
