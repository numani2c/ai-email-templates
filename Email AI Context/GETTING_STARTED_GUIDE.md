# Getting Started Guide: Figma to Email Template Conversion

## 📋 Overview

This guide walks you through the complete setup and workflow for converting Figma email designs to production-ready HTML templates using AI and the Figma MCP server.

**What you'll learn:**
- Setting up the Figma MCP server in VS Code
- Configuring Figma permissions
- Converting Figma designs to email HTML
- Managing assets and deployment

**Time to complete setup:** ~15-20 minutes (one-time)  
**Time per conversion:** ~5 minutes (AI) + ~40 minutes (assets)

---

## 🎯 Prerequisites

### Required Software
- ✅ **VS Code** (latest version)
- ✅ **GitHub Copilot** subscription (with Chat enabled)
- ✅ **Node.js** v18+ (for MCP server)
- ✅ **Git** (for installing MCP server)

### Required Accounts
- ✅ **Figma account** with access to design files
- ✅ **GitHub account** (for Copilot)

### Required Permissions
- ✅ **Figma:** View access to design files (Editor or Viewer role)
- ✅ **Figma Personal Access Token** (we'll create this below)

---

## 📦 Part 1: Figma MCP Server Setup

### Step 1: Install the Figma MCP Server

The Figma MCP (Model Context Protocol) server allows AI to read Figma designs directly.

**Option A: Install via npm (Recommended)**

```bash
# Install globally
npm install -g @figma/mcp-server-figma

# Verify installation
figma-mcp-server --version
```

**Option B: Install from GitHub**

```bash
# Clone repository
git clone https://github.com/figma/mcp-servers.git
cd mcp-servers/figma

# Install dependencies
npm install

# Build the server
npm run build
```

### Step 2: Get Your Figma Personal Access Token

1. **Open Figma** in your browser
2. Click your **profile icon** (top-right)
3. Select **Settings**
4. Scroll to **Personal Access Tokens** section
5. Click **Create new token**
6. Enter token name: `MCP Server` or `AI Email Conversion`
7. **Scopes required:**
   - ✅ `File content` (Read) - Required for design extraction
   - ✅ `File comments` (optional)
8. Click **Generate token**
9. **⚠️ COPY THE TOKEN IMMEDIATELY** - you won't see it again!

**Example token format:**
```
figd_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Step 3: Configure MCP Server in VS Code

#### A. Open VS Code Settings

1. Open VS Code
2. Press `Ctrl+Shift+P` (Windows) or `Cmd+Shift+P` (Mac)
3. Type: `Preferences: Open User Settings (JSON)`
4. Press Enter

#### B. Add MCP Server Configuration

Add the following configuration to your `settings.json`:

```json
{
  "github.copilot.chat.mcp.servers": {
    "my-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@figma/mcp-server-figma"
      ],
      "env": {
        "FIGMA_PERSONAL_ACCESS_TOKEN": "figd_your_token_here"
      }
    }
  }
}
```

**⚠️ Important:** Replace `figd_your_token_here` with your actual Figma token.

**Alternative Configuration (if using local installation):**

```json
{
  "github.copilot.chat.mcp.servers": {
    "my-mcp-server": {
      "command": "node",
      "args": [
        "/path/to/mcp-servers/figma/dist/index.js"
      ],
      "env": {
        "FIGMA_PERSONAL_ACCESS_TOKEN": "figd_your_token_here"
      }
    }
  }
}
```

#### C. Save and Reload VS Code

1. Save the `settings.json` file (`Ctrl+S`)
2. Reload VS Code:
   - Press `Ctrl+Shift+P` → `Developer: Reload Window`
   - Or close and reopen VS Code

### Step 4: Verify MCP Server Connection

1. Open **GitHub Copilot Chat** in VS Code (`Ctrl+Alt+I` or click chat icon)
2. Type: `@workspace test figma mcp connection`
3. If successful, you'll see confirmation that the Figma MCP server is available

**Troubleshooting:**
- If server doesn't start, check Node.js version: `node --version` (needs v18+)
- Check token format (should start with `figd_`)
- Review VS Code Output panel: `View → Output → GitHub Copilot Language Server`

---

## 🚀 Part 2: Converting Figma Designs to Email Templates

### Step 1: Prepare Your Figma Design

#### A. Ensure Proper Access

1. Open the Figma file in your browser
2. Verify you have **View** or **Edit** access
3. Note the file URL format:
   ```
   https://www.figma.com/design/[FILE_KEY]/[FILE_NAME]?node-id=[NODE_ID]
   ```

#### B. Select the Email Design Frame

1. In Figma, click the frame/component you want to convert
2. **Right-click** → **Copy link to selection**
3. Keep this URL ready for conversion

**Example URL:**
```
https://www.figma.com/design/SsPdaxkVsrWDFZujHumUML/Email-Templates?node-id=282-6903
```

**Best Practices:**
- ✅ Design width should be **600px** (standard email width)
- ✅ Use clear layer naming (helps with asset identification)
- ✅ Group related elements (e.g., "Header", "CTA Section")
- ✅ Include all states/variants in one frame if applicable

### Step 2: Open VS Code and Start Conversion

#### A. Create or Open Project Folder

```bash
# Create a new folder for your email
mkdir email-templates/my-email-name
cd email-templates/my-email-name

