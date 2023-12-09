-- Helper Function
function Process_badges(currentBadgeList)
  for subListName, subList in pairs(currentBadgeList) do
    for itemName, itemBadge in pairs(subList) do
      if data.raw[subListName][itemName] then
        data.raw[subListName][itemName].ib_badge = itemBadge.badge
        data.raw[subListName][itemName].ib_invert = itemBadge.invert
        data.raw[subListName][itemName].ib_corner = itemBadge.corner
      end
    end
  end
end

local badgeList = {}
badgeList["item"] = {
  -- Plates
  ["iron-plate"]                      = {badge = "Fe", },
  ["copper-plate"]                    = {badge = "Cu", },

  -- Ores
  ["iron-ore"]                        = {badge = "Fe", },
  ["copper-ore"]                      = {badge = "Cu", },
  ["uranium-ore"]                     = {badge = "U",  },
  ["coal"]                            = {badge = "C",  },
  ["stone"]                           = {badge = "S",  },

  -- Belts
  ["transport-belt"]                  = {badge = "Y",  },
  ["fast-transport-belt"]             = {badge = "R",  },
  ["express-transport-belt"]          = {badge = "B",  },
  ["underground-belt"]                = {badge = "Y",  },
  ["fast-underground-belt"]           = {badge = "R",  },
  ["express-underground-belt"]        = {badge = "B",  },
  ["splitter"]                        = {badge = "Y",  },
  ["fast-splitter"]                   = {badge = "R",  },
  ["express-splitter"]                = {badge = "B",  },

  -- Circuits
  ["electronic-circuit"]              = {badge = "G",  },
  ["advanced-circuit"]                = {badge = "R",  },
  ["processing-unit"]                 = {badge = "B",  },

  -- Wire
  ["red-wire"]                        = {badge = "R",  },
  ["green-wire"]                      = {badge = "G",  },
  ["copper-cable"]                    = {badge = "Cu", },
  
  -- Chests
  ["logistic-chest-active-provider"]  = {badge = "A",  },
  ["logistic-chest-passive-provider"] = {badge = "P",  },
  ["logistic-chest-storage"]          = {badge = "S",  },
  ["logistic-chest-buffer"]           = {badge = "B",  },
  ["logistic-chest-requester"]        = {badge = "R",  },

  -- Barrels
  ["crude-oil-barrel"]                = {badge = "C",  },
  ["water-barrel"]                    = {badge = "W",  },
  ["light-oil-barrel"]                = {badge = "L",  },
  ["heavy-oil-barrel"]                = {badge = "H",  },
  ["lubricant-barrel"]                = {badge = "Lu"  },
  ["petroleum-gas-barrel"]            = {badge = "P",  },
  ["sulfuric-acid-barrel"]            = {badge = "SA", },

  -- Fuel
  ["nuclear-fuel"]                    = {badge = "NF", },
  ["rocket-fuel"]                     = {badge = "RF", },

  -- Inserter
  ["burner-inserter"]                 = {badge = "B",  },
  ["inserter"]                        = {badge = "I",  },
  ["fast-inserter"]                   = {badge = "Fa", },
  ["long-handed-inserter"]            = {badge = "LH", },
  ["filter-inserter"]                 = {badge = "Fi", },
  ["stack-inserter"]                  = {badge = "S",  },
  ["stack-filter-inserter"]           = {badge = "SF", },

  -- Equipment
  ["energy-shield-equipment"]         = {badge = "1",  },
  ["energy-shield-mk2-equipment"]     = {badge = "2",  },
  ["personal-roboport-equipment"]     = {badge = "1",  },
  ["personal-roboport-mk2-equipment"] = {badge = "2",  },

  -- Misc
  ["explosives"]                      = {badge = "E",  }
}

badgeList["tool"] = {
  -- Science Packs
  ["automation-science-pack"]         = {badge = "A",  },
  ["logistic-science-pack"]           = {badge = "L",  },
  ["military-science-pack"]           = {badge = "M",  },
  ["chemical-science-pack"]           = {badge = "C",  },
  ["production-science-pack"]         = {badge = "P",  },
  ["utility-science-pack"]            = {badge = "U",  },
  ["space-science-pack"]              = {badge = "S",  },
}

