-- ~/.config/nvim/lua/plugins/mini-indentscope.lua
return {
  "echasnovski/mini.indentscope",
  event = "VeryLazy",
  config = function()
    require("mini.indentscope").setup({
      draw = {
        delay = 100,
        animation = require("mini.indentscope").gen_animation.none(),
      },
      options = {
        try_as_border = true,
      },
      symbol = "│",
    })
  end,
}
