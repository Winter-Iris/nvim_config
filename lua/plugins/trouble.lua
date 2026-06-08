-- ~/.config/nvim/lua/plugins/trouble.lua
return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {
    auto_open = false,
    auto_close = true,
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics<CR>",     desc = "诊断列表" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "当前文件诊断" },
    { "<leader>xL", "<cmd>Trouble loclist<CR>",         desc = "位置列表" },
    { "<leader>cs", "<cmd>Trouble symbols<CR>",         desc = "代码符号" },
  },
}
