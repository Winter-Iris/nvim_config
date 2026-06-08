-- ~/.config/nvim/lua/plugins/bufferline.lua
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.cmd([[
      hi def BufLineDateTime  guifg=#9CA0B0 guibg=#1C1A22 gui=underline guisp=#9CA0B0
      hi def BufLineGreeting  guifg=#9CA0B0 guibg=#1C1A22 gui=underline guisp=#9CA0B0
      hi def BufLineEmoji     guifg=#9CA0B0 guibg=#1C1A22
    ]])

    -- Buffer 切换快捷键
    local map = vim.keymap.set
    map("n", "[b",         ":BufferLineCyclePrev<CR>", { desc = "上一个 Buffer", silent = true })
    map("n", "]b",         ":BufferLineCycleNext<CR>", { desc = "下一个 Buffer", silent = true })
    map("n", "<leader>bd", ":bdelete<CR>",             { desc = "关闭当前 Buffer", silent = true })
    map("n", "<leader>bq", ":bdelete!<CR>",            { desc = "强制关闭 Buffer", silent = true })
    map("n", "<leader>bp", ":BufferLineMovePrev<CR>",  { desc = "Buffer 左移", silent = true })
    map("n", "<leader>bn", ":BufferLineMoveNext<CR>",  { desc = "Buffer 右移", silent = true })

    -- 快速跳转到第 N 个 buffer
    for i = 1, 9 do
      map("n", "<leader>" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", { desc = "跳转 Buffer " .. i, silent = true })
    end

    require("bufferline").setup({
      options = {
        mode = "buffers",
        numbers = "ordinal",
        indicator = { style = "none" },
        separator_style = "thin",
        color_icons = false,
        show_buffer_close_icons = true,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
        custom_areas = {
          right = function()
            local h = tonumber(os.date("%H"))
            local greeting, emoji
            if h < 12 then
              greeting, emoji = "早安喵~", "( =^･ω･^= )"
            elseif h < 18 then
              greeting, emoji = "午安喵~", "( ◡‿◡ *)♡"
            else
              greeting, emoji = "晚安喵~", "( ୨୧ • ᴗ • )"
            end
            return {
              { text = os.date("  %Y-%m-%d %H:%M:%S  "), hl = "BufLineDateTime" },
              { text = emoji .. " ", hl = "BufLineEmoji" },
              { text = greeting .. "  ", hl = "BufLineGreeting" },
            }
          end,
        },
      },
      highlights = {
        fill       = { bg = "#1C1A22" },
        background = { bg = "#1C1A22" },
        buffer     = { bg = "#1C1A22" },
        buffer_selected         = { bg = "#F8C4D4", fg = "#1E1E2E" },
        buffer_visible          = { bg = "#2D2A34", fg = "#CDD6F4" },
        numbers_selected        = { bg = "#F8C4D4", fg = "#1E1E2E" },
        numbers_visible         = { bg = "#2D2A34", fg = "#6C7086" },
        close_button_selected   = { bg = "#F8C4D4", fg = "#1E1E2E" },
        close_button_visible    = { bg = "#2D2A34", fg = "#6C7086" },
        modified_selected       = { bg = "#F8C4D4", fg = "#1E1E2E" },
        modified_visible        = { bg = "#2D2A34", fg = "#6C7086" },
        diagnostic_selected     = { bg = "#F8C4D4", fg = "#1E1E2E" },
        diagnostic_visible      = { bg = "#2D2A34", fg = "#6C7086" },
        error_selected          = { bg = "#F8C4D4", fg = "#E86671" },
        error_visible           = { bg = "#2D2A34", fg = "#E86671" },
        warning_selected        = { bg = "#F8C4D4", fg = "#DFC184" },
        warning_visible         = { bg = "#2D2A34", fg = "#DFC184" },
        info_selected           = { bg = "#F8C4D4", fg = "#B4A8D0" },
        info_visible            = { bg = "#2D2A34", fg = "#B4A8D0" },
        hint_selected           = { bg = "#F8C4D4", fg = "#9CC0B8" },
        hint_visible            = { bg = "#2D2A34", fg = "#9CC0B8" },
        error_diagnostic_selected   = { bg = "#F8C4D4", fg = "#E86671" },
        error_diagnostic_visible    = { bg = "#2D2A34", fg = "#E86671" },
        warning_diagnostic_selected = { bg = "#F8C4D4", fg = "#DFC184" },
        warning_diagnostic_visible  = { bg = "#2D2A34", fg = "#DFC184" },
        info_diagnostic_selected    = { bg = "#F8C4D4", fg = "#B4A8D0" },
        info_diagnostic_visible     = { bg = "#2D2A34", fg = "#B4A8D0" },
        hint_diagnostic_selected    = { bg = "#F8C4D4", fg = "#9CC0B8" },
        hint_diagnostic_visible     = { bg = "#2D2A34", fg = "#9CC0B8" },
        separator_selected      = { fg = "#F8C4D4", bg = "#1C1A22" },
        separator_visible       = { fg = "#2D2A34", bg = "#1C1A22" },
        separator               = { fg = "#1C1A22", bg = "#1C1A22" },
        indicator_selected      = { fg = "#F8C4D4", bg = "#1C1A22" },
        indicator_visible       = { fg = "#2D2A34", bg = "#1C1A22" },
      },
    })

    -- 强制所有图标使用深色
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("DarkIcons", {}),
      callback = function()
        vim.defer_fn(function()
          local ok, icons = pcall(require, "nvim-web-devicons")
          if ok then
            for name, _ in pairs(icons.get_icons()) do
              vim.cmd("hi! BufferLineDevIcon" .. name .. "Selected guifg=#1E1E2E")
              vim.cmd("hi! DevIcon" .. name .. " guifg=#1E1E2E")
            end
          end
        end, 200)
      end,
    })
  end,
}
