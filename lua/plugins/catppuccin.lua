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
					local accent = lightpink -- 强调色
					local cursor_n = pink -- Normal 光标 = 主粉
					local cursor_i = lightpink -- Insert 光标 = 浅粉

					return {
						-- 光标
						Cursor = { fg = cp.base, bg = cursor_n },
						CursorInsert = { fg = cp.base, bg = cursor_i },
						CursorReplace = { fg = cp.base, bg = "#E8A0B0" },

						-- 光标行号
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

						-- 状态栏 / lualine (保留背景)
						StatusLine = { bg = cp.mantle, fg = pink },
						StatusLineNC = { bg = cp.mantle, fg = cp.surface1 },

						-- 标签栏 (保留背景)
						TabLineSel = { bg = pink, fg = cp.base, style = { "bold" } },
						TabLine = { bg = cp.mantle, fg = cp.surface1 },
						TabLineFill = { bg = cp.mantle },

						-- 补全菜单
						PmenuSel = { bg = "#4D3040", fg = accent },
						PmenuThumb = { bg = cp.surface1 },

						-- 浮动窗口边框
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

						-- Bufferline (保留背景)
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

		-- 应用透明 + 边框粉色（每次 ColorScheme 事件都重新生效）
		local function apply_transparency()
			local pink = "#F8C4D4"

			-- 所有背景透明 (不碰 lualine / bufferline)
			local transparent_groups = {
				"Normal", "NormalNC", "NormalFloat", "NormalSB",
				"SignColumn", "LineNr", "CursorLine", "CursorLineNr",
				"EndOfBuffer", "FoldColumn", "CursorColumn",
				"FloatTitle",
				"WhichKeyFloat", "WhichKeyBorder",
				"Pmenu", "PmenuSbar", "PmenuKind",
				"LspInfoBorder", "LspInlayHint",
				"NotifyBackground",
				"NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer",
				"TelescopeNormal", "TelescopePromptNormal",
				"TelescopeResultsNormal", "TelescopePreviewNormal",
				"SnacksPickerNormal", "SnacksPreviewNormal",
				"SnacksInputNormal",
				"SnacksNotifierNormal",
				"AlphaHeader", "AlphaButtons", "AlphaFooter",
				"DashboardHeader", "DashboardButton", "DashboardFooter",
				"MsgArea", "MsgSeparator",
				"TroubleNormal",
				"FlashBackdrop",
				"RenderMarkdownNormal",
			}
			for _, group in ipairs(transparent_groups) do
				vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
			end

			-- 浮动边框统一粉色 + 透明背景
			local border_groups = {
				"FloatBorder", "TelescopeBorder",
				"SnacksPickerBorder", "SnacksInputBorder", "SnacksNotifierBorder",
				"NoiceCmdlinePopupBorder", "NoicePopupBorder", "NoicePopupmenuBorder",
				"NoiceCmdlinePopupBorderNormal", "NoicePopupBorderNormal",
			}
			for _, group in ipairs(border_groups) do
				vim.api.nvim_set_hl(0, group, { fg = pink, bg = "NONE", ctermbg = "NONE" })
			end

			-- 确保光标颜色
			vim.api.nvim_set_hl(0, "Cursor", { fg = "#1E1E2E", bg = pink })
			vim.api.nvim_set_hl(0, "CursorInsert", { fg = "#1E1E2E", bg = "#FDE4EE" })
			vim.api.nvim_set_hl(0, "CursorReplace", { fg = "#1E1E2E", bg = "#E8A0B0" })
		end

		apply_transparency()
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = apply_transparency,
		})
	end,
}
