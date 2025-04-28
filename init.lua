-- package manager
require("config.lazy")

-- Language Server Setup
require("mason").setup()
require("mason-lspconfig").setup()

-- After setting up mason-lspconfig you may set up servers via lspconfig
-- require("lspconfig").lua_ls.setup {}
-- require("lspconfig").rust_analyzer.setup {}
require("lspconfig").pyright.setup {}


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
