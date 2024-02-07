-- Helper functions
-- ****************
function Corner_to_direction(corner)
  local direction = {1, 1}
  if corner == "left-bottom" then
    direction = {1, -1}
  end
  if corner == "right-bottom" then
    direction = {-1, -1}
  end
  if corner == "left-top" then
    direction = {1, 1}
  end
  if corner == "right-top" then
    direction = {-1, 1}
  end
  return direction
end

function Get_case(char)
  local case = ""
  if char == string.upper(char) then case = "cap-" end
  if char == string.lower(char) then case = "low-" end
  if tonumber(char) then case = "" end
  return case
end

function Parse_char_widths(character)
  local current_width = 0
  for group, width in pairs(Ib_global.char_widths) do
    local i, j = string.find(group, character)
    if i then
      current_width = width
    end
  end
  return current_width
end

-- Build Letter Badge functions
-- ****************************
-- Icons Letter
function Build_single_letter_badge_icon(letter, case, invert, justify, corner, three_position, middle_char)
  -- Credit to Elusive for helping with badges
  
  -- One or Two character Shift
  local direction = Corner_to_direction(corner)
  local shift = {
    direction[1] * (Ib_global.default_badge_shift_icon[1] + (Ib_global.user_badge_scale * Ib_global.default_badge_shift_icon_adjust[1] / 2)),
    direction[2] * (Ib_global.default_badge_shift_icon[2] + (Ib_global.user_badge_scale * Ib_global.default_badge_shift_icon_adjust[2] / 2))
  }

  -- Three character Shift (can only be centered (going left-to-right) but can be on top or bottom)
  local three_shift = 0
  if three_position then
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
  }
end

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

-- Icons Images
function Build_single_img_badge_icon(path, size, scale, mips, corner, spacing)
  -- Credit to Elusive for helping with badges

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
  }
end

function Build_img_badge_icon(icons, paths, size, scale, mips, corner, space)
  local spacing = 0
  for i, path in pairs(paths) do
    if space then spacing = spacing + ((i - 1) * space) end
    icons[#icons + 1] = Build_single_img_badge_icon(path, size, scale, mips, corner, spacing)
    icons[#icons].is_badge_layer = true
  end
end

-- Pictures Letters
function Build_single_letter_badge_pictures(letter, case, invert, justify, corner, three_position, middle_char)
  -- Credit to Elusive for helping with badges
  
  -- One or Two character Shift
  local direction = Corner_to_direction(corner)
  local shift = {
    - direction[1] * (Ib_global.default_badge_shift_picture[1] - (Ib_global.user_badge_scale * Ib_global.default_badge_scale_picture / 2)),
    - direction[2] * (Ib_global.default_badge_shift_picture[2] - (Ib_global.user_badge_scale * Ib_global.default_badge_scale_picture / 2)),
  }
  
  -- Three character Shift (can only be centered (going left-to-right) but can be on top or bottom)
  local three_shift = 0
  if three_position then
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
  }
end

function Build_letter_badge_pictures(picture, badge, invert, repeat_count, corner)
  if not picture.layers then
    local newLayer = table.deepcopy(picture)
    picture.layers = {newLayer}
  end

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
function Build_single_img_badge_pictures(path, size, scale, mips, corner, spacing)
  -- Credit to Elusive for helping with badges
  
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
  }
end

  function Build_img_badge_pictures(picture, paths, size, scale, mips, repeat_count, corner, spacing)
  if not picture.layers then
    local newLayer = table.deepcopy(picture)
    picture.layers = {newLayer}
  end

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
function Build_badge(item, ib_data)
  -- Cases:
  --   * Items can have some, or all of: 'icon', 'icons' or 'pictures'. Recipes can have 'icon', 'icons' or none of those
  --       * Pull icon data from products if we're badging a recipe with no `icon` or `icons` data. It will be one of three things:
  --           * 'result'
  --           * 'results' with 1 entry
  --           * a 'main_product'
  --       * If there's no 'icons', there's a 'icon' data; make an 'icons' entry from the 'icon' data
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
      if ((not item.icon) and (not item.icons)) then
        
        -- Normal vs. Expensive modes: if, for some insane reason, noraml and expensive mode have different result(s)/main_products, the data from item.expensive will be used
        local recipe_data
        if not (item.expensive or item.normal) then recipe_data = item end
        if item.normal then recipe_data = item.normal end
        if item.expensive then recipe_data = item.expensive  end
        
        local product
        -- Either there's one product, or there's 'main product'
        if recipe_data.result then product = data.raw.item[recipe_data.result] end
        if recipe_data.results and #recipe_data.results == 1 then product = data.raw.item[recipe_data.results[1].name] end
        if recipe_data.main_product then product = data.raw.item[recipe_data.main_product] end

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
    local ib_let_on_top = true
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
    
    -- Case: No belt items can have badges. They're absent in pictures by default. Make pictures layers out of icons data without badges.
    if Ib_global.ib_show_badges == "Only GUI" then
      if not item.pictures then
        item.pictures = {
          layers = {}
        }
        for _, icon in pairs(item.icons) do
          if not icon.is_badge_layer then
            local icon_size = item.icon_size or icon.size
            local icon_scale = Ib_global.icon_to_pictures_ratio
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
    end

    -- Case: All belt items need badges. Icons will already have them. Add badges to things with pictures.
    if Ib_global.ib_show_badges ~= "Only GUI" then
      
      -- If there's picture data already, it's four of the four cases. We'll handle them one at a time.
      if item.pictures then
        
        -- If item.pictures is a struct with a sheet entry, make it a spritesheet directly
        if item.pictures.sheet then
          item.pictures = table.deepcopy(item.pictures.sheet)
        end

        -- if item.pictures is not an array, it must be a spritesheet directly OR it must have a layers entry.
        local oldSpritesheet
        if not item.pictures[1] then
          
          -- Reformatting item.pictures to be an entry in item.pictures.layers.
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