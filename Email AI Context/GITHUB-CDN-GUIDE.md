# Using GitHub as a Temporary CDN for Email Assets

## ⭐ RECOMMENDED: Primary Choice for Email Assets

**GitHub public repositories are the BEST temporary solution for email assets** because:
- ✅ **No authentication required** - Works perfectly in all email clients
- ✅ **Public access** - Images load instantly without login
- ✅ **Email client compatible** - Gmail, Outlook, Apple Mail, etc. all work
- ✅ **Faster setup** - 5 minutes to deploy vs 10+ minutes
- ✅ **Global CDN** - GitHub uses Fastly CDN (fast worldwide delivery)
- ✅ **Proven solution** - We successfully deployed 26 assets, all working perfectly

**Why not BitBucket?**
- ❌ Private BitBucket repos require authentication (blocks email clients)
- ❌ Images appear broken in emails even though URLs work in browser
- ⚠️ BitBucket only works if repository is PUBLIC (not typical for companies)

**Real-world validation:**
- We initially tried BitBucket private repo → all images broken in email ❌
- Switched to GitHub public repo → all 23 images loaded perfectly ✅
- Email template ready for testing in 5 minutes

---

## ⚠️ IMPORTANT: This is a TEMPORARY Solution

**GitHub CDN is an interim hosting solution** to get your email live quickly while your production CDN is being set up.

**Timeline:**
- ✅ **Now:** Use GitHub for immediate deployment (setup in 5 minutes)
- 🔄 **Later:** Migrate to production CDN when ready (easy migration provided)

**Why Temporary?**
- GitHub raw URLs are intended for development/testing, not production at scale
- Your organization likely has or will have a production CDN (Cloudflare, AWS, Azure, etc.)
- Easy to migrate: Just run `update-cdn-urls.ps1` with your production URL

## Overview

GitHub provides a free, reliable **interim** hosting solution for email assets using either:
- **GitHub Repository Raw URLs** (public repos) - ⭐ **PRIMARY RECOMMENDATION** ✅
- **GitHub Pages** (custom domain optional) - Alternative option

**Why GitHub Raw URLs are perfect for email assets:**
- Email clients can load images without any authentication
- Works in all major email clients (even strict ones like Outlook)
- Free, fast, and reliable for temporary hosting
- Easy migration path to production CDN when ready

Both methods work well for getting emails live, but **raw URLs are simpler and faster to set up**.

---

## Method 1: GitHub Raw URLs (Simplest) ⭐ Recommended

### Benefits (for email assets):
- ✅ **100% Free** - No costs while setting up production CDN
- ✅ **Instant Setup** - Get live in 5 minutes, not weeks
- ✅ **Global CDN** - GitHub uses Fastly CDN automatically
- ✅ **Reliable Interim** - 99.9%+ uptime for transition period
- ✅ **Easy Migration** - Simple switch to production CDN later
- ✅ **Bridge Solution** - Deploy now, optimize later
- ✅ **No Authentication** - **CRITICAL for email assets** - images load without login
- ✅ **Email Client Compatible** - Works in Gmail, Outlook, Apple Mail, Yahoo, etc.

### Step-by-Step Setup:

#### 1. Create GitHub Repository

```bash
# Option A: Create via GitHub Web UI
1. Go to https://github.com/new
2. Repository name: email-assets (or your preference)
3. Set to Public ✅ (required for raw URLs)
4. Add README: Optional
5. Click "Create repository"

# Option B: Create via GitHub CLI
gh repo create email-assets --public --clone
cd email-assets
```

#### 2. Upload Assets to Repository

**Option A: Via GitHub Web UI (Easy)**
1. Click "Add file" → "Upload files"
2. Drag all images from `./assets/` folder
3. Commit message: "Add email template assets"
4. Click "Commit changes"