# Open in VS Code
code .
```

#### B. Open Copilot Chat

1. Press `Ctrl+Alt+I` (Windows) or `Cmd+Alt+I` (Mac)
2. Or click the **Chat icon** in the sidebar

### Step 3: Start Smart Interactive Conversion 🚀

**NEW:** No more copying/pasting prompts! Just provide your Figma URL and answer simple questions.

#### 🎯 **Simple Conversion (Recommended):**

Just paste your Figma URL:

```
Convert this Figma email: https://www.figma.com/design/[your-file-key]/...?node-id=...
```

**The AI will automatically:**
1. ✓ Detect your Figma URL
2. ✓ Ask about email type (Marketing/Transactional/Newsletter)
3. ✓ Ask about ESP (Mailchimp/SendGrid/Custom/etc.)
4. ✓ Ask for brand name
5. ✓ Ask about asset strategy (A/B/C)
6. ✓ Start conversion with your answers

**Example Interactive Session:**

```
You: "Convert this Figma email: https://figma.com/design/xyz/..."

AI: "✓ Figma URL detected: figma.com/design/xyz...

     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     🔍 VALIDATING FIGMA MCP SERVER
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     ⏳ Testing connection...
     ✅ Figma MCP server connected
     ✅ User: your.email@company.com
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

     Let me gather some details for the conversion:

     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     1️⃣ EMAIL TYPE
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     What type of email is this?
     [1] Marketing (promotional, campaigns)
     [2] Transactional (receipts, confirmations)
     [3] Newsletter (content, updates)

     Your choice (1-3): _"

You: "1"

AI: "✓ Marketing
     
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     2️⃣ TARGET ESP
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Which ESP will send this email?
     [1] Custom HTML (manual/API)
     [2] Mailchimp
     [3] SendGrid
     ...
     
     Your choice: _"

[... continues with Brand and Asset Strategy questions ...]
```

#### 💡 **Express Mode (For Power Users):**

Provide everything in one line using pipe-separated format:

```
Figma https://figma.com/design/xyz/... | Marketing | SendGrid | Acme Corp | Option A
```

Or with more detail:

```
Convert: https://figma.com/design/xyz/... | Transactional | Custom | i2c | CDN: https://cdn.acme.com/emails/welcome
```

#### 🔧 **Manual Prompt (Legacy - Still Supported):**

If you prefer the old way, you can still use a manual prompt:

```
Email Conversion Request

Figma Design: [PASTE_YOUR_FIGMA_URL_HERE]
Email Type: [Marketing / Transactional / Newsletter]
Target ESP: [Custom / Mailchimp / SendGrid / HubSpot / etc.]
Brand: [YOUR_BRAND_NAME]
Asset Strategy: [Option A / Option B / Option C]
```

<details>
<summary>📋 Full Manual Prompt Template (Click to expand)</summary>

```
Email Conversion Request

Figma Design: [PASTE_YOUR_FIGMA_URL_HERE]
Email Type: [Marketing / Transactional / Newsletter]
Target ESP: [Custom / Mailchimp / SendGrid / HubSpot / etc.]
Brand: [YOUR_BRAND_NAME]
Asset Strategy: [Option A: Figma CDN / Option B: Local Assets / Option C: CDN Ready]

Requirements
• Convert this Figma design to a production-ready HTML email
• Use table-based layout (NO flexbox/grid)
• Inline all CSS styles
• 600px max width, mobile responsive
• Support major email clients (Gmail, Outlook, Apple Mail, Yahoo)
• Include content tokens for dynamic data

Asset Handling:
• Option A (Figma CDN): Use Figma CDN URLs directly - Quick preview, 7-day expiry
• Option B (Local Assets): Use local paths (./assets/) - For CDN upload
• Option C (CDN Ready): Use permanent CDN URLs - Production ready immediately
  - CDN Base URL: [YOUR_CDN_BASE_URL if Option C]

Deliverables
• Complete HTML email file with chosen asset strategy
• ASSETS.md documentation with all image details
• Calculate token usage and conversion time
```

</details>

**Asset Strategy Quick Guide:**

**Option A: Figma CDN URLs (Default)**
- Images use Figma API URLs: `https://www.figma.com/api/mcp/asset/[uuid]`
- Best for: Quick previews, stakeholder reviews, testing
- File created: `[name]-preview.html`
- Pros: Fastest (5 min), no asset prep needed
- Cons: URLs expire in 7 days, requires download later

**Option B: Local Assets Folder**
- Images use local paths: `./assets/image-name.png`
- Best for: Production workflows with planned CDN upload
- File created: `[name].html`
- Pros: Production-ready structure, organized
- Cons: Requires assets downloaded/prepared first

