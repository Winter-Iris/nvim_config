return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,

	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,

			-- UI 元素粉色覆盖（不碰代码语法配色）
			highlight_overrides = {
				mocha = function(cp)
					local pink = "#F8C4D4" -- 主樱粉
					local lightpink = "#FDE4EE" -- 浅樱粉
					local bgpink = "#45475A" -- 亮浅灰（光标行）
					local accent = lightpink -- 强调色
					local cursor_n = pink -- Normal 光标 = 主粉
					local cursor_i = lightpink -- Insert 光标 = 浅粉

					return {
						-- 光标
						Cursor = { fg = cp.base, bg = cursor_n },
						CursorInsert = { fg = cp.base, bg = cursor_i },
						CursorReplace = { fg = cp.base, bg = "#E8A0B0" },

						-- 光标行
						CursorLine = { bg = bgpink },
						CursorLineNr = { fg = pink, style = { "bold" } },

						-- 选中区域
						Visual = { bg = "#3D2835" },
						VisualNOS = { bg = "#3D2835" },

						-- 搜索
						Search = { bg = "#4D3040", fg = accent },
						IncSearch = { bg = pink, fg = cp.base },
						CurSearch = { bg = pink, fg = cp.base },

						-- 匹配括号
						MatchParen = { bg = "#4D3040", fg = pink, style = { "bold" } },

						-- 状态栏 / lualine
						StatusLine = { bg = cp.mantle, fg = pink },
						StatusLineNC = { bg = cp.mantle, fg = cp.surface1 },

						-- 标签栏
						TabLineSel = { bg = pink, fg = cp.base, style = { "bold" } },
						TabLine = { bg = cp.mantle, fg = cp.surface1 },
						TabLineFill = { bg = cp.mantle },

						-- 补全菜单（blink.cmp 用）
						Pmenu = { bg = cp.mantle, fg = cp.text },
						PmenuSel = { bg = "#4D3040", fg = accent },
						PmenuThumb = { bg = cp.surface1 },

						-- 浮动窗口
						NormalFloat = { bg = cp.mantle },
						FloatBorder = { fg = pink },

						-- 文件树
						Directory = { fg = pink },
						NvimTreeFolderName = { fg = pink },
						NvimTreeOpenedFolderName = { fg = pink },
						NvimTreeEmptyFolderName = { fg = cp.surface1 },
						NvimTreeIndentMarker = { fg = cp.surface0 },

						-- 诊断符号
						DiagnosticSignError = { fg = "#F4A7B9" },
						DiagnosticSignWarn = { fg = "#F0D5A8" },
						DiagnosticSignInfo = { fg = "#C8B8D8" },
						DiagnosticSignHint = { fg = "#A8C8C0" },

						-- 诊断下划线
						DiagnosticUnderlineError = { sp = "#F4A7B9", style = { "undercurl" } },
						DiagnosticUnderlineWarn = { sp = "#F0D5A8", style = { "undercurl" } },

						-- 错误列
						ErrorMsg = { fg = "#F4A7B9" },
						WarningMsg = { fg = "#F0D5A8" },

						-- 分割线
						WinSeparator = { fg = cp.surface0 },
						VertSplit = { fg = cp.surface0 },

						-- Dashboard (alpha-nvim)
						DashboardHeader = { fg = pink },
						DashboardButton = { fg = lightpink },
						DashboardFooter = { fg = pink },

						-- Bufferline
						BufferLineFill = { fg = cp.overlay0, bg = cp.base },
						BufferLineBackground = { fg = cp.overlay0, bg = cp.base },
						BufferLineBufferSelected = { fg = cp.base, bg = pink, bold = true },
						BufferLineBufferVisible = { fg = cp.text, bg = cp.surface0 },
						BufferLineSeparatorSelected = { fg = pink, bg = cp.base },
						BufferLineSeparatorVisible = { fg = cp.surface0, bg = cp.base },
						BufferLineSeparator = { fg = cp.base, bg = cp.base },
						BufferLineNumbersSelected = { fg = cp.base, bg = pink, bold = true },
						BufferLineNumbersVisible = { fg = cp.overlay0, bg = cp.surface0 },
						BufferLineCloseButtonSelected = { fg = cp.base, bg = pink },
						BufferLineCloseButtonVisible = { fg = cp.overlay0, bg = cp.surface0 },
						BufferLineModifiedSelected = { fg = cp.base, bg = pink },
						BufferLineModifiedVisible = { fg = cp.overlay0, bg = cp.surface0 },
						BufferLineIndicatorSelected = { fg = pink, bg = cp.base },
						BufferLineIndicatorVisible = { fg = cp.surface0, bg = cp.base },
					}
				end,
			},

			integrations = {
				lualine = true,
				nvimtree = true,
				treesitter = true,
				blink_cmp = true,
				mason = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
