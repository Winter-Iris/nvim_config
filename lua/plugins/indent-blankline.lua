-- ~/.config/nvim/lua/plugins/indent-blankline.lua
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "▏",
      tab_char = "▏",
    },
    scope = {
      enabled = true,
      char = "▏",
      show_start = true,
      show_end = false,
      highlight = { "Function", "Label", "String", "Keyword", "Type", "Special" },
    },
    exclude = {
      filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "Trouble" },
    },
  },
  config = function(_, opts)
    -- 彩虹缩进色
    local colors = {
      "#F8C4D4", "#F0B8D0", "#E0B0D8",
      "#C8B0E0", "#B0B8E8", "#A0C0E8", "#A8C8C0",
    }
    for i, c in ipairs(colors) do
      vim.api.nvim_set_hl(0, "RainbowIndent" .. i, { fg = c })
    end

    require("ibl").setup(vim.tbl_deep_extend("force", opts, {
      indent = {
        highlight = {
          "RainbowIndent1",
          "RainbowIndent2",
          "RainbowIndent3",
          "RainbowIndent4",
          "RainbowIndent5",
          "RainbowIndent6",
          "RainbowIndent7",
        },
      },
    }))
  end,
}
