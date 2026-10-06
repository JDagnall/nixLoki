local ncUtil = require("nixCatsUtils")
return {
	enabled = ncUtil.enableForCategory("render-markdown", true),
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		completions = { lsp = { enabled = true } },
		-- modes in which the markdown will be rendered, this way insert mode
		-- has a source view
		render_modes = { "n", "c", "t" },
		-- could also be 'obsidian' or 'lazy'
		preset = "none",
	},
}
