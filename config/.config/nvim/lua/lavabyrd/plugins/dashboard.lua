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
		},
		shortcut = {
			{
				desc = " Files",
				group = "Label",
				action = "Telescope find_files",
				key = "f",
			},
			{
				desc = " String",
				group = "Label",
				action = "Telescope live_grep",
				key = "s",
			},
			{
				desc = " Dotfiles",
				group = "Number",
				action = "e ~/.dotfiles/",
				key = "d",
			},
			{
				desc = "Explorer",
				group = "Label",
				action = "NvimTreeToggle",
				key = "o",
			},
			{ desc = " Update", group = "@property", action = "PackerUpdate", key = "u" },
			{
				desc = "  Quit",
				group = "Label",
				action = "q",
				key = "q",
			},
		},
	},
})
