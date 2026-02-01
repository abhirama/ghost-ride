# GhostRide 👻

**Project:** Browser automation for syndicating blog posts to social media.
**Mechanism:** Uses Claude's "Computer Use" / Browser capability to ghost-ride the active Chrome session.

**Note:** See `TOOLS.md` for shot-scraper and trafilatura CLI reference when debugging or modifying capture scripts.

## 🔧 Preparation (One-Time Setup)

Before running GhostRide for the first time:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
shot-scraper install
```

## 🚀 Quick Start

When you publish a new blog post to WordPress:
```bash
./ghostride.sh https://abhyrama.com/your-new-post-url/
```

This will automatically:
1. Extract blog text using Trafilatura → `latest-post.txt`
2. Capture clean screenshot → `blog-screenshot.png`
3. Copy screenshot to clipboard
4. Launch Claude to create social media drafts

**Why auto-run?**
- Prevents clipboard security issues (no chance to copy passwords/sensitive data)
- No timing gap between preparation and execution
- One command does everything

## 📁 Code Structure

### Shell Scripts

**`ghostride.sh`** - Main automation script
- Extracts blog text with Trafilatura (hybrid: `--formatting` for text + `--json` for metadata)
- Captures screenshot with shot-scraper via `capture-blog.sh`
- Copies screenshot to clipboard (macOS `osascript`)
- Launches Claude with the GhostRide routine

**`capture-blog.sh`** - Screenshot helper
- Uses shot-scraper to capture clean blog screenshots
- Removes WordPress cruft (actionbar, share buttons, comments)
- Optimized dimensions for Twitter (1600px width, scale-factor 1.5)

### Generated Files

- `latest-post.txt` - Extracted blog content (title + formatted text with paragraph spacing)
- `blog-screenshot.png` - Screenshot for Twitter image posts

Both files are in `.gitignore` and excluded from version control.

## 🤖 Routines

Execution instructions for Claude live in `ROUTINES/` as self-contained Markdown files.

**`ROUTINES/ghostride.md`** - The main social media posting routine
Contains step-by-step browser automation instructions for:
- Twitter (image post with clipboard paste)
- LinkedIn (text post with 3000 char truncation)
- Facebook (text post with 63,206 char truncation)

The `ghostride.sh` script loads this routine and passes it to Claude along with the blog post URL:
```bash
claude --chrome -p "$(cat ROUTINES/ghostride.md)

post_url: $BLOG_URL"
```

This separation keeps development context (this file) separate from execution instructions (ROUTINES/).
