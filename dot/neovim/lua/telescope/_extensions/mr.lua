local telescope = require 'telescope'
local pickers = require 'telescope.pickers'
local make_entry = require 'telescope.make_entry'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local fn = require('rc.utils').fn

---@param kind string
local function mr(opts, kind)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'MR' .. kind:upper(),
      finder = finders.new_table {
        results = fn.mr['mr' .. kind].list(),
        entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
      },
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
    })
    :find()
end

return telescope.register_extension {
  setup = function(_, _) end,
  exports = {
    mru = function(opts)
      mr(opts, 'u')
    end,
    mrr = function(opts)
      mr(opts, 'r')
    end,
    mrw = function(opts)
      mr(opts, 'w')
    end,
  },
}
