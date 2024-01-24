-- Helper Function
-- ***************
function Process_badges(currentBadgeList)
  for subListName, subList in pairs(currentBadgeList) do
    for itemName, itemBadge in pairs(subList) do
      if data.raw[subListName][itemName] and not data.raw[subListName][itemName].ib_badge then
        -- Letter Badge properties
        data.raw[subListName][itemName].ib_let_badge  = itemBadge.let_badge
        data.raw[subListName][itemName].ib_let_invert = itemBadge.let_invert
        data.raw[subListName][itemName].ib_let_corner = itemBadge.let_corner

        -- Image Badge properties
        data.raw[subListName][itemName].ib_img_paths  = itemBadge.img_paths
        data.raw[subListName][itemName].ib_img_corner = itemBadge.img_corner
        data.raw[subListName][itemName].ib_img_size   = itemBadge.img_size
        data.raw[subListName][itemName].ib_img_scale  = itemBadge.img_scale
        data.raw[subListName][itemName].ib_img_mips   = itemBadge.img_mips
        data.raw[subListName][itemName].ib_img_space  = itemBadge.img_space
      end
    end
  end
end



-- Vanilla badges
-- **************
local badgeList = {}

-- Items
badgeList["item"] = {
  -- Plates
  ["iron-plate"]                      = {let_badge = "Fe", },
  ["copper-plate"]                    = {let_badge = "Cu", },

  -- Ores
  ["iron-ore"]                        = {let_badge = "Fe", },
  ["copper-ore"]                      = {let_badge = "Cu", },
  ["uranium-ore"]                     = {let_badge = "U",  },
  ["coal"]                            = {let_badge = "C",  },
  ["stone"]                           = {let_badge = "S",  },

  -- Belts
  ["transport-belt"]                  = {let_badge = "Y",  },
  ["fast-transport-belt"]             = {let_badge = "R",  },
  ["express-transport-belt"]          = {let_badge = "B",  },
  ["underground-belt"]                = {let_badge = "Y",  },
  ["fast-underground-belt"]           = {let_badge = "R",  },
  ["express-underground-belt"]        = {let_badge = "B",  },
  ["splitter"]                        = {let_badge = "Y",  },
  ["fast-splitter"]                   = {let_badge = "R",  },
  ["express-splitter"]                = {let_badge = "B",  },

  -- Circuits
  ["electronic-circuit"]              = {let_badge = "G",  },
  ["advanced-circuit"]                = {let_badge = "R",  },
  ["processing-unit"]                 = {let_badge = "B",  },

  -- Wire
  ["red-wire"]                        = {let_badge = "R",  },
  ["green-wire"]                      = {let_badge = "G",  },
  ["copper-cable"]                    = {let_badge = "Cu", },
  
  -- Chests
  ["logistic-chest-active-provider"]  = {let_badge = "A",  },
  ["logistic-chest-passive-provider"] = {let_badge = "P",  },
  ["logistic-chest-storage"]          = {let_badge = "S",  },
  ["logistic-chest-buffer"]           = {let_badge = "B",  },
  ["logistic-chest-requester"]        = {let_badge = "R",  },

  -- Barrels
  ["crude-oil-barrel"]                = {let_badge = "C",  },
  ["water-barrel"]                    = {let_badge = "W",  },
  ["light-oil-barrel"]                = {let_badge = "L",  },
  ["heavy-oil-barrel"]                = {let_badge = "H",  },
  ["lubricant-barrel"]                = {let_badge = "Lu"  },
  ["petroleum-gas-barrel"]            = {let_badge = "P",  },
  ["sulfuric-acid-barrel"]            = {let_badge = "SA", },

  -- Fuel
  ["nuclear-fuel"]                    = {let_badge = "NF", },
  ["rocket-fuel"]                     = {let_badge = "RF", },

  -- Inserter
  ["burner-inserter"]                 = {let_badge = "B",  },
  ["inserter"]                        = {let_badge = "I",  },
  ["fast-inserter"]                   = {let_badge = "Fa", },
  ["long-handed-inserter"]            = {let_badge = "LH", },
  ["filter-inserter"]                 = {let_badge = "Fi", },
  ["stack-inserter"]                  = {let_badge = "S",  },
  ["stack-filter-inserter"]           = {let_badge = "SF", },

  -- Equipment
  ["energy-shield-equipment"]         = {let_badge = "1",  },
  ["energy-shield-mk2-equipment"]     = {let_badge = "2",  },
  ["personal-roboport-equipment"]     = {let_badge = "1",  },
  ["personal-roboport-mk2-equipment"] = {let_badge = "2",  },

  -- Misc
  ["explosives"]                      = {let_badge = "E",  },
  
  -- Test
  -- ["plastic-bar"] = {badge = "Pl"},
  -- ["steel-plate"] = {badge = "SP"},
  ["sulfur"]      = {let_badge = "Sus", let_corner = "left-top", img_paths = {"__galdocs-manufacturing__/graphics/badges/heavy-load-bearing.png", "__galdocs-manufacturing__/graphics/badges/high-tensile.png"}, img_size = 64, img_scale = 0.2, img_space = 10, img_corner = "left-top"},
}

