# CLI Tools Knowledge (Source-Code Verified)

> This reference was extracted directly from source code analysis, not documentation.
> Use as authoritative reference for Claude Code sessions.

---

## shot-scraper

**What it is**: Playwright-based CLI for screenshots and JS execution  
**Install**: `pip install shot-scraper && shot-scraper install`

### Commands (from cli.py)

| Command | Purpose |
|---------|---------|
| `shot` | Screenshot (default command) |
| `javascript` | Execute JS, return JSON |
| `pdf` | Save page as PDF |
| `har` | Record HTTP archive |
| `html` | Output rendered HTML |
| `multi` | Batch from YAML config |
| `auth` | Save login session |
| `accessibility` | Dump accessibility tree |
| `install` | Install Playwright browser |

### shot (screenshot) - Complete Flags

```
shot-scraper [URL] [OPTIONS]

Output:
  -o, --output FILE        Output file (default: url-based.png)
  -o -                     Output to stdout

Viewport:
  -w, --width INT          Browser width (default: 1280)
  -h, --height INT         Browser height (default: full page)
  --retina                 2x device scale factor
  --scale-factor FLOAT     Custom scale (conflicts with --retina)

Selectors:
  -s, --selector CSS       Screenshot element (multiple allowed)
  --selector-all CSS       All matching elements
  --js-selector EXPR       JS filter: el => EXPR returns true
  --js-selector-all EXPR   All matching via JS
  -p, --padding INT        Pixels around selection (default: 0)

Timing:
  --wait INT               Wait ms after page load
  --wait-for "JS_EXPR"     Wait until expression returns true
  --timeout INT            Fail after ms

JavaScript:
  -j, --javascript CODE    Execute before screenshot

Quality:
  --quality INT            JPEG quality 0-100 (implies JPEG)
  --omit-background        Transparent background (PNG only)

Browser:
  -b, --browser NAME       chromium|firefox|webkit|chrome|chrome-beta
  --browser-arg ARG        Pass to browser (multiple allowed)
  --user-agent STRING      Custom User-Agent
  --reduced-motion         Emulate prefers-reduced-motion

Auth:
  -a, --auth FILE          JSON auth context from `shot-scraper auth`
  --auth-username STR      HTTP Basic auth
  --auth-password STR      HTTP Basic auth

Behavior:
  --interactive            Open browser, wait for Enter
  --devtools               Interactive with DevTools
  --bypass-csp             Bypass Content-Security-Policy
  --log-console            Output console.log to stderr
  --log-requests FILE      Log all requests as JSONL
  --skip                   Skip on HTTP errors
  --fail                   Exit 1 on HTTP errors
  --silent                 No output messages
```

### javascript - Execute JS & Return JSON

```
shot-scraper javascript URL [CODE] [OPTIONS]

  -i, --input FILE         Read JS from file (or gh:user/script)
  -o, --output FILE        Write JSON output (default: stdout)
  -r, --raw                Output raw string, not JSON
  
  # Same browser/auth options as shot
```

**Patterns from source:**
```bash
# Simple expression
shot-scraper javascript URL "document.title"

# Return object (MUST wrap in parens)
shot-scraper javascript URL "({title: document.title, url: location.href})"

# Async with imports
shot-scraper javascript URL "async () => {
  const lib = await import('https://cdn.jsdelivr.net/...');
  return lib.process(document);
}"

# Promise for delays
shot-scraper javascript URL "new Promise(done => setTimeout(() => done(result), 1000))"
```

### pdf - Page to PDF

```
shot-scraper pdf URL [OPTIONS]

  -o, --output FILE        Output file
  --format FMT             Letter|Legal|Tabloid|Ledger|A0-A6
  --width, --height        Custom dimensions with units (e.g., "10cm")
  --landscape              Landscape orientation
  --media-screen           Use screen styles (not print)
  --scale FLOAT            Render scale 0.1-2.0
  --print-background       Include background graphics
  -j, --javascript CODE    Execute before PDF
  --wait, --wait-for       Same as shot
```

