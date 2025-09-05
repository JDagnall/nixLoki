return {
	"Vigemus/iron.nvim",
	enabled = require("nixCatsUtils").enableForCategory("iron", true),
	opts = function()
		local view = require("iron.view")
		local common = require("iron.fts.common")
		return {
			config = {
				scratch_repl = true,
				repl_definition = {
					sh = { command = "zsh" },
					python = {
						command = { "python3" },
						format = common.bracketed_paste_python,
						block_dividers = { "# %%", "#%%" },
					},
					hermes = {
						command = { "docker", "exec", "-it", "hermes", "flask", "shell", "--no-autoindent" },
						format = common.bracketed_paste_python,
						block_dividers = { "# %%", "#%%" },
					},
					athena = {
						command = { "docker", "exec", "-it", "athena", "flask", "shell", "--no-autoindent" },
						format = common.bracketed_paste_python,
						block_dividers = { "# %%", "#%%" },
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
