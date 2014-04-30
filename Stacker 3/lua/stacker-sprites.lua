local M = {}

local getSheetOptions = function()
	local options = {
		frames = {
		
			{
				x = 132,
				y = 66,
				width = 64,
				height = 64
			},
		
			{
				x = 66,
				y = 66,
				width = 64,
				height = 64
			},
		
			{
				x = 132,
				y = 0,
				width = 64,
				height = 64
			},
		
			{
				x = 66,
				y = 0,
				width = 64,
				height = 64
			},
		
			{
				x = 0,
				y = 66,
				width = 64,
				height = 64
			},
		
			{
				x = 66,
				y = 132,
				width = 64,
				height = 64
			},
		
			{
				x = 0,
				y = 0,
				width = 64,
				height = 64
			},
		
			{
				x = 0,
				y = 132,
				width = 64,
				height = 64
			},
		
		},
		
		sheetContentWidth = 256,
		sheetContentHeight = 256
	}

	return options
end
M.getSheetOptions = getSheetOptions

return M