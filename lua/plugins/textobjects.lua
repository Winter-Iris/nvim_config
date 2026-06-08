-- ~/.config/nvim/lua/plugins/textobjects.lua
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        selection_modes = {
          ["@function.outer"] = "V", -- 函数用行选择模式
          ["@class.outer"] = "V",    -- 类用行选择模式
        },
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    })
  end,
}
