# Quick Reference: Figma to Email Conversion

**🚀 Fast lookup guide for developers**

---

## ⚡ Quick Start (5 Minutes)

```bash
# 1. Install MCP server
npm install -g @figma/mcp-server-figma

# 2. Add to VS Code settings.json
{
  "github.copilot.chat.mcp.servers": {
    "my-mcp-server": {
      "command": "npx",
      "args": ["-y", "@figma/mcp-server-figma"],
      "env": {
        "FIGMA_PERSONAL_ACCESS_TOKEN": "figd_your_token_here"
      }
    }
  }
}

# 3. Reload VS Code (Ctrl+Shift+P → Reload Window)

# 4. Open Copilot Chat (Ctrl+Alt+I) and paste your Figma URL:
```

**🎯 Smart Interactive Conversion (NEW - Recommended):**

```
Convert this Figma email: https://www.figma.com/design/[file-key]/...?node-id=...
```

AI will:
1. ✅ Validate Figma MCP server is working
2. Then ask you:
   - Email Type? [Marketing/Transactional/Newsletter]
   - Target ESP? [Custom/Mailchimp/SendGrid/HubSpot/etc.]
   - Brand name?
   - Asset Strategy? [A: Figma CDN / B: Local / C: CDN Ready]

**💡 Express Mode (One-Line):**

```
Figma [URL] | Marketing | SendGrid | Acme Corp | Option A
```

<details>
<summary>📋 Manual Prompt (Legacy - Click to expand)</summary>

```
Email Conversion Request

Figma Design: [YOUR_FIGMA_URL]
Email Type: [Marketing/Transactional/Newsletter]
Target ESP: [Custom/Mailchimp/SendGrid/etc.]
Brand: [BRAND_NAME]
Asset Strategy: [Option A: Figma CDN / Option B: Local Assets / Option C: CDN Ready]

Requirements
• Convert this Figma design to a production-ready HTML email
• Use table-based layout (NO flexbox/grid)
• Inline all CSS styles
• 600px max width, mobile responsive
• Support major email clients (Gmail, Outlook, Apple Mail, Yahoo)
• Include content tokens for dynamic data

Asset Handling:
• Option A (Figma CDN): Use Figma CDN URLs - Quick preview, 7-day expiry
• Option B (Local Assets): Use local paths (./assets/) - For CDN upload
• Option C (CDN Ready): Use CDN URLs directly - Production ready
  - CDN Base: [YOUR_CDN_BASE_URL if Option C]

Deliverables
• Complete HTML email file with chosen asset strategy
• ASSETS.md documentation with all image details
• CDN URL updater scripts (PowerShell + Node.js)
• Calculate token usage and conversion time
```

**Asset Strategy Quick Guide:**
- **Option A:** Fastest preview (5 min), Figma URLs, expires in 7 days
- **Option B:** Local paths, staged production, requires asset prep
- **Option C:** ⭐ CDN URLs, production ready (10 min), assets already uploaded
- **Default:** Option A if not specified

**Quick decision:**
- Quick preview? → **A**
- Assets on CDN already? → **C** (fastest to production!)
- Assets local? → **B**
- Not sure? → **A** (default)

---

## 🔑 Get Figma Token

1. **Figma** → **Profile Icon** → **Settings**
2. Scroll to **Personal Access Tokens**
3. **Create new token** → Name: `MCP Server`
4. **Scopes:** File content (Read)
5. **Generate token** → Copy immediately!

Format: `figd_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

---

## 📦 Download Assets (After Conversion)

### PowerShell Script

```powershell
# Create folder
New-Item -ItemType Directory -Force -Path "assets"

# Download (replace URLs from ASSETS.md)
$urls = @(
    "https://www.figma.com/api/mcp/asset/...",
    "https://www.figma.com/api/mcp/asset/..."
)

$counter = 1
foreach ($url in $urls) {
    Invoke-WebRequest -Uri $url -OutFile "assets/asset-$counter.png"
    $counter++
}
```

### Node.js Script

```javascript
const fs = require('fs');
const https = require('https');

if (!fs.existsSync('./assets')) fs.mkdirSync('./assets');

const assets = [
    { name: 'logo.png', url: 'https://...' },
    { name: 'hero.jpg', url: 'https://...' }
];

assets.forEach(asset => {
    const file = fs.createWriteStream(`./assets/${asset.name}`);
    https.get(asset.url, res => res.pipe(file));
});
```

---

## 🗜️ Optimize Images

### ImageMagick (Command Line)

```bash
# Install
# Windows: choco install imagemagick
# Mac: brew install imagemagick
# Linux: apt-get install imagemagick

# Optimize JPEGs
cd assets
magick mogrify -strip -quality 85 *.jpg

# Optimize PNGs
magick mogrify -strip -colors 256 *.png
```

### Online Tools
- **TinyPNG:** https://tinypng.com
- **Squoosh:** https://squoosh.app

**Target:** <100KB total (Gmail limit)

---

## ☁️ Upload to CDN

### AWS S3

```bash
# Configure
aws configure

# Upload
aws s3 sync ./assets s3://bucket/email-assets/email-name/ --acl public-read

# URL format
https://bucket.s3.amazonaws.com/email-assets/email-name/logo.png
```

### Cloudinary

```bash
# Install CLI
npm install -g cloudinary-cli

