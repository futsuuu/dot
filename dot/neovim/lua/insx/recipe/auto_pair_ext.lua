local insx = require('insx')

local function auto_pair(option)
  return {
    action = function(ctx)
      ctx.send(option.open .. option.close .. ('<Left>'):rep(option.close:len()))
    end,
  }
end

return setmetatable({
  strings = function(option)
    local overrides = { insx.with.nomatch([[\\\%#]]) }
    if option.open == [[']] then
      table.insert(overrides, insx.with.nomatch([[\a\%#]]))
    end
    return insx.with(auto_pair(option), overrides)
  end,
}, {
  __call = function(_, option)
    return auto_pair(option)
  end,
})
