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
    // Force PARENT containers and article to full width
    const article = document.querySelector('article');
    if (article) {
      // First, expand all parent containers
      document.querySelectorAll('#content-wrapper, .content-wrapper, #content, .site-content, #primary, .content-area, #main, .site-main').forEach(el => {
        el.style.maxWidth = 'none';
        el.style.width = '100%';
      });

      // Set article to full width
      article.style.maxWidth = 'none';
      article.style.width = '100%';
      article.style.margin = '0';
      article.style.padding = '20px';

      // CAP HEIGHT for Twitter: Max height for 3:4 ratio (prevents mobile cropping)
      // Target: 3200px final (at 1.5x scale) = 2133px viewport, minus padding
      const MAX_HEIGHT = 2000;
      article.style.maxHeight = MAX_HEIGHT + 'px';
      article.style.overflow = 'hidden';

      // Aggressively remove ALL width/max-width constraints from article children
      article.querySelectorAll('*').forEach(el => {
        el.style.maxWidth = 'none';
        el.style.minWidth = 'auto';
      });

      // Force block-level containers to full width
      article.querySelectorAll('header, div, section, .entry-header, .entry-content, .entry-meta').forEach(el => {
        el.style.width = '100%';
        el.style.maxWidth = 'none';
      });

      // Ensure title is full width and wraps properly
      const title = article.querySelector('.entry-title, h1');
      if (title) {
        title.style.width = '100%';
        title.style.maxWidth = 'none';
        title.style.whiteSpace = 'normal';
        title.style.overflow = 'visible';
        title.style.textOverflow = 'clip';
      }

      // Reset images and figures to not stretch
      article.querySelectorAll('img, figure').forEach(el => {
        el.style.width = 'auto';
        el.style.maxWidth = '100%';
        el.style.height = 'auto';
      });
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