# Configure
cloudinary config

# Upload
cloudinary upload_dir ./assets -f email-assets/email-name

# URL format
https://res.cloudinary.com/cloud/image/upload/email-assets/email-name/logo.png
```

### Azure

```bash
# Login
az login

# Upload
az storage blob upload-batch -d email-assets -s ./assets --account-name youraccount

# URL format
https://youraccount.blob.core.windows.net/email-assets/logo.png
```

---

## 🔄 Replace URLs in HTML (Automated)

### CDN URL Updater Script

```powershell
# PowerShell (Windows)
.\update-cdn-urls.ps1

# Node.js (Cross-platform)
node update-cdn-urls.js
```

**Interactive workflow:**
1. Detects HTML files
2. Shows URL types (Figma CDN / local paths)
3. Select strategy: [1] Figma URLs [2] Local [3] Both
4. Enter CDN base URL
5. Optionally rename assets
6. Creates: `[name]-cdn.html`

**Benefits:**
- ⚡ ~2 min vs 15-20 min manual
- 🎯 100% accurate
- ✅ Non-destructive (creates new file)

### Manual Alternative

```bash
# 1. Copy preview to production
cp email-preview.html email.html

# 2. Open in VS Code
code email.html

# 3. Find & Replace (Ctrl+H)
Find:    https://www.figma.com/api/mcp/asset/
Replace: https://your-cdn.com/email-assets/email-name/

# 4. Click "Replace All"
```

**Also remove:**
- Preview warning banner (at bottom)
- `[PREVIEW]` from `<title>` tag

---

## 🧪 Test Email

### Send Test

```bash
# Method 1: Email testing service
# Upload to Litmus or Email on Acid

# Method 2: Manual test
# Send to: gmail, outlook, yahoo, apple mail
```

### Check:
- ✅ All images load
- ✅ Layout correct
- ✅ Buttons clickable
- ✅ Mobile responsive (375px width)
- ✅ Text readable
- ✅ Links work

---

## 🔧 Troubleshooting

### MCP Server Not Starting

```bash
# Check Node.js version (needs v18+)
node --version

# Reinstall MCP server
npm uninstall -g @figma/mcp-server-figma
npm install -g @figma/mcp-server-figma

# Reload VS Code
# Ctrl+Shift+P → Developer: Reload Window
```

### Token Invalid

1. Figma → Settings → Personal Access Tokens
2. Revoke old token
3. Create new token
4. Update `settings.json`
5. Reload VS Code

### Images Stretched

**Problem:** Using `height: auto`

**Fix:**
```html
<!-- ❌ Wrong -->
<img src="logo.png" width="200" style="height: auto;">

<!-- ✅ Correct -->
<img src="logo.png" width="200" height="50" 
     style="display: block; width: 200px; height: 50px;">
```

### Buttons Don't Work in Outlook

**Fix:** Use VML fallback (check GETTING_STARTED_GUIDE.md)

---

## 📊 Timeline Reference

| Task | Time | When |
|------|------|------|
| **AI Conversion** | 5 min | Automated |
| **Download Assets** | 10-15 min | Within 7 days |
| **Optimize Images** | 10-15 min | Before production |
| **Upload to CDN** | 5-10 min | Before production |
| **Replace URLs** | 5 min | Before production |
| **Test Email** | 10 min | Before deployment |
| **TOTAL** | **45 min** | vs 6-8 hours manual |

---

## 💰 Cost Reference

| Method | Time | Cost | Savings |
|--------|------|------|---------|
| **AI (preview only)** | 5 min | $0.27 | 99.3% |
| **AI + Assets** | 45 min | $5.27 | 91.7% |
| **Manual Dev** | 6-8 hrs | $36-64 | Baseline |

---

## 📋 Conversion Checklist

```
Setup (one-time):
☐ Install MCP server
☐ Get Figma token
☐ Configure VS Code
☐ Verify connection

Per Email:
☐ Get Figma URL
☐ Paste conversion prompt
☐ Wait 5 min (AI conversion)
☐ Open preview in browser
☐ Download assets (< 7 days)
☐ Optimize images
☐ Upload to CDN
☐ Replace URLs
☐ Remove preview banner
☐ Test email
☐ Deploy to ESP
```

---

## 🔗 Useful Links

- **Full Guide:** [GETTING_STARTED_GUIDE.md](./GETTING_STARTED_GUIDE.md)
- **AI Context:** [EMAIL_AI_CONTEXT.md](./EMAIL_AI_CONTEXT.md)
- **Conversion Patterns:** [EMAIL_CONVERSION_PROMPT.md](./EMAIL_CONVERSION_PROMPT.md)
- **Compatibility:** [EMAIL_CLIENT_RISKS.md](./EMAIL_CLIENT_RISKS.md)

---

## 🆘 Quick Help

**Issue:** Server not starting  
**Fix:** Check Node.js v18+, reload VS Code

**Issue:** Token invalid  
**Fix:** Generate new token in Figma settings

**Issue:** Images stretched  
**Fix:** Use explicit width/height, no `height: auto`

**Issue:** Figma URLs expired  
**Fix:** Re-run conversion or download within 7 days

**Issue:** Gmail clips email  
**Fix:** Compress images, keep total <100KB

---

**💡 Pro Tip:** Save this file for quick reference during conversions!

**Last Updated:** March 26, 2026