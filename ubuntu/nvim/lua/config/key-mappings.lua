-- Suggested Spec:
-- Mojo runner under <leader>rm
vim.keymap.set("n", "<leader>rm", function()
	local filepath = vim.fn.expand("%:p")
	if filepath:match("%.mojo$") then
		vim.cmd("write")
		vim.cmd("!mojo " .. filepath)
	else
		print("Not a Mojo file.")
	end
end, { desc = "Run Mojo file", noremap = true, silent = true })

-- Python runner under <leader>rp
vim.keymap.set("n", "<leader>rp", function()
	local filepath = vim.fn.expand("%:p")
	if filepath:match("%.py$") then
		vim.cmd("write")
		vim.cmd("!python3 " .. filepath)
	else
		print("Not a Python file.")
	end
end, { desc = "Run Python file", noremap = true, silent = true })

-- tired of gd only highlighting the instances
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })

-- debug mappings
vim.keymap.set("n", "<leader>dt", require("dap").toggle_breakpoint, { desc = "Toggle breakpoint", silent = true })
vim.keymap.set("n", "<leader>ds", require("dap").continue, { desc = "Attach session", silent = true })
vim.keymap.set("n", "<leader>de", require("dap").repl.open, { desc = "Evaluate expression", silent = true })
