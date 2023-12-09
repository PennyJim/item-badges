data:extend({
  { -- Badges setting
    type = "string-setting",
    name = "ib-show-badges",
    setting_type = "startup",
    default_value = "All",
    allowed_values = {"Inventory", "All"},
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
  -- { -- Badge Opacity
  --   type = "double-setting",
  --   name = "ib-badge-opacity",
  --   setting_type = "startup",
  --   default_value = 1.0,
  --   allowed_values = {0.2, 0.4, 0.7, 1.0},
  -- },
})