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
		-- vim.opt_local.wrapmargin = 5
		vim.keymap.set({ "n", "v" }, "h", "gh", { buffer = true })
		vim.keymap.set({ "n", "v" }, "j", "gj", { buffer = true })
		vim.keymap.set({ "n", "v" }, "k", "gk", { buffer = true })
		vim.keymap.set({ "n", "v" }, "l", "gl", { buffer = true })
	end,
})