badgeList["module"] = {
  -- Effectivity
  ["effectivity-module"]              = {badge = "E",  },
  ["effectivity-module-2"]            = {badge = "E",  },
  ["effectivity-module-3"]            = {badge = "E",  },
  
  -- Productivity
  ["productivity-module"]             = {badge = "P",  },
  ["productivity-module-2"]           = {badge = "P",  },
  ["productivity-module-3"]           = {badge = "P",  },

  -- Speed
  ["speed-module"]                    = {badge = "S",  },
  ["speed-module-2"]                  = {badge = "S",  },
  ["speed-module-3"]                  = {badge = "S",  },
}

badgeList["ammo"] = {
  -- Magazines
  ["firearm-magazine"]                = {badge = "NR", },
  ["piercing-rounds-magazine"]        = {badge = "PR", },
  ["uranium-rounds-magazine"]         = {badge = "UR", },

  -- Shotgun Shells
  ["shotgun-shell"]                   = {badge = "SS", },
  ["piercing-shotgun-shell"]          = {badge = "PS", },

  -- Rockets
  ["rocket"]                          = {badge = "R",  },
  ["explosive-rocket"]                = {badge = "ER", },
  ["atomic-bomb"]                     = {badge = "AB", },

  -- Cannon Shells
  ["cannon-shell"]                    = {badge = "CS", },
  ["explosive-cannon-shell"]          = {badge = "ES", },
  ["uranium-cannon-shell"]            = {badge = "US", },
  ["explosive-uranium-cannon-shell"]  = {badge = "UE", },
}

badgeList["capsule"] = {
  -- Grenades
  ["grenade"]                         = {badge = "G",  },
  ["cluster-grenade"]                 = {badge = "CG", },

  -- Capsules
  ["poison-capsule"]                  = {badge = "PC", },
  ["slowdown-capsule"]                = {badge = "SC", },

  -- Specialty
  ["cliff-explosives"]                = {badge = "CE", },
}

badgeList["blueprint"] = {
  ["blueprint"]                       = {badge = "B", },
}

badgeList["upgrade-item"] = {
  ["upgrade-planner"]                 = {badge = "U",  },
}

badgeList["deconstruction-item"] = {
  ["deconstruction-planner"]          = {badge = "D",  },
}

local testCorner = "left-bottom"

badgeList["recipe"] = {
  -- Fill Barrels
  ["fill-crude-oil-barrel"]                 = {badge = "C",  corner = testCorner},
  ["fill-water-barrel"]                     = {badge = "W",  corner = testCorner},
  ["fill-light-oil-barrel"]                 = {badge = "L",  corner = testCorner},
  ["fill-heavy-oil-barrel"]                 = {badge = "H",  corner = testCorner},
  ["fill-lubricant-barrel"]                 = {badge = "Lu", corner = testCorner},
  ["fill-petroleum-gas-barrel"]             = {badge = "P",  corner = testCorner},
  ["fill-sulfuric-acid-barrel"]             = {badge = "SA", corner = testCorner},

  -- Empty Barrels
  ["empty-crude-oil-barrel"]                = {badge = "C",  corner = testCorner},
  ["empty-water-barrel"]                    = {badge = "W",  corner = testCorner},
  ["empty-light-oil-barrel"]                = {badge = "L",  corner = testCorner},
  ["empty-heavy-oil-barrel"]                = {badge = "H",  corner = testCorner},
  ["empty-lubricant-barrel"]                = {badge = "Lu", corner = testCorner},
  ["empty-petroleum-gas-barrel"]            = {badge = "P",  corner = testCorner},
  ["empty-sulfuric-acid-barrel"]            = {badge = "SA", corner = testCorner},

  -- Solid Fuel
  ["solid-fuel-from-light-oil"]             = {badge = "L",  corner = testCorner},
  ["solid-fuel-from-heavy-oil"]             = {badge = "H",  corner = testCorner},
  ["solid-fuel-from-petroleum-gas"]         = {badge = "P",  corner = testCorner},

  -- Misc
  ["nuclear-fuel"]                          = {badge = "NF", },
}

Process_badges(badgeList)

--[[
  
-- This stuff is just for the supplementary images on the mod page

-- IGNORE YELLOW SQUIGGLIES; that's just FMTK and VS Code. It works.

-- Adds the badge "St" to all Stone items
data.raw.item["stone"].ib_badge = "St"

-- Adds the badge "Co", with inverted text shades, to all Coal items
data.raw.item["coal"].ib_badge = "Co"
data.raw.item["coal"].ib_invert = "whatever"

-- Adds the badge "Fe" to the iron plate recipe in the left-bottom corner
data.raw.recipe["nuclear-fuel"].ib_badge = "NF"
data.raw.recipe["nuclear-fuel"].ib_corner = "left-bottom"
--]]