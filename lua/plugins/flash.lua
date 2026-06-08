-- ~/.config/nvim/lua/plugins/flash.lua
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labels = "asdfgjklqwertyuiopzxcvbnm",
    modes = {
      search = { enabled = false },
      char = {
        enabled = true,
        multi_line = false,
        keys = { "f", "F", "t", "T" },
      },
    },
  },
  keys = {
    { "e",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "快速跳转" },
  },
}
