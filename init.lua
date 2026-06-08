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
