return {
	{ "projekt0n/github-nvim-theme", name = "github-theme" },
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
	{
		"catppuccin/nvim",
		flavour = "mocha", -- latte, frappe, macchiato, mocha
		lazy = true,
		name = "catppuccin",
		opts = {
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				fzf = true,
				grug_far = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				snacks = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		},
	},
	{
		"shortcuts/no-neck-pain.nvim",
		event = "VeryLazy",
		opts = {
			width = 120,
			autostart = false,
			autocmds = {
				enableOnVimEnter = "safe", -- Enable after dashboard or tree closes
				enableOnTabEnter = false,
				reloadOnColorSchemeChange = false,
				skipEnteringNoNeckPainBuffer = false,
			},
			integrations = {
				dashboard = {
					enabled = true, -- automatically debounce when dashboard is open
					filetypes = nil, -- fallback handled internally
				},
			},
		},
	},
	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup({
				themes = { "catppuccin-mocha", "github_dark_dimmed", "elflord", "moonfly" },
				livePreview = true,
			})
		end,
	},
}
