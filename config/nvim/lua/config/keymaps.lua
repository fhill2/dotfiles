-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- this hotkey is redundant, as <leader>` provides the same functionality`
-- changed this lazyvim default Find Buffers
vim.keymap.del("n", "<leader>bb")

vim.keymap.set("n", ";", "<cmd>write<cr>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up")
vim.keymap.set("i", "<C-l>", "<Right>")

-- lazyvim remaps this to prev next TODO
-- because I trigger hyper on tab up for yabai,
-- its nicer to not use the tab key with additional modifiers
vim.keymap.set("n", "[t", "<cmd>tabprev<cr>")
vim.keymap.set("n", "]t", "<cmd>tabnext<cr>")

-- convenience, <C-w>q feels awkward and I use this a lot...
vim.keymap.set("n", "<C-w>d", "<C-w>q")

-- lazyvim default option is <esc><esc>
vim.keymap.set("t", "<leader>y", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- https://www.reddit.com/r/neovim/comments/17a4m8q/comment/k5elu28/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
vim.keymap.set("n", "<leader>uys", function()
  vim.cmd([[
		:profile start /tmp/nvim-profile.log
		:profile func *
		:profile file *
	]])
end, { desc = "Profile Start" })

vim.keymap.set("n", "<leader>uye", function()
  vim.cmd([[
		:profile stop
		:e /tmp/nvim-profile.log
	]])
end, { desc = "Profile End" })

-- Copy ALL LSP diagnostics at the current line to the system clipboard
vim.keymap.set("n", "<leader>cy", function()
  -- Get the current line number (0-indexed)
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  -- Get all diagnostics for the current buffer on this specific line
  local diagnostics = vim.diagnostic.get(0, { lnum = line })

  if #diagnostics > 0 then
    local messages = {}
    for _, diag in ipairs(diagnostics) do
      -- Clean the message: remove newlines within a single error to keep it tidy
      local clean_msg = diag.message:gsub("\n", " ")
      table.insert(messages, string.format("[%s] %s", diag.source or "LSP", clean_msg))
    end

    -- Join all messages with a newline
    local final_proxy = table.concat(messages, "\n")
    vim.fn.setreg("+", final_proxy)
    vim.notify("Copied " .. #diagnostics .. " diagnostics to clipboard")
  else
    vim.notify("No diagnostics found at cursor", vim.log.levels.WARN)
  end
end, { desc = "Copy ALL diagnostics on line to clipboard" })
