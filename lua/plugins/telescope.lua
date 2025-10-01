vim.g.telescope_enabled = require("nixCatsUtils").enableForCategory("telescope", false)
return {
	"nvim-telescope/telescope.nvim",
	enabled = vim.g.telescope_enabled,
	lazy = false,
	version = "*",
	dependencies = {
		-- all enabled under the same nixCat category
		{ "nvim-lua/plenary.nvim" },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				pcall(require("telescope").load_extension, "fzf")
			end,
		},
		{
			"nvim-telescope/telescope-ui-select.nvim",
			config = function()
				pcall(require("telescope").load_extension, "ui-select")
			end,
		},
	},
	keys = function()
		local builtin = require("telescope.builtin")
		return {
			{ mode = "n", "<C-p>", builtin.git_files, desc = "Search files tracked by current git repo" },
			{ mode = "n", "<leader>pf", builtin.find_files, desc = "Regular telescope fuzzy finder" },
			{ mode = "n", "<leader>ps", builtin.live_grep, desc = "Grep through files in cwd" },
			{
				mode = "n",
				"<leader>t",
				":Telescope builtin include_extensions=true<CR>",
				desc = "Search through all telescope pickers",
			},
			-- LSP bindings with telescope
			{
				mode = "n",
				"<leader>f",
				function()
					builtin.lsp_document_symbols({ symbols = { "Function", "Method" } })
				end,
				desc = "find functions in the current file",
			},
			{
				mode = "n",
				"<leader>F",
				function()
					builtin.lsp_workspace_symbols({ symbols = { "Function", "Method" } })
				end,
				desc = "find functions in the current workspace",
			},
			{
				mode = "n",
				"<leader>gr",
				builtin.lsp_references,
				desc = "find functions in the current workspace",
			},
		}
	end,
	opts = function()
		-- Stops binaries from being previewed
		local previewers = require("telescope.previewers")
		local Job = require("plenary.job")
		local actions = require("telescope.actions")
		local new_maker = function(filepath, bufnr, opts)
			filepath = vim.fn.expand(filepath)
			Job:new({
				command = "file",
				args = { "--mime-type", "-b", filepath },
				on_exit = function(j)
					local mime_type = vim.split(j:result()[1], "/")[1]
					if mime_type == "text" or mime_type == "application" then
						previewers.buffer_previewer_maker(filepath, bufnr, opts)
					else
						-- maybe we want to write something to the buffer here
						vim.schedule(function()
							vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
						end)
					end
				end,
			}):sync()
		end

		return {
			pickers = {
				find_files = {
					-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--color",
						"never",
						"--glob",
						"!**/.git/*",
						"--follow",
						"-d",
						"5",
					},
					hidden = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
			defaults = {
				buffer_previewer_maker = new_maker,
				mappings = {
					i = {
						["<C-c>"] = actions.close,
						["<C-n>"] = actions.move_selection_next,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<C-\\>"] = actions.file_vsplit,
					},
					n = {
						["<C-c>"] = actions.close,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<C-p>"] = actions.move_selection_previous,
						["<C-n>"] = actions.move_selection_next,
						["<C-\\>"] = actions.file_vsplit,
					},
				},
			},
		}
	end,
}
