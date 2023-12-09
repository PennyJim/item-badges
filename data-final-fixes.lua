-- Graphical variables
local default_badge_shift_icon     = {-13, -13}
local default_badge_icon_shift     = 5.5 -- FIXME: WHAT HAPPENED HERE
local default_badge_icon_scale     = .3125

local default_badge_shift_pictures = {0.6, 0.5}

local default_badge_picture_scale  = 10/64

local default_badge_image_size     = 64

-- Structure Variables
local filepath       = "__icon-badges__/graphics/badges/"
local char_whitelist = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

-- Settings variables and parsing
local ib_show_badges       = settings.startup["ib-show-badges"].value
local ib_show_badges_scale = settings.startup["ib-show-badges-scale"].value
-- local ib_badge_opacity     = settings.startup["ib-badge-opacity"].value 
local ib_badge_opacity = 1 -- FIXME: Opacity doesn't work right
local ib_zoom_visibility   = settings.startup["ib-zoom-visibility"].value
local user_badge_scale_table = {
  ["Tiny"]    = .5,
  ["Small"]   = .75,
  ["Average"] = 1,
  ["Big"]     = 1.25,
  ["Why"]     = 1.5,
}
local user_badge_scale = user_badge_scale_table[ib_show_badges_scale]

local mipmaps = "mipAuto"
local mipmapNums = 0
if ib_zoom_visibility == "Far" then 
  mipmaps = "mipAuto"
  mipmapNums = 0
end
if ib_zoom_visibility == "Medium" then 
  mipmaps = "mip3"
  mipmapNums = 4
end
if ib_zoom_visibility == "Near" then
  mipmaps = "mip2"
  mipmapNums = 4
end

-- Item types
local item_types = {
  "item", -- Items
  "ammo",
  "capsule",
  "gun",
  "module",
  "tool",
  "armor",
  "spidertron-remote",
  "item-with-entity-data", -- entities
  "item-with-tags", -- tools and planners
  "repair-tool",
  "mining-tool",
  "selection-tool",
  "rail-planner",
  "upgrade-item",
  "deconstruction-item",
  "copy-paste-tool",
  "blueprint", -- blueprints
  "blueprint-book" ,
  "item-with-inventory", -- abstracts
  "item-with-label",
  "recipe", -- recipes
}

-- Helper Functions
function Build_single_badge_icon(letter, case, invert, justify, corner)
  -- Credit to Elusive for helping with badges
  local shift = {}

  if corner == "left-bottom" then
    shift = {
       default_badge_shift_icon[1] + (user_badge_scale * default_badge_icon_shift),
      -default_badge_shift_icon[2] - (user_badge_scale * default_badge_icon_shift)
    }
  end

  if corner == "right-bottom" then
    shift = {
      -default_badge_shift_icon[1] -(user_badge_scale * default_badge_icon_shift),
      -default_badge_shift_icon[2] -(user_badge_scale * default_badge_icon_shift)
    }
  end

  if corner == "left-top" then
    shift = {
      default_badge_shift_icon[1] + (user_badge_scale * default_badge_icon_shift),
      default_badge_shift_icon[2] + (user_badge_scale * default_badge_icon_shift)
    }
  end

  if corner == "right-top" then
    shift = {
      -default_badge_shift_icon[1] - (user_badge_scale * default_badge_icon_shift),
       default_badge_shift_icon[2] + (user_badge_scale * default_badge_icon_shift)
    }
  end
  return {
    -- blend_mode = "multiplicative-with-alpha",
    -- tint = {r = 1, b = 1, g = 1, a = ib_badge_opacity},
    scale = default_badge_icon_scale * user_badge_scale ,
    icon = filepath .. mipmaps .. "/" .. mipmaps .. "-" .. justify .. "-" .. case .. letter .. invert .. ".png", 
    icon_size = default_badge_image_size,
    icon_mipmaps = mipmapNums,
    shift = shift
  }
end

function Build_single_badge_pictures(letter, case, invert, justify)
  -- Credit to Elusive for helping with badges
  return {
    -- blend_mode = "multiplicative-with-alpha",
    -- tint = {r = 1, b = 1, g = 1, a = ib_badge_opacity},
    scale = user_badge_scale * default_badge_picture_scale,
    filename = filepath .. mipmaps .. "/" .. mipmaps .. "-" .. justify .. "-" .. case .. letter .. invert .. ".png",
    size = default_badge_image_size,
    mipmap_count = mipmapNums,
    shift = {
      -default_badge_shift_pictures[1] * 0.5 + (user_badge_scale * default_badge_picture_scale),
      -default_badge_shift_pictures[2] * 0.5 + (user_badge_scale * default_badge_picture_scale)
    }
  }
end

local function get_case(char)
  local case = ""
  if char == string.upper(char) then case = "cap-" end
  if char == string.lower(char) then case = "low-" end
  if tonumber(char) then case = "" end
  return case
end

