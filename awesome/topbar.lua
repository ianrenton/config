require('func')

--[[ ======================================
				  Main Menu
	 ====================================== --]]

mymainmenu = awful.menu({ 
	items = {
		{ "open terminal", TERMINAL },
   		{ "restart awm", awesome.restart },
   		{ "quit", awesome.quit }
	}
})

mylauncher = awful.widget.launcher({ 
	image = image(beautiful.awesome_icon),
    menu = mymainmenu 
})


--[[ ======================================
				    TOP BAR
	 ====================================== --]]

-- Colours
coldef  = "</span>"
colgre  = "<span color='#87FF00'>"

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Define icons
beautiful.widget_bat = CONFDIR .. "/themes/icons/zenburn-bat.png"

-- Battery indicator
require("vicious")
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
battext = widget({ type = "textbox", name = "battext" })

-- Battery indicator coloring
function battery_status_text(widget, args)
	local perc = args[2]

	-- color
	local color = beautiful.status_fg_good
	if perc < 15 then
		color = beautiful.status_fg_bad
	elseif perc < 50 then
		color = beautiful.status_fg_okay
	end

	-- charge state
	local ch = ''
	if batt_is_charging() then
		ch = '+'
	end

	-- return '<span color="'..color..'">'..perc..'%'..ch..'</span> '
        return ''
end

-- Debug by placing a message in the battery text.
function debug(text)
	battext.text = text
end

-- Battery Status
vicious.register(battext, 
	vicious.widgets.bat, battery_status_text, 15, BATTERY_NAME)
	
-- vol
volume = widget({ type = "textbox", name = "volume" })
vicious.register(volume, vicious.widgets.volume, "$1 $2  "..colgre.."|"..coldef.."  ", 60, "Master")

-- weather
weather = widget({ type = "textbox", name = "weather" })
vicious.register(weather, vicious.widgets.weather, "  "..colgre.."|"..coldef.."  ${tempc}°C, ${sky}  "..colgre.."|"..coldef.."  ", 600, "EGHH")

-- wifi
wifi = widget({ type = "textbox", name = "wifi" })
vicious.register(wifi, vicious.widgets.wifi, ""..colgre.."WiFi:"..coldef.." ${ssid}   ", 60, "mlan0")

-- Memory
memwidget = widget({ type = "textbox", name = "mem" })
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, ""..colgre.."Mem:"..coldef.." $1%  "..colgre.."|"..coldef.."  ", 60)

-- HDD
hddwidget = widget({ type = "textbox", name = "hdd" })
vicious.cache(vicious.widgets.fs)
vicious.register(hddwidget, vicious.widgets.fs, ""..colgre.."Disk:"..coldef.." ${/ avail_mb}MB free  "..colgre.."|"..coldef.."  ", 60)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            -- mylauncher,
            mytaglist[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        {
            mytextclock,
            weather,
            memwidget,
            hddwidget,
            wifi,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        {
            mylayoutbox[s],
            s == 1 and mysystray or nil,
            layout = awful.widget.layout.horizontal.rightleft
        },
        layout = awful.widget.layout.horizontal.leftright
    }
    awful.widget.layout.margins[mytextclock] = {left = 160 }
end

