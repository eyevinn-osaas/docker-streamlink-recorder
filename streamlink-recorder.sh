#!/bin/bash

# For more information visit: https://github.com/downthecrop/TwitchVOD

echo "Starting Streamlink Recorder with:"
echo "Stream options: $streamOptions"
echo "Stream link: $streamLink"
echo "Stream quality: $streamQuality"
echo "Stream name: $streamName"

IFS=';' read -r -a args <<< "$streamOptions"

while [ true ]; do
	Date=$(date +%Y%m%d-%H%M%S)
	streamlink "${args[@]}" "$streamLink" "$streamQuality" -o /home/download/"$streamName"-"$Date".mkv
	sleep 60s
done