function Build_badge_pictures(picture, badge, invert, repeat_count)
  if not picture.layers then
    local newLayer = table.deepcopy(picture)
    picture.layers = {newLayer}
  end

  if #badge == 1 then
    case = get_case(badge)
    picture.layers[#picture.layers + 1] = Build_single_badge_pictures(badge, case, invert, "center")
    picture.layers[#picture.layers].repeat_count = repeat_count
  end

  -- Two letter badge
  if #badge == 2 then
    local first = badge:sub(1,1)
    local second = badge:sub(2,2)

    case = get_case(first)
    picture.layers[#picture.layers + 1] = Build_single_badge_pictures(first, case, invert, "left")
    picture.layers[#picture.layers].repeat_count = repeat_count

    case = get_case(second)
    picture.layers[#picture.layers + 1] = Build_single_badge_pictures(second, case, invert, "right")
    picture.layers[#picture.layers].repeat_count = repeat_count
  end
end

-- Iterate over all items and staple on badges as appropriate

for _, groupName in pairs(item_types) do
  for name, item in pairs(data.raw[groupName]) do

    -- There are so many cases.
    -- Items can have none, some, or all of: 'icon', 'icons' or 'pictures'.
    -- Pictures can be one of four-ish things: a spritesheet, a struct with a sheet = spritesheet property, a single layers = array entry, or an array of things that have layers = array.
    -- If "Only GUI" is picked, then all items and recipes gets an 'icons' with badges and 'pictures' without.
    -- If "Only Belts" is picked, icons aren't touched but every item gets 'pictures' with badges added.

    local is_good = false

    if item.ib_badge and type(item.ib_badge) == "string" and (#item.ib_badge == 1 or #item.ib_badge == 2) then
      is_good = true
      for i = 1, #item.ib_badge do
        if not string.find(char_whitelist, item.ib_badge:sub(i,i)) then is_good = false end
      end
    end
    
    if is_good then
      local global_icon_size = 0
      if item.icon_size then global_icon_size = item.icon_size end

      local global_icon_mipmaps = 0
      if item.icon_mipmaps then global_icon_mipmaps = item.icon_mipmaps end

      -- icon
      -- ****

      if item.icon and (not item.icons) then
        item.icons = {
          {
            icon = item.icon,
            icon_size = item.icon_size,
            icon_mipmaps = item.icon_mipmaps
          }
        }
      end
      
      local invert = ""
      if item.ib_badge_inv then invert = "-inv" end
      local case = ""
      local corner = item.ib_corner
      if not corner then corner = "left-top" end

      -- icons
      -- *****

      -- One letter badge
      if #item.ib_badge == 1 then
        case = get_case(item.ib_badge)
        item.icons[#item.icons + 1] = Build_single_badge_icon(item.ib_badge, case, invert, "center", corner)
        item.icons[#item.icons].is_badge_layer = true
      end

      -- Two letter badge
      if #item.ib_badge == 2 then
        local first = item.ib_badge:sub(1,1)
        local second = item.ib_badge:sub(2,2)

        case = get_case(first)
        item.icons[#item.icons + 1] = Build_single_badge_icon(first, case, invert, "left", corner)
        item.icons[#item.icons].is_badge_layer = true
        case = get_case(second)
        item.icons[#item.icons + 1] = Build_single_badge_icon(second, case, invert, "right", corner)
        item.icons[#item.icons].is_badge_layer = true
      end

      -- pictures
      -- ********
      
      if ib_show_badges == "Only GUI" then
        if not item.pictures then
          item.pictures = {
            layers = {}
          }
          for _, icon in pairs(item.icons) do
            if not icon.is_badge_layer then
              local icon_size = item.icon_size or icon.size
              icon_scale = .25
              local newLayer = {}
              for k, v in pairs(icon) do
                newLayer[k] = v
              end
              newLayer.filename = icon.icon
              newLayer.size = icon_size
              newLayer.scale = icon_scale
              table.insert(item.pictures.layers, newLayer)
            end
          end
        end
      else
        if item.pictures then
          -- If item.pictures is just one layers thingie
          if item.pictures.sheet then
            item.pictures = table.deepcopy(item.pictures.sheet)
          end

          local oldSpritesheet
          if not item.pictures[1] then
            if not item.pictures.layers then
              wasSpritesheet = true
              oldSpritesheet = table.deepcopy(item.pictures)
              item.pictures = {
                layers = {
                  {
                    filename = oldSpritesheet.filename,
                    variation_count = oldSpritesheet.variation_count,
                    size = oldSpritesheet.size,
                    width = oldSpritesheet.width,
                    height = oldSpritesheet.height,
                    scale = oldSpritesheet.scale,
                  }
                }
              }
            end
            local sheet = item.pictures.layers[1]
            Build_badge_pictures(item.pictures, item.ib_badge, invert, (sheet.variation_count or 1) * (sheet.repeat_count or 1))
          else
            -- if item.pictures is an array of {layer-having-thingies}
            for i, picture in pairs(item.pictures) do
              Build_badge_pictures(picture, item.ib_badge, invert)
            end
          end
        end
      end
    end
  end
end
local what = 1



