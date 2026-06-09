-- ~/.config/nvim/init.lua
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 设置 C 编译器为 gcc（tree-sitter CLI 在 Windows 上默认使用 cl.exe/MSVC）
-- 必须在 lazy.setup 之前设置，因为 tree-sitter 编译在插件加载时触发
-- nvim-treesitter 新版不再使用 install.compilers 字段，改为由 tree-sitter CLI 的 CC 环境变量控制
vim.env.CC = "gcc"

require("lazy").setup("plugins")

require("core.options")
require("core.keymaps")

-- nvim-treesitter 新版不再自动启用高亮，需要手动开启
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "lua", "javascript", "typescript", "c", "cpp", "bash", "html", "css", "json" },
	callback = function()
		vim.treesitter.start()
	end,
})
