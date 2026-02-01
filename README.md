# GhostRide 👻

Browser automation for syndicating blog posts to social media using Claude's Computer Use capability.

## What is GhostRide?

GhostRide is a workflow-based automation tool that uses [Anthropic's Claude](https://www.anthropic.com/claude) with Computer Use capability to automatically create social media drafts from your blog posts. It "ghost-rides" your active Chrome browser session to post on multiple platforms.

## How it works

1. **Publish** your blog post to WordPress
2. **Run** one command: `./ghostride.sh https://your-blog.com/your-post`
3. **GhostRide automatically**:
   - Extracts blog title and text from WordPress using Trafilatura
   - Captures a clean screenshot using shot-scraper (removes ads, comments, share buttons)
   - Copies screenshot to clipboard for pasting
   - Launches Claude with Computer Use to create drafts
4. **Review and publish** the drafts on:
   - **Twitter/X**: Screenshot image with "[Title] - Read at [URL]" caption
   - **LinkedIn**: Full text with smart truncation at 3000 characters
   - **Facebook**: Full text with smart truncation at 63,206 characters

**Behind the scenes:**
- Text saved to `latest-post.txt` (in project directory, ignored by git)
- Screenshot saved to `blog-screenshot.png` and clipboard
- Claude reads the text file and pastes the image from clipboard
- All drafts are created but NOT published (you review first)

## Features

- ✅ **Fully automated** - One command does everything, auto-launches Claude (no manual steps)
- ✅ **WordPress integration** - Extracts title and content using Trafilatura
- ✅ **Clean screenshots** - Removes WordPress actionbar, share buttons, comments, footer
- ✅ **Safety first** - Creates drafts only, never auto-publishes
- ✅ **Image posts for Twitter** - Uses screenshot via clipboard paste (no file picker issues)
- ✅ **Smart truncation** - Handles character limits (Twitter N/A, LinkedIn 3000, Facebook 63,206) with "[Read the full post on my blog]" suffix
- ✅ **Session reuse** - Uses your existing authenticated browser sessions
- ✅ **Multi-platform** - One command syndicates to three social networks
- ✅ **Clipboard security** - Auto-run prevents clipboard contamination from passwords
- ✅ **Local files** - Text and screenshot stored in project directory (excluded from git)

## Requirements

- [Claude Code CLI](https://code.claude.com/) with Computer Use capability
- Python 3.8+ with virtual environment
- Active Chrome browser with logged-in sessions on Twitter, LinkedIn, and Facebook
- Anthropic API key
- macOS (for clipboard functionality)

## Setup

1. Clone this repository
2. Install dependencies:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   shot-scraper install
   ```
3. Ensure you're logged into Twitter, LinkedIn, and Facebook in Chrome

## Usage

```bash
./ghostride.sh https://your-blog.com/your-post
```

That's it! GhostRide will automatically:
- Extract your blog text
- Capture a screenshot
- Launch Claude to create drafts on all three platforms

## Configuration

The workflow is defined in `CLAUDE.md`. You can customize:
- Character limits for each platform
- Truncation behavior
- Post format and structure

## Safety & Security

**Publishing safety:**
- Drafts are never automatically published
- You maintain full control to review before posting
- Uses existing browser sessions (no credentials stored)

**Clipboard security:**
- Auto-run mode launches Claude immediately after screenshot copy
- No timing gap for clipboard contamination (passwords, sensitive data)
- Manual mode removed as it was fundamentally insecure

**Data privacy:**
- Both text and screenshot stored locally but excluded from git
- No temporary files or data persisted in system directories
- Blog content only used for social media draft creation
