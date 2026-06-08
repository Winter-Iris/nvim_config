-- ~/.config/nvim/lua/plugins/dashboard.lua
return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dash = require("alpha.themes.dashboard")

    -- Iris logo 每行独立颜色
    local logo_lines = {
      "  ██╗██████╗ ██╗███████╗",
      "  ██║██╔══██╗██║██╔════╝",
      "  ██║██████╔╝██║███████╗",
      "  ██║██╔══██╗██║╚════██║",
      "  ██║██║  ██║██║███████║",
      "  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝",
    }
    local colors = {
      "#F8C4D4", "#F0B8D0", "#E0B0D8",
      "#C8B0E0", "#B0B8E8", "#A0C0E8",
    }
    for i, c in ipairs(colors) do
      vim.api.nvim_set_hl(0, "DashLogo" .. i, { fg = c })
    end

    -- 保持标准按钮/页脚
    dash.section.buttons.val = {
      dash.button("f", "  Find File", ":lua require('snacks').picker.files()<CR>"),
      dash.button("g", "  Grep",      ":lua require('snacks').picker.grep()<CR>"),
      dash.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
      dash.button("r", "  Recent",   ":lua require('snacks').picker.recent()<CR>"),
      dash.button("c", "  Config",   ":e ~/.config/nvim/init.lua<CR>"),
      dash.button("p", "  Plugins",  ":Lazy<CR>"),
      dash.button("q", "  Quit",     ":qa<CR>"),
    }
    for _, b in ipairs(dash.section.buttons.val) do
      b.opts.hl_shortcut = "DashboardShortcut"
      b.opts.hl = "DashboardButton"
    end

    dash.section.footer.val = { "  今天也要开心哦 ~" }
    dash.section.footer.opts.hl = "DashboardFooter"

    -- 构建 layout：用 dash.config 的原始结构，只替换 header
    local layout = {
      { type = "padding", val = 2 },
    }
    -- 彩色 logo 行
    for i, line in ipairs(logo_lines) do
      table.insert(layout, {
        type = "text",
        val = line,
        opts = { hl = "DashLogo" .. i, position = "center" },
      })
    end
    -- 标准间距和按钮/页脚
    table.insert(layout, { type = "padding", val = 2 })
    table.insert(layout, dash.section.buttons)
    table.insert(layout, dash.section.footer)

    vim.api.nvim_set_hl(0, "DashboardShortcut", { fg = "#F8C4D4" })
    vim.api.nvim_set_hl(0, "DashboardButton",   { fg = "#FDE4EE" })
    vim.api.nvim_set_hl(0, "DashboardFooter",   { fg = "#C8B0D8" })

    alpha.setup({ layout = layout, opts = { margin = 5 } })

    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        vim.opt.showtabline = 0
      end,
    })
  end,
}
