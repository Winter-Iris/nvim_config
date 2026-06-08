-- ~/.config/nvim/lua/plugins/conform.lua
-- 自动格式化：保存文件自动运行，<leader>f 手动触发
return {
  "stevearc/conform.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    formatters_by_ft = {
      python = { "ruff_format" },
      lua = { "stylua" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      rust = { "rustfmt" },
      go = { "goimports" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      toml = { "taplo" },
    },

    format_on_save = {
      timeout_ms = 2000,
      lsp_fallback = true,
    },

    -- 通知格式化结果
    notify_on_error = true,
  },
}
