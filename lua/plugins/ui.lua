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
			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
				wk.register(opts.defaults)
			end
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
			{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
		},
		opts = {
			options = {
	      -- stylua: ignore
	      close_command = function(n) Snacks.bufdelete(n) end,
	      -- stylua: ignore
	      right_mouse_command = function(n) Snacks.bufdelete(n) end,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				diagnostics_indicator = function(_, _, diag)
					local icons = LazyVim.config.icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warn .. diag.warning or "")
					return vim.trim(ret)
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "snacks_layout_box",
					},
				},
				---@param opts bufferline.IconFetcherOpts
				get_element_icon = function(opts)
					return LazyVim.config.icons.ft[opts.filetype]
				end,
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},
	{
		"unblevable/quick-scope",
		lazy = false,
		init = function()
			vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			local uv = vim.loop
			local project_dir = vim.fn.expand("~/Documents/Workspace/")
			local max_projects = 5

			local function get_mtime(path)
				local stat = uv.fs_stat(path)
				return stat and stat.mtime.sec or 0
			end

			local projects = {}

			-- Scan all folders under project_dir
			for name, type in vim.fs.dir(project_dir) do
				if type == "directory" then
					local full_path = project_dir .. "/" .. name
					local mtime = get_mtime(full_path)
					table.insert(projects, { name = name, path = full_path, mtime = mtime })
				end
			end

			-- Sort by modified time, descending
			table.sort(projects, function(a, b)
				return a.mtime > b.mtime
			end)

			-- Keep only top 5
			local entries = {}
			for i = 1, math.min(max_projects, #projects) do
				local project = projects[i]
				table.insert(entries, {
					icon = "  ",
					desc = project.name,
					action = "cd " .. project.path .. " | Telescope find_files",
					key = tostring(i),
				})
			end

			-- static binding of config project
			config_proj = { name = ".config/nvim", path = "~/.config/nvim/" }
			table.insert(entries, {
				icon = "  ",
				desc = config_proj.name,
				action = "cd " .. config_proj.path .. " | Telescope find_files",
				key = "6",
			})

			-- Setup dashboard
			require("dashboard").setup({
				theme = "doom",
				config = {
					header = {
						"██╗ ██████╗    ██╗  ██╗ ██████╗    ███╗   ██╗██╗██╗  ██╗ █████╗ ",
						"██║██╔════╝    ╚██╗██╔╝██╔════╝    ████╗  ██║██║██║ ██╔╝██╔══██╗",
						"██║██║          ╚███╔╝ ██║         ██╔██╗ ██║██║█████╔╝ ███████║",
						"██║██║          ██╔██╗ ██║         ██║╚██╗██║██║██╔═██╗ ██╔══██║",
						"██║╚██████╗    ██╔╝ ██╗╚██████╗    ██║ ╚████║██║██║  ██╗██║  ██║",
						"╚═╝ ╚═════╝    ╚═╝  ╚═╝ ╚═════╝    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝",
						"                                                                ",
					},
					center = entries,
					footer = function()
						return {
							"☧ In Hoc Signo Vinces",
						}
					end,
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
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
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
}
