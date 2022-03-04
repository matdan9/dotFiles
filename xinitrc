#!/bin/sh

mainMonitor=DP-2
secMonitor=DP-5

# Multiple monitors
xrandr --output DVI-D-0 --off --output HDMI-0 --off --output DP-0 --off --output DP-1 --off --output $mainMonitor --primary --mode 1920x1080 --pos 1920x0 --rotate normal --rate 144.00 --output $secMonitor --off --output DP-4 --off --output DP-5 --mode 1920x1080 --pos 0x0 --rotate normal --rate 60.00

# Set mouse settings
# xset m 1 1
xinput --set-prop 10 'libinput Accel Profile Enabled' 0, 1
xinput --set-prop 8 'libinput Accel Profile Enabled' 0, 1
# xinput --set-prop 9 'libinput Accel Profile Enabled' 0, 1
# xinput --set-prop 9 'libinput Accel Profile Enabled' 0, 1
xset mouse 3 3

# Set keyboard key repeat
xset r rate 200 30

# Set keyboard layout
setxkbmap -layout 'us,ca' -variant ',fr' -option 'grp:ctrl_alt_toggle,grp_led:num'

# Change keyboar layout with Ctrl + Alt
setxkbmap -option 'grp:ctrl_alt_toggle'

# Allow transparancy
exec picom -f &

# Wall paper
feh --bg-scale ~/Pictures/wallpaper.jpg

# adding a clock to DWM
while true; do
	xsetroot -name "$(date)"
	sleep 1s
done &

exec dwm