**Option C: Assets Already on CDN** ⭐ NEW
- Images use permanent CDN URLs: `https://cdn.example.com/path/image.png`
- Best for: Assets already uploaded before conversion
- File created: `[name].html` (production ready)
- Pros: **Fastest to production (10 min)**, no URL replacement needed
- Cons: Requires CDN setup and asset filenames upfront

**Which to choose?**
- **Quick preview:** Option A
- **Standard workflow:** Option A → B (preview then production)
- **Assets prepared locally:** Option B
- **Assets already on CDN:** Option C (fastest to deploy!)

#### 📝 **Example Filled Prompt:**

```
Email Conversion Request

Figma Design: https://www.figma.com/design/SsPdaxkVsrWDFZujHumUML/AI-Based-Figma-to-Code-PoC?node-id=282-6903
Email Type: Marketing
Target ESP: Custom
Brand: i2c

Requirements
• Convert this Figma design to a production-ready HTML email
• Use table-based layout (NO flexbox/grid)
• Inline all CSS styles
• 600px max width, mobile responsive
• Support major email clients (Gmail, Outlook, Apple Mail, Yahoo)
• Include content tokens for dynamic data

Deliverables
• Complete HTML email file (preview version with Figma CDN URLs)
• ASSETS.md documentation with all image URLs and dimensions
• Calculate token usage and conversion time
```

### Step 4: Wait for AI Conversion

The AI will:
1. ✅ Extract the Figma design (30 seconds)
2. ✅ Analyze structure and identify components
3. ✅ Convert to table-based email HTML (2 minutes)
4. ✅ Generate preview template with Figma CDN URLs (1 minute)
5. ✅ Create ASSETS.md documentation (1 minute)
6. ✅ Generate conversion summary (30 seconds)

**Total time:** ~4-5 minutes

**What you'll get:**
- 📄 `[email-name]-preview.html` - Ready to open in browser
- 📋 `ASSETS.md` - Complete asset documentation
- 📊 `CONVERSION_SUMMARY.md` - Token usage and metrics

### Step 5: Test the Preview Template

1. **Open the preview HTML** in your browser:
   ```bash
   # Windows
   start [email-name]-preview.html
   
   # Mac
   open [email-name]-preview.html
   
   # Linux
   xdg-open [email-name]-preview.html
   ```

2. **Verify the design:**
   - ✅ All images load correctly
   - ✅ Layout matches Figma design
   - ✅ Colors and spacing are accurate
   - ✅ Text content is readable

3. **Check mobile responsive:**
   - Open browser DevTools (`F12`)
   - Toggle device toolbar (`Ctrl+Shift+M`)
   - Test at 375px width (mobile)

---

## 📦 Part 3: Asset Management & Production Deployment

### Step 1: Download Assets from Figma CDN

⚠️ **Important:** Figma CDN URLs expire after 7 days. Download assets immediately!

#### A. Open ASSETS.md

The AI-generated `ASSETS.md` file contains:
- Table of all assets with URLs, dimensions, and purposes
- Quick reference section with all URLs
- Download instructions

#### B. Download Options

**Option 1: Manual Download (Best for small projects)**

1. Open `ASSETS.md`
2. Find the "Quick Reference: All Figma Asset URLs" section
3. For each URL:
   - Right-click → Open in new tab
   - Right-click image → Save as...
   - Use descriptive filename (e.g., `logo.png`, `hero-banner.jpg`)

**Option 2: Automated Download (PowerShell Script)**

Create a file `download-assets.ps1`:

```powershell
# Create assets folder
New-Item -ItemType Directory -Force -Path "assets"

# Array of asset URLs from ASSETS.md
$urls = @(
    "https://www.figma.com/api/mcp/asset/d53040bd-1b26-44ec-a4df-a897ca46d9aa",
    "https://www.figma.com/api/mcp/asset/e950629a-eee2-483b-8441-80c0ed0e313a"
    # ... add all URLs here
)

# Download each asset
$counter = 1
foreach ($url in $urls) {
    $filename = "assets/asset-$counter.png"
    Write-Host "Downloading $filename..."
    Invoke-WebRequest -Uri $url -OutFile $filename
    $counter++
}

Write-Host "Download complete! $($urls.Count) assets saved to ./assets/"
```

Run the script:
```powershell
powershell -ExecutionPolicy Bypass -File download-assets.ps1
```

**Option 3: Batch Download (Node.js Script)**

Create `download-assets.js`:

