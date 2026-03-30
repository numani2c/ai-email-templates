# Email Assets - Flow HCM-ATS System

## Overview

This document lists all image assets used in the **Flow HCM-ATS System** email template.

**Asset Strategy:** Figma CDN URLs (Preview - 7 days validity)  
**Brand:** i2c  
**Email Type:** Marketing  
**Template File:** `flow-hcm-ats-system-preview.html`

---

## ⚠️ IMPORTANT NOTICE

**Figma CDN URLs expire in 7 days!**

The preview template currently uses temporary Figma CDN URLs. For production deployment:

1. Download all assets using the URLs below
2. Upload to your permanent CDN
3. Run `update-cdn-urls.ps1` to replace Figma URLs with CDN URLs

---

## Required Images

| # | Asset Description | Figma Layer Name | Dimensions | Figma URL | Purpose |
|---|-------------------|------------------|------------|-----------|---------|
| 1 | Header Logo | Layer_12 | 225×49px | `https://www.figma.com/api/mcp/asset/1402048a-41e6-428c-9d85-02abdcc5cf80` | Branding in hero section |
| 2 | Footer Logo | Layer_1 | 183×42px | `https://www.figma.com/api/mcp/asset/07bcb12f-e0e9-415a-be33-39e6a97f3fc6` | Branding in footer |
| 3 | Social Icons | Frame4813683 | 81×19px | `https://www.figma.com/api/mcp/asset/90bd17da-1298-4c05-8e71-da29d8f107a3` | LinkedIn, X, Instagram, Facebook icons |

**Note:** Bullet triangles and divider lines are generated using CSS (not images) for better email client compatibility.

---

## Download Instructions

### Method 1: Manual Download (Quickest)

1. **Click each Figma URL** above (opens in browser)
2. **Right-click the image** → "Save Image As..."
3. **Use these filenames:**
   - `header-logo.png` (225×49px)
   - `footer-logo.png` (183×42px)
   - `social-icons.png` (81×19px)
4. **Save all files** to a designated folder (e.g., `assets/`)

### Method 2: Automated Download Script

```powershell
# Create assets directory
New-Item -ItemType Directory -Force -Path "assets"

# Download function
function Download-Asset {
    param($url, $filename)
    $output = "assets\$filename"
    Write-Host "Downloading $filename..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Host "✓ Downloaded: $filename" -ForegroundColor Green
}

# Download all assets
Download-Asset "https://www.figma.com/api/mcp/asset/1402048a-41e6-428c-9d85-02abdcc5cf80" "header-logo.png"
Download-Asset "https://www.figma.com/api/mcp/asset/07bcb12f-e0e9-415a-be33-39e6a97f3fc6" "footer-logo.png"
Download-Asset "https://www.figma.com/api/mcp/asset/90bd17da-1298-4c05-8e71-da29d8f107a3" "social-icons.png"

Write-Host "`n✓ All assets downloaded successfully!" -ForegroundColor Green
Write-Host "⚠️  Remember to optimize images before production upload" -ForegroundColor Yellow
```

**Save as:** `download-assets.ps1`  
**Usage:** `.\download-assets.ps1`

---

## Asset Optimization Guidelines

**Before uploading to production CDN:**

### Image Compression
- **PNG images:** Use [TinyPNG](https://tinypng.com/) or [ImageOptim](https://imageoptim.com/)
- **Target quality:** 80-85% for balanced quality/size
- **Goal:** Keep total email size under 100KB (Gmail limit for images in feed)

### Recommended Tools
- **TinyPNG** - https://tinypng.com/ (PNG optimization)
- **Squoosh** - https://squoosh.app/ (Advanced compression)
- **ImageOptim** - https://imageoptim.com/ (Mac batch optimizer)

### File Format Recommendations
| Asset | Current Format | Recommended | Reason |
|-------|---------------|-------------|---------|
| Header Logo | PNG | PNG | Transparency support |
| Footer Logo | PNG | PNG | Transparency support |
| Social Icons | PNG | PNG | Small icons with transparency |

---

## CDN Migration Workflow

### Step 1: Download Assets
```powershell
# Run download script
.\download-assets.ps1
```

### Step 2: Optimize Images
- Compress all assets using tools listed above
- Verify images maintain quality
- Check file sizes (target: under 100KB total)

### Step 3: Upload to CDN
Upload all optimized images to your CDN with this structure:
```
https://cdn.yourcompany.com/emails/flow-hcm-ats/
  ├── header-logo.png
  ├── footer-logo.png
  └── social-icons.png
