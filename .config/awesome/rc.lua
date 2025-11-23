-- ===================================================================
--                     LUA ROCKS LOADER (optional)
-- ===================================================================

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader") -- Load LuaRocks package loader if available

-- ===================================================================
--                     REQUIRED LIBRARIES
-- ===================================================================

-- Standard awesome library for general utilities (gears includes functions for handling paths, signals, and more)
local gears = require("gears")

-- Library for window management and handling (handles focus, placement, etc.)
local awful = require("awful")

-- Autofocus module to automatically focus windows when switching between them
require("awful.autofocus")

-- Widget and layout library for creating and managing widgets in the wibox (top bar)
local wibox = require("wibox")

-- Theme handling library for customizing AwesomeWM’s appearance (colors, fonts, etc.)
local beautiful = require("beautiful")

-- Notification library to display notifications to the user
local naughty = require("naughty")

-- Menubar library for creating a menu (useful for app launchers)
local menubar = require("menubar")

-- Hotkeys Popup library for displaying keybinding help when needed
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps when a client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- ===================================================================
--                     ERROR HANDLING
-- ===================================================================

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical, -- Notification style for critical errors
		title = "Oops, there were errors during startup!", -- Title of the notification
		text = awesome.startup_errors, -- Display the startup errors
	})
end

-- Handle runtime errors after startup
do
	local in_error = false -- Prevent endless error loops
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical, -- Critical error notification style
			title = "Oops, an error happened!", -- Title of the error notification
			text = tostring(err), -- Display the error message
		})
		in_error = false
	end)
end

-- ===================================================================
--                     VARIABLE DEFINITIONS
-- ===================================================================

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/default/theme.lua") -- Load theme file

-- This is used later as the default terminal and editor to run.
terminal = "kitty" -- Default terminal application (can be replaced with another terminal, e.g., "alacritty")
editor = os.getenv("EDITOR") or "nano" -- Default text editor, falls back to "nano" if not set in environment
editor_cmd = terminal .. " -e " .. editor -- Command to launch the editor in the terminal

-- Default modkey.
-- Usually, Mod4 is the key with a logo (often referred to as the "Windows" key between Control and Alt).
-- This can be remapped to a different key using tools like xmodmap if necessary.
modkey = "Mod4" -- Mod4 is the default modifier key for most keybindings

-- ===================================================================
--                     WINDOW LAYOUT CONFIGURATIONS
-- ===================================================================

-- Table of layouts to cover with awful.layout.inc, order matters.
-- These layouts are available to be cycled through when changing window layouts.
-- Layouts are applied in the order they are defined here.
awful.layout.layouts = {
	awful.layout.suit.tile, -- Tiling layout (windows arranged in a grid)
	awful.layout.suit.floating, -- Floating layout (windows are free to move and resize)
	-- awful.layout.suit.tile.left, -- Tiling layout with windows stacked to the left
	-- awful.layout.suit.tile.bottom, -- Tiling layout with windows stacked at the bottom
	-- awful.layout.suit.tile.top, -- Tiling layout with windows stacked at the top
	-- awful.layout.suit.fair, -- Fair tiling layout (balances window sizes)
	-- awful.layout.suit.fair.horizontal, -- Fair layout with horizontal stacking
	-- awful.layout.suit.spiral, -- Spiral layout (windows arranged in a spiral)
	-- awful.layout.suit.spiral.dwindle, -- Dwindling spiral layout (windows grow/shrink as you add more)
	-- awful.layout.suit.max, -- Maximized layout (one window takes up the whole screen)
	-- awful.layout.suit.max.fullscreen, -- Maximized layout, fullscreen
	-- awful.layout.suit.magnifier, -- Magnifier layout (one window is enlarged while others are smaller)
	-- awful.layout.suit.corner.nw, -- Corner layout (arranges windows in the northwest corner)
	-- awful.layout.suit.corner.ne,  -- Corner layout for the northeast
	-- awful.layout.suit.corner.sw,  -- Corner layout for the southwest
	-- awful.layout.suit.corner.se,  -- Corner layout for the southeast
}

-- ===================================================================
--                     MENU AND WIDGET CONFIGURATION
-- ===================================================================

-- Create a launcher widget and a main menu
-- The menu can contain various items like hotkeys, manual, and app shortcuts

myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", terminal .. " -e man awesome" },
   { "Edit config", editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "system", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration for applications that require a terminal
menubar.utils.terminal = terminal -- Set the default terminal for menubar

-- ===================================================================
--                     KEYBOARD AND WIDGET CONFIGURATION
-- ===================================================================

-- Keyboard Layout Indicator
-- Add a keyboard layout indicator widget to display the current layout
mykeyboardlayout = awful.widget.keyboardlayout() -- Indicator for keyboard layout (e.g., switching between languages)
-- }}}

-- ===================================================================
--                     WIDGET BAR (WIBAR) CONFIGURATION
-- ===================================================================

-- Create a textclock widget and other widgets to populate the wibox
mytextclock = wibox.widget.textclock()

-- Button configurations for the taglist (the tags at the top of each screen)
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t) -- Move the focused client to the selected tag
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle), -- Toggle visibility of the tag
	awful.button({ modkey }, 3, function(t) -- Toggle the tag for the focused client
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end), -- Switch to next tag
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end) -- Switch to previous tag
)

-- Button configurations for the tasklist (list of open windows)
local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c) -- Minimize or activate the client on click
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function() -- Show client list menu on right-click
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end), -- Switch focus to next client
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end) -- Switch focus to previous client
)

-- Wallpaper configuration function (sets wallpaper for each screen)
local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen as parameter
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true) -- Set wallpaper to maximize on the screen
	end
end

-- Re-set wallpaper when a screen’s geometry changes (e.g., after screen resolution changes)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    awful.tag({ "Desk", "Web", "Doc", "Comm" }, s, awful.layout.layouts[1])

    s.mypromptbox = awful.widget.prompt()

    -- Layoutbox
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))

    -- Taglist
    s.mytaglist = awful.widget.taglist({
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
		widget_template = {
			{
				{
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				left = 20,  -- increase left/right padding
				right = 20,
				top = 4,
				bottom = 4,
				widget = wibox.container.margin
			},
			widget = wibox.container.background,
			id = "background_role"
		}
    })

    -- Tasklist
    s.mytasklist = awful.widget.tasklist({
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                id     = "text_role",
                widget = wibox.widget.textbox,
            },
            id     = "background_role",
            widget = wibox.container.background
        },
    })

    -- Wibar
    s.mywibox = awful.wibar({
        position = "bottom",
        screen   = s
    })

    -- Setup
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox
        },
    })
end)


-- ===================================================================
--                     MOUSE BINDINGS
-- ===================================================================

-- Define mouse actions for root window (e.g., the desktop area).
root.buttons(gears.table.join(
	-- Uncomment the following line to toggle the main menu with right-click
	-- awful.button({ }, 3, function () mymainmenu:toggle() end),

	-- Scroll up to view the next tag (workspace)
	awful.button({}, 4, awful.tag.viewnext),

	-- Scroll down to view the previous tag (workspace)
	awful.button({}, 5, awful.tag.viewprev)
))

-- ===================================================================
--                     KEY BINDINGS
-- ===================================================================

-- Global keybindings (applies to all windows)
globalkeys = gears.table.join(
	-- Show help window (keybinding: Mod4 + s)
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

	-- Navigate between tags (workspaces) with arrow keys
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

	-- Go back to the last visited tag
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	-- Switch focus to the next or previous window by index
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),

	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	-- Show the main menu (keybinding: Mod4 + w)
	awful.key({ modkey }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	-- Swap windows in the client list (keybinding: Mod4 + Shift + j/k)
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),

	-- Focus the next or previous screen (multi-monitor setups)
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),

	-- Jump to urgent clients (e.g., when a client needs attention)
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

	-- Go back to the last focused client
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	-- Open a terminal (keybinding: Mod4 + Return)
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	-- Reload AwesomeWM (keybinding: Mod4 + Control + r)
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	-- Quit AwesomeWM (keybinding: Mod4 + Shift + q)
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	-- Adjust master width factor (Mod4 + h/l)
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),

	-- Adjust the number of master clients (Mod4 + Shift + h/l)
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),

	-- Adjust the number of columns in the layout (Mod4 + Control + h/l)
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),

	-- Change layout (Mod4 + space)
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),

	-- Change layout in reverse order (Mod4 + Shift + space)
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	-- Restore minimized clients (keybinding: Mod4 + Control + n)
	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Run prompt (keybinding: Mod4 + r)
	awful.key({ modkey }, "r", function()
		awful.prompt.run {
			prompt       = "Run: ",
			textbox      = awful.screen.focused().mypromptbox.widget,
			exe_callback = function(command)
				-- escape single quotes in command
				local safe_command = command:gsub("'", "'\\''")
				-- spawn interactive bash, load aliases from .bashrc
				awful.spawn("bash -i -c '" .. safe_command .. "'")
			end,
			history_path = awful.util.get_cache_dir() .. "/history"
		}
	end, { description = "run prompt", group = "launcher" }),

	-- Lua execution prompt (keybinding: Mod4 + x)
	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),

	-- Show menubar (keybinding: Mod4 + p)
	awful.key({ modkey }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" }),

	-- Screenshot keybinding
	awful.key({ }, "Print",
	function ()
		awful.spawn("flameshot gui")
	end,
	{description = "flameshot screenshot", group = "launcher"})
)