### multi - Batch Screenshots

```yaml
# config.yml - YAML keys map directly to shot options
- url: https://example.com
  output: example.png
  width: 1280
  height: 800
  selector: "#main"          # or selectors: [...]
  selector_all: ".card"      # or selectors_all: [...]
  js_selector: "el.tagName == 'P'"
  padding: 10
  javascript: |
    document.querySelector('.modal').remove()
  wait: 500
  wait_for: "document.querySelector('.loaded')"
  quality: 80                # JPEG
  retina: true
```

```bash
shot-scraper multi config.yml
shot-scraper multi config.yml --no-clobber     # Skip existing
shot-scraper multi config.yml -o file1.png     # Only specific outputs
shot-scraper multi config.yml --har            # Record HAR
shot-scraper multi config.yml --har-zip        # Compressed HAR
```

### har - HTTP Archive

```
shot-scraper har URL [OPTIONS]
  -o, --output FILE
  -z, --zip                 Save as .har.zip
  -x, --extract             Extract resources to directory
```

### auth - Save Login Session

```bash
shot-scraper auth https://site.com auth.json
# Browser opens, log in manually, press Enter
# Use with: shot-scraper URL -a auth.json
```

### Source-Code Gotchas

1. **`--retina` and `--scale-factor` are mutually exclusive** (line 122-126)
2. **`--skip` and `--fail` are mutually exclusive** (line 93-95)
3. **`--quality` implies JPEG output** - no need for .jpg extension
4. **`--omit-background` doesn't work with JPEG or when quality is set** (line 217-219)
5. **JavaScript evaluation catches errors and re-raises as ClickException** (line 1650-1654)
6. **`--wait-for` uses Playwright's `wait_for_function()`** - must be valid JS returning truthy
7. **Selectors create a wrapper div** (line 1588-1647) - very complex selector logic
8. **Default width is 1280** (line 168), **default height is full page** (line 470)
9. **Auth file is chmod 600** automatically (line 1369)

---

## trafilatura

**What it is**: Web text extraction with crawling support  
**Install**: `pip install trafilatura` or `pip install trafilatura[all]`

### Input Modes (mutually exclusive)

```bash
trafilatura -u "URL"                    # Single URL
trafilatura -i urls.txt                 # File with URLs
trafilatura --input-dir html_files/     # Directory of HTML
cat page.html | trafilatura             # Stdin
```

### Output Formats

```
--output-format {csv,json,html,markdown,txt,xml,xmltei}

# Shortcuts:
--csv | --json | --html | --markdown | --xml | --xmltei

# Default: txt (plain text, no metadata)
```

### Complete Extraction Flags

```
Content Control:
  --no-comments            Exclude comments (included by default!)
  --no-tables              Exclude tables (included by default!)
  --formatting             Include bold/italic/etc (for XML/MD)
  --links                  Include hyperlinks (experimental)
  --images                 Include image sources (experimental)

Quality Tuning:
  --precision              Less noise, may miss content
  --recall                 More content, may include noise
  -f, --fast               Skip fallback algorithms (faster, less accurate)

Metadata:
  --with-metadata          Include title/author/date in output
  --only-with-metadata     Only output docs with complete metadata

Filtering:
  --target-language XX     ISO 639-1 code (requires trafilatura[all])
  --deduplicate            Remove duplicate content
  -b, --blacklist FILE     URLs to skip
  --url-filter PATTERN...  Only URLs matching patterns

Config:
  --config-file FILE       Custom settings.cfg
```

### URL Discovery (mutually exclusive)

```bash
# Find URLs from sitemap
trafilatura --sitemap "https://example.com" --list

# Find URLs from RSS/Atom feeds  
trafilatura --feed "https://example.com" --list

# Crawl internal links (max 30 pages)
trafilatura --crawl "https://example.com" --list

# Combine sitemap + crawl
trafilatura --explore "https://example.com" --list

# Probe for extractable content
trafilatura --probe "https://example.com" --list
```