badgeList["tool"] = {
  -- Science Packs
  ["automation-science-pack"]         = {let_badge = "A",  },
  ["logistic-science-pack"]           = {let_badge = "L",  },
  ["military-science-pack"]           = {let_badge = "M",  },
  ["chemical-science-pack"]           = {let_badge = "C",  },
  ["production-science-pack"]         = {let_badge = "P",  },
  ["utility-science-pack"]            = {let_badge = "U",  },
  ["space-science-pack"]              = {let_badge = "S",  },
}

badgeList["module"] = {
  -- Effectivity
  ["effectivity-module"]              = {let_badge = "E",  },
  ["effectivity-module-2"]            = {let_badge = "E",  },
  ["effectivity-module-3"]            = {let_badge = "E",  },
  
  -- Productivity
  ["productivity-module"]             = {let_badge = "P",  },
  ["productivity-module-2"]           = {let_badge = "P",  },
  ["productivity-module-3"]           = {let_badge = "P",  },

  -- Speed
  ["speed-module"]                    = {let_badge = "S",  },
  ["speed-module-2"]                  = {let_badge = "S",  },
  ["speed-module-3"]                  = {let_badge = "S",  },
}

badgeList["ammo"] = {
  -- Magazines
  ["firearm-magazine"]                = {let_badge = "NR", },
  ["piercing-rounds-magazine"]        = {let_badge = "PR", },
  ["uranium-rounds-magazine"]         = {let_badge = "UR", },

  -- Shotgun Shells
  ["shotgun-shell"]                   = {let_badge = "SS", },
  ["piercing-shotgun-shell"]          = {let_badge = "PS", },

  -- Rockets
  ["rocket"]                          = {let_badge = "R",  },
  ["explosive-rocket"]                = {let_badge = "ER", },
  ["atomic-bomb"]                     = {let_badge = "AB", },

  -- Cannon Shells
  ["cannon-shell"]                    = {let_badge = "CS", },
  ["explosive-cannon-shell"]          = {let_badge = "ES", },
  ["uranium-cannon-shell"]            = {let_badge = "US", },
  ["explosive-uranium-cannon-shell"]  = {let_badge = "UE", },
}

badgeList["capsule"] = {
  -- Grenades
  ["grenade"]                         = {let_badge = "G",  },
  ["cluster-grenade"]                 = {let_badge = "CG", },

  -- Capsules
  ["poison-capsule"]                  = {let_badge = "PC", },
  ["slowdown-capsule"]                = {let_badge = "SC", },

  -- Specialty
  ["cliff-explosives"]                = {let_badge = "CE", },
}

badgeList["blueprint"] = {
  ["blueprint"]                       = {let_badge = "B", },
}

badgeList["upgrade-item"] = {
  ["upgrade-planner"]                 = {let_badge = "U",  },
}

