local setup, dashboard = pcall(require, "dashboard")
if not setup then
	return
end

dashboard.setup({
	event = "VimEnter",
	theme = "hyper",
	config = {
		week_header = {
			enable = true,
			tbl = false,
		},
		packages = {
			enable = false,
		},
		project = {
			limit = 5,
			label = "Recent Projects",
		},
		mru = {
			limit = 5,
			label = "Recent Files",
		},
		shortcut = {
			{
				desc = "Files",
				group = "Label",
				action = "Telescope find_files",
				key = "f",
			},
			{
				desc = "String",
				group = "Label",
				action = "Telescope live_grep",
				key = "s",
			},
			{
				desc = "Config",
				group = "Number",
				action = "e ~/.dotfiles/config/.config/nvim/init.lua",
				key = "c",
			},
			{
				desc = "Explorer",
				group = "Label",
				action = "NvimTreeToggle",
				key = "o",
			},
			{
				desc = "Update",
				group = "@property",
				action = "PackerUpdate",
				key = "u",
			},
			{
				desc = "Quit",
				group = "Label",
				action = "q",
				key = "q",
			},
		},
		footer = {
			"",
			"  🌮 Who watches the watchmen?",
		},
	},
})
