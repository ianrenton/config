-- Ian Renton's awesomewm config http://ianrenton.com
-- Based on Brandon Thomas' config http://posbl.org
--

--[[ ======================================
			Load Awesome WM Libraries
	 ====================================== --]]

require("awful")			-- Standard awesome library
require("awful.autofocus")
require("awful.rules")
require("beautiful")		-- Theme library
require("naughty")			-- Notification library
require("error") 			-- Error notify (local)


--[[ ======================================
	   		  AWESOME CONFIGURATION
	 ====================================== --]]

AWESOME_NUM_TAGS = 4
AWESOME_FONT = 'Inconsolata 11'
AWESOME_THEME = '/themes/consolation/theme.lua'
AWESOME_CONFDIR  = awful.util.getdir('config')

HOMEDIR  = os.getenv('HOME')
CONFDIR  = awful.util.getdir('config') -- TODO: Deprecate
CMD_LOCK = 'xlock -mode rain'
modkey   = 'Mod1'

TERMINAL = 'xfce4-terminal'
TERMINAL_CWD = 'urxvt -cd'
BROWSER = 'firefox'
BROWSER2 = 'chromium-browser'
EDITOR = os.getenv('EDITOR') or 'vim'
EDITOR_CMD = TERMINAL .. ' -e ' .. EDITOR

BATTERY_NAME = 'sbs_4_000b'


-- Init theme
beautiful.init(AWESOME_CONFDIR .. AWESOME_THEME)

-- Spawn one and only one of these processes
--do
--	local cmds = { 
--		"gnome-sound-applet",
--		"if [ $(pidof nm-applet | wc -w) -eq 0 ]; then nm-applet; fi",
--	}
--	for _,i in pairs(cmds) do
--		awful.util.spawn_with_shell(i)
--	end
--end


-- Table of layouts. 
-- Order matters for awful.layout.inc
-- removed frivolous/redundant ones
layouts =
{
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair.horizontal, 
    awful.layout.suit.fair, 
}

-- Build a tag table which hold all screen tags.
-- Each screen has its own tag table.
tags = {}
for s = 1, screen.count() do
	local table = {}
	table[1] = 'net'
	table[2] = 'mail'
	table[3] = 'code'
	table[4] = 'misc'
  tags[s] = awful.tag(table, s, layouts[1])
end

-- REQUIRE EXTERNAL CONFIGS
require("topbar")
require("keybindings")
require("rules")
require("signals")
