-- Helper functions
-- ****************

---@class data.IconData
---@field is_badge_layer boolean? Whether or not it's a badge layer
---@class data.SpriteSheet
---@field is_badge_layer boolean? Whether or not it's a badge layer

-- An unsigned integer with bounds of 0-8192
---@alias Badge.sprite_size number --|{[1]:data.SpriteSizeType,[2]:data.SpriteSizeType}
---@alias Badge.justify "center"|"left"|"right"
---@alias Badge.case ""|"low-"|"cap-"
---@alias Badge.invert_string ""|"-inv"
---@alias Badge.corners
---| "left-bottom"
---| "right-bottom"
---| "left-top"
---| "right-top"
local valid_corners = {
  ["left-bottom"] = {1, -1},
  ["right-bottom"] = {-1, -1},
  ["left-top"] = {1, 1},
  ["right-top"] = {-1, 1},
}

---@param corner valid_badge_corners?
---@return {[1]:int,[2]:int} direction
function Corner_to_direction(corner)
  return valid_corners[corner] or {1,1}
end

---@param char string A single character string
---@return Badge.case charindex The index into the character table
function Get_case(char)
  local case = ""
  if char == string.upper(char) then case = "cap-" end
  if char == string.lower(char) then case = "low-" end
  if tonumber(char) then case = "" end
  return case
end

---@param char string
---@return int
function Parse_char_widths(char)
  local current_width = 0
  for group, width in pairs(Ib_global.char_widths) do
    local i, j = string.find(group, char)
    if i then
      current_width = width
    end
  end
  return current_width
end

--- Converts the given SpriteVariations into either a spritesheet
--- or a Sprite
---@param picture data.SpriteVariations
---@return data.SpriteSheet
---@nodiscard
function Parse_SpriteVariations(picture)
  -- Convert the SpriteVariations.struct
  if picture.sheet then
    picture.layers = {picture.sheet}
    picture.sheet = nil
  end
  ---@cast picture data.SpriteSheet|data.Sprite[]

  -- Convert into a single layered sprite
  if picture[1] and Ib_global.log_errors then
    log(Ib_global.log_prefix.."Currently doesn't support an array of sprites for SpriteVariations")
  end

  -- Convert into a layered sheet
  if not picture.layers then
    local new_layer = table.deepcopy(picture)
    -- Remove old entries?
    -- for key in pairs(new_layer) do
    --   picture[key] = nil
    -- end
    picture.layers = {new_layer}
  end
  ---@cast picture data.SpriteSheet

  return picture
end

---@alias Badge.prototype_types
---| "recipe"
---| "fluid"
---| "blueprint-book"
---| "copy-paste-tool"
---| "deconstruction-item"
---| "item-with-entity-data"
---| "item-with-inventory"
---| "item-with-label"
---| "item-with-tags"
---| "mining-tool"
---| "rail-planner"
---| "repair-tool"
---| "selection-tool"
---| "spidertron-remote"
---| "upgrade-item"

-- This will try to find the product's prototype type -- that is, a 'group' in data.raw, i.e. data.raw['group'] might be data.raw['item'] for a recipe.
-- It's often the case that an item name will be in both the 'item' and 'recipe' group. This will favor the item group.
--   Ex: If there's a prototype with the name "iron-plate" in the 'item' and 'recipe' groups, this will return 'item'.
--
-- DON'T SEND THIS FUNCTION A RECIPE.
--
-- Known issues: If the name of the prototype is in the 'fluid' group and the 'item' group (or 'child-of-item') then this will favor the item, not the fluid.
--   Ex: If there's a prototype with the name "iron-plate" in the 'item' and 'fluid' groups (for some reason), then this will return 'item'.
---@param item string
---@return Badge.prototype_types|"ERROR"
function Get_product_prototype_type(item)
  ---@type string
  local current_item_type

  -- Check to see if it's one of the non-item and non-child-of-item types
  if data.raw.recipe[item] then current_item_type = "recipe" end
  if data.raw.fluid[item] then current_item_type = "fluid" end

  -- Check if it's an item, and overwrite any result from fluid or recipe
  for item_type, _ in pairs(Ib_global.item_types) do
    if data.raw[item_type][item] then
      current_item_type = item_type
    end
  end

  -- Log errors
  -- Because IB can badge recipes, someone may screw up and try to 'get the product prototype type' of a recipe.
  if Ib_global.log_errors and current_item_type == "recipe"  then
    log(Ib_global.log_prefix .. "The prototype name exists only in data.raw.recipe, and is not a child-of-item or fluid.")
    return "recipe"
  end

  -- If it's not a fluid or an item or a child of item, then say so
  if Ib_global.log_errors and not current_item_type then
    log(Ib_global.log_prefix .. "The prototype name was not found in the fluid, item, child-of-item, or recipe subtables of data.raw.")
    return "ERROR"
  end

  return current_item_type
end



-- Build Letter and Image Badge functions
-- **************************************

