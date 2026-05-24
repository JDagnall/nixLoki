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
				-- i set my tab max width to 32
				local half_tab_length = 12 -- after whitespace
				local directory_name = basename(pane.cwd)
				local file_name = basename(vim.api.nvim_buf_get_name(0))
				local directory_name_len = math.min(#directory_name, half_tab_length)
				local file_name_len = math.min(#file_name, half_tab_length)
				if file_name_len < half_tab_length then
					directory_name_len = math.min(directory_name_len + (half_tab_length - #file_name), #directory_name)
				end
				if directory_name_len < half_tab_length then
					file_name_len = math.min(file_name_len + (half_tab_length - #directory_name), #file_name)
				end
				wezterm.set_tab_title(
					" "
						-- .. pane.tab_id + 1
						-- .. ": "
						.. string.sub(directory_name, 0, directory_name_len)
						.. " | "
						.. filetype_icon
						.. " "
						.. string.sub(file_name, 0, file_name_len)
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
