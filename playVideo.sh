#!/usr/bin/env bash

#youtube-dl -f worst[ext=mp4] -q -o- https://www.youtube.com/watch?v=Ct6BUPvE2sM | mplayer -framedrop -lavdopts threads=4 -vf scale -zoom -xy 320 -fs -cache 8192 - > ~/mplayer.log 2>&1
mplayer -framedrop -lavdopts threads=4 -vf scale -zoom -xy 320 -fs -cache 8192 -cookies -cookies-file ~/clockTube/cookie.txt $(youtube-dl -f worst[ext=mp4] -g --cookies ~/clockTube/cookie.txt "$*") > ~/mplayer.log 2>&1
