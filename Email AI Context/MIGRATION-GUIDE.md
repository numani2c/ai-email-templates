# Migration Guide: GitHub → Production CDN

## Overview

This guide helps you migrate from GitHub temporary hosting to your production CDN when it's ready.

**Timeline:** 
- ✅ **Phase 1 (Now):** GitHub = Temporary/Interim hosting for immediate launch
- 🔄 **Phase 2 (Later):** Production CDN = Permanent hosting for long-term use

**Migration Time:** < 30 minutes

---

## 🎯 When to Migrate

Migrate from GitHub to production CDN when:

- ✅ Your production CDN is provisioned and tested
- ✅ All assets are uploaded to production CDN
- ✅ Production CDN URLs are confirmed working
- ✅ You have approval from IT/DevOps team
- ✅ You're ready for permanent hosting

**Don't wait for:**
- ❌ Initial email send (use GitHub now, migrate later)
- ❌ Perfect CDN setup (iterate and improve)
- ❌ All future templates (migrate per template as needed)

---

## 📋 Pre-Migration Checklist

### 1. Verify Production CDN is Ready

```powershell
# Test that production CDN is accessible
# Test URL for one asset:
$testUrl = "https://cdn.i2cinc.com/email-assets/Logo.png"

try {
    $response = Invoke-WebRequest -Uri $testUrl -Method Head
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Production CDN is accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Production CDN not accessible yet" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Yellow
}
```

### 2. Confirm All Assets Are Uploaded

Verify all 23 assets exist on production CDN:

| Asset | Production URL |
|-------|----------------|
| Logo | `https://cdn.YOUR-DOMAIN.com/email-assets/Accelerate Event Summit Logo.png` |
| Heading | `https://cdn.YOUR-DOMAIN.com/email-assets/Heading.png` |
| ... | (all 23 assets) |

**Quick Test Script:**
```powershell
# Save as test-production-cdn.ps1
$cdnBase = "https://cdn.i2cinc.com/email-assets"

$assets = @(
    "Accelerate Event Summit Logo.png",
    "Heading.png",
    "Date.png",
    "Location icon.png",
    "Banner.gif",
    "Invite 1.png",
    "Invite 2.png",
    "Invite 3.png",
    "Video.gif",
    "Image 1.png",
    "Image 2.png",
    "center.png",
    "Image 4.png",
    "Image 5.png",
    "Feature 4.png",
    "Feature 5.png",
    "Feature 6.png",
    "Sign.png",
    "i2c logo.png",
    "Linkedin.png",
    "X.png",
    "Instagram.png",
    "Facebook.png"
)

$missing = @()
$found = 0

Write-Host "Testing production CDN..." -ForegroundColor Cyan
Write-Host ""

foreach ($asset in $assets) {
    $url = "$cdnBase/$asset"
    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ $asset" -ForegroundColor Green
            $found++
        }
    } catch {
        Write-Host "✗ $asset (Missing)" -ForegroundColor Red
        $missing += $asset
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Results: $found/$($assets.Count) assets found" -ForegroundColor $(if ($found -eq $assets.Count) { "Green" } else { "Yellow" })
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

if ($missing.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Missing assets:" -ForegroundColor Yellow
    foreach ($m in $missing) {
        Write-Host "   - $m" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Upload missing assets before migration." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "✅ All assets verified! Ready to migrate." -ForegroundColor Green
}
```

### 3. Backup Current HTML

```powershell
# Create backup before migration
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item "your-exclusive-invitation.html" "your-exclusive-invitation_before-prod-cdn_$timestamp.html"
Write-Host "✓ Backup created"
```

---

## 🔄 Migration Process

### Method 1: Automated Migration (Recommended) ⚡

**Step 1: Run the migration script**
```powershell
.\update-cdn-urls.ps1
```

**Step 2: Enter your production CDN URL when prompted**
```
Enter your CDN base URL:
Example: https://cdn.example.com/email-assets

CDN Base URL: https://cdn.i2cinc.com/email-assets
```

**Step 3: Confirm the update**
```
This will replace all './assets/' paths with CDN URLs.
A backup will be created automatically.

Continue? (y/n): y
```

**Step 4: Review the results**
```
✓ Replaced 23 asset paths
✓ Backup saved as: your-exclusive-invitation.html.backup_20260327_101530
✓ Updated file: your-exclusive-invitation.html
```

**What it does:**
- ✅ Finds all GitHub URLs: `https://raw.githubusercontent.com/...`
- ✅ Replaces with production URLs: `https://cdn.i2cinc.com/...`
- ✅ Creates automatic backup
- ✅ Preserves all formatting and structure
- ✅ Updates all 23 asset references

### Method 2: Manual Migration

**If you prefer manual control:**

1. **Open HTML file in editor**
2. **Find and Replace:**
   ```
   Find:    https://raw.githubusercontent.com/YOUR-USERNAME/email-assets/main/assets
   Replace: https://cdn.i2cinc.com/email-assets
   ```
3. **Verify count:** Should show 23 replacements
4. **Save file**

---

## ✅ Post-Migration Validation

### 1. Test in Browser
```powershell
# Open the updated HTML
Start-Process "your-exclusive-invitation.html"
```

**Check:**
- [ ] All 23 images load correctly
- [ ] No broken image icons
- [ ] Images load from production CDN (check browser Network tab)
- [ ] Page loads quickly (< 3 seconds)

### 2. Send Test Email

