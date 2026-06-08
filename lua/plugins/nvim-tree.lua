-- lua/plugins/nvim-tree.lua
return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup()  -- 使用默认配置
    end,
}
