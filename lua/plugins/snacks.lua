-- ~/.config/nvim/lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    input = { enabled = true },
    notifier = { enabled = true },
    scroll = { enabled = false },
    words = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        layout = {
          reverse = true,
          box = "horizontal",
          backdrop = false,
          width = 0.8,
          height = 0.9,
          border = "none",
          {
            box = "vertical",
            width = 0.35,
            { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
            { win = "list", title = " Results ", title_pos = "center", border = true },
          },
          {
            win = "preview",
            title = "{preview:Preview}",
            width = 0.65,
            border = true,
            title_pos = "center",
          },
        },
      },
    },
    terminal = { enabled = true },
  },
  -- stylua: ignore
  keys = {
    { "<leader>n", function()
      if Snacks.config.picker and Snacks.config.picker.enabled then
        Snacks.picker.notifications()
      else
        Snacks.notifier.show_history()
      end
    end, desc = "Notification History" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
  },
}