-- Icons Letter
--
-- Credit to Elusive for helping with badges
---@param letter string The letter being built
---@param case Badge.case The case of the letter
---@param invert Badge.invert_string Whether or not the badge is inverted
---@param justify Badge.justify
---@param corner Badge.corners? Which corner to build it in
---@param three_position int? Which position it is if it's for a three character badge
---@param middle_char string? the center letter if it's a three character badge
---@return data.IconData
function Build_single_letter_badge_icon(letter, case, invert, justify, corner, three_position, middle_char)
  -- One or Two character Shift
  local direction = Corner_to_direction(corner)
  local shift = {
    direction[1] * (Ib_global.default_badge_shift_icon[1] + (Ib_global.user_badge_scale * Ib_global.default_badge_shift_icon_adjust[1] / 2)),
    direction[2] * (Ib_global.default_badge_shift_icon[2] + (Ib_global.user_badge_scale * Ib_global.default_badge_shift_icon_adjust[2] / 2))
  }

  -- Three character Shift (can only be centered (going left-to-right) but can be on top or bottom)
  local three_shift = 0
  if three_position then
    ---@cast middle_char -?
    direction[1] = math.abs(direction[1]) -- Keeps letters going from left-to-right
    three_shift = Ib_global.three_char_icon_shift[three_position]
    shift = {
      direction[1] * ((Ib_global.user_badge_scale * three_shift * (Parse_char_widths(middle_char))) / 8 ),
      direction[2] * (Ib_global.default_badge_shift_icon[2] + (Ib_global.user_badge_scale * Ib_global.default_badge_shift_icon_adjust[2] / 2))
    }
  end

  return {
    tint = {r = Ib_global.ib_badge_opacity, b = Ib_global.ib_badge_opacity, g = Ib_global.ib_badge_opacity, a = Ib_global.ib_badge_opacity},
    scale = Ib_global.user_badge_scale * Ib_global.default_badge_icon_scale,
    icon = Ib_global.filepath .. Ib_global.mipmaps .. "/" .. Ib_global.mipmaps .. "-" .. justify .. "-" .. case .. letter .. invert .. ".png",
    icon_size = Ib_global.badge_image_size,
    icon_mipmaps = Ib_global.mipmapNums,
    shift = shift
  }--[[@as data.IconData]]
end

