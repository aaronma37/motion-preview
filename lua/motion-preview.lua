-- main module file
local module = require("motion-preview.module")

local movement_keys = {
  ["w"] = "w",
  ["W"] = "W", 
  ["b"] = "b", 
  ["B"] = "B",
  ["e"] = "e", 
  ["E"] = "E",
  ["<c-u>"] = "<Bslash><lt>C-u>",
  ["<c-d>"] = "<Bslash><lt>C-u>",
  ["]"] = "<Bslash><lt>C-u>",
  ["["] = "<Bslash><lt>C-u>",
}

local highlight_forward_key_ns = vim.api.nvim_create_namespace("highlight_forward_key")
vim.api.nvim_set_hl_ns(highlight_forward_key_ns)
vim.api.nvim_set_hl(highlight_forward_key_ns, 'HighlightForwardKeys1', { bold=true , fg = "#00ffff", underline=true})


local function highlightForwardKeys(movement_key)
  local my_ns= highlight_forward_key_ns 
  if vim.api.nvim_win_get_cursor(0) == nil then return end
  vim.api.nvim_buf_clear_namespace(0, my_ns, 0,-1)
  local og_r,og_c = unpack(vim.api.nvim_win_get_cursor(0))

  vim.cmd(vim.api.nvim_replace_termcodes('normal! ' .. movement_key,true,true,true))
  local r,c = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_add_highlight(0,my_ns,"HighlightForwardKeys1", r - 1 ,c,c+1)

  vim.api.nvim_win_set_cursor(0,{og_r,og_c})

end



local M = {}

M.setup = function(args)
vim.on_key(function(_key) 
  if movement_keys[_key] == nil then 
    vim.api.nvim_buf_clear_namespace(0, highlight_forward_key_ns, 0,-1) 
  end
end, 1, {})
for _k,_v in pairs(movement_keys) do
  vim.keymap.set('n', _k, function()  vim.cmd(vim.api.nvim_replace_termcodes('normal! ' .. _k,true,true,true)) highlightForwardKeys(_k) end, {noremap = true})
  vim.keymap.set('v', _k, function() vim.cmd(vim.api.nvim_replace_termcodes('normal! ' .. _k,true,true,true)) highlightForwardKeys(_k) end, {noremap = true})
end
end
return M
