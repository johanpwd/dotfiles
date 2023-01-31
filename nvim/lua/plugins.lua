local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[packadd packer.nvim]]

require("packer").init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	}
})

return require('packer').startup(function(use)
	use({ "wbthomason/packer.nvim" })
	use({
		"gruvbox-community/gruvbox",
		config = function()
			vim.cmd([[
				let g:gruvbox_colors = { 'bg0': ['#000000', 0]}
				colorscheme gruvbox
				highlight clear CursorLineNr
			]])
			vim.g.gruvbox_bold = 1
			vim.g.gruvbox_italic = 1
			vim.g.gruvbox_underline = 1
		end
	})
	use({
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-treesitter/playground" },
		run = ":TSUpdate",
	})
	use({ "mbbill/undotree" })
	use({ "nvim-lua/plenary.nvim" })
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "nvim-lualine/lualine.nvim" })
	use({ "numToStr/Comment.nvim" })

	if packer_bootstrap then
		require('packer').sync()
	end
end)
