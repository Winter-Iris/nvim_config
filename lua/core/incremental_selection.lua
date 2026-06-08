-- ~/.config/nvim/lua/core/incremental_selection.lua
-- 新版 nvim-treesitter 已移除 incremental_selection 模块
-- 这里用 Neovim 内置 vim.treesitter API 手动实现
local M = {}

local current_node = nil
local current_buf = nil

--- 获取光标所在的最小命名节点
local function get_node_at_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local parser = vim.treesitter.get_parser(buf)
  if not parser then
    return nil
  end

  -- parse 返回的是 LanguageTree 数组
  local lang_tree = parser:language_for_range({ row, col, row, col })
  if not lang_tree then
    return nil
  end

  local trees = lang_tree:trees()
  if not trees or #trees == 0 then
    return nil
  end

  local root = trees[1]:root()
  if not root then
    return nil
  end

  -- 找到光标位置最深的命名节点
  return root:named_descendant_for_range(row, col, row, col)
end

--- 选择指定节点
local function select_node(node)
  if not node then
    return
  end

  local start_row, start_col, end_row, end_col = node:range()
  local win = vim.api.nvim_get_current_win()

  -- 退出当前 visual 模式
  vim.cmd("normal! " .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true))

  -- 移动光标到节点起始位置
  vim.api.nvim_win_set_cursor(win, { start_row + 1, start_col })

  -- 进入 visual 模式并移动到节点结束位置
  vim.cmd("normal! v")
  -- 对于单行节点，直接移到 end_col；多行则移到 end_row, end_col-1
  if end_row == start_row then
    vim.api.nvim_win_set_cursor(win, { end_row + 1, end_col - 1 })
  else
    vim.api.nvim_win_set_cursor(win, { end_row + 1, end_col - 1 })
  end
end

--- 获取"作用域"节点（向上找最近的函数/类/方法/条件/循环体）
local function get_scope_node(node)
  local scope_types = {
    "function_definition",
    "function_declaration",
    "method_definition",
    "class_definition",
    "class_declaration",
    "if_statement",
    "for_statement",
    "while_statement",
    "do_statement",
    "switch_statement",
    "try_statement",
    "block",
  }

  local current = node
  while current do
    local node_type = current:type()
    for _, scope_type in ipairs(scope_types) do
      if node_type == scope_type then
        return current
      end
    end
    current = current:parent()
  end
  return nil
end

--- 开始增量选择：选中光标所在节点
function M.init_selection()
  local buf = vim.api.nvim_get_current_buf()
  local node = get_node_at_cursor()

  if not node then
    vim.notify("增量选择: 此处无 treesitter 节点", vim.log.levels.WARN)
    return
  end

  current_node = node
  current_buf = buf

  select_node(node)
end

--- 扩大选择：选父节点
function M.node_incremental()
  local buf = vim.api.nvim_get_current_buf()

  -- 如果 buffer 换了或没有当前节点，重新初始化
  if not current_node or current_buf ~= buf then
    M.init_selection()
    return
  end

  local parent = current_node:parent()
  if not parent then
    vim.notify("增量选择: 已到根节点", vim.log.levels.WARN)
    return
  end

  current_node = parent
  select_node(parent)
end

--- 缩小选择：选第一个命名子节点
function M.node_decremental()
  local buf = vim.api.nvim_get_current_buf()

  if not current_node or current_buf ~= buf then
    return
  end

  -- 找第一个具名子节点
  local child = nil
  for i = 0, current_node:named_child_count() - 1 do
    local c = current_node:named_child(i)
    if c then
      child = c
      break
    end
  end

  if not child or child == current_node then
    vim.notify("增量选择: 已到最小节点", vim.log.levels.WARN)
    return
  end

  current_node = child
  select_node(child)
end

--- 扩大到作用域：选择最近的函数/类/条件/循环体
function M.scope_incremental()
  local buf = vim.api.nvim_get_current_buf()

  if not current_node or current_buf ~= buf then
    M.init_selection()
    return
  end

  local scope = get_scope_node(current_node)
  if not scope then
    vim.notify("增量选择: 未找到作用域", vim.log.levels.WARN)
    return
  end

  current_node = scope
  select_node(scope)
end

return M
