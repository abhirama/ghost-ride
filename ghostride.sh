#!/bin/bash
# GhostRide - Complete blog to social media automation
# Usage: ./ghostride.sh <blog_post_url>

set -e  # Exit on error

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <blog_post_url>"
    echo "Example: $0 https://abhyrama.com/2026/01/28/shades-of-grey/"
    exit 1
fi

BLOG_URL="$1"
SCRIPT_DIR="$(dirname "$0")"

# Activate virtual environment
source "$SCRIPT_DIR/venv/bin/activate"

echo "🚀 GhostRide: Starting automation for $BLOG_URL"
echo ""

# Step 1: Extract blog text using Trafilatura
echo "📝 Step 1/2: Extracting blog text..."
trafilatura -u "$BLOG_URL" > "$SCRIPT_DIR/latest-post.txt"
if [ $? -eq 0 ]; then
    WORD_COUNT=$(wc -w < "$SCRIPT_DIR/latest-post.txt")
    echo "   ✓ Extracted $WORD_COUNT words to latest-post.txt"
else
    echo "   ✗ Failed to extract text from $BLOG_URL"
    exit 1
fi

# Step 2: Capture blog screenshot
echo "📸 Step 2/3: Capturing blog screenshot..."
"$SCRIPT_DIR/capture-blog.sh" "$BLOG_URL" /tmp/blog-screenshot.png
if [ $? -eq 0 ]; then
    echo "   ✓ Screenshot saved to /tmp/blog-screenshot.png"
else
    echo "   ✗ Failed to capture screenshot"
    exit 1
fi

# Step 3: Copy screenshot to clipboard for easy pasting
echo "📋 Step 3/3: Copying screenshot to clipboard..."
osascript -e 'set the clipboard to (read (POSIX file "/tmp/blog-screenshot.png") as «class PNGf»)' 2>/dev/null
if [ $? -eq 0 ]; then
    echo "   ✓ Screenshot copied to clipboard (ready to paste with Cmd+V)"
else
    echo "   ⚠ Could not copy to clipboard, but screenshot file is available"
fi

echo ""
echo "✅ GhostRide preparation complete!"
echo ""
echo "Next steps:"
echo "1. Review the extracted content in: latest-post.txt"
echo "2. Review the screenshot at: /tmp/blog-screenshot.png"
echo "3. Run: claude --chrome -p \"Run the GhostRide routine with post_url: $BLOG_URL\""
echo ""
echo "👻 Ready to ghost-ride!"
