-- AWESOME WINDOW MANAGER
-- KEY AND MOUSE BINDINGS 

require('func')
require('clients')

-- {{{ Mouse bindings
--root.buttons(awful.util.table.join(
--	awful.button({ }, 3, function () mymainmenu:toggle() end),
--	awful.button({ }, 4, awful.tag.viewnext),
--	awful.button({ }, 5, awful.tag.viewprev)
--))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

	---
	--- Lock screen: Mod+Ctrl+Shift+l
	---
	awful.key({ modkey , "Control", "Shift"}, "l", 
		function(c) 
			awful.util.spawn(CMD_LOCK) 
		end),

	---
	--- Switch Between Tags (Virtual Desktops): Mod+Left, Mod+Right
	---
	awful.key({ modkey, }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey, }, "Right",  awful.tag.viewnext       ),

	---
	--- Switch Between Windows: Mod+j, Mod+k
	---
	awful.key({ modkey, }, "j", switch_client_next),
    awful.key({ modkey, }, "k", switch_client_prev),

	---
	--- Move Window Around Layout: Mod+Shift+j, Mod+Shift+k
	---
    awful.key({ modkey, "Shift"   }, "j", swap_client_next),
    awful.key({ modkey, "Control" }, "j", swap_client_next),
	awful.key({ modkey, "Shift"   }, "k", swap_client_prev),
    awful.key({ modkey, "Control" }, "k", swap_client_prev),

	awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, }, "Tab", function ()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end),

    -- Launch Programs
    awful.key({ modkey, }, "Return", function () 
		awful.util.spawn(TERMINAL) end),

    awful.key({ modkey, "Control" }, "Return", function () 
		awful.util.spawn(BROWSER) end),

	-- Standard Program
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control"   }, "q", awesome.quit),
    awful.key({ modkey, "Control", "Shift"  }, "BackSpace", 
		awesome.quit),

	---
	--- Change Pane Size: Mod+h, Mod+l
	---
    awful.key({ modkey, }, "l", function () awful.tag.incmwfact( 0.03) end),
    awful.key({ modkey, }, "h", function () awful.tag.incmwfact(-0.03) end),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incnmaster(1) end),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incnmaster(-1) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.tag.incncol(1) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.tag.incncol(-1) end),

    -- Mod+space to change layout
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),

	-- Volume
	awful.key({ }, "XF86AudioRaiseVolume", function()
		awful.util.spawn_with_shell("pactl set-sink-mute 1 0 && pactl set-sink-volume 1 -- +5%", false)
	end),
	awful.key({ }, "XF86AudioLowerVolume", function()
		awful.util.spawn_with_shell("pactl set-sink-volume 1 -- -5%", false)
	end),
	awful.key({ }, "XF86AudioMute", function()
		awful.util.spawn_with_shell("pactl set-sink-mute 1 `((pactl list sinks | grep -q Mute:.no > /dev/null) && echo 1) || echo 0`", false)
	end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Alt" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Alt" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientkeys = awful.util.table.join(


	-- Spawn terminal at location
	-- NOTE: Not necessary anymore w/ global binding
    --awful.key({ modkey, }, "o", function(c)
	--	open_terminal_same_cwd(c) end),

    --awful.key({ modkey, }, "Return", function () 
	--	awful.util.spawn(terminal) end),

	-- Toggle fullscreen and floating
    awful.key({ modkey, }, "f", function (c) 
		c.fullscreen = not c.fullscreen  end),
		awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle),

	-- Kill clients
    awful.key({ modkey, "Shift"  }, "c", kill_client),
    awful.key({ modkey, "Control"}, "c", kill_client),
    awful.key({ modkey, "Control"}, "x", kill_clients_on_cur_tag),

	-- Move clients to left/right tags
	awful.key({ modkey, "Control"	}, "Left",  move_client_prev_tag),
	awful.key({ modkey, "Control"	}, "Right", move_client_next_tag),

	-- Show/hide
	awful.key({ modkey, }, "m", hide_client),
    awful.key({ modkey, "Control"}, "m", unminimize_clients_on_cur_tag),

	-- Misc
	awful.key({ modkey, "Shift"  }, "r", function (c) c:redraw() end),
    awful.key({ modkey, }, "t", function (c) 
		c.ontop = not c.ontop end)
)

-- Compute the maximum number of digit we need
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(AWESOME_NUM_TAGS, math.max(#tags[s], keynumber));
end

---
--- Allow mouse to raise (select) window
clientbuttons = awful.util.table.join(
    --awful.button({ }, 1, function() end), -- Left Click
    awful.button({ }, 2, function() end), -- Middle Click
    awful.button({ }, 3, function() end), -- Right Click
    awful.button({ }, 1, function (c) 
		client.focus = c; c:raise() 
	end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

