local opt = vim.opt

opt.number = true 
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.clipboard:append("unnamedplus")
opt.mouse:append("a")

opt.splitright = true
opt.splitbelow = true

vim.opt.cmdheight = 0
vim.opt.fillchars = "eob: "

-- 诊断信息：在出错行末尾显示错误原因（virtual text）
vim.diagnostic.config({
  virtual_text = {
    prefix = "",
    source = false,                    -- 不显示 LSP 来源，避免方块
    spacing = 2,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- 光标配色：Normal 天蓝，Insert 细粉，Replace 下划线玫
vim.opt.guicursor = table.concat({
  "n-v-c-sm:block-Cursor",       -- Normal/Visual/Command: 块状天蓝
  "i-ci-ve:ver25-CursorInsert",  -- Insert: 竖线粉色
  "r-cr-o:hor20-CursorReplace",  -- Replace: 下划线
}, ",")