```javascript
const fs = require('fs');
const https = require('https');
const path = require('path');

// Create assets directory
if (!fs.existsSync('./assets')) {
    fs.mkdirSync('./assets');
}

// Asset URLs from ASSETS.md
const assets = [
    { name: 'logo.png', url: 'https://www.figma.com/api/mcp/asset/...' },
    { name: 'hero-banner.jpg', url: 'https://www.figma.com/api/mcp/asset/...' },
    // ... add all assets here
];

// Download function
function downloadAsset(asset) {
    return new Promise((resolve, reject) => {
        const filePath = path.join('./assets', asset.name);
        const file = fs.createWriteStream(filePath);
        
        https.get(asset.url, (response) => {
            response.pipe(file);
            file.on('finish', () => {
                file.close();
                console.log(`✓ Downloaded: ${asset.name}`);
                resolve();
            });
        }).on('error', (err) => {
            fs.unlink(filePath, () => {});
            reject(err);
        });
    });
}

// Download all assets
(async () => {
    console.log('Downloading assets...');
    for (const asset of assets) {
        await downloadAsset(asset);
    }
    console.log(`\n✓ All ${assets.length} assets downloaded!`);
})();
```

Run:
```bash
node download-assets.js
```

### Step 2: Optimize Images for Email

Email-optimized images load faster and avoid Gmail clipping (100KB limit).

#### A. Compression Tools

