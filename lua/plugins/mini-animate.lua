-- ~/.config/nvim/lua/plugins/mini-animate.lua
return {
  "echasnovski/mini.animate",
  event = "VeryLazy",
  config = function()
    local timing = require("mini.animate").gen_timing.linear({ duration = 100, unit = "total" })
    local timing_fast = require("mini.animate").gen_timing.linear({ duration = 80, unit = "total" })
    require("mini.animate").setup({
      cursor = { enable = false, timing = timing },
      scroll = { enable = true, timing = timing_fast },
      resize = { enable = true, timing = timing_fast },
      open = { enable = true, timing = timing },
      close = { enable = true, timing = timing_fast },
    })
  end,
}
