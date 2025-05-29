-- package manager
require("config.lazy")

-- Language Server Setup
require("mason").setup()
require("mason-lspconfig").setup()
require("trouble").setup()
-- inlay hints
vim.diagnostic.config { virtual_text = true }

-- After setting up mason-lspconfig you may set up servers via lspconfig
-- require("lspconfig").lua_ls.setup {}
-- require("lspconfig").rust_analyzer.setup {}
require("lspconfig").pyright.setup {}

-- Syntax
require'nvim-treesitter.configs'.setup {
	auto_install = true,
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
	    	-- Using this option may slow down your editor, and you may see some duplicate highlights.
	    	-- Instead of true it can also be a list of languages
	    	additional_vim_regex_highlighting = false,
  	},
}

-- Theme
vim.cmd.colorscheme "koehler"
vim.opt.number = true
vim.opt.relativenumber = true

-- File search
require('telescope').setup()
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })

-- Fill out terminal
-- source: https://github.com/neovim/neovim/issues/16572
vim.api.nvim_create_autocmd({'UIEnter', 'ColorScheme'}, {
    callback = function()
        local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
        if normal.bg then
            io.write(string.format('\027]11;#%06x\027\\', normal.bg))
        end
    end,
})

vim.api.nvim_create_autocmd('UILeave', {
    callback = function()
        io.write('\027]111\027\\')
    end,
})
