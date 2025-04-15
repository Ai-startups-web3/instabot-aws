#!/bin/bash

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp not found! Installing..."
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
fi

# YouTube video URL
YOUTUBE_URL=$1

# Check if URL is provided
if [ -z "$YOUTUBE_URL" ]; then
    echo "Usage: $0 <YouTube-Video-URL>"
    exit 1
fi

# Download video as videoToPost.mp4
echo "Downloading video..."
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" -o "videoToPost.mp4" "$YOUTUBE_URL"

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "Download completed! Saved as videoToPost.mp4"
else
    echo "Download failed!"
    exit 1
fi
