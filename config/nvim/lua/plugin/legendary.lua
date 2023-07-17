require("legendary").setup({
  include_builtin = true,
  keymaps = {
    {
      "<leader>c",
      _G.paste_code_with_md_code_block,
      description = "discord copy",
      mode = { "v" },
    },
    -- your keymap tables here
  },
  -- Initial commands to bind
  commands = {
  { ":LspAutoFormatToggle", description = "Toggle Lsp Auto Formatting" },
  { ":NullLsInfo", description = "View Null-Ls LSP Info - currently used formatter" },
    {
      ":FOldTest",
      require("util.old").test,
      description = "old - dry run - print output paths",
    },
    { ":FOldWhole",      require("util.old").send_whole,         description = "old - send whole file" },
    { ":FOldOpenWindow", require("util.old").open_window,        description = "old - open window" },
    { ":FWriteSudo",     _G.write_sudo,                          description = "write sudo" },
    { ":FParserUnlock",  require("util.run.init").unlock_parser, description = "run - unlock parser" },
    {
      ":FParserLock",
      require("util.run.init").lock_parser,
      description = "run - lock parser - default no ft raw output",
      { "default" },
    },
    { ":FSnipRunReplToggle", require("plugin.sniprun.repl").toggle, description = "sniprun REPL toggle" },
    {
      ":FformatGithubReposDotbot",
      _G.format_github_repos_dotbot,
      description = "dotbot - format github repos",
    },
    {
      ":FReload",
      ":source $MYVIMRC",
      description = "resource reload nvim config",
    },
    { ":FLspLinesToggle",    require("lsp_lines").toggle,           description = "lsp_lines - toggle" },
    {
      ":SnippyListPaths",
      function()
        print(vim.inspect(require("snippy.reader.snipmate").list_existing_files()))
      end,
      description = "list snippy nvim snippet search paths",
    },
    -- your command tables here
  },
})

local legendary = {}

legendary.find_by_desc = function(term)
  require("legendary").find(nil, function(item)
    if not string.find(item.kind, "keymap") then
      return true
    end
    dump(item)
    return vim.startswith(item.description, term)
  end)
end

return legendary
