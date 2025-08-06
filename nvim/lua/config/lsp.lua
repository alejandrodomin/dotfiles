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
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").pyright.setup({})
-- Load the LSP.
local shell = vim.fn.getenv("SHELL"):match("bash") and "bash" or "zsh"

require("lspconfig").mojo.setup({
	cmd = { shell, "-c", "pixi run mojo-lsp-server" },
})
