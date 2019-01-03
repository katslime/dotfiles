#!/bin/sh
# Simple Bash Uploader (simple-bash-upload.sh)
#   by kei - https://kei.a52.io/

#   This will upload a file/screenshot to a server of your choice and automatically copy you the direct link to it.
#   Supports regular file uploading + full-screen, active window and selected area screenshots.

#   Usage: simple-bash-upload.sh [full|active|selection|filename.ext]
#   Can be used directly from console to upload files (./simple-bash-upload.sh file.png) or assigned to a custom action in Thunar (./simple-bash-upload.sh %f)
#   Can also be bound to run on certain keypresses such as print screen, alt+print screen and ctrl+print screen.

# Dependencies:
#   scrot (for screenshotting)
#   xclip (for copying the link to your clipboard)
#   libnotify (for notifying you of the uploads)


# Xfce4 keyboard shortcut fixes (selection mode doesn't work without these)
sleep 0.1
export DISPLAY=:0.0

# Configuration Options:
UPLOAD_SERVICE="katsli.me"

RANDOM_FILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
IMAGE_PATH="/home/$USER/Pictures/Screenshots/$RANDOM_FILENAME.png"

REMOTE_USER="kat"
REMOTE_SERVER="katsli.me"
REMOTE_PORT="22"
REMOTE_PATH="/var/www/katsli.me/i/"
REMOTE_URL="https://katsli.me/i/"

if [ "$1" == "full" ]; then
  MODE=""
elif [ "$1" == "active" ]; then
  MODE="-u"
elif [ "$1" == "selection" ]; then
  MODE="-s"
else
    FILE_PATH=$1
    FILE_NAME=$(basename $FILE_PATH)
    FILE_EXT=".${FILE_NAME##*.}"
    notify-send "$UPLOAD_SERVICE" "Upload of file '$RANDOM_FILENAME$FILE_EXT' started."

    scp -P $REMOTE_PORT $FILE_PATH $REMOTE_USER@$REMOTE_SERVER:$REMOTE_PATH$RANDOM_FILENAME$FILE_EXT
    if [ $? -eq 0 ];
    then
        echo -n $REMOTE_URL$RANDOM_FILENAME$FILE_EXT|xclip -sel clip
        notify-send "$UPLOAD_SERVICE" $REMOTE_URL$RANDOM_FILENAME$FILE_EXT
    else
        notify-send "$UPLOAD_SERVICE" "Upload failed!"
    fi
    exit
fi

scrot $MODE -z $IMAGE_PATH || exit
notify-send "$UPLOAD_SERVICE" "Upload of screenshot '$RANDOM_FILENAME.png' started."

scp -P $REMOTE_PORT $IMAGE_PATH $REMOTE_USER@$REMOTE_SERVER:$REMOTE_PATH
if [ $? -eq 0 ];
then
    echo -n "$REMOTE_URL$RANDOM_FILENAME.png"|xclip -sel clip
    notify-send "$UPLOAD_SERVICE" "$REMOTE_URL$RANDOM_FILENAME.png"
else
    notify-send "$UPLOAD_SERVICE" "Upload failed!"
fi
                
