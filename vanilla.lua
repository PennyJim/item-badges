-- Vanilla badges
-- **************

-- This is an example of how to structure badge data. Badge_list is a table of groups in data.raw (fluid, recipe, item, and 
--   child-of-item prototypes) and each table pairs a prototype name with ib_data properties.

Badge_list = {}

-- Item prototypes
Badge_list["item"] = {
  -- Plates
  ["iron-plate"]                      = {ib_let_badge = "Fe", },
  ["copper-plate"]                    = {ib_let_badge = "Cu", },

  -- Ores
  ["iron-ore"]                        = {ib_let_badge = "Fe", },
  ["copper-ore"]                      = {ib_let_badge = "Cu", },
  ["uranium-ore"]                     = {ib_let_badge = "U",  },
  ["coal"]                            = {ib_let_badge = "C",  },
  ["stone"]                           = {ib_let_badge = "S",  },

  -- Belts
  ["transport-belt"]                  = {ib_let_badge = "Y",  },
  ["fast-transport-belt"]             = {ib_let_badge = "R",  },
  ["express-transport-belt"]          = {ib_let_badge = "B",  },
  ["underground-belt"]                = {ib_let_badge = "Y",  },
  ["fast-underground-belt"]           = {ib_let_badge = "R",  },
  ["express-underground-belt"]        = {ib_let_badge = "B",  },
  ["splitter"]                        = {ib_let_badge = "Y",  },
  ["fast-splitter"]                   = {ib_let_badge = "R",  },
  ["express-splitter"]                = {ib_let_badge = "B",  },

  -- Circuits
  ["electronic-circuit"]              = {ib_let_badge = "G",  },
  ["advanced-circuit"]                = {ib_let_badge = "R",  },
  ["processing-unit"]                 = {ib_let_badge = "B",  },

  -- Wire
  ["red-wire"]                        = {ib_let_badge = "R",  },
  ["green-wire"]                      = {ib_let_badge = "G",  },
  ["copper-cable"]                    = {ib_let_badge = "Cu", },
  
  -- Chests
  ["logistic-chest-active-provider"]  = {ib_let_badge = "A",  },
  ["logistic-chest-passive-provider"] = {ib_let_badge = "P",  },
  ["logistic-chest-storage"]          = {ib_let_badge = "S",  },
  ["logistic-chest-buffer"]           = {ib_let_badge = "B",  },
  ["logistic-chest-requester"]        = {ib_let_badge = "R",  },

  -- Barrels
  ["crude-oil-barrel"]                = {ib_let_badge = "C",  },
  ["water-barrel"]                    = {ib_let_badge = "W",  },
  ["light-oil-barrel"]                = {ib_let_badge = "L",  },
  ["heavy-oil-barrel"]                = {ib_let_badge = "H",  },
  ["lubricant-barrel"]                = {ib_let_badge = "Lu"  },
  ["petroleum-gas-barrel"]            = {ib_let_badge = "P",  },
  ["sulfuric-acid-barrel"]            = {ib_let_badge = "SA", },

  -- Fuel
  ["nuclear-fuel"]                    = {ib_let_badge = "NF", },
  ["rocket-fuel"]                     = {ib_let_badge = "RF", },

  -- Inserter
  ["burner-inserter"]                 = {ib_let_badge = "B",  },
  ["inserter"]                        = {ib_let_badge = "I",  },
  ["fast-inserter"]                   = {ib_let_badge = "Fa", },
  ["long-handed-inserter"]            = {ib_let_badge = "LH", },
  ["filter-inserter"]                 = {ib_let_badge = "Fi", },
  ["stack-inserter"]                  = {ib_let_badge = "S",  },
  ["stack-filter-inserter"]           = {ib_let_badge = "SF", },

  -- Equipment
  ["energy-shield-equipment"]         = {ib_let_badge = "1",  },
  ["energy-shield-mk2-equipment"]     = {ib_let_badge = "2",  },
  ["personal-roboport-equipment"]     = {ib_let_badge = "1",  },
  ["personal-roboport-mk2-equipment"] = {ib_let_badge = "2",  },

  -- Misc
  ["explosives"]                      = {ib_let_badge = "E",  },
  
  -- Test
  -- ["plastic-bar"] = {badge = "Pl"},
  -- ["steel-plate"] = {badge = "SP"},
  -- ["sulfur"]      = {let_on_top = false, ib_let_badge = "Sus", ib_let_corner = "left-top", img_paths = {"__galdocs-manufacturing__/graphics/badges/heavy-load-bearing.png", "__galdocs-manufacturing__/graphics/badges/high-tensile.png"}, img_size = 64, img_scale = 0.2, img_space = 10, img_corner = "left-top"},
}

