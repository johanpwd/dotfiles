local a = vim.api
local o = vim.opt

-- Strip trailing spaces when saving
local StripTrailingSpaceGroup = a.nvim_create_augroup("StripTrailingSpaceGroup", { clear = true })
a.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = StripTrailingSpaceGroup,
	command = "%s/\\s\\+$//e",
})

-- Show what is being yanked
local HighlightGroup = a.nvim_create_augroup("HighlightGroup", { clear = true })
a.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = HighlightGroup,
	callback = function()
		require("vim.highlight").on_yank()
	end,
})

-- Remember cursor position when opening neovim again
local RememberGroup = a.nvim_create_augroup("RememberGroup", { clear = true })
a.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = RememberGroup,
	callback = function()
		local config = {
			ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
			ignore_buftype = { "quickfix", "nofile", "help" },
			open_folds = true,
		}

		-- Return if we have a buffer or filetype we want to ignore
		for _, k in pairs(config["ignore_filetype"]) do
			if vim.bo.buftype == k then
				return
			end
		end

		for _, k in pairs(config["ignore_buftype"]) do
			if vim.bo.buftype == k then
				return
			end
		end

		-- Return if the file doesn't exist, like a new and unsaved file
		if vim.fn.empty(vim.fn.glob(vim.fn.expand("%"))) ~= 0 then
			return
		end

		local cursor_position = a.nvim_buf_get_mark(0, '"')
		local row = cursor_position[1]

		-- If the saved row is less than the number of rows in the buffer, continue
		if row > 0 and row <= a.nvim_buf_line_count(0) then
			-- If the last row is visible within this window - like in a very short file - just
			-- set the cursor position to the saved position
			if a.nvim_buf_line_count(0) == vim.fn.line("w$") then
				a.nvim_win_set_cursor(0, cursor_position)
			elseif a.nvim_buf_line_count(0) - row > ((vim.fn.line("w$") - vim.fn.line("w0")) / 2) - 1 then
				a.nvim_win_set_cursor(0, cursor_position)
				a.nvim_input("zz")

				-- If we're at the end of the screen, set the cursor position and move the window
				-- up by one with C-e. This is to show that we are at the end of the file. If we
				-- did "zz" half the screen would be blank.
			else
				a.nvim_win_set_cursor(0, cursor_position)
				a.nvim_input("<c-e>")
			end
		end

		-- If the row is within a fold then make the row visible and recenter the screen
		if a.nvim_eval("foldclosed('.')") ~= -1 and config["open_folds"] then
			a.nvim_input("zvzz")
		end
	end,
})
