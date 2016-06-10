
xrdb -load ~/.Xresources




xset s off &
xset -dpms &
xset s noblank &

#feh -FD600 --bg-fill /home/#{user}/Pictures
feh --bg-max --randomize --bg-fill /home/#{user}/Pictures/*

exec i3