-- Child-of-Item prototype
Badge_list["tool"] = {
  -- Science Packs
  ["automation-science-pack"]         = {ib_let_badge = "A",  },
  ["logistic-science-pack"]           = {ib_let_badge = "L",  },
  ["military-science-pack"]           = {ib_let_badge = "M",  },
  ["chemical-science-pack"]           = {ib_let_badge = "C",  },
  ["production-science-pack"]         = {ib_let_badge = "P",  },
  ["utility-science-pack"]            = {ib_let_badge = "U",  },
  ["space-science-pack"]              = {ib_let_badge = "S",  },
}

Badge_list["module"] = {
  -- Effectivity
  ["effectivity-module"]              = {ib_let_badge = "E",  },
  ["effectivity-module-2"]            = {ib_let_badge = "E",  },
  ["effectivity-module-3"]            = {ib_let_badge = "E",  },
  
  -- Productivity
  ["productivity-module"]             = {ib_let_badge = "P",  },
  ["productivity-module-2"]           = {ib_let_badge = "P",  },
  ["productivity-module-3"]           = {ib_let_badge = "P",  },

  -- Speed
  ["speed-module"]                    = {ib_let_badge = "S",  },
  ["speed-module-2"]                  = {ib_let_badge = "S",  },
  ["speed-module-3"]                  = {ib_let_badge = "S",  },
}

Badge_list["ammo"] = {
  -- Magazines
  ["firearm-magazine"]                = {ib_let_badge = "NR", },
  ["piercing-rounds-magazine"]        = {ib_let_badge = "PR", },
  ["uranium-rounds-magazine"]         = {ib_let_badge = "UR", },

  -- Shotgun Shells
  ["shotgun-shell"]                   = {ib_let_badge = "SS", },
  ["piercing-shotgun-shell"]          = {ib_let_badge = "PS", },

  -- Rockets
  ["rocket"]                          = {ib_let_badge = "R",  },
  ["explosive-rocket"]                = {ib_let_badge = "ER", },
  ["atomic-bomb"]                     = {ib_let_badge = "AB", },

  -- Cannon Shells
  ["cannon-shell"]                    = {ib_let_badge = "CS", },
  ["explosive-cannon-shell"]          = {ib_let_badge = "ES", },
  ["uranium-cannon-shell"]            = {ib_let_badge = "US", },
  ["explosive-uranium-cannon-shell"]  = {ib_let_badge = "UE", },
}

Badge_list["capsule"] = {
  -- Grenades
  ["grenade"]                         = {ib_let_badge = "G",  },
  ["cluster-grenade"]                 = {ib_let_badge = "CG", },

  -- Capsules
  ["poison-capsule"]                  = {ib_let_badge = "PC", },
  ["slowdown-capsule"]                = {ib_let_badge = "SC", },

  -- Specialty
  ["cliff-explosives"]                = {ib_let_badge = "CE", },
}

Badge_list["blueprint"] = {
  ["blueprint"]                       = {ib_let_badge = "B", },
}

