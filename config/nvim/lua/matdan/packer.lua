-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- color scheme nord
	use({
		'shaunsingh/nord.nvim',
		as = 'nord',
		config = function()
			vim.cmd("colorscheme nord")
		end
	})

	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		--config = function()
			--vim.cmd('colorscheme rose-pine')
		--end
	})

	-- adding tree sitter for proper nested colors
	use('nvim-treesitter/nvim-treesitter', {run=':TSUpdate'})

	-- LSP
	
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
				'williamboman/mason.nvim',
				run = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		}
	}

end)
