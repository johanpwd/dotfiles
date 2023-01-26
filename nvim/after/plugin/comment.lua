require("Comment").setup({
  ---Add a space b/w comment and the line
  padding = true, -- Add a space b/w comment and the line
  sticky = true, -- Whether the cursor should stay at its position

  toggler = {
    line = "gcc", -- Line-comment toggle keymap
    block = "gbc", -- Block-comment toggle keymap
  },

  opleader = {
    line = "gc", -- Line-comment keymap
    block = "gb", -- Block-comment keymap
  },

  extra = {
    above = "gcO", -- Add comment on the line above
    below = "gco", -- Add comment on the line below
    eol = "gcA", -- Add comment at the end of line
  },

  mappings = {
    ---Operator-pending mapping
    ---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
    ---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
    basic = true,
    ---Extra mapping
    ---Includes `gco`, `gcO`, `gcA`
    extra = true,
    ---Extended mapping
    ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
    extended = false,
  },
})