Badge_list["upgrade-item"] = {
  ["upgrade-planner"]                 = {ib_let_badge = "U",  },
}

Badge_list["deconstruction-item"] = {
  ["deconstruction-planner"]          = {ib_let_badge = "D",  },
}

-- Fluid prototype
Badge_list["fluid"] = {
  ["crude-oil"]                       = {ib_let_badge = "C",  },
  ["water"]                           = {ib_let_badge = "W",  },
  ["light-oil"]                       = {ib_let_badge = "L",  },
  ["heavy-oil"]                       = {ib_let_badge = "H",  },
  ["lubricant"]                       = {ib_let_badge = "Lu"  },
  ["petroleum-gas"]                   = {ib_let_badge = "P",  },
  ["sulfuric-acid"]                   = {ib_let_badge = "SA", },
}

-- Recipe prototype
Badge_list["recipe"] = {
  -- Fill Barrels
  ["fill-crude-oil-barrel"]           = {ib_let_badge = "C",  ib_let_corner = "left-bottom"},
  ["fill-water-barrel"]               = {ib_let_badge = "W",  ib_let_corner = "left-bottom"},
  ["fill-light-oil-barrel"]           = {ib_let_badge = "L",  ib_let_corner = "left-bottom"},
  ["fill-heavy-oil-barrel"]           = {ib_let_badge = "H",  ib_let_corner = "left-bottom"},
  ["fill-lubricant-barrel"]           = {ib_let_badge = "Lu", ib_let_corner = "left-bottom"},
  ["fill-petroleum-gas-barrel"]       = {ib_let_badge = "P",  ib_let_corner = "left-bottom"},
  ["fill-sulfuric-acid-barrel"]       = {ib_let_badge = "SA", ib_let_corner = "left-bottom"},

  -- Empty Barrels
  ["empty-crude-oil-barrel"]          = {ib_let_badge = "C",  ib_let_corner = "left-bottom"},
  ["empty-water-barrel"]              = {ib_let_badge = "W",  ib_let_corner = "left-bottom"},
  ["empty-light-oil-barrel"]          = {ib_let_badge = "L",  ib_let_corner = "left-bottom"},
  ["empty-heavy-oil-barrel"]          = {ib_let_badge = "H",  ib_let_corner = "left-bottom"},
  ["empty-lubricant-barrel"]          = {ib_let_badge = "Lu", ib_let_corner = "left-bottom"},
  ["empty-petroleum-gas-barrel"]      = {ib_let_badge = "P",  ib_let_corner = "left-bottom"},
  ["empty-sulfuric-acid-barrel"]      = {ib_let_badge = "SA", ib_let_corner = "left-bottom"},

  -- Solid Fuel
  ["solid-fuel-from-light-oil"]       = {ib_let_badge = "L",  ib_let_corner = "left-bottom"},
  ["solid-fuel-from-heavy-oil"]       = {ib_let_badge = "H",  ib_let_corner = "left-bottom"},
  ["solid-fuel-from-petroleum-gas"]   = {ib_let_badge = "P",  ib_let_corner = "left-bottom"},

  -- Misc
  ["nuclear-fuel"]                    = {ib_let_badge = "NF", },
}




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
data.raw.item["globulent"].ib_ib_let_badge = "Hi"
--]]

--[[
-- This stuff is just for the supplementary images on the mod page
-- Adds the badge "St" to all Stone items
data.raw.item["stone"].ib_ib_let_badge = "St"

-- Adds the badge "Co", with inverted text shades, to all Coal items
data.raw.item["coal"].ib_ib_let_badge = "Co"
data.raw.item["coal"].ib_let_invert = "whatever"

-- Adds the badge "Fe" to the iron plate recipe in the left-bottom corner
data.raw.recipe["nuclear-fuel"].ib_ib_let_badge = "NF"
data.raw.recipe["nuclear-fuel"].ib_ib_let_corner = "left-bottom"
--]]