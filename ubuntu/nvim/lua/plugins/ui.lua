return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = "echasnovski/mini.icons",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			defaults = {},
			spec = {
				{
					mode = { "n", "v" },
					{ "<leader><tab>", group = "tabs" },
					{ "<leader>c", group = "code" },
					{ "<leader>d", group = "debug" },
					{ "<leader>dp", group = "profiler" },
					{ "<leader>f", group = "file/find" },
					{ "<leader>g", group = "git" },
					{ "<leader>gh", group = "hunks" },
					{ "<leader>q", group = "quit/session" },
					{ "<leader>s", group = "search" },
					{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
					{ "<leader>r", group = "run", icon = { icon = " ", color = "green" } },
					{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "gs", group = "surround" },
					{ "z", group = "fold" },
					{
						"<leader>b",
						group = "buffer",
						expand = function()
							return require("which-key.extras").expand.buf()
						end,
					},
					{
						"<leader>w",
						group = "windows",
						proxy = "<c-w>",
						expand = function()
							return require("which-key.extras").expand.win()
						end,
					},
					-- better descriptions
					{ "gx", desc = "Open with system app" },
				},
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)

			vim.schedule(function()
				vim.api.nvim_exec("doautocmd UIEnter WhichKeyLoaded", false)
			end)

			vim.api.nvim_create_autocmd("UIEnter", {
				pattern = "WhichKeyLoaded",
				callback = function()
					vim.cmd("hi WhichKeyNormal ctermbg=none guibg=none")
					vim.cmd("hi WhichKeyBorder ctermbg=none guibg=none")
					vim.cmd("hi WhichKeyTitle ctermbg=none guibg=none")
					vim.cmd("hi WhichKeyFloat ctermbg=none guibg=none")
					vim.cmd("hi WhichKeyGroup ctermbg=none guibg=none")
					vim.cmd("hi WhichKeySeperator ctermbg=none guibg=none")
					vim.cmd("hi WhichKeySeparator ctermbg=none guibg=none")
					vim.cmd("hi WhichKeyValue ctermbg=none guibg=none")
					vim.cmd("hi WhichKeyDesc ctermbg=none guibg=none")
				end,
			})

			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
				wk.register(opts.defaults)
			end
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>cg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	{
		"mgierada/lazydocker.nvim",
		dependencies = { "akinsho/toggleterm.nvim" },
		config = function()
			require("lazydocker").setup({
				border = "curved", -- valid options are "single" | "double" | "shadow" | "curved"
			})
		end,
		event = "BufRead",
		keys = {
			{
				"<leader>cd",
				function()
					require("lazydocker").open()
				end,
				desc = "LazyDocker",
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{
				"<leader>xl",
				function()
					require("noice").cmd("last")
				end,
				desc = "Noice Last Message",
			},
			{
				"<leader>xm",
				function()
					require("noice").cmd("all")
				end,
				desc = "Noice All Messages",
			},
		},
	},
}
