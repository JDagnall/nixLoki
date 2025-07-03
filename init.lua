-- this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
require('nixCatsUtils').setup {
  non_nix_value = true,
}

local ncUtil = require('nixCatsUtils')

vim.g.mapleader = " ";

require("config.options")
require("config.keymaps")
require("config.lazy-cat")