```

### Step 4: Update HTML URLs
```powershell
# Run URL replacement script
.\update-cdn-urls.ps1

# When prompted, enter your CDN base URL:
# Example: https://cdn.yourcompany.com/emails/flow-hcm-ats
```

---

## Asset Mapping Reference

| HTML Reference | Figma Asset ID | Recommended Filename | Dimensions |
|----------------|----------------|---------------------|------------|
| Header logo image | 1402048a-41e6-428c-9d85-02abdcc5cf80 | `header-logo.png` | 225×49px |
| Footer logo image | 07bcb12f-e0e9-415a-be33-39e6a97f3fc6 | `footer-logo.png` | 183×42px |
| Social icons image | 90bd17da-1298-4c05-8e71-da29d8f107a3 | `social-icons.png` | 81×19px |

---

## CSS-Generated Elements (No Images Required)

The following elements are created using CSS for maximum email client compatibility:

| Element | Implementation | Why CSS? |
|---------|---------------|----------|
| **Bullet triangles** | CSS borders (`border-left: 6px solid #ff6b35`) | SVG not supported in Gmail/Outlook |
| **Divider lines** | CSS border (`border-bottom: 1px solid #c7e2ff`) | Simpler, more reliable rendering |
| **Gradient background** | Inline CSS (`linear-gradient`) | Supported in modern email clients |

---

## Quick Reference: All Asset URLs

Copy all URLs for batch processing:

```
https://www.figma.com/api/mcp/asset/1402048a-41e6-428c-9d85-02abdcc5cf80
https://www.figma.com/api/mcp/asset/07bcb12f-e0e9-415a-be33-39e6a97f3fc6
https://www.figma.com/api/mcp/asset/90bd17da-1298-4c05-8e71-da29d8f107a3
```

---

## Timeline & Next Steps

**✅ Phase 1: Preview (Current)**
- Using temporary Figma CDN URLs
- Valid for 7 days from creation
- Perfect for stakeholder review and testing

**⏳ Phase 2: Production Preparation**
1. Download assets (before Figma URLs expire)
2. Optimize images for email
3. Upload to permanent CDN

**🚀 Phase 3: Production Deployment**
1. Run `update-cdn-urls.ps1` script
2. Test production HTML in email clients
3. Deploy to ESP (Mailchimp, SendGrid, etc.)

---

## Email Client Testing Checklist

After updating to production CDN URLs, test in these clients:

**Desktop:**
- [ ] Outlook 2016/2019/365 (Windows)
- [ ] Outlook 2011/2016 (Mac)
- [ ] Apple Mail (Mac)
- [ ] Gmail (Chrome)

**Webmail:**
- [ ] Gmail.com (Chrome, Firefox, Safari)
- [ ] Outlook.com
- [ ] Yahoo Mail

**Mobile:**
- [ ] Gmail App (Android & iOS)
- [ ] Apple Mail (iPhone/iPad)
- [ ] Outlook App (Android & iOS)
- [ ] Samsung Email

**Verify:**
- ✅ All 3 images load correctly
- ✅ CSS triangles display as orange bullets
- ✅ Gradient background renders in hero section
- ✅ Fonts consistent across clients (Arial)
- ✅ Logo dimensions correct (not stretched)
- ✅ Social icons visible and clickable

---

## Support & Documentation

**Template Documentation:**
- Main template: `flow-hcm-ats-system-preview.html`
- CDN migration: `update-cdn-urls.ps1`
- This guide: `ASSETS.md`

**Email Conversion Context:**
- Full workflow: `../Email AI Context/EMAIL_AI_CONTEXT.md`
- Email client risks: `../Email AI Context/EMAIL_CLIENT_RISKS.md`
- Design guidelines: `../Email AI Context/DESIGN_GUIDELINES_FOR_DESIGNERS.md`

**Questions or Issues?**
Refer to the Email AI Context folder for comprehensive email development guidelines.

---

**Last Updated:** March 27, 2026  
**Template Version:** 1.0 (Preview)  
**Total Assets:** 3 images + 2 CSS elements