-- ===================================================================
--                     CLIENT KEY BINDINGS
-- ===================================================================

-- Client keybindings (specific to individual windows)
clientkeys = gears.table.join(

	-- Toggle fullscreen (keybinding: Mod4 + f)
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),

	-- Close client (keybinding: Mod4 + Shift + c)
	awful.key({ modkey, "Shift" }, "c", function(c)
		c:kill()
	end, { description = "close", group = "client" }),

	-- Toggle floating mode (keybinding: Mod4 + Control + space)
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),

	-- Move client to master window (keybinding: Mod4 + Control + Return)
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),

	-- Move client to a different screen (keybinding: Mod4 + o)
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),

	-- Toggle "keep on top" state (keybinding: Mod4 + t)
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),

	-- Minimize client (keybinding: Mod4 + n)
	awful.key({ modkey }, "n", function(c)
		c.minimized = true
	end, { description = "minimize", group = "client" }),

	-- Maximize client (keybinding: Mod4 + m)
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),

	-- Maximize vertically (keybinding: Mod4 + Control + m)
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),

	-- Maximize horizontally (keybinding: Mod4 + Shift + m)
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
	
)

-- ===================================================================
--                     TAGS KEY BINDINGS
-- ===================================================================

-- Tag management keybindings (switching between workspaces/tags)
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,

		-- View tag only (keybinding: Mod4 + number)
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),

		-- Toggle tag display (keybinding: Mod4 + Control + number)
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),

		-- Move client to tag (keybinding: Mod4 + Shift + number)
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),

		-- Toggle tag on focused client (keybinding: Mod4 + Control + Shift + number)
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

-- ===================================================================
--                     CLIENT MOUSE BINDINGS
-- ===================================================================

-- Client mouse bindings (actions for mouse clicks on client windows)
clientbuttons = gears.table.join(

	-- Left-click to focus a client
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),

	-- Left-click + Mod4 to move a client window
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),

	-- Right-click + Mod4 to resize a client window
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)

)

-- ===================================================================
--                     SETTING GLOBAL KEYS
-- ===================================================================

-- Set the global keybindings
root.keys(globalkeys)

-- ===================================================================
--                     RULES
-- ===================================================================

