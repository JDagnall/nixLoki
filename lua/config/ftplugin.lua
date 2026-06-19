--
-- Filetype setting
-- opt_local and {buffer = true} ensures options only effect the one buffer
--

-- markdown
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "markdown",
	callback = function(args)
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.textwidth = 90
		-- no auto insertnig line breaks
		vim.opt_local.formatoptions:remove("t")
		-- vim.opt_local.wrapmargin = 5
		-- move on visual not logical lines
		vim.keymap.set({ "n", "v" }, "j", "gj", { buffer = true })
		vim.keymap.set({ "n", "v" }, "k", "gk", { buffer = true })
	end,
})

-- sql
-- Disable the genuinely psychotic default bindings in sql files
vim.g.omni_sql_no_default_maps = 1
