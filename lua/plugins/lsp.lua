-- ~/.config/nvim/lua/plugins/lsp.lua
-- 对齐 LazyVim: vim.lsp.config + vim.lsp.enable + mason-lspconfig.automatic_enable
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      inlay_hints = { enabled = true },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        pyright = {},
        clangd = {},
        ts_ls = {},
      },
    },
    config = function(_, opts)
      -- 诊断配置
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- 所有 LSP 服务器的默认 keymaps
      local lsp_keys = {
        { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
        { "gr", vim.lsp.buf.references, desc = "References" },
        { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "K", vim.lsp.buf.hover, desc = "Hover" },
        { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
        { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" } },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
      }

      -- 组装 keymaps 到 LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then return end
          local bo = { buffer = ev.buf }
          for _, k in ipairs(lsp_keys) do
            local mode = k.mode or "n"
            local opts = vim.tbl_extend("force", {
              desc = k.desc,
              silent = true,
              noremap = true,
            }, k.mode and { buffer = ev.buf } or bo)
            vim.keymap.set(mode, k[1], k[2], opts)
          end
          -- 语义高亮
          if client.server_capabilities.semanticTokensProvider then
            vim.lsp.semantic_tokens.start(ev.buf, client.id)
          end
        end,
      })

      -- 配置所有 servers（默认使用 "*" only 就够）
      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      -- 获取 mason-lspconfig 能管理的所有 server
      local have_mason, mason_map = pcall(function()
        return require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
      end)
      local mason_all = have_mason and vim.tbl_keys(mason_map) or {}

      -- vim.lsp.config 注册所有 mason server
      for server, sopts in pairs(opts.servers) do
        if server ~= "*" then
          sopts = type(sopts) == "table" and sopts or {}
          vim.lsp.config(server, sopts)
        end
      end

      -- 启用所有 mason 可用的 server
      local enable_list = {}
      for _, server in ipairs(vim.tbl_keys(opts.servers)) do
        if server ~= "*" and opts.servers[server] ~= false then
          table.insert(enable_list, server)
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = enable_list,
        automatic_installation = true,
        automatic_enable = true,
      })

      -- 对于不在 mason 列表里的 server，手动启用
      for _, server in ipairs(enable_list) do
        if not vim.tbl_contains(mason_all, server) then
          vim.lsp.enable(server)
        end
      end
    end,
  },

  -- mason.nvim
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {},
  },

  -- blink.cmp
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saghen/blink.lib",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      snippets = { preset = "default" },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          draw = { treesitter = { "lsp" } },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },
}
