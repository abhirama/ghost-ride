# GhostRide 👻
**Project:** Browser automation for syndicating blog posts to social media.
**Mechanism:** Uses Claude's "Computer Use" / Browser capability to ghost-ride the active Chrome session.

## ⚡️ Workflow: The GhostRide Routine

**Trigger:** User runs `claude --chrome -p "Run the GhostRide routine..."`
**Inputs:**
1. Content Source: `latest-post.txt` (Local file containing the blog text)
2. Link Source: `post_url` (Provided in the prompt/command line)

### Step-by-Step Instructions for Claude:

1.  **PREPARATION PHASE**
    * Read the content of `latest-post.txt`.
    * Construct the **Social Post String**:
        > "Read this post on my blog at [post_url]"
        > [Two Newlines]
        > [Content from latest-post.txt]

2.  **EXECUTION PHASE (Browser Actions)**
    * **IMPORTANT:** Do not close existing tabs. Open new tabs for each action.
    * **IMPORTANT:** Do not submit/publish automatically. Only draft.

    **Action A: Twitter/X**
    * Open new tab: `https://twitter.com/compose/tweet`
    * Wait for the compose box.
    * **Length Check:** If the full *Social Post String* exceeds 280 characters:
      - **ALWAYS start from the beginning** - Keep the URL line first
      - Add the two newlines after the URL
      - Add content from the beginning of the text (do NOT skip paragraphs or pick from the middle)
      - Truncate by cutting off text from the END when approaching the 280-char limit
      - Add "..." at the very end to indicate truncation
      - Example format: "Read this post at [URL]\n\n[First lines of content]..."
    * If the full post is under 280 characters, paste the complete *Social Post String* without modification.
    * *Status:* Draft Only.

    **Action B: LinkedIn**
    * Open new tab: `https://linkedin.com/feed`
    * Click "Start a post" (or equivalent button).
    * **Length Check:** If the full *Social Post String* exceeds 3000 characters:
      - **ALWAYS start from the beginning** - Keep the URL line first
      - Add the two newlines after the URL
      - Add content from the beginning of the text (do NOT skip paragraphs or pick from the middle)
      - Truncate by cutting off text from the END when approaching the 3000-char limit
      - Add "..." at the very end to indicate truncation
      - Example format: "Read this post at [URL]\n\n[Content from beginning]..."
    * If the full post is under 3000 characters, paste the complete *Social Post String* without modification.
    * *Status:* Draft Only.

    **Action C: Facebook**
    * Open new tab: `https://facebook.com`
    * Wait for the page to fully load (look for the main feed).
    * Look for and click the status update composer. This may appear as:
      - "What's on your mind?" text input
      - "What's on your mind, [Name]?" placeholder
      - A white text box at the top of the feed
      - "Create post" button or area
    * If the composer doesn't expand into a modal/dialog, click again to ensure it's active.
    * Once the text input area is active and ready, paste the full *Social Post String*.
    * Verify the text appears in the composer.
    * *Status:* Draft Only.

3.  **COMPLETION PHASE**
    * Bring the browser window to the foreground.
    * Report back to the terminal: "Drafts created. Please review and publish."

## 🛡️ Safety & Guidelines
- **No Auto-Publish:** Never click the final "Post", "Tweet", or "Publish" button. Always stop at the drafting stage.
- **Session Piggybacking:** Use the existing authenticated session. Do not attempt to log in; if logged out, stop and alert the user.
- **Focus:** If the browser loses focus or the selector isn't found, ask the user for help rather than hallucinating a click.
- **Facebook Troubleshooting:** If the composer doesn't appear after clicking:
  - Try scrolling to the top of the page
  - Look for alternative entry points like "Create post" buttons in the left sidebar
  - Check if a modal dialog opened that needs to be clicked into
  - Report to the user if the composer cannot be found and describe what you see instead
