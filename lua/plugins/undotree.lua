-- Edit hitory <leader>u
return {
	"mbbill/undotree",
	enabled = require("nixCatsUtils").enableForCategory("undotree", true),
	keys = {
		{ mode = "n", "<leader>u", vim.cmd.UndotreeToggle },
	},
}
