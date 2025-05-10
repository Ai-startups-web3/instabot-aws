#!/bin/bash

# Check dependencies
if ! command -v yt-dlp &> /dev/null; then
    echo "Installing yt-dlp and dependencies..."
    sudo apt-get update
    sudo apt-get install -y ffmpeg
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
fi

# Check URL
if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube-URL> [optional-cookies-file] [optional-output-name]"
    echo "Example: $0 'https://youtu.be/xyz' cookies.txt myVideo"
    exit 1
fi

# Inputs
YOUTUBE_URL="$1"
COOKIES_FILE="${2:-cookies.txt}"                         # default: cookies.txt
VIDEO_NAME="${3:-videoToPost}"                           # default: videoToPost
OUTPUT_DIR="insta-bot/assets/input"
OUTPUT_FILE="$OUTPUT_DIR/${VIDEO_NAME}.mp4"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Methods array (each method will be tried in sequence)
download_methods=()

# Method 1: with cookies (if exists)
if [ -f "$COOKIES_FILE" ]; then
    download_methods+=("--cookies '$COOKIES_FILE'")
fi

# Method 2: standard download
download_methods+=("")

# Method 3: spoofed user-agent and referer
download_methods+=("--user-agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)' --referer 'https://www.youtube.com/'")

# Try each method
for method in "${download_methods[@]}"; do
    echo "🔄 Trying download with method: $method"
    eval yt-dlp \
        -f "'bestvideo[height<=1080]+bestaudio/best[height<=1080]'" \
        --merge-output-format mp4 \
        --no-playlist \
        --output "$OUTPUT_FILE" \
        $method \
        "$YOUTUBE_URL"

    if [ $? -eq 0 ]; then
        echo "✅ Successfully downloaded video as $OUTPUT_FILE"
        exit 0
    fi
done

# Final fallback
echo "⚠️ All main methods failed. Trying fallback (worst quality)..."
yt-dlp \
    -f "'worstvideo+worstaudio/worst'" \
    --merge-output-format mp4 \
    --no-playlist \
    --output "$OUTPUT_FILE" \
    "$YOUTUBE_URL"

if [ $? -eq 0 ]; then
    echo "✅ Downloaded fallback low quality version: $OUTPUT_FILE"
else
    echo "❌ All download attempts failed!"
    echo "Trying one last time with default settings..."
    yt-dlp \
        --merge-output-format mp4 \
        --no-playlist \
        --output "$OUTPUT_FILE" \
        "$YOUTUBE_URL"
    
    if [ $? -eq 0 ]; then
        echo "✅ Downloaded with default settings: $OUTPUT_FILE"
    else
        echo "❌ All download attempts failed!"
        exit 1
    fi
fi