### Batch Processing

```bash
# Process URL list, save to directory
trafilatura -i urls.txt -o output_dir/

# With specific format
trafilatura -i urls.txt -o output_dir/ --json --with-metadata

# Keep HTML backups
trafilatura -i urls.txt -o text/ --backup-dir html/

# Parallel processing
trafilatura -i urls.txt -o output/ --parallel 4

# Try Internet Archive for failed downloads
trafilatura -i urls.txt -o output/ --archived
```

### Default Config Values (from settings.cfg)

```ini
DOWNLOAD_TIMEOUT = 30
MAX_FILE_SIZE = 20000000    # 20MB
MIN_FILE_SIZE = 10
SLEEP_TIME = 5.0            # Between requests
MIN_EXTRACTED_SIZE = 250    # Min chars to output
EXTRACTION_TIMEOUT = 30     # CLI only
MIN_DUPLCHECK_SIZE = 100
MAX_REPETITIONS = 2
EXTENSIVE_DATE_SEARCH = on
```

### Source-Code Gotchas

1. **Comments and tables are INCLUDED by default** - use `--no-comments`/`--no-tables` to exclude (cli.py lines 107-111 use `action="store_false"`)

2. **`--precision` and `--recall` set `focus` mode** (settings.py line 129-131):
   - Neither: "balanced"
   - `--precision`: less noise
   - `--recall`: more content

3. **`--markdown` auto-enables formatting** (settings.py line 133)

4. **`--with-metadata` is auto-enabled** when using `--only-with-metadata`, `--url-blacklist`, or `--xmltei` (settings.py lines 144-149)

5. **Output encoding is forced to UTF-8** (cli.py lines 21-24)

6. **Stdin reads from `sys.stdin.buffer`** (binary mode) - line 235

7. **Parallel default is CPU count** via `sched_getaffinity` or `cpu_count` (settings.py lines 12-16)

8. **`--list` only displays URLs** - no downloading or extraction

9. **Crawl has hardcoded max ~30 pages** in CLI mode

10. **Feed/sitemap/crawl/explore/probe are mutually exclusive** (cli.py group3_ex)

---

## Combined Workflows

### JS-rendered pages → text extraction
```bash
# Get rendered HTML, pipe to trafilatura
shot-scraper html URL | trafilatura --json --with-metadata

# Or via javascript command
shot-scraper javascript URL "document.body.innerHTML" | trafilatura
```

### Screenshot + extract from same page
```bash
URL="https://example.com/article"
shot-scraper "$URL" -o screenshot.png
trafilatura -u "$URL" --json --with-metadata > article.json
```

### Batch: crawl → filter → extract
```bash
# 1. Discover URLs
trafilatura --sitemap "https://example.com" --list > urls.txt

# 2. Filter (courlan installed with trafilatura)
courlan --inputfile urls.txt --outputfile filtered.txt --language en

# 3. Extract
trafilatura -i filtered.txt -o extracted/ --json --with-metadata
```

---

## Quick Decision Tree

**Need screenshot?** → `shot-scraper URL -o file.png`  
**Need element screenshot?** → `shot-scraper URL -s 'selector' -o file.png`  
**Need to wait for dynamic content?** → add `--wait 2000` or `--wait-for "JS"`  
**Need JSON data from page?** → `shot-scraper javascript URL "({...})"`  
**Need article text?** → `trafilatura -u URL --json --with-metadata`  
**Text missing?** → try `--recall`  
**Too much noise?** → try `--precision`  
**JS-rendered page?** → `shot-scraper html URL | trafilatura`  
**Need PDF?** → `shot-scraper pdf URL -o file.pdf`  
**Need to log in first?** → `shot-scraper auth URL auth.json` then `-a auth.json`
