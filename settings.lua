if mods["galdocs-manufacturing"] then
  data:extend({
    { -- Activation
    type = "bool-setting",
    name = "ib-activation",
    setting_type = "startup",
    default_value = true,
    },
  })
end

data:extend({
  { -- Badges setting
    type = "string-setting",
    name = "ib-show-badges",
    setting_type = "startup",
    default_value = "All",
    allowed_values = {"Only GUI", "Only Belts", "All"},
  },
  { -- Badge Scale
    type = "string-setting",
    name = "ib-show-badges-scale",
    setting_type = "startup",
    default_value = "Average",
    allowed_values = {"Tiny", "Small", "Average", "Big", "Why"},
  },
  { -- Zoom Visibility
    type = "string-setting",
    name = "ib-zoom-visibility",
    setting_type = "startup",
    default_value = "Medium",
    allowed_values = {"Far", "Medium", "Near"},
  },
  { -- Badge Opacity
    type = "double-setting",
    name = "ib-badge-opacity",
    setting_type = "startup",
    default_value = 1.0,
    allowed_values = {0.25, 0.5, 0.75, 1.0},
  },
})