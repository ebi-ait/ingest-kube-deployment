#!/bin/sh

inotifywait -mrq -e modify --format '%f' /data/sync/ | while read FILE
do 
    echo "new file [$FILE]!"
done
