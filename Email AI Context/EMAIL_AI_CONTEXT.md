# Email Template Conversion - AI Context

## Purpose

This document provides AI agents with comprehensive context for converting Figma email designs to production-ready HTML. It consolidates all email-specific documentation and provides clear instructions for generating precise, client-compatible email templates.

---

## 🌍 UNIVERSAL PRINCIPLE: Template Independence

**⚠️ CRITICAL: This workflow is COMPLETELY TEMPLATE-INDEPENDENT**

All examples in this document (layer names like "Logo", "hero", "Hero Banner", etc.) are for DEMONSTRATION ONLY. The actual conversion process:

✅ **NEVER assumes specific layer names exist** (no hardcoded "Logo", "hero", etc.)  
✅ **ALWAYS extracts actual layer names from Figma** (via `data-name` attributes)  
✅ **ADAPTS automatically to ANY template** regardless of how designers named layers  

**Examples throughout this document show:**
- Multiple naming variations ("Logo" / "logo" / "Company Logo Brand")
- Different templates with different layer names
- The EXTRACTION PROCESS, not expected names

**Remember:** One template has "Hero Banner", another has "hero", another has "main-image". Your job is to extract whatever names exist, not assume specific names.

---

## ⚠️ CRITICAL REQUIREMENT: Asset Handling Strategy

**Every email conversion MUST ask user for asset handling preference:**

**Option A: Figma CDN URLs (Default)**
- Uses Figma API URLs directly (expires in 7 days)
- Best for: Quick previews, internal testing, stakeholder review
- Creates: `[name]-preview.html`
- Includes: 7-day expiry warning, ASSETS.md with download links, URL updater scripts

**Option B1: GitHub Temporary CDN** ⭐ RECOMMENDED for Email Assets
- Uses public GitHub repository for temporary hosting
- Best for: Email asset hosting (no authentication required)
- Creates: `[name].html` with GitHub raw URLs
- **✅ Works perfectly for email clients - no authentication issues**
- **⚠️ REQUIRES asset validation:** Must check actual filenames in local assets folder before generating HTML
- **📁 Organized Structure:** Assets deployed to `email-templates/[template-name]/assets/` for better organization
- **🤖 Automatic Deployment:** Script auto-creates folder structure and deploys assets
- **GitHub Token:** Set in deploy script or use environment variable `$env:GITHUB_TOKEN`

**Option B2: Local Assets Folder**
- Uses local paths: `./assets/image-name.png`
- Best for: Production-ready templates with planned CDN upload
- Creates: `[template-name]/[name].html`
- Requires: Assets already downloaded/available locally
- **📁 Creates template folder:** `[template-name]/assets/` for organization
- Includes: URL updater scripts for CDN migration

**Option C: Assets Already on CDN** ⭐ PRODUCTION READY
- Uses permanent CDN URLs directly: `https://cdn.example.com/path/image.png`
- Best for: Assets already uploaded to CDN before conversion
- Creates: `[name].html` - **Production ready immediately**
- Requires: CDN base URL and asset filenames from user
- **No URL replacement needed - fastest to production (10 min)**

