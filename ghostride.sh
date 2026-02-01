#!/bin/bash
# GhostRide - Complete blog to social media automation
# Usage: ./ghostride.sh [--link-only] <blog_post_url>

set -e  # Exit on error

# Parse arguments
LINK_ONLY=false
BLOG_URL=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --link-only|-l)
            LINK_ONLY=true
            shift
            ;;
        *)
            BLOG_URL="$1"
            shift
            ;;
    esac
done

# Check if URL is provided
if [ -z "$BLOG_URL" ]; then
    echo "Usage: $0 [--link-only] <blog_post_url>"
    echo ""
    echo "Examples:"
    echo "  $0 https://abhyrama.com/2026/01/28/shades-of-grey/"
    echo "  $0 --link-only https://abhyrama.com/2026/01/28/shades-of-grey/"
    echo ""
    echo "Modes:"
    echo "  Default (full-text): Posts full blog content with images"
    echo "  --link-only: Posts only title and link (no images)"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Set posting mode
if [ "$LINK_ONLY" = true ]; then
    POSTING_MODE="link"
    TOTAL_STEPS=1
else
    POSTING_MODE="full"
    TOTAL_STEPS=3
fi

# Activate virtual environment
source "$SCRIPT_DIR/venv/bin/activate"

echo "🚀 GhostRide: Starting automation for $BLOG_URL"
if [ "$LINK_ONLY" = true ]; then
    echo "   Mode: Link-only (title + URL)"
else
    echo "   Mode: Full-text (with images)"
fi
echo ""

# Step 1: Extract blog text using Trafilatura (hybrid approach)
echo "📝 Step 1/$TOTAL_STEPS: Extracting blog text..."
TEMP_JSON="/tmp/ghostride-$$.json"
TEMP_TEXT="/tmp/ghostride-$$.txt"
TEXT_FILE="$SCRIPT_DIR/latest-post.txt"

# Extract formatted text with proper paragraph spacing
trafilatura -u "$BLOG_URL" --formatting 2>/dev/null > "$TEMP_TEXT"
if [ $? -ne 0 ] || [ ! -s "$TEMP_TEXT" ]; then
    rm -f "$TEMP_TEXT"
    echo "   ✗ Failed to extract text from $BLOG_URL"
    exit 1
fi

# Extract metadata (title) from JSON
trafilatura -u "$BLOG_URL" --json --with-metadata 2>/dev/null > "$TEMP_JSON"
if [ $? -eq 0 ] && [ -s "$TEMP_JSON" ]; then
    # Combine title from JSON with formatted text
    python3 <<EOF > "$TEXT_FILE"
import json

with open('$TEMP_JSON', 'r') as f:
    data = json.load(f)

title = data.get('title', '')

# Write title on first line, then blank line, then formatted content
if title:
    print(title)
    print()  # Blank line

with open('$TEMP_TEXT', 'r') as f:
    print(f.read(), end='')
EOF

    rm -f "$TEMP_JSON" "$TEMP_TEXT"
    WORD_COUNT=$(wc -w < "$TEXT_FILE")
    TITLE=$(head -1 "$TEXT_FILE")
    echo "   ✓ Extracted \"$TITLE\" ($WORD_COUNT words)"
else
    rm -f "$TEMP_JSON" "$TEMP_TEXT"
    echo "   ✗ Failed to extract metadata from $BLOG_URL"
    exit 1
fi

# Steps 2 & 3: Screenshot and clipboard (only for full-text mode)
if [ "$LINK_ONLY" = false ]; then
    # Step 2: Capture blog screenshot
    echo "📸 Step 2/3: Capturing blog screenshot..."
    SCREENSHOT_FILE="$SCRIPT_DIR/blog-screenshot.png"
    "$SCRIPT_DIR/capture-blog.sh" "$BLOG_URL" "$SCREENSHOT_FILE"
    if [ $? -eq 0 ]; then
        echo "   ✓ Screenshot saved to $SCREENSHOT_FILE"
    else
        echo "   ✗ Failed to capture screenshot"
        exit 1
    fi

    # Step 3: Copy screenshot to clipboard for easy pasting
    echo "📋 Step 3/3: Copying screenshot to clipboard..."
    osascript -e "set the clipboard to (read (POSIX file \"$SCREENSHOT_FILE\") as «class PNGf»)" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "   ✓ Screenshot copied to clipboard (ready to paste with Cmd+V)"
    else
        echo "   ⚠ Could not copy to clipboard, but screenshot file is available"
    fi
fi

echo ""
echo "✅ GhostRide preparation complete!"
echo ""
echo "🚀 Launching Claude to create social media drafts..."
echo ""

# Launch Claude immediately to prevent clipboard contamination
claude --chrome -p "$(cat "$SCRIPT_DIR/ROUTINES/ghostride.md")

posting_mode: $POSTING_MODE
post_url: $BLOG_URL"
