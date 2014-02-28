if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi
xfsettingsd &
sh .fehbg &
xscreensaver &
xfce4-power-manager &
volumeicon &
#owncloud &
xfce4-terminal &
firefox & 
exec dbus-launch --exit-with-session --sh-syntax awesome
#exec /usr/bin/WindowMaker
#exec unity
