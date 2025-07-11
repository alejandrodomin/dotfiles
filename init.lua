-- package manager
require("config.lazy")

-- requrie custom configs
require("config.key-mappings")

-- require neovide configs if it exists
if vim.g.neovide then
	require("config.neovide")
end

-- Language Server Setup
require("mason").setup()
require("mason-lspconfig").setup({
	automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗",
		},
	},
})
require("trouble").setup()
-- inlay hints
vim.diagnostic.config({ virtual_text = true })

-- After setting up mason-lspconfig you may set up servers via lspconfig
-- require("lspconfig").lua_ls.setup {}
-- require("lspconfig").rust_analyzer.setup {}
require("lspconfig").pyright.setup({})
-- Load the LSP.
require("lspconfig").mojo.setup({})

-- Syntax
require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4 -- Number of spaces a <Tab> feels like when editing
vim.opt.shiftwidth = 4 -- Number of spaces used for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of actual tab characters
vim.opt.smartindent = true -- Auto-indent new lines

-- Theme
if vim.env.DISPLAY == nil or vim.env.DISPLAY == "" then
	vim.cmd.colorscheme("elflord")
else
	vim.cmd.colorscheme("catppuccin")
end

vim.opt.number = true
vim.opt.relativenumber = true

require("no-neck-pain").setup({
	width = 120,
	autocmds = { enableOnVimEnter = true },
})

-- File search
require("telescope").setup()
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope live grep" })

-- Fill out terminal
-- source: https://github.com/neovim/neovim/issues/16572
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
	callback = function()
		local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
		if normal.bg then
			io.write(string.format("\027]11;#%06x\027\\", normal.bg))
		end
	end,
})

vim.api.nvim_create_autocmd("UILeave", {
	callback = function()
		io.write("\027]111\027\\")
	end,
})

-- UI tabs for the buffers
vim.opt.termguicolors = true
require("bufferline").setup({
	options = {
		numbers = function(opts)
			return string.format("%s|%s", opts.id, opts.raise(opts.ordinal))
		end,
	},
})

-- Quality of Life QoL
require("mini.pairs").setup()

require("conform").setup({
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})
