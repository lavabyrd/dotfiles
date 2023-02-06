-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
	return
end

-- configure lualine with modified theme
lualine.setup({
	options = {
		theme = "dracula",
	},
	sections = {
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "hostname" },
	},
})
