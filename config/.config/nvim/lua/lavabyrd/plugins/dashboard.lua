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
			{ desc = " Update", group = "@property", action = "PackerUpdate", key = "u" },
			{
				desc = " Find Files",
				group = "Label",
				action = "Telescope find_files",
				key = "f",
			},
			{
				desc = " Find String",
				group = "Label",
				action = "Telescope live_grep",
				key = "a",
			},
			{
				desc = " dotfiles",
				group = "Number",
				action = "e ~/.dotfiles/",
				key = "d",
			},
		},
		-- footer = {
		-- 	text = "Who watches the watchmen?",
		-- },
	},
})
