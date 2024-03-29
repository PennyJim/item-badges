-- Generate letter icon Badges
-- ***************************
-- Prepare badges for Vanilla
require("vanilla")
Ib_global.Badge_list = Badge_list

-- Iterate over all vanilla items from above and build badges for each
if Ib_global.badge_vanilla then
  if not mods["galdocs-manufacturing"] or (mods["galdocs-manufacturing"] and Ib_global.activation) then
    Process_badge_list(Ib_global.Badge_list)
  end
end

-- require("icon-badges")