badgeList["deconstruction-item"] = {
  ["deconstruction-planner"]          = {let_badge = "D",  },
}

badgeList["fluid"] = {
  ["crude-oil"]                       = {let_badge = "C",  },
  ["water"]                           = {let_badge = "W",  },
  ["light-oil"]                       = {let_badge = "L",  },
  ["heavy-oil"]                       = {let_badge = "H",  },
  ["lubricant"]                       = {let_badge = "Lu"  },
  ["petroleum-gas"]                   = {let_badge = "P",  },
  ["sulfuric-acid"]                   = {let_badge = "SA", },
}

-- Recipes
badgeList["recipe"] = {
  -- Fill Barrels
  ["fill-crude-oil-barrel"]           = {let_badge = "C",  let_corner = "left-bottom"},
  ["fill-water-barrel"]               = {let_badge = "W",  let_corner = "left-bottom"},
  ["fill-light-oil-barrel"]           = {let_badge = "L",  let_corner = "left-bottom"},
  ["fill-heavy-oil-barrel"]           = {let_badge = "H",  let_corner = "left-bottom"},
  ["fill-lubricant-barrel"]           = {let_badge = "Lu", let_corner = "left-bottom"},
  ["fill-petroleum-gas-barrel"]       = {let_badge = "P",  let_corner = "left-bottom"},
  ["fill-sulfuric-acid-barrel"]       = {let_badge = "SA", let_corner = "left-bottom"},

  -- Empty Barrels
  ["empty-crude-oil-barrel"]          = {let_badge = "C",  let_corner = "left-bottom"},
  ["empty-water-barrel"]              = {let_badge = "W",  let_corner = "left-bottom"},
  ["empty-light-oil-barrel"]          = {let_badge = "L",  let_corner = "left-bottom"},
  ["empty-heavy-oil-barrel"]          = {let_badge = "H",  let_corner = "left-bottom"},
  ["empty-lubricant-barrel"]          = {let_badge = "Lu", let_corner = "left-bottom"},
  ["empty-petroleum-gas-barrel"]      = {let_badge = "P",  let_corner = "left-bottom"},
  ["empty-sulfuric-acid-barrel"]      = {let_badge = "SA", let_corner = "left-bottom"},

  -- Solid Fuel
  ["solid-fuel-from-light-oil"]       = {let_badge = "L",  let_corner = "left-bottom"},
  ["solid-fuel-from-heavy-oil"]       = {let_badge = "H",  let_corner = "left-bottom"},
  ["solid-fuel-from-petroleum-gas"]   = {let_badge = "P",  let_corner = "left-bottom"},

  -- Misc
  ["nuclear-fuel"]                    = {let_badge = "NF", },
}



-- Actually Do Stuff
-- *****************
Process_badges(badgeList)



-- debug stuff
-- ***********

-- Make and badge an item with a sprite-sheet for testing purposes
--[[
local item = {
  type = "item",
  name = "globulent",
  stack_size = 1000,
  icon = "__icon-badges__/graphics/globulent.png",
  icon_size = 64,
  pictures = {
    sheet = {
      filename = "__icon-badges__/graphics/globulent.png",
      height = 64,
      width = 64,
      variation_count = 4,
      scale = 0.25
    }
  }
}
data:extend({item})
data.raw.item["globulent"].ib_let_badge = "Hi"
--]]

--[[
-- This stuff is just for the supplementary images on the mod page
-- Adds the badge "St" to all Stone items
data.raw.item["stone"].ib_let_badge = "St"

-- Adds the badge "Co", with inverted text shades, to all Coal items
data.raw.item["coal"].ib_let_badge = "Co"
data.raw.item["coal"].ib_let_invert = "whatever"

-- Adds the badge "Fe" to the iron plate recipe in the left-bottom corner
data.raw.recipe["nuclear-fuel"].ib_let_badge = "NF"
data.raw.recipe["nuclear-fuel"].ib_let_corner = "left-bottom"
--]]