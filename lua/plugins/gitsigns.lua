-- ~/.config/nvim/lua/plugins/gitsigns.lua
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    signs_staged = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 500,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = vim.keymap.set
      map("n", "]c", gs.next_hunk, { buffer = bufnr, desc = "下一处修改" })
      map("n", "[c", gs.prev_hunk, { buffer = bufnr, desc = "上一处修改" })
      map("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "暂存修改" })
      map("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "撤销修改" })
      map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = bufnr, desc = "暂存选中" })
      map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = bufnr, desc = "撤销选中" })
      map("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "暂存全部" })
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { buffer = bufnr, desc = "行 Git Blame" })
      map("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Diff 当前文件" })
      map("n", "<leader>hp", gs.preview_hunk_inline, { buffer = bufnr, desc = "预览修改" })
    end,
  },
}
