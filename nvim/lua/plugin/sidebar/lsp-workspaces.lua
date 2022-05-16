local Loclist = require("sidebar-nvim.components.loclist")

local loclist = Loclist:new({
    highlights = {
         group = "SidebarNvimLspDiagnosticsFilename",
    --     --group_count = "SidebarNvimLspDiagnosticsTotalNumber",
         item_text = "SidebarNvimLspDiagnosticsMessage",
    --     --item_lnum = "SidebarNvimLspDiagnosticsLineNumber",
    --     --item_col = "SidebarNvimLspDiagnosticsColNumber",
     },
    show_group_count = false,
    show_location = false,
})


local function get_workspaces(ctx)
  local lines = {}
  local hl = {}
  --for _, workspace in ipairs(vim.lsp.buf.list_workspace_folders()) do
  --table.insert(lines, workspace)
  --end
  --return { lines = lines }

  -- local clients = vim.lsp.buf_get_clients()
  -- if next(clients) == nil then
  --   return nil
  -- end

  -- for _, client in pairs(clients) do
  --   dump(client.name)
  --   dump(client.config.filetypes)
  -- end


local loclist_items = {}

local workspace_folders = {}
  for _, client in pairs(vim.lsp.buf_get_clients()) do
    for _, folder in pairs(client.workspaceFolders) do
      table.insert(loclist_items, {
      group = client.name,
      text = folder.name,
      })
    end

  end -- end client iter

loclist:set_items(loclist_items)
loclist:draw(ctx, lines, hl)
if lines == nil or #lines == 0 then
       return "<no workspaces>"
   else
       return { lines = lines, hl = hl }
    end

end

return {
  title = "Workspaces (current file)",
  draw = function(ctx)
    return get_workspaces(ctx)
  end,
  highlights = {},
  -- highlights = {
  --     groups = { CustomHighlightGroupHello = { gui="#ff0000", fg="#00ff00", bg="#0000ff" } },
  --     links = { CustomHighlightGroupWorld = "Keyword" }
  -- }
}
