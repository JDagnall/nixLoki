return {
	"Vigemus/iron.nvim",
	enabled = require("nixCatsUtils").enableForCategory("iron", true),
	opts = function()
		local view = require("iron.view")
		local common = require("iron.fts.common")
		local cr = "\13"
		local comment = "#"

		-- formats multiline code onto one line, used for nix repl which does not accept
		-- single line expressions
		local nix_oneline_format = function(lines, repldef)
			assert(type(lines) == "table", "Supplied lines is not a table")
			if repldef.format then
				return repldef.format(lines, { command = repldef.command })
			end
			local new_lines = {}
			-- filter out comments
			for _, line in pairs(lines) do
				if type(line) == "string" then
					local new_line = string.gsub(line, comment .. ".*$", " ")
					if #new_line > 0 then
						table.insert(new_lines, new_line)
					end
				end
			end
			local formatted_output = table.concat(new_lines, " ")
			return string.gsub(formatted_output, "%s+", " ") .. cr -- no whitespace
		end
		return {
			config = {
				scratch_repl = true,
				repl_definition = {
					sh = { command = "zsh" },
					python = {
						command = { "python3" },
						format = common.bracketed_paste_python,
						block_dividers = { "# %%", "#%%" },
						env = { PYTHON_BASIC_REPL = "1" },
					},
					nix = {
						command = { "nix", "repl" },
						format = nix_oneline_format,
					},
				},
				repl_filetype = function(_, ft)
					return ft
				end,
				repl_open_cmd = view.split.vertical.botright(0.4),
			},
			ignore_blank_lines = true,
			keymaps = {
				toggle_repl = "<leader>R", -- toggles the repl open and closed.
				restart_repl = "<leader>RR", -- calls `IronRestart` to restart the repl
				send_motion = "<leader>rc",
				visual_send = "<leader>rc",
				send_file = "<leader>rf",
				send_line = "<leader>rl",
				send_until_cursor = "<leader>ru",
				send_mark = "<leader>rm",
				send_code_block = "<leader>rb",
				mark_motion = "<leader>mc",
				mark_visual = "<leader>mc",
				remove_mark = "<leader>md",
				cr = "<leader>s<cr>",
				interrupt = "<leader>s<leader>",
				exit = "<leader>RQ",
				clear = "<leader>RC",
			},
		}
	end,
	keys = {
		"<leader>R",
	},
	cmd = { "Iron", "IronAttach", "IronFocus" },
}
