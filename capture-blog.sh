#!/bin/bash
# Helper script to capture blog post screenshots using shot-scraper
# Usage: ./capture-blog.sh <blog_post_url> [output_file]

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <blog_post_url> [output_file]"
    echo "Example: $0 https://abhyrama.com/2026/01/28/shades-of-grey/ screenshot.png"
    exit 1
fi

# Set variables
BLOG_URL="$1"
OUTPUT_FILE="${2:-/tmp/blog-screenshot.png}"

# Activate virtual environment
source "$(dirname "$0")/venv/bin/activate"

# Run shot-scraper with cleanup
echo "Capturing screenshot of: $BLOG_URL"
shot-scraper "$BLOG_URL" \
  -s 'article' \
  --padding 20 \
  --javascript "
    // Hide share buttons, related posts, footer, and comments
    document.querySelectorAll('.sharedaddy, .jp-relatedposts, .entry-footer, #respond').forEach(el => el.style.display = 'none');
    // Hide wpDiscuz inline comment overlays
    document.querySelectorAll('.wpd-inline-shortcode, .wpd-inline-icon-wrapper, .wpd-inline-form-wrapper, .wpd-inline-opened, .wpd-inline-closed').forEach(el => el.style.display = 'none');
  " \
  -o "$OUTPUT_FILE" \
  --retina

# Check if successful
if [ $? -eq 0 ]; then
    echo "✓ Screenshot saved to: $OUTPUT_FILE"
    ls -lh "$OUTPUT_FILE"
else
    echo "✗ Failed to capture screenshot"
    exit 1
fi
