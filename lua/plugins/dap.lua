-- ~/.config/nvim/lua/plugins/dap.lua
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
    "jay-babu/mason-nvim-dap.nvim",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<leader>db", "<cmd>DapToggleBreakpoint<CR>",   desc = "断点切换" },
    { "<leader>dB", "<cmd>DapClearBreakpoints<CR>",   desc = "清除所有断点" },
    { "<leader>dc", "<cmd>DapContinue<CR>",           desc = "继续 / 开始调试" },
    { "<leader>dC", "<cmd>DapTerminate<CR>",          desc = "终止调试" },
    { "<leader>do", "<cmd>DapStepOver<CR>",           desc = "单步跳过" },
    { "<leader>di", "<cmd>DapStepInto<CR>",           desc = "单步进入" },
    { "<leader>dO", "<cmd>DapStepOut<CR>",            desc = "单步跳出" },
    { "<leader>dr", "<cmd>DapRestartFrame<CR>",       desc = "重启当前帧" },
    { "<leader>du", "<cmd>DapUI<CR>",                  desc = "调试 UI 面板" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "调试悬浮信息" },
  },
  config = function()
    local dap = require("dap")

    -- DAP UI
    local dapui = require("dapui")
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
    })

    -- 自动打开/关闭 DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    -- ── Python (debugpy) ──
    require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

    -- ── Mason 管理其他 debug adapter ──
    require("mason-nvim-dap").setup({
      ensure_installed = { "debugpy", "codelldb" },
      automatic_installation = false,
    })

    -- ── 快捷键增强 (调试时可见) ──
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#E86671" })
    vim.api.nvim_set_hl(0, "DapStopped",    { fg = "#F8C4D4" })

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapStopped",    { text = "▶", texthl = "DapStopped" })
  end,
}
