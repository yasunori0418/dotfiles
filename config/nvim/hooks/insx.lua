-- lua_source {{{
local insx = require("insx")
local esc = require("insx").helper.regex.esc
local recipe = require("insx.recipe")

for open, close in pairs({
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
}) do
  insx.add(
    "<CR>",
    recipe.fast_break(
      {
        open_pat = esc(open),
        close_pat = esc(close),
        arguments = true,
        html_attrs = true,
      }
    )
  )
end

-- }}}
