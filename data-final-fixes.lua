-- Generate letter icon Badges
-- ***************************
-- Prepare badges for Vanilla
require("vanilla")

-- Iterate over all vanilla items from above and build badges for each
if Ib_global.badge_vanilla and Ib_global.activation then
  Process_badge_list(Badge_list)
end

-- require("icon-badges")