-- Rules to apply to new clients when they are managed.
awful.rules.rules = {

	-- Default rule for all clients
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width, -- Set border width from theme
			border_color = beautiful.border_normal, -- Set border color from theme
			focus = awful.client.focus.filter, -- Use focus filter to focus on new clients
			raise = true, -- Raise the client to the top of the stack
			keys = clientkeys, -- Assign global keybindings for client windows
			buttons = clientbuttons, -- Assign mouse actions to client windows
			screen = awful.screen.preferred, -- Set the screen to the preferred one
			placement = awful.placement.no_overlap + awful.placement.no_offscreen, -- Avoid overlap and offscreen windows
		},
	},

	-- Floating clients rule: Specific applications are set to float
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry", -- Used for password entry dialogs.
			},
			class = {
				"Arandr", -- Display configuration tool.
				"Blueman-manager", -- Bluetooth manager.
				"Gpick", -- Color picker tool.
				"Kruler", -- Screen ruler.
				"MessageWin", -- Used in KAlarm.
				"Sxiv", -- Simple image viewer.
				"Tor Browser", -- Browser, needs fixed window size for privacy.
				"Wpa_gui", -- Network manager GUI.
				"veromix", -- Volume mixer.
				"xtightvncviewer", -- VNC viewer.
			},
			name = {
				"Event Tester", -- Used by xev to test events.
				"Picture in picture" -- Used by brave small media player
			},
			role = {
				"AlarmWindow", -- Thunderbird calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- E.g., Google Chrome's Developer Tools.
			},
		},
		properties = { floating = true },

	},

	-- Add titlebars to normal windows and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },


	-- Apps on "Desk" tag
	{ 
		rule = { class = "steam" },
		properties = {
			screen = 1,
			tag = "Desk",
			floating = false,
			maximize = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimize = false
		}
	},
	{
		rule = { class = "kitty" },
		properties = {
			screen = 1,
			tag = "Desk",
			floating = false,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = false
		}
	},
	{ 
		rule = { class = "cura" },
		properties = {
			screen = 1,
			tag = "Desk",
			floating = false,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = false
		}
	},
	{ 
		rule = { name = "Lightscreen" },
		properties = {
			screen = 1,
			tag = "Web",
			floating = true,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = true
		}
	},
	{ rule = { class = "virt-manager" },
	 	properties = {
			screen = 1,
			tag = "Web",
			floating = false,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = false
		}
	},

	-- Apps on "Web" tag
	{
		rule = { name = "Proton VPN" },
		properties = {
			screen = 1,
			tag = "Web",
			floating = true,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = true
		}
	},
	{ 
		rule = { class = "Kapsa" },
		properties = {
			screen = 1,
			tag = "Web",
			floating = true,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = true
		}
	},
	{ 
		rule = { class = "Brave-browser" },
		properties = {
			screen = 1,
			tag = "Web",
			floating = false,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = false
		}
	},

	-- Apps on "Doc" tag
	{
		rule = { class = "Thunar" },
		properties = {
			screen = 1,
			tag = "Doc",
			floating = false,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = false
		}
	},
	{
		rule = { class = "code-oss" },
		properties = {
			screen = 1,
			tag = "Doc",
			floating = false,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = false
		}
	},

	-- Apps on "Comm" tag
	{
		rule = { class = "Ferdium" },
		properties = {
			screen = 1,
			tag = "Comm",
			floating = false,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = false
		}
	},
	{
		rule = { class = "discord" },
		properties = {
			screen = 1,
			tag = "Comm",
			floating = false,
			maximized = false,
			maximized_horizontal = false,
			maximized_vertical = false,
			minimized = false
		}
	},

}

-- ===================================================================
--                     SIGNALS
-- ===================================================================

-- Signal function to execute when a new client is managed.
client.connect_signal("manage", function(c)
	-- Ensure new clients are not placed off-screen and appear on the current screen.
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen changes
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if the rule specifies to enable titlebars
client.connect_signal("request::titlebars", function(c)
	-- Define buttons for the titlebar: left-click to move, right-click to resize
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c) -- Move the client with the mouse
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c) -- Resize the client with the mouse
		end)
	)

	-- Create the titlebar with specified buttons and layout
	awful.titlebar(c):setup({
		{ -- Left part: Icon
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle part: Title
			{ -- Title widget
				align = "left",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right part: Control buttons (Floating, Maximize, Close, etc.)
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- -- Enable sloppy focus, so the window focuses when the mouse hovers over it
-- client.connect_signal("mouse::enter", function(c)
-- 	c:emit_signal("request::activate", "mouse_enter", { raise = false })
-- end)

-- Change border color on focus/unfocus
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- ===================================================================
--                     AUTORUN PROGRAMS
-- ===================================================================

-- Apps to run
local apps = {
    { cmd = "nm-applet" }, 		-- Network Manager
    { cmd = "protonvpn-app" },	-- VPN
    { cmd = "io.kapsa.drive" },	-- Proton Drive
    { cmd = "flameshot" },   	-- Screenshot app
    { cmd = "ferdium"  },     	-- Social apps
    { cmd = "discord" },      	-- Discord
    { cmd = "thunar" },         -- File explorer
    { cmd = "code" },           -- VS Code
    { cmd = "kitty" },          -- Terminal
    { cmd = "brave" }          	-- Browser
}

-- Spawn apps
for _, app in ipairs(apps) do
    awful.spawn(app.cmd)
end

-- Spawn scripts
awful.spawn.with_shell("~/.config/awesome/scripts/screensaver.sh")
awful.spawn.with_shell("~/.config/awesome/scripts/turing-system-monitor.sh")