**Online Tools:**
- [TinyPNG](https://tinypng.com/) - PNG/JPEG compression
- [Squoosh](https://squoosh.app/) - Google's image optimizer
- [ImageOptim](https://imageoptim.com/) - Mac app

**Command Line (ImageMagick):**

```bash
# Install ImageMagick
# Windows: choco install imagemagick
# Mac: brew install imagemagick
# Linux: apt-get install imagemagick

# Optimize all images in assets folder
cd assets
magick mogrify -strip -quality 85 -resize "100%" *.jpg
magick mogrify -strip -colors 256 *.png
```

#### B. Optimization Guidelines

| Image Type | Format | Quality | Max Size |
|------------|--------|---------|----------|
| **Photos/Hero** | JPEG | 80-85% | 50-80KB |
| **Logos/Icons** | PNG-8 | Lossless | 10-20KB |
| **Graphics** | PNG-24 | Lossless | 20-40KB |
| **Decorative** | JPEG | 75-80% | 30-50KB |

**Target: Keep total email under 100KB to avoid Gmail clipping**

### Step 3: Upload to CDN

Your images need permanent hosting (Figma URLs expire in 7 days).

#### Option A: AWS S3 + CloudFront

```bash
# Install AWS CLI
# Windows: choco install awscli
# Mac: brew install awscli

# Configure AWS credentials
aws configure

# Upload assets
aws s3 sync ./assets s3://your-bucket/email-assets/email-name/ --acl public-read

# Get CloudFront URL
# https://d1234567890.cloudfront.net/email-assets/email-name/logo.png
```

#### Option B: Cloudinary

```bash
# Install Cloudinary CLI
npm install -g cloudinary-cli

# Configure
cloudinary config

# Upload folder
cloudinary upload_dir ./assets -f email-assets/email-name

# Get URLs
# https://res.cloudinary.com/your-cloud/image/upload/email-assets/email-name/logo.png
```

#### Option C: Azure Blob Storage

```bash
# Install Azure CLI
# Windows: choco install azure-cli

# Login
az login

# Upload
az storage blob upload-batch -d email-assets -s ./assets --account-name youraccount

# Get URL
# https://youraccount.blob.core.windows.net/email-assets/logo.png
```

#### Option D: Simple HTTP Server (Development Only)

```bash
# Python 3
python -m http.server 8000

# Access: http://localhost:8000/assets/logo.png
```

**⚠️ Not recommended for production - use a proper CDN**

### Step 4: Replace Figma URLs with CDN URLs

#### A. Create Production Template

1. Copy the preview HTML:
   ```bash
   cp [email-name]-preview.html [email-name].html
   ```

2. Open `[email-name].html` in VS Code

#### B. Automated URL Replacement (Recommended)

Use the included CDN URL updater script for fast, accurate replacement:

**PowerShell (Windows):**
```powershell
# Navigate to email folder
cd path/to/email-folder

# Run script
.\update-cdn-urls.ps1
```

**Node.js (Cross-platform):**
```bash
node update-cdn-urls.js
```

**Interactive workflow:**
1. Script detects HTML files and URL types
2. Shows: Figma CDN URLs count, local paths count
3. Select replacement strategy:
   - [1] Figma CDN → Permanent CDN
   - [2] Local paths → Permanent CDN
   - [3] Both → Permanent CDN
4. Enter CDN base URL (e.g., `https://cdn.example.com/emails/welcome`)
5. (For Figma URLs) Optionally customize asset filenames
6. Script creates new file: `[email-name]-cdn.html`

**Example session:**
```
========================================
  CDN URL Updater for Email Templates
========================================

Found HTML files:
  [0] welcome-email-preview.html

Current URLs detected:
  - Figma CDN URLs: 27
  - Local paths: 0

Select option (1-3): 1

CDN Base URL: https://cdn.mycompany.com/emails/welcome

Asset ID → Filename mapping:
  d53040bd-... → asset-1.png
  e950629a-... → asset-2.png

Use custom filenames? (y/N): y
  d53040bd-... [asset-1.png]: logo.png
  e950629a-... [asset-2.png]: hero-banner.jpg

✓ URL Replacement Complete!
  - Replacements: 27
  - Output: welcome-email-cdn.html
```

**Benefits:**
- ⚡ ~2 minutes vs 15-20 minutes manual
- 🎯 100% accuracy (no typos or missed URLs)
- 📋 Shows all replacements before applying
- ✅ Creates new file (preserves original)

#### C. Manual URL Replacement (Alternative)

If you prefer manual control:

1. Press `Ctrl+H` (Find and Replace)
2. **Find:** `https://www.figma.com/api/mcp/asset/`
3. **Replace with:** `https://your-cdn.com/email-assets/email-name/`
4. Click **Replace All**

**Verify replacements:**
- Check that all image `src=""` attributes now point to your CDN
- Ensure no broken Figma URLs remain
- Test in browser to verify all images load

#### D. Final Cleanup

Find and delete the warning banner at the bottom of the HTML:

```html
<!-- Preview Warning Banner -->
<table role="presentation" width="600" ...>
  <tr>
    <td style="background-color: #fff3cd; ...">
      <p>⚠️ <strong>PREVIEW VERSION</strong> - Images hosted...</p>
    </td>
  </tr>
</table>
```

#### D. Update Title

Change the `<title>` tag:

```html
<!-- Before -->
<title>Your Exclusive Invitation [PREVIEW]</title>

<!-- After -->
<title>Your Exclusive Invitation</title>
```

### Step 5: Add Dynamic Tokens (Optional)

If your email uses personalization or dynamic content, replace hardcoded text with tokens.

**Common tokens:**

```html
<!-- Name personalization -->
<p>Hello {{first_name}},</p>

<!-- Account data -->
<p>Your balance: {{account_balance}}</p>

<!-- Links -->
<a href="{{cta_url}}">Click Here</a>

<!-- Images -->
<img src="{{hero_image_url}}" alt="Hero">
```

**Token syntax varies by ESP:**
- **Mailchimp:** `*|FNAME|*`
- **SendGrid:** `{{first_name}}`
- **HubSpot:** `{{ contact.firstname }}`
- **Custom:** `{{first_name}}` (default)

### Step 6: Test Across Email Clients

#### A. Use Email Testing Tools

**Litmus:** [litmus.com](https://litmus.com)
- Upload HTML file
- Test across 90+ email clients
- Check rendering, spam score, accessibility

**Email on Acid:** [emailonacid.com](https://emailonacid.com)
- Similar to Litmus
- Includes spam testing

**Free Alternative: Mailtrap**
- [mailtrap.io](https://mailtrap.io)
- Free tier available
- Test email rendering and HTML validation

#### B. Manual Testing

Send test emails to:
- Gmail (web, mobile app)
- Outlook (2016, 2019, 365, web)
- Apple Mail (macOS, iOS)
- Yahoo Mail
- Your company email

**Test checklist:**
- ✅ All images load
- ✅ Layout renders correctly
- ✅ Buttons are clickable
- ✅ Text is readable
- ✅ Mobile responsive works
- ✅ Links work correctly

### Step 7: Deploy to ESP

Upload your production HTML to your Email Service Provider.

#### Mailchimp

1. Create new campaign
2. Choose "Code your own" template
3. Paste HTML
4. Map merge tags
5. Send test email
6. Schedule or send

#### SendGrid

```bash
# Using SendGrid CLI
sendgrid template create --name "Email Name" --html-file email-name.html
```

#### HubSpot

1. Marketing → Email → Create email
2. Drag custom HTML module
3. Paste HTML
4. Add tokens
5. Preview and send

#### Custom ESP

Consult your ESP documentation for HTML upload process.

---

## 🔧 Part 4: Managing the MCP Server

### Starting the Server

The MCP server starts automatically when VS Code loads (if properly configured).

**To manually start:**

```bash
# Using npx
npx -y @figma/mcp-server-figma

# Using local installation
node /path/to/mcp-servers/figma/dist/index.js
```

### Stopping the Server

**Method 1: Reload VS Code Window**
- `Ctrl+Shift+P` → `Developer: Reload Window`

**Method 2: Disable in Settings**

Edit `settings.json`:
```json
{
  "github.copilot.chat.mcp.enabled": false
}
```

**Method 3: Close VS Code**
- Server stops when VS Code closes

### Checking Server Status

1. Open GitHub Copilot Chat
2. Type: `@workspace what MCP servers are running?`
3. You should see `my-mcp-server` listed

**Alternative: Check VS Code Output**
- `View → Output`
- Select "GitHub Copilot Language Server" from dropdown
- Look for MCP server initialization messages

### Troubleshooting

#### Server Not Starting

**Check Node.js version:**
```bash
node --version
# Should be v18.0.0 or higher
```

**Check token format:**
- Must start with `figd_`
- No spaces or special characters
- Copy-paste directly from Figma (don't type manually)

**Check VS Code settings:**
- Open `settings.json`
- Verify `github.copilot.chat.mcp.servers` section exists
- Check for syntax errors (missing commas, brackets)

#### Token Expired or Invalid

**Symptoms:**
- "Authentication failed" errors
- "Invalid token" messages
- Cannot access Figma designs

**Solution:**
1. Go to Figma → Settings → Personal Access Tokens
2. Revoke old token
3. Create new token with same permissions
4. Update `settings.json` with new token
5. Reload VS Code

#### MCP Server Not Found

**Check installation:**
```bash
# Verify npm global packages
npm list -g --depth=0

# Should show @figma/mcp-server-figma
```

**Reinstall if needed:**
```bash
npm uninstall -g @figma/mcp-server-figma
npm install -g @figma/mcp-server-figma
```

#### Permission Denied Errors

**Windows:**
- Run PowerShell as Administrator
- Install with:
  ```powershell
  npm install -g @figma/mcp-server-figma --force
  ```

**Mac/Linux:**
```bash
sudo npm install -g @figma/mcp-server-figma
```

---

## 📚 Part 5: Best Practices & Tips

### Figma Design Preparation

**Before conversion, ensure:**

1. **Use 600px width** for main email container
2. **Name layers clearly:** "Header", "CTA Button", "Footer", etc.
3. **Group related elements** into frames
4. **Use components** for repeated elements (buttons, icons)
5. **Include all states** in one frame (hover, active, etc.)
6. **Add notes** for dynamic content areas
7. **Use real content** (not lorem ipsum) for better AI understanding

### Email HTML Best Practices

**The AI follows these automatically, but verify:**

✅ **Table-based layout** (no divs for structure)  
✅ **Inline CSS** on all elements  
✅ **Explicit image dimensions** (width + height attributes)  
✅ **No `height: auto`** on images (causes stretching)  
✅ **Web-safe fonts** (Arial, Georgia, Times)  
✅ **Bulletproof buttons** with VML fallbacks  
✅ **Mobile responsive** with media queries  
✅ **Max-width 600px** container  
✅ **Alt text** on all images  
✅ **Preview text** in `<head>`  

### Asset Management

**Naming convention:**
```
logo.png
header-background.jpg
cta-button-icon.png
social-icon-linkedin.png
```

**Folder structure:**
```
/email-templates/
  /welcome-email/
    welcome-email.html
    welcome-email-preview.html
    ASSETS.md
    /assets/
      logo.png
      hero-banner.jpg
      ...
```

### Version Control

**Commit to Git:**

```bash
git init
git add .
git commit -m "Add welcome email template"

# .gitignore
node_modules/
*.log
.env
```

**Track versions:**
- Use semantic versioning for email templates
- Tag releases: `git tag v1.0.0`
- Document changes in CHANGELOG.md

### Conversion Tips

**For best results:**

1. **Start with preview:** Test with Figma CDN URLs first
2. **Download assets immediately:** Don't wait until they expire
3. **Optimize images:** Compress before uploading to CDN
4. **Test early and often:** Send test emails throughout development
5. **Use tokens consistently:** Follow your ESP's token syntax
6. **Document customizations:** Note any manual changes made
7. **Batch conversions:** Convert multiple emails in one session

### Cost Optimization

**Reduce AI token usage:**
- Use concise prompts (include only necessary details)
- Reuse conversion patterns for similar emails
- Batch multiple conversions in same session

**Estimated costs per email:**
- AI conversion: ~$0.27
- Asset work: ~$5 (at $8/hour rate)
- Total: ~$5.27 per email

**vs. Manual development: $36-64 (6-8 hours)**

---

## 🆘 Part 6: Troubleshooting Common Issues

### Issue: Images Are Stretched or Distorted

**Cause:** Missing or incorrect image dimensions

**Solution:**
1. Open ASSETS.md
2. Find the exact dimensions for each image
3. Update HTML with correct width/height:
   ```html
   <img src="logo.png" width="200" height="50" 
        style="display: block; width: 200px; height: 50px;">
   ```
4. Never use `height: auto` in email HTML

### Issue: Buttons Don't Render in Outlook

**Cause:** Missing VML fallbacks

**Solution:**
Use bulletproof button pattern:
```html
<table role="presentation" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td style="border-radius: 5px; background-color: #1434cb;">
      <!--[if mso]>
      <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" 
                   href="#" style="height:46px;width:200px;" 
                   arcsize="11%" fillcolor="#1434cb">
        <center style="color:#ffffff;font-family:Arial;">
          Button Text
        </center>
      </v:roundrect>
      <![endif]-->
      <!--[if !mso]><!-->
      <a href="#" style="display:inline-block;padding:14px 20px;
                        font-family:Arial;color:#ffffff;">
        Button Text
      </a>
      <!--<![endif]-->
    </td>
  </tr>
</table>
```

### Issue: Mobile Layout Breaks

**Cause:** Missing mobile responsive classes or media queries

**Solution:**
1. Verify `<style>` block in `<head>` contains media queries
2. Add responsive classes to tables/cells:
   ```html
   <table class="mobile-full">
   <td class="mobile-padding">
   <td class="mobile-hide">
   ```
3. Test at 375px width in browser DevTools

### Issue: Gmail Clips Email

**Cause:** Email exceeds 102KB file size limit

**Solution:**
1. Compress images more aggressively
2. Remove unnecessary whitespace in HTML
3. Inline only critical CSS
4. Consider splitting into multiple emails

### Issue: Figma URLs Expired

**Cause:** 7 days passed since conversion

**Solution:**
1. Re-run conversion prompt to get fresh URLs
2. Or: Download assets immediately after conversion
3. Set calendar reminder for 5 days after conversion

### Issue: AI Doesn't Recognize Figma URL

**Cause:** Incorrect URL format or permissions

**Solution:**
1. Verify URL format:
   ```
   https://www.figma.com/design/[FILE_KEY]/[NAME]?node-id=[ID]
   ```
2. Check Figma file permissions (must have View access)
3. Try copying link directly from Figma:
   - Right-click frame → "Copy link to selection"
4. Verify MCP server is running (see Part 4)

---

## 📖 Part 7: Example Workflows

### Workflow 1: Quick Preview (5 minutes)

**Use case:** Show design to stakeholders quickly

```bash
# 1. Get Figma URL (right-click → copy link)
# 2. Open VS Code with email project folder
# 3. Open Copilot Chat (Ctrl+Alt+I)
# 4. Paste conversion prompt with Figma URL
# 5. Wait ~5 minutes
# 6. Open preview HTML in browser
# 7. Share with team
```

**Deliverables:** Preview HTML with Figma CDN URLs (valid 7 days)

### Workflow 2: Production Deployment (45 minutes)

**Use case:** Deploy email to production ESP

```bash
# 1. Convert design (5 min) - see Workflow 1
# 2. Download assets (10-15 min)
#    - Copy URLs from ASSETS.md
#    - Use download script or manual download
# 3. Optimize images (10-15 min)
#    - Use TinyPNG or ImageMagick
#    - Target: <100KB total
# 4. Upload to CDN (5-10 min)
#    - AWS S3, Cloudinary, or Azure
#    - Get CDN URLs
# 5. Replace URLs (5 min)
#    - Find/replace in production HTML
#    - Remove preview banner
# 6. Test (10 min)
#    - Send test emails
#    - Check rendering
# 7. Deploy to ESP
```

**Deliverables:** Production HTML with permanent CDN URLs

### Workflow 3: Batch Conversion (Multiple Emails)

**Use case:** Convert multiple email templates efficiently

```bash
# 1. Organize Figma file with clear layer names
# 2. Copy all Figma URLs (one per email)
# 3. Open VS Code
# 4. Convert emails one by one (~5 min each)
# 5. Batch download all assets at once
# 6. Batch optimize all images
# 7. Batch upload to CDN
# 8. Batch replace URLs
# 9. Test all emails
```

**Time savings:** ~30% faster than converting individually

### Workflow 4: Email Series (Campaign)

**Use case:** Create email series with consistent branding

```bash
# 1. Convert first email (full workflow)
# 2. Save header/footer as reusable components
# 3. For subsequent emails:
#    - Convert body content only
#    - Merge with saved header/footer
#    - Reuse CDN URLs for logos/icons
#    - Update dynamic content areas
```

**Time savings:** ~50% faster for emails 2+

---

### Workflow 5: Production Ready (Assets Already on CDN) ⭐ NEW

**Use case:** Assets already uploaded to CDN, need template ASAP

**Scenario:** 
- You've already uploaded the logo, banner, and icons to your CDN
- Assets are at: `https://cdn.mycompany.com/emails/2026/march/`
- Need production-ready template in ~10 minutes

```bash
# 1. Get Figma URL
# 2. Open VS Code Copilot Chat
# 3. Use conversion prompt with Option C:

Email Conversion Request

Figma Design: [YOUR_FIGMA_URL]
Email Type: Marketing
Target ESP: Custom
Brand: MyCompany
Asset Strategy: Option C: Assets Already on CDN

Asset Details:
- CDN Base URL: https://cdn.mycompany.com/emails/2026/march
- Asset filenames: 
  * logo.png
  * hero-banner.jpg
  * icon-calendar.svg
  * icon-location.svg
  * footer-logo.png

Requirements
• Convert to production-ready HTML email
• Use CDN URLs directly
• Table-based layout, inline CSS
• 600px max width, mobile responsive

# 4. AI generates HTML with CDN URLs (5 min)
# 5. Test in browser - all images load immediately
# 6. Send test email - works perfectly
# 7. Deploy to ESP - production ready!
```

**Deliverables:**
- `email-name.html` - Production ready with CDN URLs
- `ASSETS.md` - CDN asset documentation
- No URL replacement scripts needed

**Timeline:**
- Conversion: 5 minutes
- Testing: 5 minutes
- **Total: ~10 minutes** (fastest workflow!)

**Benefits:**
- ✅ No asset download needed
- ✅ No CDN upload needed
- ✅ No URL replacement needed
- ✅ **Deploy immediately**

**When to use:**
- Assets already on CDN before conversion
- Urgent production deployments
- Email series reusing shared assets
- Teams with established CDN workflows

**Example interaction:**

```
AI: "Asset Strategy: Option C detected. Please provide CDN base URL:"

You: "https://cdn.mycompany.com/emails/welcome-2026"

AI: "Found 5 image assets. Provide filename for each:"

AI: "1. Logo (265×36px) - filename?"
You: "logo.png"

AI: "2. Hero banner (600×230px) - filename?"
You: "hero-banner.jpg"

AI: "3. Calendar icon (16×16px) - filename?"
You: "icon-calendar.svg"

AI: "4. Location icon (16×16px) - filename?"
You: "icon-location.svg"

AI: "5. Footer logo (165×29px) - filename?"
You: "footer-logo.png"

AI: "✓ Generating production-ready HTML with CDN URLs..."
AI: "✓ Created: welcome-email.html (production ready)"
AI: "✓ All images: https://cdn.mycompany.com/emails/welcome-2026/[filename]"
```

---

## 📋 Quick Reference Checklist

### ✅ Setup Checklist (One-Time)

- [ ] Install Node.js v18+
- [ ] Install Figma MCP server (`npm install -g @figma/mcp-server-figma`)
- [ ] Create Figma Personal Access Token
- [ ] Configure MCP server in VS Code `settings.json`
- [ ] Reload VS Code window
- [ ] Verify MCP connection in Copilot Chat

### ✅ Conversion Checklist (Per Email)

- [ ] Get Figma design URL (right-click → copy link)
- [ ] Open VS Code with project folder
- [ ] Paste conversion prompt in Copilot Chat
- [ ] Wait ~5 minutes for AI conversion
- [ ] Open preview HTML in browser
- [ ] Verify design matches Figma
- [ ] Download assets from Figma CDN (within 7 days)
- [ ] Optimize images (<100KB total)
- [ ] Upload to permanent CDN
- [ ] Replace Figma URLs with CDN URLs
- [ ] Remove preview warning banner
- [ ] Add dynamic tokens (if needed)
- [ ] Test across email clients
- [ ] Deploy to ESP

---

## 🎓 Additional Resources

### Documentation
- [EMAIL_AI_CONTEXT.md](./EMAIL_AI_CONTEXT.md) - Complete AI context for conversions
- [EMAIL_CONVERSION_PROMPT.md](./EMAIL_CONVERSION_PROMPT.md) - Detailed conversion patterns
- [EMAIL_CLIENT_RISKS.md](./EMAIL_CLIENT_RISKS.md) - Email client compatibility guide
- [CONTENT_TOKENS.md](./CONTENT_TOKENS.md) - Token documentation template

### Email Testing Tools
- **Litmus:** [litmus.com](https://litmus.com) - Comprehensive email testing
- **Email on Acid:** [emailonacid.com](https://emailonacid.com) - Email testing platform
- **Can I Email:** [caniemail.com](https://www.caniemail.com/) - Email client support tables
- **Mailtrap:** [mailtrap.io](https://mailtrap.io) - Free email testing

### CDN Providers
- **AWS S3 + CloudFront:** [aws.amazon.com/s3](https://aws.amazon.com/s3/)
- **Cloudinary:** [cloudinary.com](https://cloudinary.com)
- **Azure Blob Storage:** [azure.microsoft.com/storage](https://azure.microsoft.com/en-us/products/storage/blobs)
- **Google Cloud Storage:** [cloud.google.com/storage](https://cloud.google.com/storage)

### Image Optimization
- **TinyPNG:** [tinypng.com](https://tinypng.com) - PNG/JPEG compression
- **Squoosh:** [squoosh.app](https://squoosh.app) - Google's image optimizer
- **ImageOptim:** [imageoptim.com](https://imageoptim.com) - Mac image optimizer

### Email Design Resources
- **Really Good Emails:** [reallygoodemails.com](https://reallygoodemails.com) - Email inspiration
- **Campaign Monitor Guide:** [campaignmonitor.com/css](https://www.campaignmonitor.com/css/) - CSS support
- **Email on Acid Blog:** [emailonacid.com/blog](https://www.emailonacid.com/blog/) - Email tips

---

## 🚀 You're Ready!

You now have everything you need to convert Figma email designs to production-ready HTML templates using AI.

**Next steps:**
1. Complete the setup (Part 1)
2. Try converting your first email (Part 2)
3. Follow the asset management workflow (Part 3)
4. Bookmark this guide for reference

**Support:**
- Review the troubleshooting section if you encounter issues
- Check the example workflows for guidance
- Refer to additional resources for deeper learning

**Happy converting! 🎉**

---

**Document Version:** 1.0  
**Last Updated:** March 26, 2026  
**Maintained By:** Email Development Team