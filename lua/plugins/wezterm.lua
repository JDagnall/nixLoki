local ncUtil = require("nixCatsUtils")

local function basename(s)
	return string.gsub(s, "^.*[\\/]([^/\\]+)[/\\]?$", "%1")
end

return {
	-- Wezterm integration
	-- Can be used as an image provider
	-- Also being used to set tab names
	"willothy/wezterm.nvim",
	enabled = ncUtil.enableForCategory("wezterm", true),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local wezterm = require("wezterm")
		wezterm.setup()
		-- These autocommands are to set custom tab titles for nvim tabs
		-- local old_tabtitle = ""
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			callback = function()
				local current_pane_id = wezterm.get_current_pane()
				local pane = wezterm.list_panes()[current_pane_id]
				local filetype_icon = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
				-- expand('%') expands to the the filename
				wezterm.set_tab_title(
					" "
						.. pane.tab_id
						.. ": "
						.. basename(pane.cwd)
						.. " | "
						.. filetype_icon
						.. " "
						.. vim.fn.expand("%")
				)
			end,
		})
		vim.api.nvim_create_autocmd({ "VimLeave" }, {
			callback = function()
				-- should cause wezterm too format the tab title normally
				wezterm.set_tab_title("")
			end,
		})
	end,
}
