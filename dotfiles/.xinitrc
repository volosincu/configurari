
xrdb -load ~/.Xresources

xset b off
xset b 0 0 0

xset s off &
xset -dpms &
xset s noblank &

#feh -FD600 --bg-fill /home/#{user}/Pictures
feh --bg-max --randomize --bg-fill /home/#{user}/Pictures/*

exec i3
