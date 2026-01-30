# Blog Screenshot Tool

Helper script to capture clean screenshots of blog posts for social media sharing.

## Setup (One-time)

```bash
# Install dependencies
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
shot-scraper install
```

## Usage

```bash
# Capture screenshot (saves to /tmp/blog-screenshot.png by default)
./capture-blog.sh https://abhyrama.com/2026/01/28/shades-of-grey/

# Specify custom output file
./capture-blog.sh https://abhyrama.com/2026/01/28/shades-of-grey/ my-screenshot.png
```

## What Gets Captured

The script captures:
- ✅ Article title and metadata (author/date)
- ✅ Full blog post content
- ✅ 20px white padding around edges
- ✅ Retina/high-DPI quality (2x resolution)

And automatically removes:
- ❌ Share buttons (.sharedaddy)
- ❌ Related posts section (.jp-relatedposts)
- ❌ Tags/categories footer (.entry-footer)
- ❌ Comment reply box (#respond)

## Technical Details

Uses [shot-scraper](https://shot-scraper.datasette.io/) built on Playwright to:
1. Navigate to the blog URL
2. Select the `article` element
3. Hide unwanted UI elements via JavaScript
4. Capture a retina-quality screenshot
