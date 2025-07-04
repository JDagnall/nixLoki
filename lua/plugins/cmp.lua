local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

-- function that formats each individual entry in the completion list
local function format_entry(entry, item)
	-- Define menu shorthand for different completion sources.
	local menu_icon = {
		nvim_lsp = "NLSP",
		buffer = "BUFF",
		path = "PATH",
	}

	-- Set the fixed width of the completion menu
	local fixed_width = 40

	-- Set the fixed completion window width.
	vim.o.pumwidth = fixed_width

	-- Set the menu "icon" to the shorthand for each completion source.
	-- item.menu = menu_icon[entry.source.name]
	if entry.source ~= nil then
		item.menu = menu_icon[entry.source.name]
	end

	-- Get the completion entry text shown in the completion window.
	local content = item.abbr

	-- Set the max content width, -10 to leave room for the 'kind' element
	-- like 'function', or 'field'
	local max_content_width = fixed_width - 10

	-- Truncate the completion entry text if it's longer than the
	-- max content width. We subtract 1 from the max content width
	-- to account for the '…' that will be appended to it.
	local ellipsis = "…"
	if #content > max_content_width then
		item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. ellipsis
	else
		item.abbr = content .. (" "):rep(max_content_width - #content)
	end
	return item
end

-- completions for nvim
return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
	enabled = ncUtil.enableForCategory("cmp"),
	init = function()
		-- set the amount of items that can appear in the completion menu
		vim.o.pumheight = 10
		-- default completion interfers with nvim-cmp
		vim.opt.completeopt = ""
		vim.opt.complete = ""
	end,
	opts = function()
		local cmp = require("cmp")
		return {
			-- disable completion in certain contexts
			enabled = function()
				local context = require("cmp.config.context")
				local disabled = false
				-- in a prompt
				-- disabled = disabled or (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')
				-- macros
				-- disabled = disabled or (vim.fn.reg_recording() ~= '')
				-- disabled = disabled or (vim.fn.reg_executing() ~= '')
				-- in comments
				disabled = disabled or context.in_syntax_group("Comment")
				return not disabled
			end,
			auto_brackets = {},
			preselect = cmp.PreselectMode.Item,
			disallow_fuzzy_matching = false,
			completion = {
				keyword_length = 1,
				completeopt = "menu,menuone,noinsert",
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			},
			mapping = {
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-f>"] = cmp.mapping.confirm({ select = true, behaviour = cmp.ConfirmBehavior.Insert }),
				-- ["<C-y>"] = cmp.mapping.complete(),
				["<Tab>"] = nil,
				["<S-Tab>"] = nil,
				["<C-g>"] = function()
					if cmp.visible_docs() then
						cmp.close_docs()
					else
						cmp.open_docs()
					end
				end,
			},
			view = {
				docs = {
					auto_open = true,
				},
			},
			window = {
				completion = {
					scrolloff = 3,
					-- border = "solid", { "", "" ,"", "", " ", " ", " ", "" }
					scrollbar = true,
					winhighlight = "Normal:CmpNormal,CursorLine:CmpSel,Search:SearchBar",
				},
				documentation = {
					max_height = 10,
					max_width = 40,
					scrollbar = false,
					-- border = "solid",
					border = { "", "", "", " ", " ", " ", " ", " " },
					winhighlight = "Normal:DocNormal,FloatBorder:DocNormal,Search:SearchBar",
				},
			},
			performance = {
				-- max_view_entries = 10, -- Changes the max amount in the list itself not the view
			},
			experimental = {
				ghost_text = false,
			},
			formatting = {
				fields = { "abbr", "menu", "kind" },
				format = format_entry,
			},
		}
	end,
	-- config = config
	-- keys = { },
}
