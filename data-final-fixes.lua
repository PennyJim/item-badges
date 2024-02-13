-- Generate letter icon Badges
-- ***************************
-- Prepare badges for Vanilla
require("vanilla")

-- Iterate over all vanilla items from above and build badges for each
if Ib_global.badge_vanilla then
  Process_badge_list(Badge_list)
end

-- require("icon-badges")