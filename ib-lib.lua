-- Small functions
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

-- Build Letter Badge functions
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