---@param icons data.IconData[]
---@param let_badge string The badge being built
---@param invert_str Badge.invert_string
---@param let_corner Badge.corners?
function Build_letter_badge_icon(icons, let_badge, invert_str, let_corner)
  -- One letter badge
  if #let_badge == 1 and Ib_global.ib_show_badges ~= "Only Belts" then
    case = Get_case(let_badge)
    icons[#icons + 1] = Build_single_letter_badge_icon(let_badge, case, invert_str, "center", let_corner)
    icons[#icons].is_badge_layer = true
  end

  -- Two letter badge
  if #let_badge == 2 and Ib_global.ib_show_badges ~= "Only Belts" then
    local first = let_badge:sub(1,1)
    local second = let_badge:sub(2,2)

    case = Get_case(first)
    icons[#icons + 1] = Build_single_letter_badge_icon(first, case, invert_str, "left", let_corner)
    icons[#icons].is_badge_layer = true
    case = Get_case(second)
    icons[#icons + 1] = Build_single_letter_badge_icon(second, case, invert_str, "right", let_corner)
    icons[#icons].is_badge_layer = true
  end

  -- Three letter badge
  if #let_badge == 3 and Ib_global.ib_show_badges ~= "Only Belts" then

    local first = let_badge:sub(1,1)
    local second = let_badge:sub(2,2)
    local third = let_badge:sub(3,3)

    case = Get_case(first)
    icons[#icons + 1] = Build_single_letter_badge_icon(first, case, invert_str, "left", let_corner, 1, second)
    icons[#icons].is_badge_layer = true
    case = Get_case(second)
    icons[#icons + 1] = Build_single_letter_badge_icon(second, case, invert_str, "center", let_corner, 2, second)
    icons[#icons].is_badge_layer = true
    case = Get_case(third)
    icons[#icons + 1] = Build_single_letter_badge_icon(third, case, invert_str, "right", let_corner, 3, second)
    icons[#icons].is_badge_layer = true
  end
end

--- Credit to Elusive for helping with badges
---@param path string
---@param size Badge.sprite_size
---@param scale double
---@param mips int
---@param corner Badge.corners?
---@param spacing double
---@return data.IconData
function Build_single_img_badge_icon(path, size, scale, mips, corner, spacing)
  -- Image Shift
  local direction = Corner_to_direction(corner)
  local shift = {
    direction[1] * (Ib_global.default_badge_shift_icon[1] + (Ib_global.user_badge_scale * ((Ib_global.default_badge_shift_icon_adjust[1] / 2) + spacing ))),
    direction[2] * (Ib_global.default_badge_shift_icon[2] + (Ib_global.user_badge_scale * Ib_global.default_badge_shift_icon_adjust[2] / 2))
  }

  return {
    tint = {r = Ib_global.ib_badge_opacity, b = Ib_global.ib_badge_opacity, g = Ib_global.ib_badge_opacity, a = Ib_global.ib_badge_opacity},
    scale = Ib_global.user_badge_scale * scale,
    icon = path, 
    icon_size = size,
    icon_mipmaps = mips or Ib_global.mipmapNums,
    shift = shift
  }--[[@as data.IconData]]
end

---@param icons data.IconData[]
---@param paths string[]
---@param size Badge.sprite_size
---@param scale double
---@param mips int
---@param corner Badge.corners?
---@param space double?
function Build_img_badge_icon(icons, paths, size, scale, mips, corner, space)
  local spacing = 0
  for i, path in pairs(paths) do
    if space then spacing = spacing + ((i - 1) * space) end
    icons[#icons + 1] = Build_single_img_badge_icon(path, size, scale, mips, corner, spacing)
    icons[#icons].is_badge_layer = true
  end
end

-- Pictures Letters

-- Credit to Elusive for helping with badges
---@param letter string
---@param case Badge.case
---@param invert Badge.invert_string
---@param justify Badge.justify
---@param corner Badge.corners?
---@param three_position int?
---@param middle_char string?
---@return data.SpriteSheet
function Build_single_letter_badge_pictures(letter, case, invert, justify, corner, three_position, middle_char)
  
  -- One or Two character Shift
  local direction = Corner_to_direction(corner)
  local shift = {
    - direction[1] * (Ib_global.default_badge_shift_picture[1] - (Ib_global.user_badge_scale * Ib_global.default_badge_scale_picture / 2)),
    - direction[2] * (Ib_global.default_badge_shift_picture[2] - (Ib_global.user_badge_scale * Ib_global.default_badge_scale_picture / 2)),
  }
  
  -- Three character Shift (can only be centered (going left-to-right) but can be on top or bottom)
  local three_shift = 0
  if three_position then
    ---@cast middle_char -?
    direction[1] = math.abs(direction[1]) -- Keeps letters going from left-to-right
    three_shift = Ib_global.three_char_icon_shift[three_position]
    shift = {
      direction[1] * ((Ib_global.user_badge_scale * three_shift * Ib_global.default_badge_scale_picture * (Parse_char_widths(middle_char))) / 8 / 8),
      - direction[2] * (Ib_global.default_badge_shift_picture[2] - (Ib_global.user_badge_scale * Ib_global.default_badge_scale_picture / 2)),
    }
  end

  return {
    tint = {r = Ib_global.ib_badge_opacity, b = Ib_global.ib_badge_opacity, g = Ib_global.ib_badge_opacity, a = Ib_global.ib_badge_opacity},
    scale = Ib_global.user_badge_scale * Ib_global.default_badge_scale_picture,
    filename = Ib_global.filepath .. Ib_global.mipmaps .. "/" .. Ib_global.mipmaps .. "-" .. justify .. "-" .. case .. letter .. invert .. ".png",
    size = Ib_global.badge_image_size,
    mipmap_count = Ib_global.mipmapNums,
    shift = shift
  }--[[@as data.SpriteSheet]]
end

---@param picture data.SpriteVariations
---@param badge string
---@param invert Badge.invert_string
---@param repeat_count int
---@param corner Badge.corners?
function Build_letter_badge_pictures(picture, badge, invert, repeat_count, corner)
  picture = Parse_SpriteVariations(picture)

  -- One letter badge
  if #badge == 1 then
    case = Get_case(badge)
    picture.layers[#picture.layers + 1] = Build_single_letter_badge_pictures(badge, case, invert, "center", corner)
    picture.layers[#picture.layers].repeat_count = repeat_count
    picture.layers[#picture.layers].is_badge_layer = true
  end

  -- Two letter badge
  if #badge == 2 then
    local first = badge:sub(1,1)
    local second = badge:sub(2,2)

    case = Get_case(first)
    picture.layers[#picture.layers + 1] = Build_single_letter_badge_pictures(first, case, invert, "left", corner)
    picture.layers[#picture.layers].repeat_count = repeat_count
    picture.layers[#picture.layers].is_badge_layer = true

    case = Get_case(second)
    picture.layers[#picture.layers + 1] = Build_single_letter_badge_pictures(second, case, invert, "right", corner)
    picture.layers[#picture.layers].repeat_count = repeat_count
    picture.layers[#picture.layers].is_badge_layer = true
  end

  if #badge == 3 then
    local first = badge:sub(1,1)
    local second = badge:sub(2,2)
    local third = badge:sub(3,3)

    case = Get_case(first)
    picture.layers[#picture.layers + 1] = Build_single_letter_badge_pictures(first, case, invert, "left", corner, 1, second)
    picture.layers[#picture.layers].repeat_count = repeat_count
    picture.layers[#picture.layers].is_badge_layer = true

    case = Get_case(second)
    picture.layers[#picture.layers + 1] = Build_single_letter_badge_pictures(second, case, invert, "center", corner, 2, second)
    picture.layers[#picture.layers].repeat_count = repeat_count
    picture.layers[#picture.layers].is_badge_layer = true

    case = Get_case(third)
    picture.layers[#picture.layers + 1] = Build_single_letter_badge_pictures(third, case, invert, "right", corner, 3, second)
    picture.layers[#picture.layers].repeat_count = repeat_count
    picture.layers[#picture.layers].is_badge_layer = true
  end
end

-- Pictures Images

-- Credit to Elusive for helping with badges
---@param path string
---@param size Badge.sprite_size
---@param scale double
---@param mips int?
---@param corner Badge.corners?
---@param spacing double
---@return data.SpriteSheet
function Build_single_img_badge_pictures(path, size, scale, mips, corner, spacing)
  -- Image Shift
  local direction = Corner_to_direction(corner)
  local shift = {
    - direction[1] * (Ib_global.default_badge_shift_picture[1] - (Ib_global.user_badge_scale * ((Ib_global.default_badge_scale_picture / 2) + (spacing/64))) ),
    - direction[2] * (Ib_global.default_badge_shift_picture[2] - (Ib_global.user_badge_scale * Ib_global.default_badge_scale_picture / 2)),
  }

  return {
    tint = {r = Ib_global.ib_badge_opacity, b = Ib_global.ib_badge_opacity, g = Ib_global.ib_badge_opacity, a = Ib_global.ib_badge_opacity},
    scale = Ib_global.user_badge_scale * scale / 2,
    filename = path,
    size = size,
    mipmap_count = mips or Ib_global.mipmapNums,
    shift = shift
  }--[[@as data.SpriteSheet]]
end

---@param picture data.SpriteVariations
---@param paths string[]
---@param size Badge.sprite_size
---@param scale double
---@param mips int
---@param repeat_count int
---@param corner Badge.corners?
---@param spacing double
function Build_img_badge_pictures(picture, paths, size, scale, mips, repeat_count, corner, spacing)
  picture = Parse_SpriteVariations(picture)

  local current_spacing = 0
  for i, path in pairs(paths) do
    -- Image Badge
    if spacing then current_spacing = current_spacing + ((i - 1) * spacing) end
    picture.layers[#picture.layers + 1] = Build_single_img_badge_pictures(path, size, scale, mips, corner, current_spacing)
    picture.layers[#picture.layers].repeat_count = repeat_count
    picture.layers[#picture.layers].is_badge_layer = true
  end
end


-- ******************************************************************************************
-- The most important function that other modders need to care about; srsly this is the candy
-- ******************************************************************************************

---@class Badge.letter_badge
---Must be a 1, 2 or 3 character string, consisting of lower- or upper-case letters or numbers (nothing else!).
---<br>
---Valid examples: `"AB"`, `"aB"`, `"Ab"`, `"A"`, `"b"`, `"1A"`, `"1"`, `"GUI"`, `"wHy"`.
---<br>
---<br>
---Note: 3-letter badges are always centered horizontally, though they can be put on the top or bottom of the icon.
---<br>
---They're just too wide. Use "ib_corner" like normal; it'll work out the rest.
---@field ib_let_badge string
---Set to anything that isn't `nil` to invert the text.
---
---By default, badges are 'white text with black borders'.
---<br>
---To help with collisions, I've also supplied 'black text with white borders.'
---
---It's both-or-neither; it's not possible to have one character inverted and another not.
---@field ib_let_invert? boolean
---This moves the badge in one of the four corners instead of the upper-left.
---@field ib_let_corner? Badge.corners

---@class Badge.image_badge
---Each path should point to the location of the image file.
---
---Note: If you have just one path, still enclose it in a table. eg:
---```lua
---ib_img_paths = {"whatever.png"}
---```
---@field ib_img_paths string[]
---The size of the image file.
---@field ib_img_size? Badge.sprite_size
---This moves the badge in one of the four corners instead of the upper-left.
---
---There can be only one image badge corner, no matter how many images are referenced in `ib_img_paths`.
---@field ib_img_corner? Badge.corners
---The mip levels of the image. By default, it assumes none, but if the image has mipmaps in it, leaving this blank will cause a crash.
---@field ib_img_mips? uint8
---A knob for modders to scale the image badges. This number will potentially differ between images, because the profile of the image may not take up the full (say) 64x64 px canvas.
---<br>
---Determine empirically.
---@field ib_img_scale? double
---Controls spacing between image badges, one value for all, in pixels. If this is 0, all images will stack on top of one another, in order.
---@field ib_img_space? double

-- A hack because you cannot inherit from multiple classes (or an alias):

---@class Badge.combined_badge
---A boolean value that determines if the letter badge should be on top of the image badge. Default is true
---@field ib_let_on_top? boolean

---@alias Badge.badge_data Badge.letter_badge|Badge.image_badge|Badge.combined_badge

---@param item data.RecipePrototype|data.ItemPrototype|data.FluidPrototype
---@param ib_data Badge.badge_data
function Build_badge(item, ib_data)
  -- Cases:
  --   * Items can have some, or all of: 'icon', 'icons' or 'pictures'. Recipes can have 'icon', 'icons' or none of those
  --       * Pull icon data from products if we're badging a recipe with no `icon` or `icons` data. It will be one of three things:
  --           * 'result'
  --           * 'results' with 1 entry
  --           * a 'main_product'
  --         from properties directly on the recipe, in normal, or in expensive; further, the product can come from fluid, item, or child-of-item prototypes in data.raw
  --       * If there's no 'icons', there's a 'icon' data; make an 'icons' entry from the 'icon' data. Make sure to pull partial information -- like icon_size
  --       * Only make 'pictures' out of 'icons' data if needed for belts
  --   * Pictures can be one of four structures: 
  --       * A spritesheet
  --       * A struct with a sheet = spritesheet property 
  --       * A single layers = array entry 
  --       * An array of things that have layers = array
  -- If "Only GUI" is picked, then all items and recipes gets an 'icons' with badges and items without 'pictures' have one made from 'icons' without badges
  -- If "Only Belts" is picked, icons and recipes aren't touched but every item gets 'pictures' with badges added

  -- Future upgrades:
  --   For cases with multiple image badges, expose a setting to modders that makes the badges display left-to-right OR top-to-bottom
  --   When feeling particularly desperate for something to do, make 4 letter badges, or have 3-letter badges actually be left/right justified instead of just centered

  -- Check to see if 'ib_let_badge' is well-formed
  local is_good_letters = false
  if ib_data.ib_let_badge and type(ib_data.ib_let_badge) == "string" and (#ib_data.ib_let_badge >= 1 and #ib_data.ib_let_badge <= 3) then
    is_good_letters = true
    for i = 1, #ib_data.ib_let_badge do
      if not string.find(Ib_global.char_whitelist, ib_data.ib_let_badge:sub(i,i)) then is_good_letters = false end
    end
  end

  if ((ib_data.ib_let_badge or ib_data.ib_let_invert or ib_data.ib_let_corner) and not is_good_letters) and Ib_global.log_errors then
    log(Ib_global.log_prefix .. "Set letter badge properties but ib_let_badge isn't good (make sure it is 1, 2 or 3 english letters OR numbers, exactly).")
  end

  local is_good_paths = false
  if ib_data.ib_img_paths and type(ib_data.ib_img_paths) == "table" then
    is_good_paths = true
    for _, path in pairs(ib_data.ib_img_paths) do
      if type(path) ~= "string" then is_good_paths = false end
    end
  end

  if ((ib_data.ib_img_paths or ib_data.ib_img_corner or ib_data.ib_img_size or ib_data.ib_img_scale or ib_data.ib_img_mips or ib_data.ib_img_space) and not is_good_paths) and Ib_global.log_errors then
    log(Ib_global.log_prefix .. "Set image badge properties but ib_img_paths isn't good (make sure it is an array of strings, each a path to an image, that works).")
  end

  -- If 'ib_let_badge' is well-formed, do the crucial stuff
  if is_good_letters or is_good_paths then

    -- Icon
    -- ****

    -- Make `icon` data from the products of a recipe that has no innate `icon` or `icons` data
    if item.type == "recipe" then
      ---@cast item data.RecipePrototype
      if ((not item.icon) and (not item.icons)) then
        -- Normal vs. Expensive modes: if, for some insane reason, noraml and expensive mode have different result(s)/main_products, the data from item.expensive will be used
        ---@type data.RecipeData
        local recipe_data
        if not (item.expensive or item.normal) then recipe_data = item--[[@as data.RecipeData]] end
        if item.normal then recipe_data = item.normal--[[@as data.RecipeData]] end
        if item.expensive then recipe_data = item.expensive--[[@as data.RecipeData]] end

        ---@type data.ItemPrototype|data.FluidPrototype
        local product
        ---@type Badge.prototype_types|"ERROR" --FIXME: Not handling ERROR
        local product_group
        -- Either there's one product, or there's 'main product'
        if recipe_data.result then 
          product_group = Get_product_prototype_type(recipe_data.result)
          product = data.raw[product_group][recipe_data.result]--[[@as data.ItemPrototype|data.FluidPrototype]]
        end
        if recipe_data.results and #recipe_data.results == 1 then 
          product_group = Get_product_prototype_type(recipe_data.results[1].name)
          product = data.raw[product_group][recipe_data.results[1].name]--[[@as data.ItemPrototype|data.FluidPrototype]]
        end
        if recipe_data.main_product then 
          product_group = Get_product_prototype_type(recipe_data.main_product)
          product = data.raw[product_group][recipe_data.main_product]--[[@as data.ItemPrototype|data.FluidPrototype]]
        end

        -- Fill in anything
        if not item.icon then item.icon = product.icon end
        if not item.icons then item.icons = product.icons end
        if not item.icon_size then item.icon_size = product.icon_size end
        if not item.icon_mipmaps then item.icon_mipmaps = product.icon_mipmaps end
      end
    end

    -- Build 'icons' data from icon if present
    if item.icon and (not item.icons) then
      item.icons = {
        {
          icon = item.icon,
          icon_size = item.icon_size,
          icon_mipmaps = item.icon_mipmaps
        }
      }
    end

    if item.icons then
      for _, icon in pairs(item.icons) do
        if not icon.icon_size and item.icon_size then icon.icon_size = item.icon_size end
        -- if not icon.icon_mipmaps and item.icon_mipmaps then icon.icon_mipmaps = item.icon_mipmaps end
      end
    end

    -- icons Mipmap Error Logging
    -- **************************
    -- if ((item.icons[1].icon_mipmaps and item.icons[1].icon_mipmaps ~= mipmapNums) or (not item.icons[1].icon_mipmaps and mipmapNums ~= 0))  and log_errors then
    --   log("(Icon Badges) Mipmap Disagreement! Recipe: " .. name .. "    icon_mipmaps: " .. item.icon_mipmaps .. "    Current Badge Mipmaps: " .. mipmapNums)
    -- end



    -- ib_let_badge data
    -- *****************

    local invert_str = ""
    if ib_data.ib_let_invert then invert_str = "-inv" end
    local let_corner    = ib_data.ib_let_corner or "left-top"
    local img_corner    = ib_data.ib_img_corner or "left-top"
    local img_scale     = ib_data.ib_img_scale  or Ib_global.default_badge_scale_picture
    local img_mips      = ib_data.ib_img_mips   or Ib_global.mipmapNums
    local ib_let_on_top = true --NOTE: `ib_data.ib_let_on_top ~= false` should also work
    if ib_data.ib_let_on_top ~= nil then
      ib_let_on_top = ib_data.ib_let_on_top
    end

    local case = ""



    -- icons
    -- *****
    if Ib_global.ib_show_badges ~= "Only Belts" then
      -- Build letter badges into 'icons' Ib_global.ib_show_badges says to
      if is_good_letters and not is_good_paths then
        Build_letter_badge_icon(item.icons, ib_data.ib_let_badge, invert_str, let_corner)
      end

      -- Build image badges into 'icons' Ib_global.ib_show_badges says to
      if is_good_paths and not is_good_letters then
        Build_img_badge_icon(item.icons, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, img_corner, ib_data.ib_img_space)
      end
      
      -- Build Letter and Image Badges in the correct order into 'icons' Ib_global.ib_show_badges says to
      if is_good_paths and is_good_letters then
        if ib_let_on_top then
          Build_img_badge_icon(item.icons, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, img_corner, ib_data.ib_img_space)
          Build_letter_badge_icon(item.icons, ib_data.ib_let_badge, invert_str, let_corner)
        else
          Build_letter_badge_icon(item.icons, ib_data.ib_let_badge, invert_str, let_corner)
          Build_img_badge_icon(item.icons, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, img_corner, ib_data.ib_img_space)
        end
      end
    end



    -- pictures
    -- ********
    
    -- Don't put 'pictures' data on recipes
    if item.type ~= "recipe" then
      ---@cast item data.ItemPrototype|data.FluidPrototype
      -- Case: No belt items can have badges. They're absent in pictures by default. Make pictures layers out of icons data without badges.
      if Ib_global.ib_show_badges == "Only GUI" then
        if not item.pictures then
          item.pictures = {
            layers = {}
          }
          for _, icon in pairs(item.icons) do
            if not icon.is_badge_layer then
              local icon_size = item.icon_size or icon.icon_size
              local icon_scale = Ib_global.icon_to_pictures_ratio
              ---@type data.SpriteSheet
              local newLayer = {}
              for k, v in pairs(icon--[[@as table<any,any>]]) do
---@diagnostic disable-next-line: no-unknown
                newLayer[k] = v
              end
              newLayer.filename = icon.icon
              newLayer.size = icon_size
              newLayer.scale = icon_scale
              table.insert(item.pictures.layers, newLayer)
            end
          end
        end
      end

      -- Case: All belt items need badges. Icons will already have them. Add badges to things with pictures.
      if Ib_global.ib_show_badges ~= "Only GUI" then

        -- If there's picture data already, it's four of the four cases. We'll handle them one at a time.
        if item.pictures then
          ---@cast item data.ItemPrototype|data.FluidPrototype

          -- If item.pictures is a struct with a sheet entry, make it a spritesheet directly
          if item.pictures.sheet then
            item.pictures = table.deepcopy(item.pictures.sheet)
          end

          -- if item.pictures is not an array, it must be a spritesheet directly OR it must have a layers entry.
          if not item.pictures[1] then

            -- Reformatting item.pictures to be an entry in item.pictures.layers.
            if not item.pictures.layers then
              wasSpritesheet = true
              local oldSpritesheet = table.deepcopy(item.pictures--[[@as data.SpriteVariations]])
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

            -- Now that item.pictures has (only) a layers property, build badges onto it. 
            --   * If it was a spritesheet, variation_count and/or repeat_count are needed.
            --   * If it had a layers property to begin with, the logic will be the same, except 1 will be used instead of variation_count * repeat_count
            local sheet = item.pictures.layers[1]

            -- pictures Mipmap Error Logging
            -- *****************************
            -- if ((item.pictures.layers[1].mipmap_count and item.pictures.layers[1].mipmap_count ~= mipmapNums) or (not item.pictures.layers[1].mipmap_count and mipmapNums ~= 0))  and log_errors then
            --   log("(Icon Badges) Mipmap Disagreement! Item name: " .. name .. "    mipmap_count: " .. item.pictures.layers[1].mipmap_count .. "    Current Badge Mipmaps: " .. mipmapNums)
            -- end

            -- Build Letter Badges
            if is_good_letters and not is_good_paths then
              Build_letter_badge_pictures(item.pictures, ib_data.ib_let_badge, invert_str, (sheet.variation_count or 1) * (sheet.repeat_count or 1), let_corner)
            end

            -- Build Image Badges
            if is_good_paths and not is_good_letters then
              Build_img_badge_pictures(item.pictures, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, (sheet.variation_count or 1) * (sheet.repeat_count or 1), img_corner, ib_data.ib_img_space)
            end

            -- Build Letter and Image Badges in the correct order
            if is_good_paths and is_good_letters then
              if ib_let_on_top then
                Build_img_badge_pictures(item.pictures, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, (sheet.variation_count or 1) * (sheet.repeat_count or 1), img_corner, ib_data.ib_img_space)
                Build_letter_badge_pictures(item.pictures, ib_data.ib_let_badge, invert_str, (sheet.variation_count or 1) * (sheet.repeat_count or 1), let_corner)
              else
                Build_letter_badge_pictures(item.pictures, ib_data.ib_let_badge, invert_str, (sheet.variation_count or 1) * (sheet.repeat_count or 1), let_corner)
                Build_img_badge_pictures(item.pictures, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, (sheet.variation_count or 1) * (sheet.repeat_count or 1), img_corner, ib_data.ib_img_space)
              end
            end
          else
            -- if item.pictures is an array of {layer = stuff}, then add badges to each variant.
            for i, picture in pairs(item.pictures) do
              -- Build Letter Badges
              if is_good_letters and not is_good_paths then
                Build_letter_badge_pictures(picture, ib_data.ib_let_badge, invert_str, 1, let_corner)
              end

              -- Build Image Badges
              if is_good_paths and not is_good_letters then
                Build_img_badge_pictures(picture, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, 1, img_corner, ib_data.ib_img_space)
              end

              -- Build Letter and Image Badges in the correct order
              if is_good_paths and is_good_letters then
                if ib_let_on_top then
                  Build_img_badge_pictures(picture, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, 1, img_corner, ib_data.ib_img_space)
                  Build_letter_badge_pictures(picture, ib_data.ib_let_badge, invert_str, 1, let_corner)
                else
                  Build_letter_badge_pictures(picture, ib_data.ib_let_badge, invert_str, 1, let_corner)
                  Build_img_badge_pictures(picture, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, 1, img_corner, ib_data.ib_img_space)
                end
              end

            end
          end
        end

        -- If the item (not recipe!) has no pictures property and we need one, build one from the icons data (either what it originally had or what we built above)
        -- This will exclude badge data, because the only time we need this is when ib_show_badges = "Only Belts".
        if not item.pictures then

          -- Initialize item.pictures.layers = {}
          item.pictures = {
            layers = {}
          }

          -- Shove data from 'iconss' into the layer property WITHOUT the badge data.
          for _, icon in pairs(item.icons) do
            if not icon.is_badge_layer then
              local icon_size = icon.icon_size -- or icon.size
              local icon_scale = Ib_global.icon_to_pictures_ratio
              local icon_mipmaps = icon.icon_mipmaps
              local icon_tint = icon.tint

              local newLayer = {}

              -- Just pull over all the properties; chose not to do this because it puts unused 'icon' properties in 'pictures'
              -- for k, v in pairs(icon) do
              --   newLayer[k] = v
              -- end

              newLayer.filename = icon.icon
              newLayer.size = icon_size
              newLayer.scale = icon_scale
              newLayer.mipmap_count = icon_mipmaps
              newLayer.tint = icon_tint
              newLayer.is_badge_layer = icon.is_badge_layer

              table.insert(item.pictures.layers, newLayer)
            end
          end

          -- wait why is this part happening; i just forget and am very tired
          for _, layer in pairs(item.pictures.layers) do
            -- Build Letter Badges
            if is_good_letters and not is_good_paths then
              Build_letter_badge_pictures(layer, ib_data.ib_let_badge, invert_str, 1, let_corner)
            end

            -- Build Image Badges
            if is_good_paths and not is_good_letters then
              Build_img_badge_pictures(layer, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, 1, img_corner, ib_data.ib_img_space)
            end

            -- Build Letter and Image Badges in the correct order
            if is_good_paths and is_good_letters then
              if ib_let_on_top then
                Build_img_badge_pictures(layer, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, 1, img_corner, ib_data.ib_img_space)
                Build_letter_badge_pictures(layer, ib_data.ib_let_badge, invert_str, 1, let_corner)
              else
                Build_letter_badge_pictures(layer, ib_data.ib_let_badge, invert_str, 1, let_corner)
                Build_img_badge_pictures(layer, ib_data.ib_img_paths, ib_data.ib_img_size, img_scale, img_mips, 1, img_corner, ib_data.ib_img_space)
              end
            end

          end
        end
      end
    end
  end
end

---@alias Badge.Badge_list  {[Badge.prototype_types]:table<string,Badge.badge_data>}}

-- Badge List Functions
-- ********************

-- This is an optional structure to facilitate easy badging of prototypes. It's what I used for my vanilla badging. 
--   Modders may use it too if they wish, or instead use the individual function above.
-- The format for a badge list is: 
--   badge_list[prototype_group_1] = {["prototype_name_1"] = ib_data_1_1, ["prototype_name_2"] = ib_data_1_2, ...}
--   badge_list[prototype_group_2] = {["prototype_name_1"] = ib_data_2_1, ["prototype_name_2"] = ib_data_2_2, ...}
--   ...
--   where:
--     prototype_group is either fluid, recipe, item, or child-of-item in data.raw
--     prototype_name is the name of a fluid, recipe, item, or child-of-item in the prototype_group
--     ib_data_whatever_whatever is a table with icon badge properties as outline in the readme

-- Merge Badge List
-- NOTE: To remove a badge from list1 (i.e. un-badging an item from vanilla), simply set the ib_data = {} for that entry
-- WARNING: Using this function will overwrite entries in list1 with entries from list2!!!!
---comment
---@param list1 Badge.Badge_list
---@param list2 Badge.Badge_list
---@return Badge.Badge_list? merged_list
function Merge_badge_lists(list1, list2)
  -- Sanitize inputs
  if type(list1) ~= "table" or type(list2) ~= "table" then
    if Ib_global.log_errors then
      log(Ib_global.log_prefix .. "Called merge_badge_list with invalid params")
    end
    return
  end

  -- Initialize new badge_list with contents of first arg (list1)
  ---@type Badge.Badge_list
  local merged_list = {}
  for sub_list_name, sub_list_entries in pairs(list1) do
    merged_list[sub_list_name] = sub_list_entries
  end

  -- Add content from second arg (list2)
  for sub_list_name, sub_list_entries in pairs(list2) do
    -- Add in any groups that haven't been seen
    if not merged_list[sub_list_name] then
      merged_list[sub_list_name] = sub_list_entries
    else
      -- Add/Overwrite entries
      for entry, ib_data in pairs(sub_list_entries) do
        -- Check to see if ib_data is empty; this will remove the ib_data that was in list1
        local num_properties = 0
        if type(ib_data) == "table" then
          for k, v in pairs(ib_data--[[@as table<string,any>]]) do
            num_properties = num_properties + 1
          end
        end
        if num_properties == 0 then
          merged_list[sub_list_name][entry] = nil
        else
          -- Overwrite the data from list1 with the contents of list2
          merged_list[sub_list_name][entry] = ib_data
        end
      end
    end
  end
  return merged_list
end

-- Process Badge List
---@param list Badge.Badge_list
function Process_badge_list(list)
  for sub_list_name, sub_list in pairs(list) do
    for item_name, ib_data in pairs(sub_list) do
      if data.raw[sub_list_name][item_name] then
        Build_badge(data.raw[sub_list_name][item_name], ib_data)
      elseif Ib_global.log_errors then
        log(Ib_global.log_prefix .. "Item " .. item_name .. " not found in data.raw[" .. sub_list_name .. "]")
      end
    end
  end
end



-- DO NOT USE
-- **********
-- FIXME : This function doesn't work but this is where it is right now in development.
-- Unbadge Function
---@deprecated
function Unbadge(item)
  log("Icon Badges: asdf")
  if not item.icons then log(Ib_global.log_prefix .. "Prototype has no 'icons' property, and thus hasn't been badged.") end
  local new_icons = {}
  for _, icon in pairs(items.icons) do
    if not icon.is_badge_layer then
      table.insert(new_icons, icon)
    end
  end
  item.icons = new_icons

  if item.pictures then
    for _, picture in pairs(item.pictures) do
      if not picture.layers then log(Ib_global.log_prefix .. "Prototype has pictures property whose structure differs from Icon Badge's structure, and thus hasn't been badged.") end
      local new_layers = {}
      for _, layer in pairs(picture.layers) do
        if not layer.is_badge_layer then
          table.insert(new_layers, layer)
        end
      end
      picture.layers = new_layers
    end
  end
end
