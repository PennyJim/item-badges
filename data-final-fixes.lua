-- Generate letter icon Badges
-- ***************************

-- Iterate over all items and staple on badges as appropriate
for _, groupName in pairs(Ib_global.item_types) do
  for name, item in pairs(data.raw[groupName]) do

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

    -- Check to see if 'ib_let_badge' is well-formed
    local is_good_letters = false
    if item.ib_let_badge and type(item.ib_let_badge) == "string" and (#item.ib_let_badge >= 1 and #item.ib_let_badge <= 3) then
      is_good_letters = true
      for i = 1, #item.ib_let_badge do
        if not string.find(Ib_global.char_whitelist, item.ib_let_badge:sub(i,i)) then is_good_letters = false end
      end
    end

    if ((item.ib_let_badge or item.ib_let_invert or item.ib_let_corner) and not is_good_letters) and Ib_global.log_errors then
      log(Ib_global.log_prefix .. "Set letter badge properties but ib_let_badge isn't good (make sure it is 1, 2 or 3 english letters OR numbers, exactly).")
    end

    local is_good_paths = false
    if item.ib_img_paths and type(item.ib_img_paths) == "table" then
      is_good_paths = true
      for _, path in pairs(item.ib_img_paths) do
        if type(path) ~= "string" then is_good_paths = false end
      end
    end

    if ((item.ib_img_paths or item.ib_img_corner or item.ib_img_size or item.ib_img_scale or item.ib_img_mips or item.ib_img_space) and not is_good_paths) and Ib_global.log_errors then
      log(Ib_global.log_prefix .. "Set image badge properties but ib_img_paths isn't good (make sure it is an array of strings, each a path to an image, that works).")
    end

    -- If 'ib_let_badge' is well-formed, do the crucial stuff
    if is_good_letters or is_good_paths then

      -- Icon
      -- ****

      -- Make `icon` data from the products of a recipe that has no innate `icon` or `icons` data
      if groupName == "recipe" then
        -- FIXME : Normal vs. Expensive vs. Neither declared?

        if ((not item.icon) and (not item.icons)) then
          local recipe_data
          if not (item.expensive or item.normal) then recipe_data = item end
          if item.normal then recipe_data = item.normal end
          if item.expensive then recipe_data = item.expensive  end
          
          local product

          -- Either there's one product, or there's 'main product'
          if item.result then product = data.raw.item[item.result] end
          if item.results and #item.results == 1 then product = data.raw.item[item.results[1].name] end
          if item.main_product then product = data.raw.item[item.main_product] end

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
      if item.ib_let_invert then invert_str = "-inv" end
      local let_corner    = item.ib_let_corner or "left-top"
      local img_corner    = item.ib_img_corner or "left-top"
      local img_scale     = item.ib_img_scale  or Ib_global.default_badge_scale_picture
      local img_mips      = item.ib_img_mips   or 0
      local ib_let_on_top = true
      if item.ib_let_on_top ~= nil then
        ib_let_on_top = item.ib_let_on_top
      end

      local case = ""



      -- icons
      -- *****
      if Ib_global.ib_show_badges ~= "Only Belts" then
        -- Build letter badges into 'icons' Ib_global.ib_show_badges says to
        if is_good_letters and not is_good_paths then
          Build_letter_badge_icon(item.icons, item.ib_let_badge, invert_str, let_corner)
        end

        -- Build image badges into 'icons' Ib_global.ib_show_badges says to
        if is_good_paths and not is_good_letters then
          Build_img_badge_icon(item.icons, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, img_corner, item.ib_img_space)
        end
        
        -- Build Letter and Image Badges in the correct order into 'icons' Ib_global.ib_show_badges says to
        if is_good_paths and is_good_letters then
          if ib_let_on_top then
            Build_img_badge_icon(item.icons, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, img_corner, item.ib_img_space)
            Build_letter_badge_icon(item.icons, item.ib_let_badge, invert_str, let_corner)
          else
            Build_letter_badge_icon(item.icons, item.ib_let_badge, invert_str, let_corner)
            Build_img_badge_icon(item.icons, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, img_corner, item.ib_img_space)
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
              local icon_scale = icon_to_pictures_ratio
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
              Build_letter_badge_pictures(item.pictures, item.ib_let_badge, invert_str, (sheet.variation_count or 1) * (sheet.repeat_count or 1), let_corner)
            end

            -- Build Image Badges
            if is_good_paths and not is_good_letters then
              Build_img_badge_pictures(item.pictures, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, (sheet.variation_count or 1) * (sheet.repeat_count or 1), img_corner, item.ib_img_space)
            end

            -- Build Letter and Image Badges in the correct order
            if is_good_paths and is_good_letters then
              if ib_let_on_top then
                Build_img_badge_pictures(item.pictures, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, (sheet.variation_count or 1) * (sheet.repeat_count or 1), img_corner, item.ib_img_space)
                Build_letter_badge_pictures(item.pictures, item.ib_let_badge, invert_str, (sheet.variation_count or 1) * (sheet.repeat_count or 1), let_corner)
              else
                Build_letter_badge_pictures(item.pictures, item.ib_let_badge, invert_str, (sheet.variation_count or 1) * (sheet.repeat_count or 1), let_corner)
                Build_img_badge_pictures(item.pictures, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, (sheet.variation_count or 1) * (sheet.repeat_count or 1), img_corner, item.ib_img_space)
              end
            end
          else
            -- if item.pictures is an array of {layer = stuff}, then add badges to each variant.
            for i, picture in pairs(item.pictures) do
              -- Build Letter Badges
              if is_good_letters and not is_good_paths then
                Build_letter_badge_pictures(picture, item.ib_let_badge, invert_str, 1, let_corner)
              end

              -- Build Image Badges
              if is_good_paths and not is_good_letters then
                Build_img_badge_pictures(picture, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, 1, img_corner, item.ib_img_space)
              end

              -- Build Letter and Image Badges in the correct order
              if is_good_paths and is_good_letters then
                if ib_let_on_top then
                  Build_img_badge_pictures(picture, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, 1, img_corner, item.ib_img_space)
                  Build_letter_badge_pictures(picture, item.ib_let_badge, invert_str, 1, let_corner)
                else
                  Build_letter_badge_pictures(picture, item.ib_let_badge, invert_str, 1, let_corner)
                  Build_img_badge_pictures(picture, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, 1, img_corner, item.ib_img_space)
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
              Build_letter_badge_pictures(layer, item.ib_let_badge, invert_str, 1, let_corner)
            end

            -- Build Image Badges
            if is_good_paths and not is_good_letters then
              Build_img_badge_pictures(layer, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, 1, img_corner, item.ib_img_space)
            end

            -- Build Letter and Image Badges in the correct order
            if is_good_paths and is_good_letters then
              if ib_let_on_top then
                Build_img_badge_pictures(layer, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, 1, img_corner, item.ib_img_space)
                Build_letter_badge_pictures(layer, item.ib_let_badge, invert_str, 1, let_corner)
              else
                Build_letter_badge_pictures(layer, item.ib_let_badge, invert_str, 1, let_corner)
                Build_img_badge_pictures(layer, item.ib_img_paths, item.ib_img_size, img_scale, img_mips, 1, img_corner, item.ib_img_space)
              end
            end

          end
        end
      end
    end
  end
end

local a = 1