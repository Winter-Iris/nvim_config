-- ~/.config/nvim/lua/plugins/notify.lua
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    timeout = 3000,
    max_width = 60,
    max_height = 10,
    background_colour = "#1C1A22",
    render = "default",
    stages = "fade",
  },
  config = function(_, opts)
    require("notify").setup(opts)
    -- 替换 Neovim 默认通知为美化版
    vim.notify = require("notify")
  end,
}
