--------------------------------------------------
-- Default awesome theme - customized by TAR-IT --
--------------------------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir() .. "themes/"

local theme = {}

-- Color variables

color_white         = "#ffffff"
color_black         = "#000000"
color_lightgrey     = "#aaaaaa"
color_mediumgrey    = "#555555"
color_darkgrey      = "#333333"
color_red           = "#ff0000"
color_darkred       = "#91231c"
color_blue          = "#005577"
color_yellow        = "#ffcc00"

-- Theme variables

theme.font          = "Hack 12"

theme.bg_normal     = color_black
theme.bg_focus      = color_white
theme.bg_urgent     = color_red
theme.bg_minimize   = color_mediumgrey
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = color_white
theme.fg_focus      = color_black
theme.fg_urgent     = color_white
theme.fg_minimize   = color_lightgrey

theme.useless_gap   = dpi(1)
theme.border_width  = dpi(1)
theme.border_normal = color_darkgrey
theme.border_focus  = color_white
theme.border_marked = color_darkred

-- Taglist colors
theme.taglist_bg_focus    = color_white
theme.taglist_fg_focus    = color_black

theme.taglist_bg_urgent   = color_red
theme.taglist_fg_urgent   = color_white

theme.taglist_bg_occupied = color_black
theme.taglist_fg_occupied = color_white

theme.taglist_bg_empty    = color_black
theme.taglist_fg_empty    = color_mediumgray

theme.taglist_bg_volatile = color_yellow
theme.taglist_fg_volatile = color_black

-- Taglist behavior and spacing
theme.taglist_font          = theme.font
theme.taglist_shape         = require("gears").shape.powerline
theme.taglist_spacing       = dpi(1)
theme.taglist_shape_border_width = dpi(2)
theme.taglist_shape_border_color = color_white
theme.taglist_shape_clip    = false
theme.taglist_disable_icon  = false

-- Tasklist colors
theme.tasklist_bg_focus    = color_white
theme.tasklist_fg_focus    = color_black

theme.tasklist_bg_urgent   = color_red
theme.tasklist_fg_urgent   = color_white

theme.tasklist_bg_minimize = color_black
theme.tasklist_fg_minimize = color_mediumgray

theme.tasklist_bg_normal   = color_black
theme.tasklist_fg_normal   = color_white

-- Tasklist behavior and spacing
theme.tasklist_font          = theme.font
theme.tasklist_shape         = require("gears").shape.powerline
theme.tasklist_shape_border_width = dpi(2)
theme.tasklist_shape_border_color = color_white
theme.tasklist_shape_clip    = true
theme.tasklist_disable_icon  = false
theme.tasklist_spacing       = dpi(1)
theme.tasklist_plain_task_name = false
theme.tasklist_align         = "center"

-- Generate taglist squares:
local taglist_square_size = dpi(5)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Menu
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width  = dpi(200)

-- Titlebar buttons
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active   = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active    = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active   = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active    = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active   = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active    = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path.."default/titlebar/maximized_focus_active.png"

-- Wallpaper
theme.wallpaper = themes_path.."default/background.png"

-- Layout icons
theme.layout_fairh      = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv      = themes_path.."default/layouts/fairvw.png"
theme.layout_floating   = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier  = themes_path.."default/layouts/magnifierw.png"
theme.layout_max        = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile       = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop    = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle    = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_normal, theme.fg_focus
)

-- Icon theme
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
