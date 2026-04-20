vim.cmd [[colorscheme kanagawa-wave]]

local colorbuddy = require('colorbuddy')
local Color = colorbuddy.Color
local colors = colorbuddy.colors
local Group = colorbuddy.Group
local groups = colorbuddy.groups
local styles = colorbuddy.styles

Color.new('background', '#282c34')
Color.new('red', '#cc6666')
Color.new('green', '#99cc99')
Color.new('yellow', '#f0c674')

-- Constant
Group.new('@lsp.mod.readonly.go', colors.red, nil, styles.italic)

vim.api.nvim_set_hl(0, "@keyword.return", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@keyword.import.go", { link = "@keyword" })
