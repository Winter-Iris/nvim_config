return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local c = {
            bg      = "#1C1A22",
            pink    = "#F8C4D4",
            light   = "#FDE4EE",
            surface = "#2D2A34",
            text    = "#CDD6F4",
            subtext = "#6C7086",
        }

        local theme = {
            normal = {
                a = { fg = c.bg,    bg = c.pink,    gui = "bold" },
                b = { fg = c.pink,  bg = c.surface               },
                c = { fg = c.text,  bg = c.bg                    },
            },
            insert = {
                a = { fg = c.bg,    bg = "#FDE4EE",  gui = "bold" },
                b = { fg = c.light, bg = c.surface               },
            },
            visual = {
                a = { fg = c.bg,    bg = c.pink,    gui = "bold" },
                b = { fg = c.pink,  bg = c.surface               },
            },
            replace = {
                a = { fg = c.bg,    bg = "#F0C0D0", gui = "bold" },
                b = { fg = "#F0C0D0", bg = c.surface             },
            },
            command = {
                a = { fg = c.bg,    bg = "#E8C0D8", gui = "bold" },
                b = { fg = "#E8C0D8", bg = c.surface             },
            },
            inactive = {
                a = { fg = c.subtext, bg = c.surface },
                b = { fg = c.subtext, bg = c.surface },
                c = { fg = c.subtext, bg = c.bg      },
            },
        }

        require("lualine").setup({
            options = {
                theme = theme,
                globalstatus = true,
                component_separators = "",
                section_separators  = { left = "", right = "" },
            },
            sections = {
                -- 左右两端加圆角外壳
                lualine_a = {
                    { "mode",
                        separator = { left = "", right = "" },
                    },
                },
                lualine_b = { "branch", "diff" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "diagnostics" },
                lualine_y = { "filetype" },
                lualine_z = {
                    { "location",
                        separator = { left = "", right = "" },
                    },
                },
            },
        })
    end,
}
