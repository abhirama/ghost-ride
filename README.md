# GhostRide 👻

Browser automation for syndicating blog posts to social media using Claude's Computer Use capability.

## What is GhostRide?

GhostRide is a workflow-based automation tool that uses [Anthropic's Claude](https://www.anthropic.com/claude) with Computer Use capability to automatically create social media drafts from your blog posts. It "ghost-rides" your active Chrome browser session to post on multiple platforms.

## How it works

1. Save your blog post content in `latest-post.txt`
2. Run: `claude --chrome -p "Run the GhostRide routine with post_url: https://your-blog.com/post"`
3. Claude reads the content and creates drafts on:
   - **Twitter/X** (280 character limit with smart truncation)
   - **LinkedIn** (3000 character limit with smart truncation)
   - **Facebook** (full post)

## Features

- ✅ **No code required** - Pure instruction-based automation
- ✅ **Safety first** - Creates drafts only, never auto-publishes
- ✅ **Smart truncation** - Automatically handles character limits while preserving content from the beginning
- ✅ **Session reuse** - Uses your existing authenticated browser sessions
- ✅ **Multi-platform** - One command syndicates to three social networks

## Requirements

- [Claude Code CLI](https://code.claude.com/) with Computer Use capability
- Active Chrome browser with logged-in sessions on Twitter, LinkedIn, and Facebook
- Anthropic API key

## Setup

1. Clone this repository
2. Create `latest-post.txt` with your blog post content
3. Ensure you're logged into Twitter, LinkedIn, and Facebook in Chrome
4. Run the GhostRide routine

## Usage

```bash
claude --chrome -p "Run the GhostRide routine with post_url: https://your-blog.com/your-post"
```

## Configuration

The workflow is defined in `CLAUDE.md`. You can customize:
- Character limits for each platform
- Truncation behavior
- Post format and structure

## Safety

- Drafts are never automatically published
- You maintain full control to review before posting
- Uses existing browser sessions (no credentials stored)

## License

MIT

## Credits

Built with [Claude Code](https://code.claude.com/) by Anthropic.
