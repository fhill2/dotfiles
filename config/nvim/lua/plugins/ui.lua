print("noice loaded")
return {
  {
    "folke/noice.nvim",
    opts = {
      commands = {
        history = {
          view = "vsplit",
        },
      },
      views = {
        vsplit = {
          size = "50%",
        },
      },
    },
  },
}
