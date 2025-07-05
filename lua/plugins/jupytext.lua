return {
	"GCBallesteros/jupytext.nvim",
	config = true,
	enabled = require("nixCatsUtils").enableForCategory("jupytext", false),
	lazy = false,
	opts = {
		style = "markdown",
		output_extension = "md",
		force_ft = "markdown",
	},
}