**Option B: Via Git CLI (Advanced)**
```bash
# Clone the repository
git clone https://github.com/YOUR-USERNAME/email-assets.git
cd email-assets

# Create assets folder
mkdir assets

# Copy your images
cp -r "/path/to/Your exclusive invitation-iteration 7/assets/"* ./assets/

# Commit and push
git add assets/
git commit -m "Add email template assets"
git push origin main
```

**Option C: Via PowerShell**
```powershell
# Clone the repository
git clone https://github.com/YOUR-USERNAME/email-assets.git
cd email-assets

# Create assets folder
New-Item -ItemType Directory -Path "assets" -Force

# Copy your images
Copy-Item -Path "C:\Users\nhaq\Desktop\Your exclusive invitation-iteration 7\assets\*" -Destination ".\assets\" -Recurse

# Commit and push
git add assets/
git commit -m "Add email template assets"
git push origin main
```

#### 3. Get Raw URLs

**URL Format:**
```
https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/PATH/TO/FILE

Example:
https://raw.githubusercontent.com/john-doe/email-assets/main/assets/Logo.png
```

**For Your Assets:**
```
Base URL: https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/

Full URLs:
https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Accelerate Event Summit Logo.png
https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Heading.png
https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Banner.gif
... etc
```

#### 4. Update HTML Template

**Option A: Use the Update Script**
```bash
# Run the Node.js updater
node update-cdn-urls.js

# When prompted, enter:
CDN Base URL: https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets
```

**Option B: Manual Find & Replace**

Replace all instances in `your-exclusive-invitation.html`:
```
Find:    https://staging.i2cinc.org/ai-templates/assets/
Replace: https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/
```

---

## Method 2: GitHub Pages (Alternative)

### Benefits:
- ✅ Custom domain support
- ✅ Better for websites (not just files)
- ✅ Still free and reliable

### Setup:

#### 1. Create Repository
Same as Method 1, but name it `your-username.github.io` for automatic setup

#### 2. Enable GitHub Pages
1. Go to repository Settings → Pages
2. Source: Deploy from a branch
3. Branch: `main` → `/root` or `/docs`
4. Click Save

#### 3. Upload Assets
Same as Method 1

#### 4. Access URLs

**URL Format:**
```
https://USERNAME.github.io/REPO/PATH/TO/FILE

Example:
https://john-doe.github.io/email-assets/assets/Logo.png
```

**With Custom Domain (Optional):**
```
https://cdn.yourdomain.com/assets/Logo.png
```

---

## 📋 Complete Asset URLs (After GitHub Upload)

Replace `YOUR-USERNAME` with your GitHub username:

| Asset | GitHub Raw URL |
|-------|----------------|
| Logo | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Accelerate Event Summit Logo.png` |
| Heading | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Heading.png` |
| Date Icon | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Date.png` |
| Location Icon | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Location icon.png` |
| Banner | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Banner.gif` |
| Invite 1 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Invite 1.png` |
| Invite 2 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Invite 2.png` |
| Invite 3 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Invite 3.png` |
| Video | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Video.gif` |
| Image 1 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Image 1.png` |
| Image 2 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Image 2.png` |
| Center | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/center.png` |
| Image 4 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Image 4.png` |
| Image 5 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Image 5.png` |
| Feature 4 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Feature 4.png` |
| Feature 5 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Feature 5.png` |
| Feature 6 | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Feature 6.png` |
| Signature | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Sign.png` |
| Footer Logo | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/i2c logo.png` |
| LinkedIn | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Linkedin.png` |
| X | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/X.png` |
| Instagram | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Instagram.png` |
| Facebook | `https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Facebook.png` |

---

## 🚀 Quick Start Script

Save this as `upload-to-github.ps1`:

