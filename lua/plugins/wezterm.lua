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
				local panes = wezterm.list_panes()
				local pane = nil
				for _, p in pairs(panes) do
					if p.pane_id == current_pane_id then
						pane = p
					end
				end
				if pane == nil then
					return
				end
				local filetype_icon = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
				if filetype_icon == nil then
					filetype_icon = ""
				end
				-- expand('%') expands to the the filename
				-- tab_id plus one may (probably) wont work well, but wezterm CLI is not exposing tab_index for some reason
				wezterm.set_tab_title(
					" "
						-- .. pane.tab_id + 1
						-- .. ": "
						.. basename(pane.cwd)
						.. " | "
						.. filetype_icon
						.. " "
						.. basename(vim.api.nvim_buf_get_name(0))
						.. " "
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
