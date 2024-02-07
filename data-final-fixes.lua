-- Generate letter icon Badges
-- ***************************
-- Prepare badges for Vanilla
require("vanilla")

-- Iterate over all vanilla items from above and build badges for each
if Ib_global.badge_vanilla then
  for subListName, subList in pairs(Badge_list) do
    for itemName, ib_data in pairs(subList) do
      if data.raw[subListName][itemName] then
        Build_badge(data.raw[subListName][itemName], ib_data)
      end
    end
  end
end