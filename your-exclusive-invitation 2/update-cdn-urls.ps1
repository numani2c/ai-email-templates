# CDN URL Update Script - Your Exclusive Invitation 2
# Replaces GitHub temporary CDN URLs with permanent CDN URLs

param(
    [string]$HtmlFile = "your-exclusive-invitation-2.html",
    [string]$CdnBaseUrl = ""
)

$ErrorActionPreference = "Stop"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  CDN URL Updater - Your Exclusive Invitation 2" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Validate HTML file exists
if (-not (Test-Path $HtmlFile)) {
    Write-Host "✗ HTML file not found: $HtmlFile" -ForegroundColor Red
    Write-Host "  Please run this script from the template folder" -ForegroundColor Yellow
    exit 1
}

# Prompt for CDN base URL if not provided
if ([string]::IsNullOrWhiteSpace($CdnBaseUrl)) {
    Write-Host "Enter your CDN base URL (without trailing slash):" -ForegroundColor Yellow
    Write-Host "Example: https://cdn.example.com/emails/your-exclusive-invitation-2" -ForegroundColor Gray
    Write-Host ""
    $CdnBaseUrl = Read-Host "CDN Base URL"
    
    if ([string]::IsNullOrWhiteSpace($CdnBaseUrl)) {
        Write-Host "✗ CDN base URL is required" -ForegroundColor Red
        exit 1
    }
}

# Remove trailing slash if present
$CdnBaseUrl = $CdnBaseUrl.TrimEnd('/')

Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  HTML File: $HtmlFile" -ForegroundColor White
Write-Host "  CDN Base URL: $CdnBaseUrl" -ForegroundColor White
Write-Host ""

# Current GitHub CDN URLs to replace
$githubCdnBase = "https://raw.githubusercontent.com/numani2c/ai-email-templates/main/your-exclusive-invitation-2/assets/"

# Asset list (23 total images)
$assets = @(
    "Accelerate%20Event%20Summit%20Logo.png",
    "Heading.png",
    "Banner.gif",
    "Date.png",
    "Location%20icon.png",
    "link%20arrow%20icon.png",
    "Invite%201.png",
    "Invite%202.png",
    "Invite%203.png",
    "Video.gif",
    "Image%201.png",
    "Image%202.png",
    "center.png",
    "Image%204.png",
    "Image%205.png",
    "Feature%204.png",
    "Feature%205.png",
    "Feature%206.png",
    "Sign.png",
    "i2c%20logo.png",
    "Linkedin.png",
    "X.png",
    "Instagram.png",
    "Facebook.png"
)

Write-Host "Step 1: Reading HTML file..." -ForegroundColor Yellow
$content = Get-Content $HtmlFile -Raw
Write-Host "  ✓ File read successfully ($($content.Length) characters)" -ForegroundColor Green
Write-Host ""

Write-Host "Step 2: Replacing GitHub CDN URLs with permanent CDN URLs..." -ForegroundColor Yellow
Write-Host ""

$replacements = 0

foreach ($asset in $assets) {
    $oldUrl = "$githubCdnBase$asset"
    # Convert URL-encoded filename to actual filename for CDN
    $decodedFilename = [System.Web.HttpUtility]::UrlDecode($asset)
    $newUrl = "$CdnBaseUrl/$decodedFilename"
    
    if ($content -match [regex]::Escape($oldUrl)) {
        $content = $content -replace [regex]::Escape($oldUrl), $newUrl
        Write-Host "  ✓ Replaced: $decodedFilename" -ForegroundColor Green
        $replacements++
    } else {
        Write-Host "  ⚠ Not found: $decodedFilename" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Step 3: Saving updated HTML file..." -ForegroundColor Yellow

# Create backup
$backupFile = $HtmlFile -replace '\.html$', '-github-cdn-backup.html'
Copy-Item $HtmlFile $backupFile
Write-Host "  ✓ Backup created: $backupFile" -ForegroundColor Green

# Save updated content
Set-Content $HtmlFile -Value $content -NoNewline
Write-Host "  ✓ Updated HTML saved: $HtmlFile" -ForegroundColor Green
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  ✓ URL REPLACEMENT COMPLETE!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor White
Write-Host "  Replaced: $replacements GitHub CDN URLs" -ForegroundColor Green
Write-Host "  With: Permanent CDN URLs" -ForegroundColor Green
Write-Host "  Backup: $backupFile" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor White
Write-Host "  1. ✅ Upload all assets from ./assets/ folder to your CDN" -ForegroundColor Gray
Write-Host "  2. ✅ Test HTML file: Open in browser to verify all images load" -ForegroundColor Gray
Write-Host "  3. ✅ Send test email to verify in email clients" -ForegroundColor Gray
Write-Host "  4. ✅ Deploy to production: Upload HTML to your ESP" -ForegroundColor Gray
Write-Host ""
Write-Host "Asset Upload Checklist:" -ForegroundColor White
Write-Host "  - Ensure all 23 assets are uploaded to: $CdnBaseUrl/" -ForegroundColor Gray
Write-Host "  - Verify CDN URLs are publicly accessible (no authentication required)" -ForegroundColor Gray
Write-Host "  - Test each image URL in a browser to confirm loading" -ForegroundColor Gray
Write-Host ""

# Validate URLs (optional check)
Write-Host "Would you like to validate that all CDN URLs are accessible? (Y/n)" -ForegroundColor Yellow
$validate = Read-Host

if ($validate -ne "n" -and $validate -ne "N") {
    Write-Host ""
    Write-Host "Validating CDN URLs..." -ForegroundColor Yellow
    Write-Host ""
    
    $successCount = 0
    $failCount = 0
    
    foreach ($asset in $assets) {
        $decodedFilename = [System.Web.HttpUtility]::UrlDecode($asset)
        $testUrl = "$CdnBaseUrl/$decodedFilename"
        
        try {
            $response = Invoke-WebRequest -Uri $testUrl -Method Head -TimeoutSec 5 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Host "  ✓ $decodedFilename" -ForegroundColor Green
                $successCount++
            }
        } catch {
            Write-Host "  ✗ $decodedFilename - Not accessible" -ForegroundColor Red
            $failCount++
        }
    }
    
    Write-Host ""
    if ($failCount -eq 0) {
        Write-Host "✓ All $successCount assets are accessible!" -ForegroundColor Green
    } else {
        Write-Host "⚠ $failCount assets are not accessible" -ForegroundColor Yellow
        Write-Host "  Please upload missing assets to your CDN" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Update complete! 🎉" -ForegroundColor Green
Write-Host ""