**All temporary strategies (A, B1, B2) include:**
- ✅ `update-cdn-urls.ps1` (PowerShell) - Automated CDN URL replacement (template-specific)
- ✅ `ASSETS.md` - Complete asset documentation (template-specific)
- ✅ `download-assets.ps1` - Asset downloader (ONLY if assets don't exist in repository)

**GitHub temporary CDN (B1) uses generic scripts:**
- ✅ `deploy-to-github.ps1` - Generic deployment script (in Email AI Context folder, works for all templates)
- ✅ `GITHUB-CDN-GUIDE.md` - Generic deployment guide (in Email AI Context folder, reusable)
- ⚠️ **Do NOT regenerate these files** - they already exist and are template-independent

**Strategy C includes:**
- ✅ `ASSETS.md` - CDN asset documentation (no scripts needed)

**DO NOT skip asking about asset strategy!** This determines URL structure in HTML and whether template is immediately production-ready.

---

## 📋 Quick Reference

**When a user provides a Figma URL for email conversion:**

### 🤖 Smart Interactive Workflow

**IMPORTANT:** Use `vscode_askQuestions` tool for all user questions to provide native VS Code picker interface with radio button/dropdown experience.

**AI should automatically detect Figma URLs and initiate interactive questioning:**

1. **User provides Figma URL** (any format):
   - `https://www.figma.com/design/[file-key]/...?node-id=...`
   - `figma.com/design/...`
   - Or simple mention: "Convert this Figma design: [URL]"

2. **AI validates Figma MCP server** (pre-flight check):
   - Test server connection by calling `mcp_my-mcp-server_whoami`
   - If ✅ working: Continue to Q&A using `vscode_askQuestions`
   - If ❌ not working: Show troubleshooting guide

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 VALIDATING FIGMA MCP SERVER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⏳ Testing connection...

[If successful:]
✅ Figma MCP server connected
✅ User: [email] (Team: [team_name])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[If failed:]
❌ Figma MCP server not responding

Troubleshooting:
1. Check VS Code settings.json has mcp-server-figma configured
2. Verify FIGMA_PERSONAL_ACCESS_TOKEN is set correctly
3. Reload VS Code: Ctrl+Shift+P → "Reload Window"
4. Test token: https://www.figma.com/api/explore

Need help? See GETTING_STARTED_GUIDE.md (Part 1: Setup)

Would you like me to show setup instructions? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

3. **AI starts interactive Q&A** (only after server validation passes):

**Use `vscode_askQuestions` tool for interactive picker-based questions:**

```javascript
// Call vscode_askQuestions with all questions at once:
vscode_askQuestions({
  questions: [
    {
      header: "email_type",
      question: "What type of email is this?",
      options: [
        {
          label: "Marketing",
          description: "Promotional emails, campaigns, announcements",
          recommended: true
        },
        {
          label: "Transactional",
          description: "Receipts, confirmations, order updates"
        },
        {
          label: "Newsletter",
          description: "Content updates, blog digests, news"
        }
      ],
      allowFreeformInput: false
    },
    {
      header: "target_esp",
      question: "Which Email Service Provider (ESP) will send this email?",
      options: [
        {
          label: "Custom HTML",
          description: "Manual sending or API integration",
          recommended: true
        },
        {
          label: "Mailchimp",
          description: "Mailchimp platform"
        },
        {
          label: "SendGrid",
          description: "SendGrid/Twilio platform"
        },
        {
          label: "HubSpot",
          description: "HubSpot Marketing Hub"
        },
        {
          label: "Salesforce Marketing Cloud",
          description: "Salesforce SFMC"
        },
        {
          label: "Klaviyo",
          description: "Klaviyo ecommerce platform"
        },
        {
          label: "Other",
          description: "Specify in freeform input"
        }
      ],
      allowFreeformInput: true
    },
    {
      header: "brand_name",
      question: "What is the brand or company name?",
      // No options = free text input
    },
    {
      header: "design_type",
      question: "Is this Figma design responsive or standard (fixed-width)?",
      options: [
        {
          label: "Responsive",
          description: "Design adapts to mobile/tablet/desktop - Use media queries and mobile stacking",
          recommended: true
        },
        {
          label: "Standard (Fixed-Width)",
          description: "Same layout on all devices - No responsive CSS, consistent across email clients"
        }
      ],
      allowFreeformInput: false
    },
    {
      header: "asset_strategy",
      question: "How should image assets be handled?",
      options: [
        {
          label: "Figma CDN URLs",
          description: "Quick preview (expires in 7 days) - Best for testing",
          recommended: true
        },
        {
          label: "GitHub Temporary CDN",
          description: "Public repository (temporary) - RECOMMENDED for email assets",
          recommended: true
        },
        {
          label: "Local Assets Folder",
          description: "Production-ready with ./assets/ paths - Best for staged workflow"
        },
        {
          label: "Assets Already on CDN",
          description: "Permanent CDN URLs - Fastest to production (requires CDN setup)"
        }
      ],
      allowFreeformInput: false
    }
  ]
});

// If "Assets Already on CDN" selected, ask follow-up:
if (asset_strategy === "Assets Already on CDN") {
  vscode_askQuestions({
    questions: [
      {
        header: "cdn_base_url",
        question: "What is your CDN base URL? (e.g., https://cdn.example.com/emails/welcome)"
      },
      {
        header: "asset_naming",
        question: "How should assets be named on CDN?",
        options: [
          {
            label: "Use Figma layer names",
            description: "e.g., 'Logo.png', 'Header Banner.jpg'",
            recommended: true
          },
          {
            label: "Auto-generate simple names",
            description: "e.g., 'asset-1.png', 'asset-2.jpg'"
          },
          {
            label: "Interactive mapping",
            description: "I'll provide filename for each asset"
          }
        ],
        allowFreeformInput: false
      }
    ]
  });
}

// If "GitHub Temporary CDN" selected, ask follow-up:
if (asset_strategy === "GitHub Temporary CDN") {
  vscode_askQuestions({
    questions: [
      {
        header: "github_username",
        question: "What is your GitHub username?"
      },
      {
        header: "assets_folder_exists",
        question: "Do assets already exist in ./assets/ folder?",
        options: [
          {
            label: "Yes, assets are downloaded",
            description: "Ready to deploy to GitHub",
            recommended: true
          },
          {
            label: "No, need to download first",
            description: "Download from Figma URLs first"
          }
        ],
        allowFreeformInput: false
      }
    ]
  });
}
```

**Benefits of Interactive Pickers:**
- ✅ Cleaner UI - Dropdown/picker interface instead of text
- ✅ Faster selection - Click to choose, no typing
- ✅ Clear options - Descriptions show details for each choice
- ✅ Fewer errors - Can't type wrong option
- ✅ Recommended defaults - Shows suggested choice
- ✅ Better UX - Professional, native VS Code experience

**Display to User:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 EMAIL CONVERSION - CONFIGURATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Please answer a few questions to configure the conversion...

[VS Code opens interactive picker for each question]

✓ All set! Starting conversion...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

3. **AI processes with gathered information:**
   
   **Step 3A: Deploy Assets to GitHub (if assets exist locally)**
   
   If user answered "Yes, assets are downloaded":
   
   ```javascript
   // AI MUST execute deployment BEFORE generating HTML
   run_in_terminal({
     command: ".\\Email AI Context\\deploy-to-github.ps1",
     explanation: "Deploying email assets to GitHub CDN",
     goal: "Upload assets to GitHub repository",
     isBackground: false,
     timeout: 60000  // 60 seconds
   });
   
   // Wait for deployment to complete
   // Check terminal output for success/failure
   // If successful: "✅ Assets deployed successfully!"
   // If failed: Show error, provide troubleshooting
   ```
   
   **Display to User during deployment:**
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   📤 DEPLOYING ASSETS TO GITHUB
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ⏳ Initializing git repository...
   ⏳ Adding assets folder...
   ⏳ Committing changes...
   ⏳ Pushing to GitHub...
   
   ✅ Deployment successful!
   ✅ Assets available at: https://github.com/[username]/[repo]
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```
   
   **Step 3B: Extract Figma design**
   - Call `mcp_my-mcp-server_get_design_context`
   - Analyze structure and assets
   
   **Step 3C: Generate HTML**
   - Uses GitHub CDN URLs (since assets are now deployed)
   - Maps actual asset filenames from local folder
   - Creates production-ready HTML
   
   **Step 3D: Create documentation**
   - ASSETS.md with GitHub CDN URLs
   - update-cdn-urls.ps1 for future migration
   - Summary with next steps

4. **No prompt copying required** - Just provide URL and answer interactive questions!

---

### 🎯 Detection Patterns

**AI should recognize these inputs as conversion requests:**

```
✅ Automatic Detection:
- "Convert this Figma email: [URL]"
- "Create HTML from: [FIGMA_URL]"
- "Email template from Figma: [URL]"
- "[FIGMA_URL]" (just the URL alone if in email context)
- "Turn this into an email: [URL]"
- "Make an email from: [URL]"

✅ Explicit Keywords:
- "figma to email"
- "convert figma design"
- "email from figma"
- "figma email template"
```

**After detection, start interactive Q&A immediately (don't ask "shall I convert?" - just do it)**

---

### 📝 Smart Defaults

If user doesn't answer a question, use these defaults:

| Question | Default | Reasoning |
|----------|---------|-----------|
| Email Type | Marketing | Most common |
| Target ESP | Custom | Most flexible |
| Brand | Extract from Figma | Try to auto-detect |
| Design Type | Responsive | Modern best practice, better mobile experience |
| Asset Strategy | Option A (Figma CDN) | Fastest, least friction |

**If user provides partial info upfront, skip those questions:**

Example:
```
User: "Convert this Figma to a transactional email for SendGrid: [URL]"

AI: [Skips Q1 & Q2, already knows: Transactional + SendGrid]
     [Asks Q3: Brand name]
     [Asks Q4: Asset strategy]
```

---

### 🎨 Interactive Asset Mapping (Strategy C)

**When user chooses "Assets Already on CDN", use interactive questions for each asset:**

**Step 1: Show asset preview to user:**
```
Found [N] image assets in design:
1. [Asset 1 name] ([W]×[H]px) - [Purpose]
2. [Asset 2 name] ([W]×[H]px) - [Purpose]
3. [Asset 3 name] ([W]×[H]px) - [Purpose]
...

Example from one template:
1. Logo (200×50px) - Header branding
2. hero (600×400px) - Main banner
3. icon-calendar (24×24px) - Date indicator
```

**Step 2: Use interactive picker for each asset:**
```javascript
// For each asset, create an interactive question:
const assetQuestions = assets.map((asset, index) => ({
  header: `asset_${index}_filename`,
  question: `CDN filename for ${asset.description} (${asset.dimensions})?`,
  options: [
    {
      label: asset.suggestedName,  // e.g., "logo.png"
      description: `Recommended: ${asset.suggestedName}`,
      recommended: true
    },
    {
      label: "Use Figma layer name",
      description: `"${asset.figmaLayerName}"`  // e.g., "Logo.png", "hero.png", "Feature Card 1.png"
    }
  ],
  allowFreeformInput: true  // User can type custom filename
}));

vscode_askQuestions({ questions: assetQuestions });
```

**Example Interactive Experience:**
```
VS Code opens picker for each asset:

┌─────────────────────────────────────────────────┐
│ CDN filename for Logo (265×36px)?              │
├─────────────────────────────────────────────────┤
│ ● logo.png (Recommended)                       │
│   Use Figma layer name ("Accelerate...")      │
│ ───────────────────────────────────────────    │
│ Type custom filename here                      │
└─────────────────────────────────────────────────┘

[User selects option or types custom name]
```

**AI should provide smart suggestions based on:**
- Asset type (logo, icon, banner, button) → Suggests: `logo.png`, `icon-calendar.svg`
- Dimensions → Large images get descriptive names: `hero-banner-600x230.jpg`
- Position in layout (header, footer, hero) → Prefix: `header-`, `footer-`, `hero-`
- File format recommendations (PNG for transparency, JPG for photos)
- Figma layer name (always offer as alternative option)

**Benefits:**
- ✅ Visual picker interface per asset
- ✅ Smart default suggestions
- ✅ Option to use Figma layer name
- ✅ Freedom to type custom name
- ✅ Context-aware recommendations

---

### ⚡ Express Mode

**For experienced users, support one-line conversions:**

```
User: "Figma [URL] | Marketing | SendGrid | Acme Corp | CDN: https://cdn.acme.com/emails/welcome"

AI: [Parses everything, minimal confirmation:]
    ✓ Email Type: Marketing
    ✓ ESP: SendGrid  
    ✓ Brand: Acme Corp
    ✓ Assets: CDN (https://cdn.acme.com/emails/welcome)
    
    Proceed with conversion? [Y/n]
```

**Pipe-separated format:**
```
figma [URL] | [type] | [ESP] | [brand] | [strategy]
```

---

### 🎬 User Experience: Interactive Questions

**What the user sees when conversion starts:**

```
AI: I'll convert this Figma design to an email template. Let me ask a few quick questions...
```

**VS Code opens interactive picker (one at a time):**

```
┌────────────────────────────────────────────────────────┐
│ What type of email is this?                           │
├────────────────────────────────────────────────────────┤
│ ▸ Marketing                                    ⭐ Rec. │
│   Promotional emails, campaigns, announcements         │
│                                                         │
│   Transactional                                        │
│   Receipts, confirmations, order updates               │
│                                                         │
│   Newsletter                                           │
│   Content updates, blog digests, news                  │
└────────────────────────────────────────────────────────┘
```

**User clicks "Marketing" → Next question appears:**

```
┌────────────────────────────────────────────────────────┐
│ Which Email Service Provider (ESP) will send this?    │
├────────────────────────────────────────────────────────┤
│ ▸ Custom HTML                                  ⭐ Rec. │
│   Manual sending or API integration                    │
│                                                         │
│   Mailchimp                                            │
│   Mailchimp platform                                   │
│                                                         │
│   SendGrid                                             │
│   SendGrid/Twilio platform                             │
│                                                         │
│   [+ 4 more options...]                                │
│                                                         │
│   Type to filter or enter custom...                    │
└────────────────────────────────────────────────────────┘
```

**User selects "SendGrid" → Next question:**

```
┌────────────────────────────────────────────────────────┐
│ What is the brand or company name?                    │
├────────────────────────────────────────────────────────┤
│ [Type here: ________________]                          │
└────────────────────────────────────────────────────────┘
```

**User types "Acme Corp" → Final question:**

```
┌────────────────────────────────────────────────────────┐
│ How should image assets be handled?                   │
├────────────────────────────────────────────────────────┤
│ ▸ Figma CDN URLs                               ⭐ Rec. │
│   Quick preview (expires in 7 days)                    │
│   Best for testing                                     │
│                                                         │
│   Local Assets Folder                                  │
│   Production-ready with ./assets/ paths                │
│   Best for staged workflow                             │
│                                                         │
│   Assets Already on CDN                                │
│   Permanent CDN URLs - Fastest to production           │
│   (requires CDN setup)                                 │
└────────────────────────────────────────────────────────┘
```

**After all questions answered:**

```
AI: ✓ Configuration complete!

    Email Type: Marketing
    ESP: SendGrid
    Brand: Acme Corp
    Assets: Local Assets Folder

    Starting conversion...
```

**Key UX benefits:**
- ✅ **Native VS Code interface** - Feels professional and integrated
- ✅ **Visual clarity** - No text parsing, just click
- ✅ **Contextual help** - Descriptions explain each option
- ✅ **Recommended defaults** - Marked with ⭐ for quick selection
- ✅ **Type-ahead filtering** - For long option lists
- ✅ **Freeform fallback** - Can always type custom answer
- ✅ **Keyboard navigation** - Arrow keys + Enter to select
- ✅ **No typos** - Predefined options prevent errors

---

### 📊 Conversion Progress Indicators

**Show progress during conversion:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 CONVERTING EMAIL TEMPLATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏳ Extracting Figma design...
✓ Design extracted (27 assets found)

⏳ Analyzing structure...
✓ Identified 6 modules (Header, Hero, Body, CTA, Gallery, Footer)

⏳ Converting to email HTML...
✓ Generated table-based layout (600px, mobile responsive)

⏳ Processing images...
✓ All images mapped with explicit dimensions

⏳ Creating files...
✓ welcome-email-preview.html (30KB)
✓ ASSETS.md (documented 27 assets)
✓ update-cdn-urls.ps1 + .js

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ CONVERSION COMPLETE!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### 🎯 Success Checklist (for AI to verify)

Before marking conversion complete:

- [ ] **Pre-flight:** Validated Figma MCP server is working (whoami call successful)
- [ ] **Detection:** Detected Figma URL correctly and extracted file-key/node-id
- [ ] **Interactive Q&A:** Used `vscode_askQuestions` tool for configuration questions (not text-based prompts)
- [ ] **Gathered Info:** Asked all required questions with options and descriptions
- [ ] **User Experience:** Provided recommended defaults marked in picker interface
- [ ] **GitHub Deployment (Strategy B1):** If assets exist locally AND Strategy B1 chosen:
  - [ ] Executed `run_in_terminal` with `deploy-to-github.ps1` script
  - [ ] Waited for deployment to complete (did not proceed until finished)
  - [ ] Verified deployment success from terminal output
  - [ ] If deployment failed, showed troubleshooting steps to user
- [ ] **Asset Names:** Extracted actual Figma layer names for all images (from data-name attributes)
- [ ] **HTML Generated:** Generated HTML with correct asset strategy
- [ ] **Asset References:** HTML uses actual Figma layer names as filenames (not generic placeholders)
- [ ] **Images:** All images have explicit dimensions (no `height:auto`)
- [ ] **Filename:** Created appropriate filename based on strategy
- [ ] **Scripts:** Included asset management scripts (if Strategy A or B)
- [ ] **Documentation:** Created ASSETS.md with correct URL types
- [ ] **ASSETS.md Mapping:** Documents Figma layer name → filename mapping clearly
- [ ] **Strategy C:** Used CDN URLs throughout if Strategy C
- [ ] **Simple Shapes:** Used CSS for bullets/dividers (not images when possible)
- [ ] **Quality:** No stretched or distorted images
- [ ] **Layout:** Table-based layout (no flexbox/grid)
- [ ] **Styling:** Inline CSS on all elements
- [ ] **Mobile:** Mobile responsive classes added (ONLY if design_type = "Responsive")
- [ ] **Tokens:** Token usage summary provided
- [ ] **Summary:** Showed completion summary with next steps

---

## 📁 Repository Structure

```
ai-email-templates/                    ← GitHub Repository
├── Email AI Context/                  ← Generic (for all templates)
│   ├── EMAIL_AI_CONTEXT.md           ← This file
│   ├── EMAIL_CONVERSION_PROMPT.md
│   ├── EMAIL_CLIENT_RISKS.md
│   ├── deploy-to-github.ps1          ← Generic deployment script
│   ├── GITHUB-CDN-GUIDE.md
│   └── ... (other generic docs)
│
├── [template-name-1]/                 ← Template-specific folder
│   ├── assets/                        ← Template assets
│   │   ├── logo.png
│   │   ├── banner.jpg
│   │   └── ...
│   ├── [template-name-1].html        ← Email template
│   ├── ASSETS.md                      ← Asset documentation
│   ├── update-cdn-urls.ps1           ← CDN migration script
│   └── download-assets.ps1           ← (if needed)
│
└── [template-name-2]/                 ← Another template
    ├── assets/
    ├── [template-name-2].html
    └── ...
```

**Example with actual template:**
```
ai-email-templates/
├── Email AI Context/              ← Generic (for all templates)
│   ├── EMAIL_AI_CONTEXT.md      ← This file
│   ├── EMAIL_CONVERSION_PROMPT.md
│   ├── EMAIL_CLIENT_RISKS.md
│   ├── deploy-to-github.ps1     ← Generic deployment script
│   ├── GITHUB-CDN-GUIDE.md
│   └── ... (other generic docs)
│
├── [template-name-1]/             ← Template-specific folder
│   ├── assets/                    ← Template assets
│   │   ├── logo.png
│   │   ├── banner.jpg
│   │   └── ...
│   ├── [template-name-1].html    ← Email template
│   ├── ASSETS.md                  ← Asset documentation
│   ├── update-cdn-urls.ps1       ← CDN migration script
│   └── download-assets.ps1       ← (if needed)
│
└── [template-name-2]/             ← Another template
    ├── assets/
    ├── [template-name-2].html
    └── ...

**Example with your-exclusive-invitation:**
```
ai-email-templates/
├── Email AI Context/
│   └── ... (generic files)
│
└── your-exclusive-invitation/
    ├── assets/
    │   ├── Accelerate Event Summit Logo.png
    │   ├── Banner.gif
    │   └── ... (25 assets)
    ├── your-exclusive-invitation.html
    ├── ASSETS.md
    └── update-cdn-urls.ps1
```

**GitHub CDN URL Format:**
```
https://raw.githubusercontent.com/[owner]/[repo]/[branch]/[template-name]/assets/[filename]

Example:
https://raw.githubusercontent.com/numani2c/ai-email-templates/main/your-exclusive-invitation/assets/Banner.gif
```

**Benefits of This Structure:**
- ✅ Multi-template support - Each template in its own folder
- ✅ Clean organization - Generic files separate from template-specific files
- ✅ Easy to add new templates - Just create new template folder
- ✅ No naming conflicts - Assets scoped to template folder
- ✅ Clear CDN paths - Template name in URL for clarity

---

## Step-by-Step Email Conversion Workflow

### Step 1: Gather Requirements

**Required Information:**
- Figma design URL
- Email type (Marketing, Transactional, Newsletter)
- Target ESP (Mailchimp, SendGrid, HubSpot, Custom, etc.)
- Brand name
- **Template name** (derived from Figma design name or brand/email purpose)
- **Asset handling strategy** (new requirement)

**Template Naming Convention:**
- Use kebab-case (lowercase with hyphens)
- Descriptive and concise
- Examples:
  - `your-exclusive-invitation` 
  - `welcome-email`
  - `password-reset`
  - `monthly-newsletter`
  - `order-confirmation`
- **This becomes the folder name:** `[template-name]/`
- **Used in GitHub CDN URLs:** `.../[template-name]/assets/...`

**Ask User if Not Provided:**
```
To convert this email accurately, please provide:
1. Email type (Marketing, Transactional, or Newsletter)
2. Target ESP (Mailchimp, SendGrid, etc., or "Custom")
3. Asset Handling Strategy - Choose ONE:
   
   Option A: "Use Figma CDN URLs" (Quick preview, 7-day expiry)
   - Images link directly to Figma CDN
   - For: Quick previews, internal testing, stakeholder review
   - No asset download/management needed
   - Must be replaced within 7 days for production
   
   Option B: "Use Local Assets Folder" (For later CDN upload)
   - Images reference local folder: ./assets/ or email-templates/[name]/assets/
   - For: Production workflow with planned CDN upload
   - Requires: Assets already downloaded/available locally
   - Ready for CDN upload with batch URL replacement script
   
   Option C: "Assets Already on CDN" (Production ready immediately)
   - Images use permanent CDN URLs directly
   - For: Assets already uploaded to CDN before conversion
   - Requires: CDN base URL and asset filenames/mapping
   - No URL replacement needed - production ready
   - Example: https://cdn.example.com/emails/welcome/logo.png
   
   Default: Option A (Figma CDN) if not specified
```

**Asset Strategy Decision Tree:**
```
User specifies asset strategy?
│
├─ "Use Figma CDN" OR not specified (Option A)
│  ├─ Use Figma CDN URLs directly in HTML
│  ├─ Create preview template: [name]-preview.html
│  ├─ Include 7-day expiry warning
│  ├─ Document all Figma URLs in ASSETS.md
│  └─ Include update-cdn-urls scripts for later conversion
│
├─ "Use Local Assets Folder" (Option B)
│  ├─ Ask for assets folder path (default: ./assets/)
│  ├─ Reference local paths in HTML: ./assets/image-name.png
│  ├─ Create production template: [name].html
│  ├─ Assumes assets already exist locally
│  ├─ Document local paths in ASSETS.md
│  └─ Include update-cdn-urls scripts for CDN migration
│
└─ "Assets Already on CDN" (Option C)
   ├─ Ask for CDN base URL (e.g., https://cdn.example.com/emails/welcome)
   ├─ Ask for asset naming convention or provide mapping
   ├─ Use CDN URLs directly in HTML: [cdn-base]/image-name.png
   ├─ Create production template: [name].html
   ├─ No URL replacement needed
   ├─ Document CDN URLs in ASSETS.md
   └─ Production ready immediately - no scripts needed
```

**When to Use Each Option:**

| Scenario | Best Option | Reason |
|----------|-------------|--------|
| Quick stakeholder review | **Option A** | Fastest, no asset prep |
| Standard workflow | **Option A → B** | Preview first, then production |
| Assets prepared locally | **Option B** | Organized, ready for CDN |
| Assets already on CDN | **Option C** | Skip steps, production ready |
| Unknown CDN yet | **Option A** | Maximum flexibility |
| Urgent production deploy | **Option C** | If assets uploaded, immediate deploy |

---

### Step 2: Extract Figma Design

**Use Figma MCP:**
```
mcp_my-mcp-server_get_design_context(
  nodeId: "extracted from URL",
  fileKey: "extracted from URL",
  clientLanguages: "html,css",
  clientFrameworks: "email"
)
```

**CRITICAL: Analyze Response Thoroughly:**

1. **Extract template name from Figma:**
   - Use Figma design/frame name from the response
   - Convert to kebab-case (lowercase with hyphens)
   - Examples:
     - "Your exclusive invitation" → `your-exclusive-invitation`
     - "Welcome Email" → `welcome-email`
     - "Password_Reset" → `password-reset`
   - This becomes the folder name and part of CDN URLs
2. **Review screenshot** for visual accuracy
3. **Identify sections** (header, hero, content, footer)
4. **Note exact colors, fonts, spacing** from the generated code
5. **EXTRACT ALL IMAGE URLS** from the response:
   - Look for `const img[Name] = "https://www.figma.com/api/mcp/asset/[id]"` 
   - Create a list of ALL image URLs with their variable names
   - Note the exact dimensions from the React code (width/height attributes)
   - These URLs are valid for 7 days only
6. **Identify dynamic content** (names, dates, balances, etc.)

**Example Image Extraction:**
```javascript
// From Figma response:
const img0211 = "https://www.figma.com/api/mcp/asset/168b53d5-a64c-4d1e-96a2-e41394248bb8";
const imgLogoBorder = "https://www.figma.com/api/mcp/asset/7c3cff47-13df-4a33-afb7-482f94ded908";
const imgBankingPayments = "https://www.figma.com/api/mcp/asset/87c1cfac-4f2e-4518-810b-f44ad1379995";
// ... etc

// Create mapping:
Hero Background → img0211 → 168b53d5-a64c-4d1e-96a2-e41394248bb8
Logo Border → imgLogoBorder → 7c3cff47-13df-4a33-afb7-482f94ded908
Banking Payments Text → imgBankingPayments → 87c1cfac-4f2e-4518-810b-f44ad1379995
```

**⚠️ CRITICAL:** Save all image URLs immediately - they expire in 7 days!

---

### Step 2A: 🏷️ DETECT AND MAP ASSET NAMES FROM FIGMA

**⚠️ CRITICAL FOR ASSET STRATEGY B (Local Assets):**

When user chooses "Local Assets Folder" strategy, you MUST use actual Figma layer names in HTML, not generic placeholders. This eliminates the need for renaming after download.

#### 🌍 Universal Principle (Template-Independent):

**THIS SOLUTION WORKS FOR ANY TEMPLATE - NO HARDCODED ASSUMPTIONS:**

The naming strategy is purely data-driven. Whatever layer names exist in the Figma design → Use them as filenames. This means:

- ✅ Template A has "Hero Banner" → Use `Hero Banner.png`
- ✅ Template B has "hero" → Use `hero.png`
- ✅ Template C has "main-image" → Use `main-image.png`
- ✅ Template D has "Background Image 1" → Use `Background Image 1.png`

**No manual configuration needed.** The system extracts names from Figma's own metadata (`data-name` attributes), so it adapts to any template automatically.

#### Why This Matters:

**Problem:** Using generic names like `logo.png`, `banner.jpg` causes mismatches when users download from Figma.

**Figma exports use layer names (examples from ANY template):**
- Layer "Company Logo" → Downloads as `Company Logo.png`
- Layer "hero" → Downloads as `hero.png`
- Layer "main-banner" → Downloads as `main-banner.png`
- Layer "Feature Image 1" → Downloads as `Feature Image 1.png`

**Universal Rule:** Whatever the layer name is in Figma → That's the filename

**If HTML references generic names:** User must manually rename 20+ files → wasted time, errors.

#### Detection Strategy:

**From Figma Response, Extract Layer Names:**

```javascript
// Figma MCP returns (pattern for ANY template):
const imgSomething = "https://www.figma.com/api/mcp/asset/[uuid]";
const imgAnother = "https://www.figma.com/api/mcp/asset/[uuid]";

// Also includes usage in JSX:
<img src={imgSomething} alt="..." width="X" height="Y" />
// Often near: data-name="[ACTUAL LAYER NAME FROM FIGMA]"

// Examples of what data-name might contain in different templates:
// data-name="Logo" or data-name="Company Logo Brand" or
// data-name="hero" or data-name="main_banner" or
// data-name="Feature Card 1" or data-name="[ANY NAME]"
```

**Steps to Detect Names:**

1. **Look for `data-name` attributes** in the Figma response JSX
2. **Variable names provide hints** (imgLogo → likely "Logo" layer)
3. **Context from parent elements** (nested in Header → might be "Header Logo")
4. **When unclear:** Use descriptive names based on position and purpose

**Mapping Logic:**

```javascript
// Extract from Figma response (works for ANY template):
Asset Variable: imgLogo (or imgHero, imgBanner, img...)
data-name attribute: "[WHATEVER FIGMA LAYER NAME IS]" ✅ USE THIS EXACT NAME
Context: Inside [relevant] section
Dimensions: [W]×[H]px

// Generate filename:
Filename: "[SAME AS data-name].[ext]"
HTML reference: <img src="./assets/[SAME AS data-name].[ext]">

// Real-world examples showing diversity:
// Example 1: data-name="Company Logo" → Filename: "Company Logo.png"
// Example 2: data-name="hero" → Filename: "hero.png"
// Example 3: data-name="Feature Card 1" → Filename: "Feature Card 1.png"
```

#### Smart Naming Rules:

**Priority Order for Detecting Names:**

1. **data-name attribute** (highest priority - exact Figma layer name)
   ```javascript
   <div data-name="[LAYER_NAME]">...</div>
   → Use: "[LAYER_NAME].[ext]"
   
   // Real examples from different templates:
   <div data-name="Logo"> → "Logo.png"
   <div data-name="hero"> → "hero.png"  
   <div data-name="Feature Image 1"> → "Feature Image 1.png"
   <div data-name="main_banner"> → "main_banner.jpg"
   ```

2. **Variable name clues** (when data-name missing, parse variable)
   ```javascript
   const imgLogo = "..."     → Likely layer: "Logo" or "logo"
   const imgHeroBg = "..."   → Likely layer: "Hero Bg" or "heroBg"  
   const imgIcon24 = "..."   → Likely layer: "Icon 24" or "icon24"
   // Process: Remove "img" prefix, interpret camelCase
   ```

3. **Semantic fallback** (only when both above fail)
   ```javascript
   // Analyze context to generate descriptive name:
   imgX in header section, dimensions suggest logo
   → Fallback: "header-logo.png"
   
   imgY in footer, appears to be background
   → Fallback: "footer-bg.jpg"
   ```

#### Handling Special Cases:

**Case 1: Simple Shapes (Bullets, Dividers)**
```
Detected: Small triangle shape 6×24px
Action: Generate with CSS, not an image
<div style="width:0; height:0; border-left:6px solid #1434cb; ..."></div>
```

**Case 2: Text Layers Exported as Images**
```
Detected: "[LAYER_NAME]" layer contains text, but exported as image
Action: Use the image with data-name as filename: "[LAYER_NAME].png"

// Example: data-name="Hero Title" → "Hero Title.png"
// Example: data-name="heading" → "heading.png"
```

**Case 3: Spaces and Special Characters**
```
Rule: Preserve ALL characters from Figma layer name

// Examples from various templates:
Figma layer: "Feature Image 1"  → Filename: "Feature Image 1.png"
Figma layer: "hero_banner"      → Filename: "hero_banner.png"
Figma layer: "Icon-24"          → Filename: "Icon-24.png"
Figma layer: "CTA Button"       → Filename: "CTA Button.png"

HTML: <img src="./assets/[EXACT_LAYER_NAME].[ext]">
Note: Spaces, underscores, hyphens are all valid in URLs
```

**Case 4: Missing or Generic Names**
```
Variable: img0211 (no clear name)
data-name: Not found
Action: Use descriptive name based on context:
- In hero section → "hero-background.jpg"
- In footer → "footer-background.png"
Document in ASSETS.md with note about expected name
```

#### File Extension Logic:

```javascript
// Determine extension from content type or usage:
- Photos, banners, complex graphics → .jpg or .png
- Logos, icons with transparency → .png
- Simple graphics → .png or .svg
- Social media icons → .png

// Default: .png (safest for email)
```

#### Implementation Checklist:

For each image asset detected:

- [ ] Extract variable name (e.g., `imgLogo`)
- [ ] Find corresponding `data-name` attribute
- [ ] Determine file extension (.png, .jpg)
- [ ] Create asset entry:
  ```javascript
  {
    varName: "imgSomething",
    layerName: "[FROM data-name ATTRIBUTE]",
    filename: "[SAME AS layerName].[ext]",
    url: "https://www.figma.com/api/mcp/asset/...",
    dimensions: { width: X, height: Y },
    purpose: "[Describe purpose]"
  }
  
  // Example 1:
  // { varName: "imgLogo", layerName: "Company Logo", filename: "Company Logo.png", ... }
  
  // Example 2:
  // { varName: "imgHero", layerName: "hero", filename: "hero.jpg", ... }
  ```
- [ ] Use `filename` in HTML `src` attribute
- [ ] Document in ASSETS.md with exact filename

#### HTML Generation:

**✅ CORRECT Approach (Template-Independent):**
```html
<!-- Use actual Figma layer name (whatever it is): -->
<img src="./assets/[FIGMA_LAYER_NAME].[ext]" 
     alt="[descriptive alt]" 
     width="[W]" 
     height="[H]" 
     style="display: block; width: [W]px; height: [H]px;">

<!-- Real examples from different templates: -->
<img src="./assets/Logo.png" ... >        <!-- From template with "Logo" layer -->
<img src="./assets/hero banner.png" ... > <!-- From template with "hero banner" layer -->
<img src="./assets/main-img.jpg" ... >    <!-- From template with "main-img" layer -->
```

**❌ WRONG Approach:**
```html
<!-- Don't use generic names: -->
<img src="./assets/logo.png" ... >
<!-- Unless you create a rename script for user -->
```

#### ASSETS.md Documentation Format:

```markdown
## Required Images

| Asset Description | Figma Layer Name | Filename | Dimensions | Figma URL |
|-------------------|------------------|----------|------------|-----------|
| [Describe purpose] | [Exact layer name] | `[Same as layer].[ext]` | [W×H]px | https://... |

**Examples from different templates:**
| Logo | Logo | `Logo.png` | 200×50px | https://... |
| Hero image | hero | `hero.jpg` | 600×400px | https://... |
| CTA button | CTA Primary | `CTA Primary.png` | 180×45px | https://... |

**Download Instructions:**
1. Download images from Figma URLs above (7-day validity)
2. Save files with exact filenames shown in "Filename" column
3. Place in `./assets/` folder
4. ✅ No renaming needed - template uses these exact names

**Note:** Filename matches Figma layer name for easy identification.
```

#### Alternative: Generic Names with Rename Script

**If using generic names is preferred (for consistency across projects):**

1. Generate HTML with generic names: `logo.png`, `icon-date.png`
2. Create rename script in ASSETS.md:

```markdown
## Asset Rename Script

After downloading from Figma, rename files:

**PowerShell:**
```powershell
# Map Figma layer names → Standard names
Rename-Item "[FIGMA_LAYER_NAME].[ext]" "logo.png"
Rename-Item "[FIGMA_LAYER_NAME].[ext]" "hero.jpg"
Rename-Item "[FIGMA_LAYER_NAME].[ext]" "icon-1.png"
# ... for each asset
```

**Bash:**
```bash
mv "[FIGMA_LAYER_NAME].[ext]" "logo.png"
mv "[FIGMA_LAYER_NAME].[ext]" "hero.jpg"
mv "[FIGMA_LAYER_NAME].[ext]" "icon-1.png"
```
```

**When to use:** User explicitly requests standardized names, or working on a large project with naming conventions.

**Default behavior:** Use actual Figma layer names (no rename needed).

---

### 🚨 Fallback Strategy: Missing Assets Handling

**WHEN TO USE:** Asset name mapping fails or user chooses Local Assets strategy but some files are missing.

#### Problem Scenarios:

1. **Local Assets strategy chosen** but asset files don't exist in `./assets/` folder yet
2. **Asset name extraction fails** (missing `data-name` attributes, unclear layer names)
3. **User testing/preview mode** - needs to see layout before downloading assets
4. **Partial asset availability** - some assets downloaded, others missing

#### Solution: Temporary Figma CDN URL Fallback

**Automatic Fallback Logic:**

```javascript
// For each asset in Local Assets mode:
function generateImageSrc(asset) {
  const localPath = `./assets/${asset.filename}`;
  const figmaCDNUrl = asset.figmaUrl;
  
  // Check if generating HTML before assets are downloaded
  // OR if asset name mapping is uncertain
  if (assetsNotYetDownloaded || nameMappingUncertain) {
    return figmaCDNUrl;  // Use Figma CDN temporarily
  }
  
  return localPath;  // Use local path
}
```

**Implementation in HTML:**

```html
<!-- When asset is missing or mapping fails: -->
<img src="https://www.figma.com/api/mcp/asset/[uuid]" 
     data-local-path="./assets/[expected-filename].[ext]"
     alt="[description]" 
     width="[W]" 
     height="[H]">
     
<!-- Include HTML comment warning: -->
<!-- ⚠️ TEMPORARY: Using Figma CDN URL - Replace with local asset -->
```

#### User Notification Template

**When fallback URLs are used, generate this notification:**

```markdown
## ⚠️ ASSET FALLBACK NOTICE

Some images in the generated HTML are using **temporary Figma CDN URLs** instead of local paths:

### Missing/Fallback Assets:

| Asset | Expected Local Path | Current Status | Action Required |
|-------|---------------------|----------------|-----------------|
| [Asset name] | `./assets/[filename].[ext]` | ❌ Using Figma CDN (expires in 7 days) | Download and update |
| [Asset name] | `./assets/[filename].[ext]` | ❌ Using Figma CDN (expires in 7 days) | Download and update |

**Why this happened:**
- ✅ You chose "Local Assets Folder" strategy
- ⚠️ Assets not yet downloaded to `./assets/` folder
- ✅ Template uses Figma CDN URLs temporarily so you can preview layout

**What to do:**

1. **Download missing assets** from Figma URLs in ASSETS.md
2. **Save with exact filenames** shown in "Expected Local Path" column
3. **Run update script** to replace Figma CDN URLs with local paths:
   ```powershell
   .\update-to-local-assets.ps1
   ```
   OR manually find/replace:
   ```
   Find:    https://www.figma.com/api/mcp/asset/[uuid]
   Replace: ./assets/[filename].[ext]
   ```

**Timeline:** Figma CDN URLs expire in **7 days** - download and update before then!

**Assets already in local format:** [N] images are correctly using `./assets/` paths.
```

#### Auto-Generated Update Script

**Create `update-to-local-assets.ps1` when fallback used:**

```powershell
# Auto-generated script to replace Figma CDN URLs with local paths
param(
    [string]$HtmlFile = "[template-name].html"
)

Write-Host "Updating Figma CDN URLs to local asset paths..." -ForegroundColor Cyan

$replacements = @(
    @{
        Find = "https://www.figma.com/api/mcp/asset/[uuid-1]"
        Replace = "./assets/[filename-1].[ext]"
        Asset = "[Asset 1 name]"
    },
    @{
        Find = "https://www.figma.com/api/mcp/asset/[uuid-2]"
        Replace = "./assets/[filename-2].[ext]"
        Asset = "[Asset 2 name]"
    }
    # ... for each fallback asset
)

$content = Get-Content $HtmlFile -Raw
$updated = 0

foreach ($item in $replacements) {
    if ($content -match [regex]::Escape($item.Find)) {
        Write-Host "  ✓ Updating: $($item.Asset)" -ForegroundColor Green
        $content = $content -replace [regex]::Escape($item.Find), $item.Replace
        $updated++
    } else {
        Write-Host "  - Already updated: $($item.Asset)" -ForegroundColor Yellow
    }
}

Set-Content $HtmlFile -Value $content -NoNewline

Write-Host "`n✓ Updated $updated asset URLs" -ForegroundColor Green
Write-Host "⚠️ Verify all assets exist in ./assets/ folder before deployment!" -ForegroundColor Yellow
```

**Usage:** `.\update-to-local-assets.ps1`

#### Deliverables When Using Fallback:

When Figma CDN fallback is used, provide:

1. ✅ **HTML template** with Figma CDN URLs (temporary)
2. ✅ **ASSETS.md** with complete asset list and download instructions
3. ✅ **FALLBACK-NOTICE.md** explaining which assets need updating
4. ✅ **update-to-local-assets.ps1** automated replacement script
5. ✅ **update-cdn-urls.ps1** for eventual CDN migration (once assets are local)

#### Best Practices:

**DO:**
- ✅ Clearly mark fallback URLs with HTML comments
- ✅ Generate detailed asset replacement instructions
- ✅ Include `data-local-path` attributes for reference
- ✅ Provide automated update script
- ✅ List missing vs. available assets clearly
- ✅ Warn about 7-day expiry timeline

**DON'T:**
- ❌ Use fallback silently without notifying user
- ❌ Mix Figma CDN and local paths without clear documentation
- ❌ Skip ASSETS.md documentation when using fallback
- ❌ Assume user knows why Figma URLs are used

#### Example: Partial Fallback Scenario

```html
<!-- ✅ CORRECT - Asset exists locally -->
<img src="./assets/Logo.png" alt="Company logo" width="200" height="50">

<!-- ⚠️ FALLBACK - Asset not yet downloaded -->
<img src="https://www.figma.com/api/mcp/asset/abc-123" 
     data-local-path="./assets/hero banner.png"
     alt="Hero banner" 
     width="600" 
     height="400">
<!-- ⚠️ TEMPORARY: Using Figma CDN URL - Update after downloading asset -->

<!-- ✅ CORRECT - Asset exists locally -->
<img src="./assets/CTA Button.png" alt="Sign up button" width="180" height="45">
```

**Notification shows:**
- 2 assets using local paths ✅
- 1 asset using Figma CDN fallback ⚠️
- Clear instructions to download "hero banner.png" and run update script

---

### Step 2B: 🔍 Validate and Map Actual Asset Files (REQUIRED for Options B1 & B2)

**⚠️ CRITICAL FOR BOTH:**
- **Option B1 (GitHub Temporary CDN):** Must validate actual filenames before generating HTML
- **Option B2 (Local Assets Folder):** Must validate actual filenames before generating HTML

**Why this is essential for BOTH strategies:**
The HTML must reference the exact filenames that exist in the assets folder (which will be deployed to GitHub or used locally). This prevents filename mismatches and broken images.

#### Why This Step Is Essential:

**Problem:** Figma layer names don't always match downloaded filenames:
- Figma layer: "Logo" → User may have downloaded as: "Accelerate Event Summit Logo.png"
- Figma layer: "hero" → User may have downloaded as: "Banner.gif"
- Figma layer: "Feature 1" → User may have downloaded as: "Feature 4.png"

**Without validation:** HTML references wrong filenames → Broken images
**With validation:** HTML uses actual filenames → Works immediately

#### Implementation Steps:

**1. Check if assets folder exists:**

```javascript
// Use list_dir tool to check folder
const assetsPath = "./assets" // or user-specified path
const folderExists = await listDirectory(assetsPath)

if (!folderExists) {
  // Folder doesn't exist - inform user and use fallback
  return handleMissingAssetsFolder()
}
```

**2. List all files in assets folder:**

```javascript
// Get actual filenames
const actualFiles = await listDirectory(assetsPath)

// Example output from real scenario:
// [
//   "Accelerate Event Summit Logo.png",
//   "Banner.gif",
//   "center.png",
//   "Date.png",
//   "Facebook.png",
//   "Feature 4.png",
//   "Feature 5.png",
//   "Feature 6.png",
//   "Heading.png",
//   "i2c logo.png",
//   "Image 1.png",
//   "Image 2.png",
//   "Image 4.png",
//   "Image 5.png",
//   "Instagram.png",
//   "Invite 1.png",
//   "Invite 2.png",
//   "Invite 3.png",
//   "link arrow icon.png",
//   "Linkedin.png",
//   "Location icon.png",
//   "Polygon.svg",
//   "Sign.png",
//   "Video.gif",
//   "X.png"
// ]
```

**3. Map Figma assets to actual files:**

```javascript
// Create intelligent mapping
function mapFigmaAssetsToActualFiles(figmaAssets, actualFiles) {
  const mapping = {}
  
  for (const figmaAsset of figmaAssets) {
    // Strategy 1: Exact match (case-insensitive)
    let match = actualFiles.find(file => 
      file.toLowerCase() === figmaAsset.expectedName.toLowerCase()
    )
    
    // Strategy 2: Partial match (handle renamed files)
    if (!match) {
      match = actualFiles.find(file => 
        file.toLowerCase().includes(figmaAsset.layerName.toLowerCase()) ||
        figmaAsset.layerName.toLowerCase().includes(file.toLowerCase())
      )
    }
    
    // Strategy 3: Semantic match (logo matches any file with "logo")
    if (!match && figmaAsset.purpose) {
      match = actualFiles.find(file => 
        file.toLowerCase().includes(figmaAsset.purpose.toLowerCase())
      )
    }
    
    // Strategy 4: Ask user (when all else fails)
    if (!match) {
      match = await askUserToMapAsset(figmaAsset, actualFiles)
    }
    
    mapping[figmaAsset.varName] = match || figmaAsset.expectedName // fallback
  }
  
  return mapping
}

// Example mapping from real scenario:
// {
//   "imgLogo": "Accelerate Event Summit Logo.png",    // Not "logo.png"
//   "imgHeading": "Heading.png",                       // Exact match ✓
//   "imgBanner": "Banner.gif",                         // GIF not JPG
//   "imgDate": "Date.png",                             // Exact match ✓
//   "imgLocationIcon": "Location icon.png",            // Has space
//   "imgInvite1": "Invite 1.png",                      // Has space
//   "imgInvite2": "Invite 2.png",                      // Has space
//   "imgInvite3": "Invite 3.png",                      // Has space
//   "imgVideo": "Video.gif",                           // GIF not JPG
//   "imgImage1": "Image 1.png",                        // Has space
//   "imgImage2": "Image 2.png",                        // Has space
//   "imgCenter": "center.png",                         // Lowercase
//   "imgImage4": "Image 4.png",                        // Has space
//   "imgImage5": "Image 5.png",                        // Has space
//   "imgFeature1": "Feature 4.png",                    // Different number!
//   "imgFeature2": "Feature 5.png",                    // Different number!
//   "imgFeature3": "Feature 6.png",                    // Different number!
//   "imgSignature": "Sign.png",                        // Abbreviated
//   "imgFooterLogo": "i2c logo.png",                   // Has space, lowercase
//   "imgLinkedin": "Linkedin.png",                     // Exact match ✓
//   "imgX": "X.png",                                   // Exact match ✓
//   "imgInstagram": "Instagram.png",                   // Exact match ✓
//   "imgFacebook": "Facebook.png"                      // Exact match ✓
// }
```

**4. Use actual filenames in HTML generation:**

```html
<!-- ✅ CORRECT - Uses actual filename from assets folder -->
<img src="./assets/Accelerate Event Summit Logo.png" alt="Logo" width="265" height="36" />

<!-- ❌ WRONG - Uses assumed/generic name -->
<img src="./assets/logo.png" alt="Logo" width="265" height="36" />
```

#### Smart Matching Algorithm:

**Priority order for matching:**

1. **Exact match (case-insensitive):**
   - Figma: "Logo" → File: "Logo.png" ✓

2. **Partial substring match:**
   - Figma: "logo" → File: "Accelerate Event Summit Logo.png" ✓
   - Figma: "Feature 1" → File: "Feature 4.png" ✓

3. **Semantic/purpose match:**
   - Figma purpose: "header logo" → File contains "logo" and in first 5 files ✓
   - Figma purpose: "social icon" → File: "Linkedin.png" ✓

4. **Extension flexibility:**
   - Figma suggests ".jpg" → Actual file is ".gif" ✓
   - Figma suggests ".png" → Actual file is ".svg" ✓

5. **Interactive mapping:**
   - When confidence is low, ask user via `vscode_askQuestions`

#### Interactive Asset Mapping UI:

**When automated matching fails or has low confidence:**

```javascript
// Use vscode_askQuestions for clear mapping
vscode_askQuestions({
  questions: [
    {
      header: "map_logo_asset",
      question: "Which file is the Logo (265×36px)?",
      options: actualFiles.map(file => ({
        label: file,
        description: getFileInfo(file) // Size, type, etc.
      })),
      allowFreeformInput: false
    },
    {
      header: "map_banner_asset",
      question: "Which file is the Hero Banner (600×230px)?",
      options: actualFiles.map(file => ({
        label: file,
        description: getFileInfo(file)
      })),
      allowFreeformInput: false
    }
    // ... for each uncertain asset
  ]
})
```

#### Handling Common Scenarios:

**Scenario 1: All files match perfectly**
```
✓ All 23 assets matched automatically
✓ Generating HTML with actual filenames...
```

**Scenario 2: Partial matches need confirmation**
```
✓ Matched 20/23 assets automatically
⚠️ Need confirmation for 3 assets:
  - Logo: Best match is "Accelerate Event Summit Logo.png" - Confirm? [Y/n]
  - Feature 1: Best match is "Feature 4.png" - Confirm? [Y/n]
  - Footer Logo: Best match is "i2c logo.png" - Confirm? [Y/n]
```

**Scenario 3: Missing files**
```
✓ Matched 20/23 assets
⚠️ 3 assets not found in folder:
  - "icon-arrow.png" (expected for CTA buttons)
  - "divider.png" (expected for section separator)
  - "background.jpg" (expected for hero background)

Options:
1. Use Figma CDN URLs temporarily (fallback mode)
2. Generate HTML with placeholder comments
3. Ask user to download missing files first
```

#### Deliverables:

When validation is successful, provide:

1. ✅ **Validated asset mapping** (Figma → Actual files)
2. ✅ **HTML template** with correct filenames
3. ✅ **ASSETS.md** documenting actual filenames
4. ✅ **Mapping report** showing all matches
5. ✅ **No fallback/replacement needed** - works immediately

#### Validation Checklist:

Before generating HTML, verify:

- [ ] Assets folder exists at specified path
- [ ] All files listed successfully
- [ ] Each Figma asset mapped to actual file
- [ ] File extensions match (png/jpg/gif/svg)
- [ ] Ambiguous matches confirmed with user
- [ ] Missing files handled appropriately
- [ ] Mapping documented in ASSETS.md

#### Example Output Log:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 VALIDATING ASSETS FOLDER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Found assets folder: ./assets/
✓ Discovered 25 files

📊 ASSET MAPPING RESULTS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Logo                 → Accelerate Event Summit Logo.png
✓ Heading              → Heading.png
✓ Date Icon            → Date.png
✓ Location Icon        → Location icon.png
✓ Banner               → Banner.gif (format: gif)
✓ Invite 1             → Invite 1.png
✓ Invite 2             → Invite 2.png
✓ Invite 3             → Invite 3.png
✓ Video Thumbnail      → Video.gif (format: gif)
✓ Gallery Image 1      → Image 1.png
✓ Gallery Image 2      → Image 2.png
✓ Gallery Center       → center.png
✓ Gallery Image 4      → Image 4.png
✓ Gallery Image 5      → Image 5.png
⚠ Feature 1            → Feature 4.png (name mismatch - using actual)
⚠ Feature 2            → Feature 5.png (name mismatch - using actual)
⚠ Feature 3            → Feature 6.png (name mismatch - using actual)
✓ Signature            → Sign.png
✓ Footer Logo          → i2c logo.png
✓ LinkedIn Icon        → Linkedin.png
✓ X Icon               → X.png
✓ Instagram Icon       → Instagram.png
✓ Facebook Icon        → Facebook.png

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ All 23 assets mapped successfully
✓ 3 mappings used actual filenames (minor mismatches)
✓ Ready to generate HTML with correct paths
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### Benefits of This Approach:

✅ **Zero manual renaming** - HTML uses whatever names exist
✅ **Immediate functionality** - Works as soon as generated
✅ **Handles variations** - Spaces, cases, extensions all supported
✅ **User-friendly** - Interactive confirmation when needed
✅ **Documented** - Clear mapping shown in ASSETS.md
✅ **Template-independent** - Works with any asset naming scheme
✅ **Error-prevention** - Catches mismatches before HTML generation

---

### Step 3: Convert Design to Email HTML

**⚠️ CRITICAL: Check Design Type First**

**Before generating HTML, check the `design_type` response:**

**If design_type = "Responsive":**
- ✅ Include `@media` queries in `<style>` block
- ✅ Add responsive CSS classes (`.mobile-stack`, `.mobile-full`, `.mobile-padding`, `.mobile-hide`)
- ✅ Add `class="mobile-*"` attributes to tables/cells
- ✅ Design will adapt: desktop shows side-by-side, mobile stacks vertically
- ✅ Used for: Multi-column layouts, complex responsive designs

**If design_type = "Standard (Fixed-Width)":**
- ❌ NO `@media` queries in `<style>` block
- ❌ NO mobile-specific CSS classes
- ❌ NO `class="mobile-*"` attributes
- ✅ Same layout on all devices (may require pinch-zoom on mobile)
- ✅ Simpler HTML, more predictable rendering
- ✅ Used for: Simple single-column designs, fixed layouts, maximum compatibility

**Example Comparison:**

**Responsive Design CSS:**
```html
<style>
  /* Mobile Responsive */
  @media only screen and (max-width: 600px) {
    .mobile-full { width: 100% !important; }
    .mobile-stack { display: block !important; width: 100% !important; }
  }
</style>

<!-- In HTML: -->
<table class="mobile-stack">
  <!-- Will stack on mobile -->
</table>
```

**Standard (Fixed-Width) CSS:**
```html
<style>
  /* NO @media queries */
  /* Just basic resets */
  body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
  table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
</style>

<!-- In HTML: -->
<table>
  <!-- Same layout on all devices -->
</table>
```

---

**Critical Email-Specific Rules:**

1. **Layout:** Use `<table>` elements ONLY (no `<div>`, flexbox, or grid)
2. **Styling:** Inline all CSS in `style=""` attributes
3. **Width:** 600px max-width container, centered
4. **Spacing:** Use `padding` on `<td>` (never `margin`)
5. **Images:** Absolute HTTPS URLs, explicit width/height, alt text
6. **Fonts:** Web-safe fonts only (Arial, Georgia, Times)
7. **Buttons:** Bulletproof button pattern with VML for Outlook
8. **Responsive:** Media queries in `<style>` block **ONLY if design_type = "Responsive"**

**HTML Structure (Responsive Design):**
```html
<!DOCTYPE html>
<html lang="en" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
  <!-- Meta tags -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="x-apple-disable-message-reformatting">
  <title>{{email_title}}</title>
  
  <!-- MSO Outlook support -->
  <!--[if mso]>
  <noscript><xml>
    <o:OfficeDocumentSettings><o:AllowPNG/><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings>
  </xml></noscript>
  <![endif]-->
  
  <!-- Styles -->
  <style>
    /* CSS Reset */
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; outline: none; text-decoration: none; }
    
    /* Mobile Responsive - ONLY for Responsive designs */
    @media only screen and (max-width: 600px) {
      .mobile-full { width: 100% !important; }
      .mobile-padding { padding: 20px !important; }
      .mobile-stack { display: block !important; width: 100% !important; }
      .mobile-hide { display: none !important; }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #f4f4f4;">
  <!-- Preview text -->
  <div style="display: none; max-height: 0; overflow: hidden;">
    {{preview_text}}
    &nbsp;&zwnj;&nbsp;&zwnj;<!-- Padding -->
  </div>
  
  <!-- Email container -->
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td align="center" style="padding: 20px 0;">
        <table role="presentation" width="600" cellpadding="0" cellspacing="0" border="0" class="mobile-full" style="max-width: 600px; background-color: #ffffff;">
          <!-- MODULES GO HERE -->
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

**HTML Structure (Standard/Fixed-Width Design):**
```html
<!DOCTYPE html>
<html lang="en" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
  <!-- Meta tags -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="x-apple-disable-message-reformatting">
  <title>{{email_title}}</title>
  
  <!-- MSO Outlook support -->
  <!--[if mso]>
  <noscript><xml>
    <o:OfficeDocumentSettings><o:AllowPNG/><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings>
  </xml></noscript>
  <![endif]-->
  
  <!-- Styles -->
  <style>
    /* CSS Reset - NO @media queries for fixed-width */
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; outline: none; text-decoration: none; }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #f4f4f4;">
  <!-- Preview text -->
  <div style="display: none; max-height: 0; overflow: hidden;">
    {{preview_text}}
    &nbsp;&zwnj;&nbsp;&zwnj;<!-- Padding -->
  </div>
  
  <!-- Email container -->
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td align="center" style="padding: 20px 0;">
        <table role="presentation" width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; background-color: #ffffff;">
          <!-- MODULES GO HERE - NO mobile-* classes -->
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

**Module Pattern:**
```html
<!-- MODULE N: [Name] -->
<tr>
  <td style="background-color: #FFFFFF; padding: 40px 50px;" class="mobile-padding">
    <!-- Content here -->
  </td>
</tr>
```

**Reference:** [EMAIL_CONVERSION_PROMPT.md](./EMAIL_CONVERSION_PROMPT.md) for complete patterns

---

### Step 4: Handle Figma → Email Conversions

**Common Conversions:**

| Figma Design | Email HTML |
|--------------|------------|
| Flexbox layout | Nested `<table>` elements |
| CSS Grid | `<table>` with fixed-width `<td>` |
| `div` containers | `<table>` wrappers |
| Background images | `<img>` tag in table cell (table-based images) |
| External images | Absolute HTTPS URLs in `src=""` |
| Custom fonts | Arial, Georgia (web-safe) |
| `margin` spacing | `padding` on `<td>` |
| `position: absolute` | Nested tables (avoid absolute positioning) |
| CSS classes | Inline `style=""` |
| Button with padding | Bulletproof button with VML |

**Do NOT Use:**
- `<div>`, `<section>`, `<header>`, `<footer>` for layout
- `display: flex`, `display: grid`
- `position: absolute` (limited support in Outlook)
- CSS `background-image` (use table-based images instead)
- `margin` for spacing
- External CSS files
- JavaScript
- `<style>` for primary styles (use inline)

---

### Step 5: Implement Dynamic Content (Tokens)

**Token Strategy:**

1. **Identify dynamic content:**
   - Personalization: Names, email addresses, company names
   - Account data: Balances, transaction IDs, account numbers
   - Dates: Current year, expiry dates, send dates
   - Images: Logo URLs, product images, banners
   - Links: CTA buttons, social links, unsubscribe

2. **Use default token syntax:** `{{token_name}}`

3. **Follow naming conventions:**
   - Lowercase with underscores: `{{first_name}}`
   - Descriptive names: `{{hero_image_url}}` not `{{img1}}`
   - Category prefixes: `{{social_linkedin_url}}`

4. **Provide fallbacks:**
   ```html
   Hi {{first_name|default:"there"}},
   ```

5. **Use hardcoded content** in preview template

**Example Content:**
- Use actual names instead of tokens (e.g., "Hello Stephen" not "Hello {{first_name}}")
- Use real dates (e.g., "May 17-20, 2026")
- Use placeholder links (e.g., "#" for buttons)
- Include actual company name
- All static content displayed directly

---

### Step 6: Ensure Email Client Compatibility

**Must-Have Features:**

1. **Bulletproof Buttons** (Outlook compatibility):
```html
<table role="presentation" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td style="border-radius: 8px; background-color: #f97c00;">
      <!--[if mso]>
      <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" href="{{cta_url}}" style="height:48px;v-text-anchor:middle;width:200px;" arcsize="17%" stroke="f" fillcolor="#f97c00">
        <w:anchorlock/>
        <center style="color:#ffffff;font-family:Arial,sans-serif;font-size:14px;font-weight:bold;">Button Text</center>
      </v:roundrect>
      <![endif]-->
      <!--[if !mso]><!-->
      <a href="{{cta_url}}" style="display:inline-block;padding:14px 40px;font-family:Arial,sans-serif;font-size:14px;font-weight:bold;color:#ffffff;text-decoration:none;">Button Text</a>
      <!--<![endif]-->
    </td>
  </tr>
</table>
```

2. **"Background" Images Using Table-Based Approach (RECOMMENDED):**

**Why Table-Based:** CSS `background-image` has poor support in Outlook and requires complex VML fallbacks. Using actual `<img>` tags within table cells provides better compatibility.

```html
<!-- Full-width background image with overlaid content -->
<tr>
  <td style="background-color: #1434cb; padding: 0; position: relative;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <!-- Background image layer -->
        <td style="font-size: 0; line-height: 0; padding: 0;">
          <img src="{{hero_bg_url}}" alt="" width="600" height="433" style="display: block; width: 100%; max-width: 600px; height: auto;">
        </td>
      </tr>
      <tr>
        <!-- Content layer (positioned absolutely or in separate row) -->
        <td style="padding: 50px; margin-top: -433px; position: relative;" valign="top">
          <!-- Your content here -->
          <h1 style="color: #ffffff; margin: 0;">Hero Text</h1>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

**Alternative: Side-by-side with absolute positioning:**
```html
<tr>
  <td style="position: relative; padding: 0;">
    <!-- Background image -->
    <img src="{{hero_bg_url}}" alt="" width="600" height="433" style="display: block; width: 600px; height: 433px;">
    
    <!-- Content overlaid (use table for Outlook compatibility) -->
    <table role="presentation" cellpadding="0" cellspacing="0" border="0" style="position: absolute; top: 0; left: 0; width: 100%;">
      <tr>
        <td style="padding: 50px;">
          <h1 style="color: #ffffff; margin: 0;">Hero Text</h1>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

**For Outlook (if absolute positioning doesn't work):**
Use separate table cells or nested tables instead of overlays. Place content below or beside the image.

3. **Mobile Responsive Classes:**
```css
@media only screen and (max-width: 600px) {
  .mobile-full { width: 100% !important; }
  .mobile-stack { display: block !important; width: 100% !important; }
  .mobile-hide { display: none !important; }
  .mobile-padding { padding: 20px !important; }
}
```

**Apply to HTML:**
```html
<table width="600" class="mobile-full">
<td class="mobile-padding">
<td class="mobile-hide">
```

4. **Explicit Image Dimensions:**
```html
<img 
  src="{{logo_url}}" 
  alt="Company Name" 
  width="200" 
  height="50" 
  style="display: block; width: 200px; height: auto;"
>
```

**Reference:** [EMAIL_CLIENT_RISKS.md](./EMAIL_CLIENT_RISKS.md) for full compatibility matrix

---

### Step 7: Generate Documentation

#### A. ASSETS.md (Required)

**See Step 8C below for complete structure.**

#### B. README.md (Optional)

**Quick start guide with:**
- How to open preview template
- Asset download instructions
- Testing recommendations
- Email specifications

#### C. EMAIL_CLIENT_RISKS.md (Optional)

**Structure:**
```markdown
# Email Client Risk Assessment - [Email Name]

## Executive Summary
**Overall Risk Level:** ✅ LOW | ⚠️ MODERATE | ❌ HIGH

## Feature Analysis

### [Feature Name] (e.g., "Border Radius on Cards")
**Risk Level:** ⚠️ MODERATE
**Affected Clients:** Outlook 2016/2019/365
**Impact:** [Description]
**Mitigation:** [Solution]
**Recommendation:** [Action]
```

**Reference:** [EMAIL_CLIENT_RISKS.md](./EMAIL_CLIENT_RISKS.md) for full guide

---

### Step 8: Create Final Deliverables

**Deliverables depend on Asset Handling Strategy chosen:**

#### Strategy A: Figma CDN URLs (Preview)

**Create:**
1. `[name]-preview.html` - Uses Figma CDN URLs
2. `ASSETS.md` - Documents all Figma URLs for download
3. `update-cdn-urls.ps1` + `.js` - Automated URL replacement scripts

**Use when:** Quick preview, testing, stakeholder review (7-day validity)

#### Strategy B1: GitHub Temporary CDN ⭐ RECOMMENDED

**⚠️ CRITICAL WORKFLOW:**

1. **Create template folder structure**
   - Create `[template-name]/` folder in workspace root
   - Create `[template-name]/assets/` subfolder
   - Ask user: "Do assets already exist in ./assets/ folder?"
   - If YES → Move assets to `[template-name]/assets/` and proceed to deployment
   - If NO → Skip deployment, create download-assets.ps1 script

2. **Automatically deploy assets to GitHub** (ONLY if assets exist locally)
   - **⚠️ REQUIRED:** Use `run_in_terminal` to execute deployment script
   - Navigate to workspace root directory
   - Run: `.\Email AI Context\deploy-to-github.ps1`
   - Pass GitHub username and repo name as parameters
   - Script will:
     - Auto-detect template name from HTML filename
     - Create organized folder structure: `email-templates/[template-name]/assets/`
     - Copy all assets from `./assets/` to organized structure
     - Initialize git repository (if needed)
     - Stage and commit files with message: "Deploy email template: [name] - [count] assets"
     - Push to GitHub repository using hardcoded token
   - **Wait for deployment to complete before generating HTML**
   - Verify deployment success (check terminal output)
   - If deployment fails, show error and troubleshooting steps

3. **Validate actual asset filenames** (Step 2B process)
   - List files in local assets folder: `Get-ChildItem ./assets`
   - Map Figma assets to actual files (fuzzy matching)
   - Use actual filenames in HTML (not generic names)

4. **Generate HTML with GitHub CDN URLs**
   - Format: `https://raw.githubusercontent.com/[owner]/[repo]/[branch]/email-templates/[template-name]/assets/[filename]`
   - Example: `https://raw.githubusercontent.com/numani2c/ai-email-templates/main/email-templates/your-exclusive-invitation/assets/Banner.gif`
   - Use actual filenames from assets folder mapping
   - Images will load immediately since assets are already deployed
   - All URLs follow organized folder structure for better asset management

**Workflow:**

**IF assets exist locally:**
1. **Create template folder structure** first:
   - Create `[template-name]/` folder in workspace root
   - Move/organize files: `[template-name]/assets/`, `[template-name]/[name].html`
2. **Deploy to GitHub** (using `run_in_terminal`):
   ```powershell
   .\Email AI Context\deploy-to-github.ps1
   ```
3. Wait for deployment to complete successfully
4. Generate `[template-name]/[name].html` with GitHub CDN URLs
5. Create `[template-name]/ASSETS.md` documentation
6. Create `[template-name]/update-cdn-urls.ps1` migration script

**IF assets don't exist locally:**
1. **Create template folder structure**:
   - Create `[template-name]/` folder in workspace root
   - Create `[template-name]/assets/` subfolder
2. Generate `[template-name]/[name].html` with GitHub CDN URLs (deployment happens later)
3. Create `[template-name]/ASSETS.md` with Figma download URLs
4. Create `[template-name]/download-assets.ps1` to download from Figma
5. Create `[template-name]/update-cdn-urls.ps1` migration script
6. User must run `download-assets.ps1` then deploy manually

**Create (in `[template-name]/` folder):**
1. `[name].html` - Uses GitHub CDN URLs with actual filenames
2. `ASSETS.md` - Documents all assets (GitHub URLs or Figma URLs depending on deployment status)
3. `update-cdn-urls.ps1` - For future CDN migration (template-specific)
4. `download-assets.ps1` - **ONLY if assets don't exist locally**
5. `assets/` subfolder - Contains all image assets

**Reference generic scripts** (in `Email AI Context/` folder):
- `deploy-to-github.ps1` - Generic deployment script (executed automatically if assets exist)
- `GITHUB-CDN-GUIDE.md` - Deployment guide
- `EMAIL_AI_CONTEXT.md` - This context file
- All other generic documentation files

**GitHub Configuration:**
- **Repository:** User provides (e.g., `https://github.com/username/repo-name`)
- **Branch:** User provides (default: `main`)
- **Template Folder:** Auto-generated from template name (e.g., `your-exclusive-invitation`)
- **CDN URL Format:** `https://raw.githubusercontent.com/[owner]/[repo]/[branch]/[template-name]/assets/[filename]`
- **Token:** Use from environment variable `$env:GITHUB_TOKEN` or prompt user interactively

**🚨 Troubleshooting GitHub Deployment:**

If `deploy-to-github.ps1` execution fails, AI should:

1. **Check terminal output for specific error:**
   - "fatal: not a git repository" → Need to initialize git first
   - "authentication failed" → GitHub token might be expired
   - "remote: Repository not found" → Repository doesn't exist or wrong name
   - "Permission denied" → User doesn't have push access

2. **Show user-friendly troubleshooting:**
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ⚠️  GITHUB DEPLOYMENT FAILED
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   Error: [specific error message]
   
   Possible solutions:
   1. Verify repository exists: https://github.com/[username]/[repo]
   2. Check repository is public or you have push access
   3. Ensure git is installed: git --version
   4. Try manual deployment:
      cd "[workspace]"
      .\Email AI Context\deploy-to-github.ps1
   
   Would you like to:
   - Retry deployment automatically
   - Continue without deployment (use Figma CDN temporarily)
   - See detailed deployment guide
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

3. **Offer fallback options:**
   - Continue with Figma CDN URLs (Strategy A)
   - Generate HTML with GitHub URLs but note deployment pending
   - Show manual deployment instructions from GITHUB-CDN-GUIDE.md

4. **Never block workflow completely:**
   - If deployment fails, still generate HTML
   - Document deployment status in ASSETS.md
   - Provide clear next steps for user

---
- **Authentication Token:** Retrieved from environment variable or user prompt during deployment
- **Generic scripts:** Use from Email AI Context folder (don't regenerate)

**Use when:** Email asset hosting with GitHub as temporary CDN

#### Strategy B2: Local Assets Folder (Staged Production)

**Create:**
1. `[name].html` - Uses local asset paths (./assets/)
2. `ASSETS.md` - Documents all assets with local paths
3. `update-cdn-urls.ps1` - Ready to update to CDN when uploaded

**Use when:** Assets downloaded locally, planned CDN upload

#### Strategy C: Assets Already on CDN (Production Ready)

**Create:**
1. `[name].html` - Uses permanent CDN URLs directly
2. `ASSETS.md` - Documents all assets with CDN URLs
3. **No URL replacement scripts needed** - Production ready immediately

**Use when:** Assets already uploaded to CDN before conversion

**Required from user:**
- CDN base URL (e.g., `https://cdn.example.com/emails/welcome`)
- Asset filenames or mapping (e.g., "logo.png", "hero-banner.jpg")
- Or: Asset naming convention to auto-generate filenames

**Workflow:**
1. AI extracts design and identifies all images
2. User provides CDN base URL
3. AI asks for each asset:
   - "Figma asset: [description] → CDN filename?"
   - User provides: "logo.png", "hero-banner.jpg", etc.
   - Or user provides pattern: "asset-{n}.png"
4. AI generates HTML with direct CDN URLs: `https://cdn.example.com/emails/welcome/logo.png`
5. Template is production-ready immediately

**Example interaction:**
```
AI: "Found [N] image assets. Provide CDN base URL:"
User: "https://cdn.mycompany.com/emails/welcome-2026"

AI: "Provide filename for each asset (or 'auto' for asset-1.png, asset-2.png...):"
- [Asset 1] ([W]×[H]px) → User: "[user-chosen-name].[ext]"
- [Asset 2] ([W]×[H]px) → User: "[user-chosen-name].[ext]"
...

Sample (actual asset names vary by template):
- Logo (200×50px) → User: "logo.png"
- hero (600×400px) → User: "hero-banner.jpg"
- icon-cal (24×24px) → User: "icon-calendar.svg"

AI generates: https://cdn.mycompany.com/emails/welcome-2026/logo.png
```

---

#### A. Preview Template with Figma CDN (`[name]-preview.html`) - **For Strategy A**

**Purpose:** Immediate testing with actual Figma CDN URLs (valid for 7 days)

**Why Create This First:**
- Client can open immediately in browser to see rendered email
- No CDN setup required for initial review
- Easier to catch design/layout issues early
- Validates that all images are extracted correctly

**Critical Requirements:**
1. **Use actual Figma API URLs** (not tokens):
   ```html
   <img src="https://www.figma.com/api/mcp/asset/168b53d5-a64c-4d1e-96a2-e41394248bb8" ...>
   ```

2. **Extract exact dimensions from Figma React code**:
   ```javascript
   // From Figma response:
   <img className="..." width="238" height="40" src={imgLogo} />
   
   // Use in email HTML:
   <img src="https://..." width="238" height="40" style="display: block; width: 238px; height: 40px;">
   ```

3. **NEVER use `height: auto`** - this causes stretching in email clients:
   ```html
   ❌ BAD: style="width: 200px; height: auto;"
   ✅ GOOD: width="200" height="50" style="width: 200px; height: 50px;"
   ```

4. **For "background" images**, use table-based image approach:
   ```html
   <!-- Instead of background-image CSS -->
   <td style="padding: 0; position: relative;">
     <img src="..." width="600" height="433" style="display: block; width: 600px; height: 433px;">
     <!-- Overlay content in separate table/td -->
   </td>
   ```

5. **Include sample/hardcoded data** instead of tokens:
   ```html
   <p>Hi [Name],</p>  <!-- Not {{first_name}} -->
   ```

6. **Add warning banner** at bottom:
   ```html
   <p style="...">⚠️ <strong>PREVIEW VERSION</strong> - Images hosted on Figma CDN (valid for 7 days)<br>
   For production, export images and update URLs in the main template.</p>
   ```

7. **Title includes "[PREVIEW]"** suffix:
   ```html
   <title>Inside Payment - i2c [PREVIEW]</title>
   ```

**Image Dimension Extraction Process:**
1. Search Figma response for image variable usage: `src={imgLogo}`
2. Find corresponding `<img>` tag with width/height
3. Extract exact pixel dimensions
4. Apply to HTML with both attributes AND inline styles
5. Verify no stretching by opening in browser

---

#### B. ASSETS.md (Required)

**Purpose:** Quick reference guide for downloading assets with correct filenames

**Structure for Strategy B (Local Assets):**
```markdown
# Email Assets - [Email Name]

## Overview

This document lists all image assets for the email template with **exact Figma layer names** used as filenames.

**Asset Strategy:** Local Assets Folder (./assets/)

## Required Images

| Asset Description | Figma Layer Name | Filename | Dimensions | Figma URL | Purpose |
|-------------------|------------------|----------|------------|-----------|---------|
| [Describe asset] | [Exact Figma layer name] | `[Same as layer].[ext]` | [W×H]px | `https://www.figma.com/api/mcp/asset/...` | [Purpose] |

**Example entries (will vary by template):**
| Logo | Logo | `Logo.png` | 200×50px | `https://...` | Header branding |
| Hero image | hero | `hero.jpg` | 600×400px | `https://...` | Main banner |
| CTA button | CTA Primary | `CTA Primary.png` | 180×45px | `https://...` | Call to action |

## Download Instructions

⚠️ **IMPORTANT:** Figma URLs expire in **7 days** - download promptly!

### Method 1: Automated Download (Recommended)

See `download-assets.ps1` script below for batch download.

### Method 2: Manual Download

1. Click each Figma URL above (opens image in browser)
2. Right-click image → "Save Image As..."
3. **Save with exact filename from "Filename" column** (including spaces)
4. Place all files in `./assets/` folder (create folder if needed)
5. ✅ No renaming needed - template uses these exact names

### Folder Structure:
```
your-email-template.html
assets/
  ├── [Asset 1 filename].[ext]
  ├── [Asset 2 filename].[ext]
  ├── [Asset 3 filename].[ext]
  └── ... (all assets from table above)

Example (varies by template):
  ├── Logo.png
  ├── hero.jpg
  ├── CTA Primary.png
```

## Automated Download Script

**download-assets.ps1:**
```powershell
# Create assets directory
New-Item -ItemType Directory -Force -Path "assets"

# Download function
function Download-Asset {
    param($url, $filename)
    $output = "assets/$filename"
    Write-Host "Downloading $filename..."
    Invoke-WebRequest -Uri $url -OutFile $output
}

# Download all assets (generated automatically from ASSETS.md table)
Download-Asset "https://www.figma.com/api/mcp/asset/[uuid]" "[Asset 1 name].[ext]"
Download-Asset "https://www.figma.com/api/mcp/asset/[uuid]" "[Asset 2 name].[ext]"
# ... (one line per asset from table)

Write-Host "✓ All assets downloaded successfully!"
```

**Usage:** `.\download-assets.ps1`

## Optimization Guidelines

**Before using in production:**
- Compress JPG images to 80-85% quality
- Optimize PNG images with TinyPNG or ImageOptim
- Target: Keep total email size under 100KB (Gmail limit)
- Use progressive JPEGs for better loading

**Tools:**
- [TinyPNG](https://tinypng.com/) - PNG/JPG compression
- [Squoosh](https://squoosh.app/) - Advanced optimization
- [ImageOptim](https://imageoptim.com/) - Mac app

## Next Steps

1. ✅ Download all assets to `./assets/` folder
2. ✅ Optimize images for email
3. ✅ Test HTML template locally (all images should display)
4. ☁️ Upload assets folder to CDN when ready for production
5. 🔄 Run `update-cdn-urls.ps1` to replace local paths with CDN URLs
6. 📧 Deploy final template to ESP

## Quick Reference: Asset URLs

Copy all URLs for batch processing:
```
https://www.figma.com/api/mcp/asset/...
https://www.figma.com/api/mcp/asset/...
[... all URLs listed]
```

---

**Note:** Template already references these exact filenames. No renaming or mapping required!
```

**Structure for Strategy A (Figma CDN URLs):**
```markdown
[Same structure, but note that URLs are temporary and need to be replaced]

## Required Images

| Asset Description | Figma Layer Name | Temporary URL | Dimensions | Purpose |
|-------------------|------------------|---------------|------------|---------|
| [Describe asset] | [Exact layer name] | `https://www.figma.com/api/mcp/asset/...` | [W×H]px | [Purpose] |

**Example (varies by template):**
| Logo | Logo | `https://...` | 200×50px | Header branding |

⚠️ **WARNING:** Template currently uses Figma CDN URLs which **expire in 7 days**.

## Next Steps

1. Download assets using URLs above
2. Upload to permanent CDN
3. Run `update-cdn-urls.ps1` to replace Figma URLs with CDN URLs
```

**Include:**
- Table with Figma layer names, filenames, dimensions, URLs, and purpose
- Clear download instructions emphasizing exact filenames
- Automated download script (PowerShell)
- Optimization guidelines
- CDN migration instructions
- Folder structure visualization
- Quick reference URL list

---

#### C. Automated CDN URL Replacement Script (Required for Both Strategies)

**Purpose:** Automatically replace Figma CDN URLs or local paths with permanent CDN URLs after assets are uploaded.

**Create:** `update-cdn-urls.ps1` (PowerShell) or `update-cdn-urls.js` (Node.js)

**Features:**
- ✅ Detects current URL types (Figma CDN, local paths, or both)
- ✅ Interactive prompts for replacement strategy
- ✅ Batch URL replacement with single CDN base URL
- ✅ Asset filename mapping (auto-generated or custom)
- ✅ Creates new file (preserves original)
- ✅ Summary report with replacement count

**When to Run:**
1. **For Figma CDN Strategy:** After uploading assets to permanent CDN
2. **For Local Assets Strategy:** After uploading assets folder to CDN

**Usage:**

```powershell
# PowerShell version (Windows)
.\update-cdn-urls.ps1

# Node.js version (Cross-platform)
node update-cdn-urls.js
```

**Interactive Workflow:**

1. **Script detects HTML files** in current directory
2. **Shows URL detection:**
   - Figma CDN URLs: X found
   - Local paths (./assets/): Y found
3. **Prompts for replacement strategy:**
   - [1] Replace Figma CDN URLs → Permanent CDN
   - [2] Replace Local paths → Permanent CDN
   - [3] Replace Both → Permanent CDN
4. **Asks for CDN base URL:**
   - Example: `https://cdn.example.com/email-assets/email-name`
5. **Shows asset mapping** (for Figma URLs):
   - UUID → asset-1.png
   - UUID → asset-2.png
   - Option to use custom filenames
6. **Performs batch replacement**
7. **Creates output file:** `[email-name]-cdn.html`
8. **Shows replacement summary**

**Example Session:**

```
========================================
  CDN URL Updater for Email Templates
========================================

Found HTML files:
  [0] welcome-email-preview.html

Using: welcome-email-preview.html

Current URLs detected:
  - Figma CDN URLs: 27
  - Local paths (./assets/): 0

Replacement Options:
  [1] Replace Figma CDN URLs → Permanent CDN
  [2] Replace Local paths (./assets/) → Permanent CDN
  [3] Replace Both → Permanent CDN

Select option (1-3): 1

Enter your CDN base URL (without trailing slash)
Examples:
  - AWS S3: https://your-bucket.s3.amazonaws.com/email-assets/email-name
  - CloudFront: https://d1234567890.cloudfront.net/email-assets/email-name
  - Cloudinary: https://res.cloudinary.com/your-cloud/image/upload/email-assets/email-name

CDN Base URL: https://cdn.mycompany.com/emails/welcome-email

Replacing Figma CDN URLs...
Found 27 Figma URLs to replace

Asset ID → Filename mapping:
  d53040bd-1b26-44ec-a4df-a897ca46d9aa → asset-1.png
  e950629a-eee2-483b-8441-80c0ed0e313a → asset-2.png
  ...

Use custom asset filenames? (y/N): y

Enter filenames for each asset:
  d53040bd-1b26-44ec-... [asset-1.png]: logo.png
  e950629a-eee2-483b-... [asset-2.png]: hero-banner.jpg
  ...

========================================
✓ URL Replacement Complete!
========================================

Summary:
  - Replacements made: 27
  - CDN Base URL: https://cdn.mycompany.com/emails/welcome-email
  - Output file: welcome-email-cdn.html

Next Steps:
  1. Review the updated file: welcome-email-cdn.html
  2. Test in browser to verify all images load
  3. Send test email
  4. Deploy to ESP

✓ Script completed successfully!
```

**Script Benefits:**
- ⏱️ **Time savings:** ~5 minutes vs. manual find/replace per asset
- 🎯 **Accuracy:** No missed URLs or typos
- 🔄 **Repeatable:** Same process for all emails
- 📋 **Asset tracking:** Shows all mappings before replacement
- ✅ **Safe:** Creates new file, preserves original

**Best Practices:**
1. **Keep original files:** Script creates new `-cdn.html` file
2. **Verify in browser:** Always test before deploying
3. **Use consistent naming:** Follow asset naming conventions
4. **Document mappings:** Save asset ID → filename mappings for reference
5. **Test CDN URLs:** Ensure CDN is accessible before running script

**Asset Naming Conventions:**

```
Recommended structure:
- logo.png
- header-background.jpg
- hero-banner.jpg
- cta-button.png
- icon-calendar.svg
- social-linkedin.png
- footer-logo.png

Avoid:
- asset-1.png (not descriptive)
- Image1.jpg (inconsistent casing)
- temp_file.png (unclear purpose)
```

---

## Asset Handling Strategy Comparison

### Strategy A: Figma CDN URLs (Preview)

**Best For:**
- Quick previews and internal testing
- Stakeholder reviews and feedback loops
- Design validation before production
- Teams without immediate CDN access

**Workflow:**
1. ✅ AI converts design → Uses Figma CDN URLs
2. ✅ Preview HTML ready in 5 minutes
3. ✅ Share for feedback (valid 7 days)
4. 📥 Download assets when ready for production
5. ☁️ Upload to CDN
6. 🔄 Run `update-cdn-urls.ps1` script
7. ✅ Production template ready

**Pros:**
- ⚡ Fastest time to preview (5 minutes)
- 🎯 No asset preparation needed
- 🔄 Easy to iterate on design changes
- 👥 Quick stakeholder feedback

**Cons:**
- ⏰ 7-day expiry on Figma URLs
- 📦 Requires separate asset download step
- 🔧 Additional URL replacement step

**Timeline:**
- Preview ready: 5 minutes
- Production ready: +40 minutes (asset work)
- **Total: ~45 minutes**

---

### Strategy B: Local Assets Folder (Staged Production)

**Best For:**
- Production-ready templates with planned CDN upload
- Teams with assets already prepared/downloaded
- Organized asset management workflows
- Projects with local asset libraries

**Workflow:**
1. 📥 Download assets from Figma first (or have them ready)
2. 📂 Organize in ./assets/ folder
3. ✅ AI converts design → Uses local paths (./assets/)
4. ✅ Production HTML ready in 5 minutes
5. ☁️ Upload ./assets/ folder to CDN
6. 🔄 Run `update-cdn-urls.ps1` script
7. ✅ CDN-connected template ready

**Pros:**
- 🎯 Production-ready structure from start
- 📂 Better asset organization
- 🔗 No dependency on Figma URLs
- ✅ Assets tracked locally
- 🔄 Easy to version control

**Cons:**
- 📦 Requires asset prep before conversion
- ⏱️ Slightly longer initial setup
- 🔧 Assumes assets already downloaded

**Timeline:**
- Asset prep: 20-30 minutes (if not done)
- HTML ready: 5 minutes
- CDN upload + URL update: 10-15 minutes
- **Total: ~40-50 minutes**

---

### Strategy C: Assets Already on CDN (Production Ready)

**Best For:**
- Assets already uploaded to CDN before conversion
- Teams with established CDN workflows
- Urgent production deployments
- Reusing existing asset libraries
- Multiple email templates sharing assets

**Workflow:**
1. ☁️ Assets already on CDN (prerequisite)
2. 📋 User provides CDN base URL
3. 📋 User provides asset filenames or mapping
4. ✅ AI converts design → Uses CDN URLs directly
5. ✅ Production HTML ready in 5 minutes
6. 🚀 Deploy immediately - no additional steps

**Pros:**
- ⚡ **Fastest to production** (5 minutes total)
- ✅ No URL replacement needed
- 🚀 Deploy immediately after generation
- 🔗 Permanent URLs from start
- 📦 No asset download/upload workflow
- 🔄 Ideal for template series (shared assets)

**Cons:**
- 📋 Requires CDN setup before conversion
- 📝 User must provide asset filenames
- ⚠️ Must ensure assets actually exist on CDN
- 🔧 Less flexible for quick iterations

**Timeline:**
- HTML ready: 5 minutes (+ user providing asset info)
- Test and deploy: 5 minutes
- **Total: ~10 minutes** (fastest!)

**Ideal scenarios:**
- "We've already uploaded the banner and logo to our CDN"
- "Assets are at https://cdn.example.com/2026/emails/"
- "Creating a series of emails with same header/footer assets"
- "Our design system assets are pre-hosted"

---

### Decision Matrix

| Factor | Figma CDN (A) | Local Assets (B) | CDN Ready (C) |
|--------|---------------|------------------|---------------|
| **Time to Preview** | 5 min ⚡ | 30-40 min | 10 min ⚡⚡ |
| **Time to Production** | 45 min | 40-50 min | 10 min ⚡⚡⚡ |
| **Asset Preparation** | Later | Upfront | Already done |
| **URL Expiry Risk** | Yes (7 days) | No | No |
| **Flexibility** | High | Medium | Low |
| **Production Ready** | After work | After upload | Immediate ✅ |
| **Best For** | Quick iterations | Organized workflow | Urgent deploy |

**Recommendation by use case:**
- 🎯 **New email, quick feedback:** Use Strategy A (Figma CDN)
- 🎯 **Standard workflow:** Use Strategy A → B (Preview then production)
- 🎯 **Assets prepared locally:** Use Strategy B (Local Assets)
- 🎯 **Assets already on CDN:** Use Strategy C (Production ready)
- 🎯 **Email series with shared assets:** Use Strategy C (Reuse CDN assets)
- 🎯 **Urgent production deploy:** Use Strategy C (If CDN ready)
- 🔄 **All strategies** can use update-cdn-urls scripts for later migration (except C)

---

## AI Decision Tree

```
User provides Figma URL for email
│
├─ Is it an email template? (check width ~600px, email-like structure)
│  ├─ YES → Proceed with email conversion
│  └─ NO → Ask user to confirm it's for email (not web/React)
│
├─ Extract design context via Figma MCP
│  ├─ Success → Analyze structure
│  └─ Fail → Ask user for clarification or retry
│
├─ Identify email type
│  ├─ Transactional (receipts, confirmations) → Focus on clarity, account info tokens
│  ├─ Marketing (promotions, offers) → Focus on CTAs, product images, discount codes
│  └─ Newsletter (updates, content) → Focus on article layout, social links
│
├─ Convert Figma design to email HTML
│  ├─ Use table-based layout (NO divs/flexbox)
│  ├─ Inline all CSS
│  ├─ Add bulletproof buttons
│  ├─ Add VML fallbacks for Outlook
│  ├─ Add mobile responsive classes
│  └─ Replace static content with tokens
│
├─ Create HTML template
│  ├─ Preview template ([name].html)
│  │  ├─ Use actual Figma CDN URLs
│  │  ├─ Include sample/hardcoded data
│  │  └─ Add 7-day expiry warning
│
├─ Create documentation
│  ├─ ASSETS.md (required)
│  ├─ README.md (optional)
│  └─ EMAIL_CLIENT_RISKS.md (optional)
│
└─ Deliver complete package
   ├─ Preview HTML (ready to open in browser)
   ├─ ASSETS.md documentation
   └─ Brief summary of key features and compatibility notes
```

---

## Precision Guidelines for AI

### 1. Spacing from Figma

**Extract exact spacing:**
- Header padding: Top/bottom, left/right
- Module gaps: Vertical spacing between sections
- Card padding: Internal padding
- Button padding: Vertical and horizontal

**Match Figma precisely:**
```
Figma: 48px padding
Email: style="padding: 48px;"

Figma: 32px gap between modules
Email: style="padding-top: 32px;"
```

**Mobile adjustments:**
```css
@media only screen and (max-width: 600px) {
  .desktop-48 { padding: 24px !important; } /* Reduce by 50% */
}
```

---

### 2. Colors from Figma

**Extract exact hex codes:**
- Background colors
- Text colors
- Border colors
- Button colors

**Apply inline:**
```html
<td style="background-color: #1434cb; color: #ffffff;">
```

**Never guess colors** - use exact values from Figma

---

### 3. Typography from Figma

**Extract:**
- Font family → Convert to web-safe (Arial, Georgia, Times)
- Font size (px)
- Line height (px)
- Font weight (400, 500, 700)
- Letter spacing (if significant)
- Text color

**Convert custom fonts:**
```
Figma: "Inter" → Email: "Arial, Helvetica, sans-serif"
Figma: "Merriweather" → Email: "Georgia, Times, serif"
Figma: "Roboto Mono" → Email: "'Courier New', Courier, monospace"
```

**Apply inline:**
```html
<p style="margin: 0; font-family: Arial, sans-serif; font-size: 16px; line-height: 24px; color: #041145; font-weight: 400;">
```

---

### 4. Images from Figma

**For each image:**
1. Note Figma dimensions
2. Export at 2x resolution (@2x for retina)
3. Set display size as Figma size
4. Use descriptive file names
5. Provide CDN URL placeholder

**Example (Standard Image):**
```
Figma: 300×200px
Export: 600×400px
HTML: width="300" height="200" (explicit attributes)
      style="display: block; width: 300px; height: 200px;"
```

**⚠️ NEVER use `height: auto`** - this causes stretching in email clients.

---

#### 4a. Table-Based "Background" Images

**When Figma shows a background image with overlaid content:**

Instead of using CSS `background-image` (poor email support), use an actual `<img>` tag within a table cell structure.

**Pattern 1: Image with Overlaid Content (Negative Margin)**
```html
<tr>
  <td style="padding: 0; background-color: #1434cb;\">
    <table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">
      <!-- Image layer -->
      <tr>
        <td style=\"padding: 0; line-height: 0; font-size: 0;\">
          <img src=\"{{hero_bg_url}}\" alt=\"\" width=\"600\" height=\"433\" 
               style=\"display: block; width: 100%; max-width: 600px; height: auto;\">
        </td>
      </tr>
      <!-- Content layer (overlaid using negative margin) -->
      <tr>
        <td style=\"padding: 50px; margin-top: -433px;\" valign=\"top\">
          <h1 style=\"color: #ffffff; margin: 0; font-family: Arial, sans-serif;\">
            Hero Headline
          </h1>
          <p style=\"color: #ffffff; margin: 10px 0 0 0;\">Subheading</p>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

**Pattern 2: Image with Content Below (Simpler, Better Outlook Support)**
```html
<tr>
  <td style=\"padding: 0; background-color: #1434cb;\">
    <!-- Full-width image -->
    <img src=\"{{hero_bg_url}}\" alt=\"\" width=\"600\" height=\"300\" 
         style=\"display: block; width: 100%; max-width: 600px; height: auto;\">
  </td>
</tr>
<tr>
  <td style=\"padding: 50px; background-color: #1434cb;\">
    <!-- Content in separate row -->
    <h1 style=\"color: #ffffff; margin: 0;\">Hero Headline</h1>
  </td>
</tr>
```

**Pattern 3: Side-by-Side (Image + Content Columns)**
```html
<tr>
  <td>
    <table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">
      <tr>
        <!-- Image column -->
        <td width=\"300\" valign=\"top\">
          <img src=\"{{left_image}}\" alt=\"\" width=\"300\" height=\"400\" 
               style=\"display: block; width: 300px; height: 400px;\">
        </td>
        <!-- Content column -->
        <td width=\"300\" valign=\"top\" style=\"padding: 40px;\">
          <h2 style=\"margin: 0;\">Content Here</h2>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

**Why Table-Based Images Are Better:**
- ✅ Works in all email clients (including Outlook)
- ✅ No VML fallbacks needed
- ✅ Images always render (unless blocked by user)
- ✅ Simpler code, easier to maintain
- ✅ Better mobile responsive behavior

**When to Use Each Pattern:**
- **Pattern 1 (Negative Margin):** When content must overlay image exactly as in Figma
- **Pattern 2 (Separate Rows):** Best Outlook support, simpler code
- **Pattern 3 (Columns):** For side-by-side layouts

---

### 5. Real Data vs. Tokens

**User Preference Check:**

If user says:
- "add real text" / "use real data" / "no placeholders" → Use example data directly in HTML
- "use tokens" / "dynamic content" / "personalization" → Use `{{token}}` syntax

**Default Behavior:** Use tokens for personalization (names, balances), real data for static content (headings, descriptions)

**Example:**
```html
<!-- User wants real data -->
<h1>Balance Inquiry</h1>
<p>Hi Stephen,</p>
<p>Your balance: $512.00 USD</p>

<!-- User wants tokens (default) -->
<h1>Balance Inquiry</h1>
<p>Hi {{first_name}},</p>
<p>Your balance: {{current_balance}}</p>
```

---

## Quality Checklist

Before delivering, verify:

### ⚠️ CRITICAL: Template Creation
- [ ] **Preview template created** (`[name].html`) - **MANDATORY**
- [ ] Preview template uses actual Figma CDN URLs
- [ ] Preview template includes 7-day expiry warning
- [ ] Preview template opens correctly in browser with all images visible
- [ ] All content is hardcoded (no tokens)

### Image Quality (Prevent Stretching)
- [ ] All images have explicit width AND height attributes
- [ ] All images have matching width/height in inline styles
- [ ] NO images use `height: auto` (causes stretching)
- [ ] Dimensions extracted from Figma React code (not guessed)
- [ ] **"Background" images use table-based `<img>` approach (not CSS `background-image`)**
- [ ] Hero/banner sections use `<img>` tags with overlaid content tables
- [ ] All images display correctly without distortion in browser
- [ ] Logo images use proper composite or individual assets

### 🏷️ Asset Naming & Mapping (CRITICAL for Strategy B)
- [ ] **Asset names match Figma layer names** (not generic placeholders)
- [ ] **Extracted `data-name` attributes** from Figma response for all images
- [ ] **HTML uses actual filenames** user will download from Figma
- [ ] **No generic names** like `logo.png`, `banner.jpg` (unless rename script provided)
- [ ] **Spaces in filenames preserved** (e.g., "Feature Image 1.png")
- [ ] **ASSETS.md documents exact Figma layer names** → filenames mapping
- [ ] **Simple shapes replaced with CSS** (bullets, dividers) - not images
- [ ] **Text layers identified** and either kept as images or converted to HTML
- [ ] **File extensions appropriate** (.png for logos/icons, .jpg for photos)
- [ ] **All asset entries include**: layer name, filename, dimensions, URL, purpose
- [ ] **Download instructions clear**: "Save with exact filename shown"
- [ ] **If using generic names**: Rename script provided in ASSETS.md
- [ ] **If assets missing/unavailable**: Figma CDN URLs used as fallback with clear notification
- [ ] **If fallback used**: FALLBACK-NOTICE.md created with asset update instructions
- [ ] **If fallback used**: update-to-local-assets.ps1 script generated
- [ ] **Fallback assets marked**: HTML comments indicate temporary Figma CDN URLs

### HTML Quality
- [ ] All CSS inlined in `style=""` attributes
- [ ] `<table>` layout (no divs for structure)
- [ ] 600px max-width container
- [ ] Mobile responsive media queries
- [ ] Bulletproof buttons with VML
- [ ] All images have width/height/alt
- [ ] Preview text implemented
- [ ] Unsubscribe link present (if marketing)

### Figma Accuracy
- [ ] Colors match exactly (hex codes)
- [ ] Spacing matches (padding, gaps)
- [ ] Typography matches (size, weight, line-height)
- [ ] Layout structure matches
- [ ] Images placed correctly
- [ ] Mobile responsive behavior appropriate

### Documentation Quality
- [ ] ASSETS.md lists all Figma CDN URLs with download instructions
- [ ] README.md includes quick start guide (optional)
- [ ] EMAIL_CLIENT_RISKS.md addresses compatibility (optional)
- [ ] Clear, actionable documentation

### Deliverables Completeness
- [ ] Preview template created ([name].html)
- [ ] Preview template uses actual Figma CDN URLs
- [ ] Preview template includes 7-day expiry warning
- [ ] ASSETS.md documentation created
- [ ] All images documented with dimensions and URLs

### Email Client Compatibility
- [ ] Outlook VML fallbacks for buttons
- [ ] **Table-based images used instead of CSS background-image**
- [ ] No CSS `background-image` properties (use `<img>` tags instead)
- [ ] Web-safe fonts only
- [ ] File size under 100KB (Gmail limit)
- [ ] No JavaScript
- [ ] No external CSS

---

## Common Mistakes to Avoid

1. ❌ Using `<div>` for layout → ✅ Use `<table>`
2. ❌ External CSS files → ✅ Inline all styles
3. ❌ Custom/web fonts → ✅ Web-safe fonts only
4. ❌ Flexbox/Grid → ✅ Table-based layout
5. ❌ `margin` for spacing → ✅ `padding` on `<td>`
6. ❌ Relative image URLs → ✅ Absolute HTTPS URLs
7. ❌ Missing alt text → ✅ Always include alt text
8. ❌ No mobile responsive → ✅ Media queries required
9. ❌ Plain `<a>` buttons → ✅ Bulletproof button pattern
10. ❌ Missing unsubscribe → ✅ Always include (legal requirement)
11. ❌ **Not including Figma CDN URLs** → ✅ **Create ASSETS.md with all Figma URLs**
12. ❌ **Using generic asset names** → ✅ **Use actual Figma layer names in HTML**
13. ❌ **Using `height: auto` on images** → ✅ **Use explicit width and height attributes**
14. ❌ **Guessing image dimensions** → ✅ **Extract exact dimensions from Figma React code**
15. ❌ **Not testing preview in browser** → ✅ **Open preview.html to verify images render correctly**
16. ❌ **Using CSS `background-image`** → ✅ **Use table-based `<img>` tags for "background" images**
17. ❌ **Ignoring `data-name` attributes** → ✅ **Extract and use actual Figma layer names for assets**
18. ❌ **Creating images for simple shapes** → ✅ **Use CSS for bullets, dividers, simple icons**
19. ❌ **Failing silently when assets missing** → ✅ **Use Figma CDN fallback + notify user with FALLBACK-NOTICE.md**
20. ❌ **Breaking template when name mapping fails** → ✅ **Use temporary Figma URLs + generate update script**

---

## Troubleshooting Image Issues

### Problem: Images are stretched or distorted

**Cause:** Using `height: auto` or missing explicit dimensions

**Solution:**
```html
❌ BAD:
<img src="..." width="200" style="width: 200px; height: auto;">

✅ GOOD:
<img src="..." width="200" height="50" style="display: block; width: 200px; height: 50px;">
```

**How to Fix:**
1. Open Figma response file
2. Search for the image variable (e.g., `src={imgLogo}`)
3. Find the `<img>` tag with width/height
4. Extract BOTH dimensions
5. Apply to HTML with attributes AND inline styles

---

### Problem: Logo is missing or broken

**Cause:** Logo may be composite of multiple elements in Figma

**Solution:**
1. Check Figma response for multiple logo parts:
   - `imgLogoBorder` - logo icon
   - `imgBankingPayments` - text portion
2. Combine into a table layout:
```html
<table role="presentation" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td style="padding-right: 10px;">
      <img src="[logo-icon-url]" width="65" height="40">
    </td>
    <td style="vertical-align: middle;">
      <img src="[logo-text-url]" width="158" height="23">
    </td>
  </tr>
</table>
```

---

### Problem: Background image not showing

**Cause:** Using CSS `background-image` which has poor email client support (especially Outlook)

**Solution:** Use table-based image approach instead:
```html
❌ BAD (CSS background-image):
<td style="background-image: url('hero.jpg'); background-size: cover; height: 433px;">
  <h1>Content</h1>
</td>

✅ GOOD (Table-based image):
<td style="padding: 0; position: relative;">
  <!-- Actual image tag -->
  <img src="hero.jpg" alt="" width="600" height="433" style="display: block; width: 600px; height: 433px;">
  
  <!-- Content overlaid using nested table -->
  <table role="presentation" cellpadding="0" cellspacing="0" border="0" style="width: 100%; margin-top: -433px; position: relative;">
    <tr>
      <td style="padding: 50px;" valign="top">
        <h1 style="color: #ffffff; margin: 0;">Content</h1>
      </td>
    </tr>
  </table>
</td>
```

**Why this works better:**
- Actual `<img>` tags have universal email client support
- No VML fallbacks needed
- Images always render (unless blocked by user)
- More reliable than CSS background properties

---

### Problem: Asset files missing or not in assets folder

**Cause:** User chose "Local Assets Folder" strategy but hasn't downloaded files yet, or asset name mapping failed

**Solution: Use Figma CDN URL Fallback Strategy**

**Step 1: Use Figma CDN URLs temporarily**
```html
<!-- Instead of breaking with missing local path: -->
❌ BAD:
<img src="./assets/logo.png" ... >  <!-- File doesn't exist yet -->

✅ GOOD (Fallback):
<img src="https://www.figma.com/api/mcp/asset/58b625db-ba64-42f3-bc8c-033c12ce018b" 
     data-local-path="./assets/Logo.png"
     alt="Company logo" 
     width="200" 
     height="50">
<!-- ⚠️ TEMPORARY: Using Figma CDN URL - Replace with ./assets/Logo.png after download -->
```

**Step 2: Create FALLBACK-NOTICE.md**
```markdown
## ⚠️ ASSET FALLBACK NOTICE

The following assets are using **temporary Figma CDN URLs** (expire in 7 days):

| Asset | Expected Local Path | Action |
|-------|---------------------|--------|
| Logo | `./assets/Logo.png` | Download from ASSETS.md |
| Hero Banner | `./assets/hero.jpg` | Download from ASSETS.md |

**To fix:**
1. Download assets from URLs in ASSETS.md
2. Run: `.\update-to-local-assets.ps1`
```

**Step 3: Generate update-to-local-assets.ps1**
```powershell
# Automated script to replace Figma CDN URLs with local paths
$replacements = @(
    @{Find = "https://www.figma.com/api/.../uuid1"; Replace = "./assets/Logo.png"},
    @{Find = "https://www.figma.com/api/.../uuid2"; Replace = "./assets/hero.jpg"}
)

$content = Get-Content "[template].html" -Raw
foreach ($r in $replacements) {
    $content = $content -replace [regex]::Escape($r.Find), $r.Replace
}
Set-Content "[template].html" -Value $content -NoNewline
```

**Step 4: Inform user clearly**
```
✅ Generated HTML template with 15 images
⚠️ 2 assets using temporary Figma CDN URLs (not yet downloaded)
📄 See FALLBACK-NOTICE.md for details
🔧 Run update-to-local-assets.ps1 after downloading assets

Timeline: Figma CDN URLs expire in 7 days - download promptly!
```

**When to use this strategy:**
- User chooses Local Assets but files don't exist yet
- Asset name extraction fails or is uncertain
- Preview/testing mode before asset download
- Partial asset availability (some local, some missing)

**Benefits:**
- ✅ Template works immediately (can preview layout)
- ✅ User can download assets at their convenience  
- ✅ Clear upgrade path from temporary to production
- ✅ Automated script makes replacement easy
- ✅ No broken images in preview

---

## References

- [EMAIL_CONVERSION_PROMPT.md](./EMAIL_CONVERSION_PROMPT.md) - Complete HTML patterns and examples
- [CONTENT_TOKENS.md](./CONTENT_TOKENS.md) - Token documentation template
- [EMAIL_CLIENT_RISKS.md](./EMAIL_CLIENT_RISKS.md) - Compatibility reference guide
- [Can I Email](https://www.caniemail.com/) - Feature support checker
- [Litmus](https://litmus.com/) - Email testing platform

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024-03-24 | Initial AI context documentation |
| 2.0 | 2026-03-25 | **CRITICAL UPDATE:** Mandatory preview template requirement, image dimension extraction, troubleshooting section added |
| 2.1 | 2026-03-25 | **MAJOR UPDATE:** Table-based "background" images instead of CSS background-image - better email client compatibility, no VML fallbacks needed, added 3 patterns with examples |
| 2.2 | 2026-03-27 | **REPOSITORY STRUCTURE UPDATE:** Template-specific folders (`[template-name]/`) for multi-template support, automated GitHub deployment with folder organization, updated CDN URL format to include template name |

---

## 📝 Complete Workflow Summary (With New Structure)

### For Strategy B1 (GitHub Temporary CDN):

1. **User provides Figma URL** → AI detects and validates Figma MCP server
2. **Interactive Q&A** → Gathers email type, ESP, brand, design type, asset strategy
3. **Extract Figma design** → Get design context, extract template name from Figma frame name
4. **Convert to kebab-case** → "Your exclusive invitation" → `your-exclusive-invitation`
5. **Create folder structure:**
   ```
   workspace/
   ├── Email AI Context/         ← Already exists (generic files)
   └── your-exclusive-invitation/ ← Create this
       ├── assets/                 ← Create this, move assets here
       ├── your-exclusive-invitation.html
       ├── ASSETS.md
       └── update-cdn-urls.ps1
   ```
6. **Deploy to GitHub** → Execute `.\Email AI Context\deploy-to-github.ps1` via `run_in_terminal`
7. **Wait for deployment** → Verify success before generating HTML
8. **Generate HTML** → Use GitHub CDN URLs: `.../your-exclusive-invitation/assets/Banner.gif`
9. **Create documentation** → ASSETS.md with GitHub CDN links, update scripts
10. **Provide summary** → Show user next steps and testing instructions

### Final GitHub Repository Structure:

```
https://github.com/numani2c/ai-email-templates
├── Email AI Context/
│   ├── EMAIL_AI_CONTEXT.md
│   ├── deploy-to-github.ps1
│   └── ... (all generic files)
│
├── your-exclusive-invitation/
│   ├── assets/ (25 images)
│   ├── your-exclusive-invitation.html
│   ├── ASSETS.md
│   └── update-cdn-urls.ps1
│
└── [next-template]/
    ├── assets/
    ├── [next-template].html
    └── ...
```

### CDN URLs Generated:
```
https://raw.githubusercontent.com/numani2c/ai-email-templates/main/your-exclusive-invitation/assets/Banner.gif
https://raw.githubusercontent.com/numani2c/ai-email-templates/main/your-exclusive-invitation/assets/Logo.png
... (all assets with template-specific path)
```

---

**End of Document**
