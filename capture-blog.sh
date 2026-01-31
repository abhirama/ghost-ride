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
OUTPUT_FILE="${2:-blog-screenshot.png}"

# Activate virtual environment
source "$(dirname "$0")/venv/bin/activate"

# Run shot-scraper with cleanup
# Using wider viewport (1200px) to reduce height and fit Twitter's aspect ratio (max 1:2)
echo "Capturing screenshot of: $BLOG_URL"
shot-scraper "$BLOG_URL" \
  -s 'article' \
  --width 1600 \
  --padding 20 \
  --wait 3000 \
  --javascript "
    // Force article to be wider for better Twitter aspect ratio
    const article = document.querySelector('article');
    if (article) {
      article.style.maxWidth = '1600px';
      article.style.width = '1600px';
    }
    // Remove actionbar (WordPress comment overlay)
    const actionbar = document.getElementById('actionbar');
    if (actionbar) actionbar.remove();
    document.querySelectorAll('[class*=\"actnbr\"]').forEach(el => el.remove());
    // Remove other WordPress elements
    document.querySelectorAll('.sharedaddy, .jp-relatedposts, .entry-footer, #respond').forEach(el => el.remove());
  " \
  -o "$OUTPUT_FILE" \
  --scale-factor 1.5

# Check if successful
if [ $? -eq 0 ]; then
    echo "✓ Screenshot saved to: $OUTPUT_FILE"
    ls -lh "$OUTPUT_FILE"
else
    echo "✗ Failed to capture screenshot"
    exit 1
fi
