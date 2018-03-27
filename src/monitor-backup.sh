#!/bin/sh

while inotifywait -e modify /data/sync; do 
    echo 'new file!'
done
