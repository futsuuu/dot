local f = math.floor

local function get_pos(width_per, height_per)
  local o = vim.o
  local e_height = o.lines
  local e_width = o.columns
  local width = e_width * width_per / 100
  local height = e_height * height_per / 100
  local left = (e_width - width) / 2
  local top = (e_height - height) / 2
  return f(left), f(top), f(width), f(height)
end

local layouts = {
  ---@param width_per number
  ---@param height_per number
  ---@param preview boolean
  ---@return table
  ff = function(width_per, height_per, preview)
    local left, top, width, height = get_pos(width_per, height_per)
    local previewWidth = f(width / 2)
    local p = {
      previewFloatingBorder = { '', '', '', '', '', '', '', '▕' },
      previewCol = left + width - previewWidth,
      previewRow = top + 1,
      previewWidth = previewWidth,
      previewHeight = height,
    }
    local w = {
      winCol = left,
      winRow = top,
      winWidth = width,
      winHeight = height,
    }
    local r
    if preview then
      r = vim.tbl_extend('error', w, p)
    else
      r = w
    end
    return {
      ui = 'ff',
      uiParams = { ff = r },
    }
  end,
}

return layouts
