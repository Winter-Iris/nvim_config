-- ~/.config/nvim/lua/plugins/treesitter.lua
-- 新版 nvim-treesitter 只负责 parser 安装和 queries，不再包含 highlight/indent/incremental_selection
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    install_dir = vim.fn.stdpath("data") .. "/site",
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    -- 安装 parser（如果还没安装）
    require("nvim-treesitter").install({
      "c", "cpp", "python", "lua", "javascript",
      "typescript", "html", "css", "json", "bash",
    })
  end,
}