1. Send test email to yourself
2. Check on multiple clients:
   - [ ] Gmail (Desktop)
   - [ ] Gmail (Mobile)
   - [ ] Outlook (Desktop)
   - [ ] Outlook Mobile
   - [ ] Apple Mail
3. Verify all images load
4. Check load speed (should be fast)

### 3. Verify Production URLs

**Check Network Tab in Browser:**
```
✓ Should load from: https://cdn.i2cinc.com/email-assets/...
✗ Should NOT load from: https://raw.githubusercontent.com/...
```

### 4. Compare Before/After

```powershell
# View differences
$before = Get-Content "your-exclusive-invitation_before-prod-cdn_*.html" -Raw
$after = Get-Content "your-exclusive-invitation.html" -Raw

# Count URLs
$githubUrls = ([regex]::Matches($before, "raw.githubusercontent.com")).Count
$prodUrls = ([regex]::Matches($after, "cdn.i2cinc.com")).Count

Write-Host "Before: $githubUrls GitHub URLs" -ForegroundColor Yellow
Write-Host "After:  $prodUrls Production URLs" -ForegroundColor Green
```

---

## 🔧 Troubleshooting

### Issue: Images Not Loading After Migration

**Problem:** 404 errors on production CDN

**Solutions:**
1. Verify assets uploaded to correct path on CDN
2. Check URL path structure matches exactly
3. Verify CDN is publicly accessible (not behind auth)
4. Check CORS settings on CDN (should allow all origins)
5. Verify HTTPS certificate is valid

```powershell
# Test individual asset
$url = "https://cdn.i2cinc.com/email-assets/Logo.png"
Invoke-WebRequest -Uri $url -Method Head
```

### Issue: Some Images Load, Others Don't

**Problem:** Mixed working/broken images

**Solutions:**
1. Check filenames match exactly (case-sensitive!)
2. Verify spaces in filenames are handled correctly
3. Check special characters in filenames
4. Ensure all 23 assets uploaded (not just some)

```powershell
# Use the test script above to identify missing assets
.\test-production-cdn.ps1
```

### Issue: Slow Image Loading

**Problem:** Images load but take too long

**Solutions:**
1. Enable CDN caching (check CDN settings)
2. Verify CDN is serving from edge locations (not origin)
3. Compress images if needed (see optimization guide)
4. Check CDN plan/tier supports global distribution

---

## 📊 Migration Checklist

**Pre-Migration:**
- [ ] Production CDN provisioned and accessible
- [ ] All 23 assets uploaded to production CDN
- [ ] Assets tested and loading correctly
- [ ] Backup of current HTML created
- [ ] Team notified of upcoming change

**During Migration:**
- [ ] Run `update-cdn-urls.ps1` script
- [ ] Enter production CDN URL
- [ ] Review replacement summary
- [ ] Verify backup was created

**Post-Migration:**
- [ ] Test HTML in browser (all images load)
- [ ] Send test email to yourself
- [ ] Verify production CDN URLs in Network tab
- [ ] Test on multiple email clients
- [ ] Monitor first production send
- [ ] Document production CDN URL for team
- [ ] Update any documentation referencing GitHub URLs

---

## 🎯 Success Criteria

Migration is successful when:

✅ All 23 images load from production CDN
✅ No GitHub URLs remain in HTML
✅ Test emails render correctly in all clients  
✅ Image load time is fast (< 2 seconds per image)
✅ Production CDN URLs documented for team
✅ Backup of GitHub version saved (just in case)

---

## 📞 Rollback Plan

If migration issues occur, you can quickly rollback:

```powershell
# Restore from backup
$latestBackup = Get-ChildItem "your-exclusive-invitation.html.backup*" | 
                Sort-Object LastWriteTime -Descending | 
                Select-Object -First 1

Copy-Item $latestBackup.FullName "your-exclusive-invitation.html" -Force
Write-Host "✓ Rolled back to: $($latestBackup.Name)"
```

**This restores GitHub URLs** so emails continue working while you fix production CDN issues.

---

## 📝 Example: Complete Migration Flow

### Real-World Example

**Current (GitHub Temporary):**
```html
<img src="https://raw.githubusercontent.com/i2cinc/email-assets/main/assets/Logo.png" ... />
```

**After Migration (Production):**
```html
<img src="https://cdn.i2cinc.com/email-assets/Logo.png" ... />
```

**Command:**
```powershell
PS> .\update-cdn-urls.ps1

Enter your CDN base URL:
CDN Base URL: https://cdn.i2cinc.com/email-assets

Continue? (y/n): y

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Update Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Replaced 23 asset paths
✓ Backup saved as: your-exclusive-invitation.html.backup_20260327_143022
✓ Updated file: your-exclusive-invitation.html

Next steps:
1. Review the updated HTML file
2. Test the email in your email client
3. Verify all images load from CDN
```

---

## 🚀 Timeline Expectations

| Task | Duration |
|------|----------|
| Pre-migration testing | 15 min |
| Running migration script | 1 min |
| Post-migration validation | 10 min |
| Test email send | 5 min |
| **Total** | **~30 min** |

---

## ✅ You're Done!

After successful migration:

1. ✅ **Delete GitHub repository** (optional, to avoid confusion)
2. ✅ **Document production CDN URL** for team
3. ✅ **Update internal documentation**
4. ✅ **Inform stakeholders** migration is complete
5. ✅ **Monitor first production email send**

**Production CDN is now your permanent solution!** 🎉

---

**Questions?** See [CDN-OPTIONS.md](CDN-OPTIONS.md) for production CDN recommendations.
