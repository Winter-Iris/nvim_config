-- ~/.config/nvim/lua/plugins/outline.lua
return {
  "hedyhli/outline.nvim",
  cmd = { "Outline", "OutlineOpen" },
  opts = {
    outline_window = {
      position = "right",
      width = 30,
    },
    symbols = {
      filter = {
        kind = { "Function", "Method", "Class", "Variable", "Constant", "Field", "Property" },
      },
    },
  },
  keys = {
    { "<leader>o", "<cmd>Outline<CR>", desc = "代码大纲" },
  },
}
