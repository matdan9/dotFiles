require("matdan")

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = false

vim.opt.termguicolors = true
vim.opt.colorcolumn = "80"

-- change indent depending on file type
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.py",
	command = "set sta et fo=croql"
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.yml",
	command = "set sw=2 ts=2 sta et fo=croql"
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.html",
	command = "se sw=2 ts=2"
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.blade.php",
	command = "set sw=2 ts=2"
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = ".xml",
	command = "set sta et fo=croql sw=2 ts=2"
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.java",
	command = "set sta et fo=croql sw=4 ts=4"
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.ts",
	command = "set sta et fo=croql sw=2 ts=2"
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.pug",
	command = "set sta et fo=croql sw=2 ts=2"
})
