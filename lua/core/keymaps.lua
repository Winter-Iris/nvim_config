-- ~/.config/nvim/lua/core/keymaps.lua
local map = vim.keymap.set
local desc = function(text) return { desc = text } end

-- ═══════════════════════════════════════════
--  窗口 / 界面
-- ═══════════════════════════════════════════
map("n", "<leader>e",  ":NvimTreeToggle<CR>",  desc("打开/关闭文件树"))
map("n", "<leader>sv", "<C-w>v",               desc("垂直分割窗口"))
map("n", "<leader>sh", "<C-w>s",               desc("水平分割窗口"))
map("n", "<leader>o",  "<cmd>Outline<CR>",     desc("代码大纲"))

-- ═══════════════════════════════════════════
--  移动行
-- ═══════════════════════════════════════════
map("v", "J", ":m '>+1<CR>gv=gv", desc("下移当前行"))
map("v", "K", ":m '<-2<CR>gv=gv", desc("上移当前行"))

-- ═══════════════════════════════════════════
--  增量选择 (Treesitter)
-- ═══════════════════════════════════════════
local inc_sel = require("core.incremental_selection")
map("n", "<CR>",  function() inc_sel.init_selection() end,     desc("开始增量选择"))
map("v", "<CR>",  function() inc_sel.node_incremental() end,   desc("扩大选择 (父节点)"))
map("v", "<BS>",  function() inc_sel.node_decremental() end,   desc("缩小选择 (子节点)"))
map("v", "<TAB>", function() inc_sel.scope_incremental() end,  desc("扩大到作用域"))

-- ═══════════════════════════════════════════
--  文件搜索 (snacks)
-- ═══════════════════════════════════════════
local snacks_ok, snacks = pcall(require, "snacks")
if snacks_ok then
  map("n", "<leader>ff", function() snacks.picker.files() end,       desc("查找文件"))
  map("n", "<leader>fg", function() snacks.picker.grep() end,        desc("全文搜索 (Grep)"))
  map("n", "<leader>fb", function() snacks.picker.buffers() end,     desc("切换已打开的 Buffer"))
  map("n", "<leader>fh", function() snacks.picker.help() end,        desc("搜索帮助文档"))
  map("n", "<leader>fr", function() snacks.picker.recent() end,      desc("最近打开的文件"))
  map("n", "<leader>fk", function() snacks.picker.keymaps() end,     desc("查看所有快捷键"))
  map("n", "<leader>fd", function() snacks.picker.diagnostics() end, desc("诊断信息列表"))

  map("n", "<leader>tt", function() snacks.terminal.open() end,              desc("打开底部终端"))
  map("n", "<leader>tf", function() snacks.terminal.open(vim.o.shell) end,    desc("打开浮动终端"))
end

-- ═══════════════════════════════════════════
--  代码格式化 (conform)
-- ═══════════════════════════════════════════
map("n", "<leader>cf", function()
  local ok, conform = pcall(require, "conform")
  if ok then conform.format({ async = true }) end
end, desc("格式化代码"))

-- ═══════════════════════════════════════════
--  LSP 快捷键 (全局注册，确保 which-key 可发现)
-- ═══════════════════════════════════════════
map("n", "gd",  vim.lsp.buf.definition,      desc("跳转到定义"))
map("n", "gD",  vim.lsp.buf.declaration,     desc("跳转到声明"))
map("n", "gr",  vim.lsp.buf.references,      desc("查找所有引用"))
map("n", "gi",  vim.lsp.buf.implementation,  desc("跳转到实现"))
map("n", "K",   vim.lsp.buf.hover,            desc("显示悬浮文档"))
map("i", "<C-k>", vim.lsp.buf.signature_help, desc("函数签名帮助"))
map("n", "<leader>rn", vim.lsp.buf.rename,      desc("重命名符号"))
map("n", "<leader>ca", vim.lsp.buf.code_action, desc("代码操作 (自动修复)"))

-- ═══════════════════════════════════════════
--  诊断导航
-- ═══════════════════════════════════════════
map("n", "[d", vim.diagnostic.goto_prev, desc("上一个诊断 (错误/警告)"))
map("n", "]d", vim.diagnostic.goto_next, desc("下一个诊断 (错误/警告)"))

-- ═══════════════════════════════════════════
--  快捷键总览 (自定义命令)
-- ═══════════════════════════════════════════
vim.api.nvim_create_user_command("Keys", function()
  local help = {
    "═════════════════════════════════════════",
    "              快捷键总览",
    "═════════════════════════════════════════",
    "",
    " 窗口 / 界面",
    "  <leader>e   打开/关闭文件树",
    "  <leader>sv  垂直分割窗口",
    "  <leader>sh  水平分割窗口",
    "  <leader>o   代码大纲",
    "",
    " 增量选择 (按回车开始，再按回车扩大)",
    "  <CR>        Normal: 开始选择  Visual: 扩大选择",
    "  <BS>        缩小选择 (Visual 模式)",
    "  <TAB>       扩大到作用域 (Visual 模式)",
    "",
    " 文件 / 搜索",
    "  <leader>ff  查找文件",
    "  <leader>fg  全文搜索",
    "  <leader>fb  切换 Buffer",
    "  <leader>fh  帮助文档",
    "  <leader>fr  最近文件",
    "  <leader>fk  查看所有快捷键",
    "  <leader>fd  诊断列表",
    "",
    " 代码",
    "  <leader>cf  格式化代码",
    "  <leader>ca  代码操作 (自动修复)",
    "  <leader>rn  重命名符号",
    "  gcc         注释/取消注释当前行",
    "  gc + motion 注释区域 (如 gc3j)",
    "",
    " Git",
    "  <leader>hs  暂存当前修改",
    "  <leader>hr  撤销当前修改",
    "  <leader>hS  暂存全部修改",
    "  <leader>hb  查看行 Blame",
    "  <leader>hd  Diff 当前文件",
    "  <leader>hp  预览修改内容",
    "  ]c          下一处 Git 修改",
    "  [c          上一处 Git 修改",
    "",
    " LSP 跳转",
    "  gd          跳转到定义",
    "  gD          跳转到声明",
    "  gr          查找所有引用",
    "  gi          跳转到实现",
    "  K           悬浮文档",
    "  <C-k>       函数签名帮助 (插入模式)",
    "",
    " 终端",
    "  <leader>tt  底部终端",
    "  <leader>tf  浮动终端",
    "",
    " 诊断 & 问题",
    "  <leader>xx  全部诊断面板",
    "  <leader>xX  当前文件诊断",
    "  [d / ]d     上/下一个诊断",
    "",
    " 补全 (插入模式)",
    "  <Tab>       选择下一项",
    "  <S-Tab>     选择上一项",
    "  <CR>        确认补全",
    "  <C-Space>   打开补全菜单",
    "  <C-e>       关闭补全菜单",
    "",
    " 移动行 (Visual 模式)",
    "  J           下移当前行",
    "  K           上移当前行",
    "",
    "═════════════════════════════════════════",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, help)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 70,
    height = #help,
    col = 2,
    row = 1,
    style = "minimal",
    border = "single",
  })
  vim.api.nvim_win_set_option(win, "winhl", "Normal:NormalFloat,FloatBorder:FloatBorder")
end, {})
