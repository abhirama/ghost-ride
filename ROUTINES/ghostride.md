# GhostRide Routine

**Task:** Create social media drafts from a blog post on Twitter, LinkedIn, and Facebook.

**Inputs:**
1. Content Source: `latest-post.txt` (blog title and text)
2. Link Source: `post_url` (blog post URL)
3. Posting Mode: `posting_mode` (either `full` or `link`)
4. Screenshot: `blog-screenshot.png` (in clipboard, only available when `posting_mode` is `full`)

## Step-by-Step Instructions

### 1. PREPARATION PHASE

* Read the **Title** from the first line of `latest-post.txt` in the project directory.

**If `posting_mode` is `link`:**
* Construct the **Post Content** as:
    > [Title]
    > [Blank line]
    > [post_url]

**If `posting_mode` is `full`:**
* Read the **entire content** of `latest-post.txt` (includes title on line 1, blank line, then article text).
* Construct the **Social Post String**:
    > "Read this post on my blog at [post_url]"
    > [Two Newlines]
    > [Entire content from latest-post.txt including the title]

### 2. EXECUTION PHASE (Browser Actions)

* **IMPORTANT:** Do not close existing tabs. Open new tabs for each action.
* **IMPORTANT:** Do not submit/publish automatically. Only draft.

**Action A: Twitter/X**
* Open new tab: `https://twitter.com/compose/tweet`
* Wait for the compose box to appear.
* Click inside the compose text area to focus it.

**If `posting_mode` is `link`:**
* Type the **Post Content**:
  - Format: "[Title]\n\n[post_url]"
  - Example: "Vroom Vroom: Performance Engineering from First Principles\n\nhttps://abhyrama.com/2026/01/28/vroom-vroom/"
* *Status:* Draft Only. Do NOT click Tweet/Post.

**If `posting_mode` is `full`:**
* **CRITICAL**: Paste from clipboard using Cmd+V (or Ctrl+V).
  - **DO NOT click any upload buttons or file pickers**
  - **DO NOT use any alternative image upload methods**
  - **ONLY use Cmd+V to paste from clipboard**
* **VERIFY**: Check if an image preview appears in the compose area.
  - ✅ If image preview appears: Proceed to next step
  - ⚠️ If text appears instead of image: **STOP IMMEDIATELY**
    - Alert the user: "Clipboard contains text, not an image. This may be sensitive data. Please run ghostride.sh again."
    - Do NOT proceed with posting
    - Close the tab
  - ⚠️ If nothing appears after pasting: **STOP IMMEDIATELY**
    - Alert the user: "Clipboard paste failed. The screenshot may not be in clipboard. Please run ghostride.sh again."
    - Do NOT try file picker or other upload methods
    - Close the tab
* Wait for the image to fully upload and render.
* In the text field above or below the image, type the caption:
  - Format: "[Title] - Read at [post_url]"
  - Example: "Code is the new assembly - Read at https://abhyrama.com/2026/01/22/code-is-the-new-assembly/"
* *Status:* Draft Only. Do NOT click Tweet/Post.

**Action B: LinkedIn**
* Open new tab: `https://linkedin.com/feed`
* Click "Start a post" (or equivalent button).
* Wait for the text composer to appear.

**If `posting_mode` is `link`:**
* Type the **Post Content**:
  - Format: "[Title]\n\n[post_url]"
  - Example: "Vroom Vroom: Performance Engineering from First Principles\n\nhttps://abhyrama.com/2026/01/28/vroom-vroom/"
* *Status:* Draft Only.

**If `posting_mode` is `full`:**
* **Determine what to post:**
  - If the *Social Post String* is under 3000 characters: Use it as-is
  - If it exceeds 3000 characters: Create a truncated version by:
    1. Starting with "Read this post on my blog at [post_url]"
    2. Adding two newlines
    3. Adding text from the beginning of latest-post.txt content
    4. Stopping when approaching 3000 characters
    5. Ending with "... [Read the full post on my blog]"
* **Paste once** - Paste the determined content (either full or truncated) into the composer.
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
* Wait for the text input area to be ready.

**If `posting_mode` is `link`:**
* Type the **Post Content**:
  - Format: "[Title]\n\n[post_url]"
  - Example: "Vroom Vroom: Performance Engineering from First Principles\n\nhttps://abhyrama.com/2026/01/28/vroom-vroom/"
* Verify the text appears in the composer.
* *Status:* Draft Only.

**If `posting_mode` is `full`:**
* **Determine what to post:**
  - If the *Social Post String* is under 63,206 characters: Use it as-is
  - If it exceeds 63,206 characters: Create a truncated version by:
    1. Starting with "Read this post on my blog at [post_url]"
    2. Adding two newlines
    3. Adding text from the beginning of latest-post.txt content
    4. Stopping when approaching 63,206 characters
    5. Ending with "... [Read the full post on my blog]"
* **Paste once** - Paste the determined content (either full or truncated) into the composer.
* Verify the text appears in the composer.
* *Status:* Draft Only.

### 3. COMPLETION PHASE

* Bring the browser window to the foreground.
* Report back to the terminal: "Drafts created. Please review and publish."

## Safety & Guidelines

- **No Auto-Publish:** Never click the final "Post", "Tweet", or "Publish" button. Always stop at the drafting stage.
- **Session Piggybacking:** Use the existing authenticated session. Do not attempt to log in; if logged out, stop and alert the user.
- **Focus:** If the browser loses focus or the selector isn't found, ask the user for help rather than hallucinating a click.
- **Facebook Troubleshooting:** If the composer doesn't appear after clicking:
  - Try scrolling to the top of the page
  - Look for alternative entry points like "Create post" buttons in the left sidebar
  - Check if a modal dialog opened that needs to be clicked into
  - Report to the user if the composer cannot be found and describe what you see instead