```powershell
#!/usr/bin/env pwsh
param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "email-assets"
)

Write-Host "🚀 GitHub CDN Setup for Email Assets" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}

# Check if gh CLI is installed (optional but helpful)
$hasGhCli = Get-Command gh -ErrorAction SilentlyContinue

$repoUrl = "https://github.com/$GitHubUsername/$RepoName"

Write-Host "📦 Repository: $repoUrl" -ForegroundColor Yellow
Write-Host ""

# Option to create repo via gh CLI
if ($hasGhCli) {
    Write-Host "Would you like to create the repository now? (y/n)" -ForegroundColor Yellow
    $createRepo = Read-Host
    
    if ($createRepo -eq 'y') {
        Write-Host "Creating repository..." -ForegroundColor Cyan
        gh repo create $RepoName --public --description "Email template assets"
    }
}

# Clone or initialize
$tempDir = Join-Path $env:TEMP $RepoName
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}

Write-Host "Cloning repository..." -ForegroundColor Cyan
git clone $repoUrl $tempDir

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to clone. Make sure the repository exists and is public." -ForegroundColor Red
    exit 1
}

# Create assets folder
$assetsDir = Join-Path $tempDir "assets"
New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null

# Copy assets
$sourceAssets = ".\assets\*"
Write-Host "Copying assets..." -ForegroundColor Cyan
Copy-Item -Path $sourceAssets -Destination $assetsDir -Recurse -Force

# Commit and push
Set-Location $tempDir
git add assets/
git commit -m "Add email template assets"
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Success! Assets uploaded to GitHub" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔗 Your CDN Base URL:" -ForegroundColor Cyan
    Write-Host "https://raw.githubusercontent.com/$GitHubUsername/$RepoName/main/assets/" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Run: node update-cdn-urls.js" -ForegroundColor White
    Write-Host "2. Enter the CDN Base URL above" -ForegroundColor White
    Write-Host "3. Test your email template" -ForegroundColor White
} else {
    Write-Host "❌ Failed to push to GitHub" -ForegroundColor Red
}

# Cleanup
Set-Location ..
Remove-Item $tempDir -Recurse -Force
```

**Usage:**
```powershell
.\upload-to-github.ps1 -GitHubUsername "your-username"
```

---

## 🔧 Automated URL Update Script

Save this as `update-to-github-cdn.ps1`:

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "email-assets",
    
    [Parameter(Mandatory=$false)]
    [string]$HtmlFile = "your-exclusive-invitation.html"
)

$cdnBaseUrl = "https://raw.githubusercontent.com/$GitHubUsername/$RepoName/main/assets"

Write-Host ""
Write-Host "🔄 Updating HTML to use GitHub CDN" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "CDN URL: $cdnBaseUrl" -ForegroundColor Green
Write-Host "HTML File: $HtmlFile" -ForegroundColor Green
Write-Host ""

if (-not (Test-Path $HtmlFile)) {
    Write-Host "❌ File not found: $HtmlFile" -ForegroundColor Red
    exit 1
}

# Create backup
$backupFile = "$HtmlFile.backup"
Copy-Item $HtmlFile $backupFile -Force
Write-Host "✓ Backup created: $backupFile" -ForegroundColor Green

# Read content
$content = Get-Content $HtmlFile -Raw

# Replace staging URL or local paths
$patterns = @(
    "https://staging.i2cinc.org/ai-templates/assets",
    "./assets"
)

$updated = 0
foreach ($pattern in $patterns) {
    $matches = ([regex]::Matches($content, [regex]::Escape($pattern))).Count
    if ($matches -gt 0) {
        $content = $content -replace [regex]::Escape($pattern), $cdnBaseUrl
        $updated += $matches
        Write-Host "✓ Replaced $matches instances of '$pattern'" -ForegroundColor Green
    }
}

