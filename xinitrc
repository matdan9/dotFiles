#!/bin/sh

# Set monitor variables
mainMonitor=HDMI-0
secMonitor=DP-0

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
# setxkbmap -layout 'us,ca' -variant ',fr' -option 'grp:ctrl_alt_toggle,grp_led:num'

# Change keyboar layout with Ctrl + Alt
# setxkbmap -option 'grp:ctrl_alt_toggle'

# Allow transparancy
# exec picom -f &

# xrandr --output hdmi-0 --mode 1920x1080 --pos 0x0 --rotate normal --rate 119.98 --output dp-0 --primary --mode 3840x2160 --pos 0x1080 --rotate normal --rate 143.99

# Wall paper
feh --bg-scale "/home/matdan/Pictures/$(ls ~/Pictures | shuf -n 1)"

# adding a clock to DWM
while true; do
	xsetroot -name "$(date)"
	sleep 1s
done &

# exec i3
exec i3

