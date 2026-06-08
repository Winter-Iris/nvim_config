-- ~/.config/nvim/lua/plugins/lsp.lua
-- blink.cmp + mason + Neovim 原生 vim.lsp.config
return {
  "saghen/blink.cmp",
  dependencies = {
    "saghen/blink.lib",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "rafamadriz/friendly-snippets",
  },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "none",
      ["<Tab>"]   = { "select_next", "snippet_forward",  "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"]    = { "accept", "fallback" },
      ["<Up>"]    = { "select_prev", "fallback" },
      ["<Down>"]  = { "select_next", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"]     = { "hide" },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 300,
        window = { border = "none" },
      },
      menu = { border = "none" },
    },
    signature = {
      enabled = true,
      window = { border = "none" },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "lua" },
  },

  config = function(_, opts)
    require("mason").setup()

    local servers = { "pyright", "clangd", "lua_ls", "ts_ls" }
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    require("blink.cmp").setup(opts)

    -- 去除所有 LSP 弹窗边框
    local hover = vim.lsp.handlers["textDocument/hover"]
    local sig   = vim.lsp.handlers["textDocument/signatureHelp"]
    if hover then
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(hover, { border = "none" })
    end
    if sig then
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(sig, { border = "none" })
    end

    -- LSP 按键绑定
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        local bo = { noremap = true, silent = true, buffer = ev.buf }
        local map = vim.keymap.set

        map("n", "gd", vim.lsp.buf.definition,     vim.tbl_extend("force", bo, { desc = "跳转定义" }))
        map("n", "gD", vim.lsp.buf.declaration,    vim.tbl_extend("force", bo, { desc = "跳转声明" }))
        map("n", "gr", vim.lsp.buf.references,     vim.tbl_extend("force", bo, { desc = "查找引用" }))
        map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bo, { desc = "查找实现" }))
        map("n", "K",  vim.lsp.buf.hover,           vim.tbl_extend("force", bo, { desc = "悬浮文档" }))
        map("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", bo, { desc = "签名帮助" }))
        map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bo, { desc = "重命名" }))
        map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bo, { desc = "代码操作" }))

        -- 语义 Token 高亮
        if client.server_capabilities.semanticTokensProvider then
          vim.lsp.semantic_tokens.start(ev.buf, client.id)
        end
      end,
    })

    -- CursorHold 自动悬浮文档
    vim.api.nvim_create_autocmd("CursorHold", {
      group = vim.api.nvim_create_augroup("UserLspHover", {}),
      callback = function()
        vim.lsp.buf.hover({ border = "none" })
      end,
    })

    -- 配置各 LSP server
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local function mkcfg(cfg)
      cfg.capabilities = vim.tbl_deep_extend("force",
        vim.lsp.protocol.make_client_capabilities(),
        capabilities
      )
      return cfg
    end

    vim.lsp.config("pyright", mkcfg({
      cmd = { mason_bin .. "/pyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = { ".git", "pyproject.toml", "setup.py", "setup.cfg" },
    }))

    vim.lsp.config("clangd", mkcfg({
      cmd = { mason_bin .. "/clangd" },
      filetypes = { "c", "cpp", "objc", "objcpp" },
      root_markers = { ".git", "compile_commands.json", "CMakeLists.txt", "compile_flags.txt" },
    }))

    vim.lsp.config("lua_ls", mkcfg({
      cmd = { mason_bin .. "/lua-language-server" },
      filetypes = { "lua" },
      root_markers = { ".git", ".luarc.json", ".luarc.jsonc" },
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
      },
    }))

    vim.lsp.config("ts_ls", mkcfg({
      cmd = { mason_bin .. "/typescript-language-server", "--stdio" },
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      root_markers = { ".git", "package.json", "tsconfig.json", "jsconfig.json" },
    }))

    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
  end,
}