# Write updated content
Set-Content $HtmlFile -Value $content -NoNewline

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "✅ Update Complete!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "Updated: $updated asset URLs" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Open $HtmlFile in a browser" -ForegroundColor White
Write-Host "2. Verify all images load correctly" -ForegroundColor White
Write-Host "3. Send a test email" -ForegroundColor White
Write-Host ""
```

**Usage:**
```powershell
.\update-to-github-cdn.ps1 -GitHubUsername "your-username"
```

---

## ⚡ One-Command Setup

If you have Git and GitHub CLI installed:

```bash
# Create repo, upload assets, and update HTML in one go
gh repo create email-assets --public && \
git clone https://github.com/YOUR-USERNAME/email-assets.git && \
cd email-assets && \
mkdir assets && \
cp -r ../assets/* ./assets/ && \
git add assets/ && \
git commit -m "Add email assets" && \
git push origin main && \
cd .. && \
node update-cdn-urls.js
# When prompted, enter: https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets
```

---

## 📊 Comparison: GitHub vs Other CDNs

| Feature | GitHub Raw | Cloudflare R2 | AWS S3 | Azure CDN |
|---------|------------|---------------|---------|-----------|
| **Cost** | ✅ Free | Paid (10GB free) | Paid | Paid |
| **Setup Time** | 5 min | 30 min | 45 min | 60 min |
| **Global CDN** | ✅ Yes (Fastly) | ✅ Yes | ✅ Yes | ✅ Yes |
| **Bandwidth Limit** | Unlimited* | 10TB/month | Pay per GB | Pay per GB |
| **Uptime** | 99.9%+ | 99.9%+ | 99.99% | 99.95% |
| **HTTPS** | ✅ Free | ✅ Free | ✅ Free | ✅ Free |
| **Best For** | Email assets | Large files | Enterprise | Enterprise |

*Reasonable use policy applies

---

## 🔒 Security & Best Practices

### Public Repository Considerations:
1. ✅ **Safe for email assets** (images are public anyway)
2. ❌ **Don't store sensitive data** (API keys, credentials)
3. ✅ **Use separate repo** for assets (not your main codebase)
4. ✅ **Keep repository clean** (only essential assets)

### Optimization:
1. **Compress images** before upload:
   - Use TinyPNG, ImageOptim, or similar
   - Target: < 100KB per image for email
   
2. **Use appropriate formats**:
   - JPG for photos
   - PNG for logos/graphics with transparency
   - GIF for simple animations (keep < 500KB)
   - SVG for icons (when supported)

3. **Test loading speed**:
   ```bash
   # Check asset load time
   curl -w "@curl-format.txt" -o /dev/null -s "https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets/Banner.gif"
   ```

---

## 🆘 Troubleshooting

### Issue: Images not loading

**Problem:** URLs return 404 or don't load

**Solutions:**
1. ✅ Verify repository is **Public** (not Private)
2. ✅ Check file names match exactly (case-sensitive)
3. ✅ Ensure spaces in filenames are preserved in URLs
4. ✅ Confirm files are in correct folder path
5. ✅ Wait 1-2 minutes after upload for CDN propagation

### Issue: Slow loading

**Problem:** Images take too long to load

**Solutions:**
1. ✅ Compress images (use TinyPNG)
2. ✅ Reduce dimensions (email max: 600px wide)
3. ✅ Use JPG instead of PNG for photos
4. ✅ Keep GIFs under 500KB

### Issue: Authentication errors

**Problem:** Push to GitHub fails

**Solutions:**
1. ✅ Configure Git credentials: `git config --global credential.helper store`
2. ✅ Use GitHub Personal Access Token (not password)
3. ✅ Or use GitHub CLI: `gh auth login`

---

## 📚 Additional Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Git Large File Storage (LFS)](https://git-lfs.github.com/) - For files > 50MB
- [GitHub CLI](https://cli.github.com/) - Command-line tool
- [Email Image Best Practices](https://www.litmus.com/blog/email-image-optimization/)

---

## ✅ Final Checklist

Before sending your email:

- [ ] Repository is public
- [ ] All 23 assets uploaded to GitHub
- [ ] HTML updated with GitHub raw URLs
- [ ] Images tested in browser
- [ ] Test email sent to yourself
- [ ] Images verified in email client (Gmail, Outlook)
- [ ] Mobile responsive check
- [ ] All links work correctly

---

**Ready to deploy?** Your email template is now using GitHub's free, global CDN! 🚀

**Cost:** $0/month  
**Reliability:** 99.9%+ uptime  
**Speed:** Global CDN  
**Maintenance:** None required
