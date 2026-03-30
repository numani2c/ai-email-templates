# ============================================
# Asset Download Script
# ============================================
# Purpose: Download all email assets from Figma CDN
# Template: Flow HCM-ATS System
# Version: 1.0
# ============================================

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  EMAIL ASSET DOWNLOADER" -ForegroundColor Cyan
Write-Host "  Template: Flow HCM-ATS System" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Create assets directory
Write-Host "📁 Creating assets directory..." -ForegroundColor Cyan
$assetsDir = "assets"
if (-not (Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null
    Write-Host "✓ Created: $assetsDir\" -ForegroundColor Green
} else {
    Write-Host "✓ Directory exists: $assetsDir\" -ForegroundColor Green
}
Write-Host ""

# Download function
function Download-Asset {
    param(
        [string]$url,
        [string]$filename,
        [string]$description,
        [string]$dimensions
    )
    
    $output = Join-Path $assetsDir $filename
    
    Write-Host "⏳ Downloading: $description ($dimensions)" -ForegroundColor Cyan
    Write-Host "   URL: $url" -ForegroundColor DarkGray
    Write-Host "   Saving as: $filename" -ForegroundColor DarkGray
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop
        
        # Get file size
        $fileInfo = Get-Item $output
        $fileSizeKB = [math]::Round($fileInfo.Length / 1KB, 2)
        
        Write-Host "   ✓ Downloaded: $fileSizeKB KB" -ForegroundColor Green
        Write-Host ""
        return $true
    } catch {
        Write-Host "   ❌ FAILED: $_" -ForegroundColor Red
        Write-Host ""
        return $false
    }
}

# Asset definitions
$assets = @(
    @{
        Description = "Header Logo"
        Url = "https://www.figma.com/api/mcp/asset/1402048a-41e6-428c-9d85-02abdcc5cf80"
        Filename = "header-logo.png"
        Dimensions = "225×49px"
    },
    @{
        Description = "Footer Logo"
        Url = "https://www.figma.com/api/mcp/asset/07bcb12f-e0e9-415a-be33-39e6a97f3fc6"
        Filename = "footer-logo.png"
        Dimensions = "183×42px"
    },
    @{
        Description = "Social Icons"
        Url = "https://www.figma.com/api/mcp/asset/90bd17da-1298-4c05-8e71-da29d8f107a3"
        Filename = "social-icons.png"
        Dimensions = "81×19px"
    }
)

Write-Host "📦 DOWNLOADING $($assets.Count) ASSETS" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Download all assets
$successCount = 0
$failedAssets = @()

foreach ($asset in $assets) {
    $success = Download-Asset -url $asset.Url -filename $asset.Filename -description $asset.Description -dimensions $asset.Dimensions
    
    if ($success) {
        $successCount++
    } else {
        $failedAssets += $asset.Description
    }
}

# Summary
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

if ($successCount -eq $assets.Count) {
    Write-Host "✅ ALL ASSETS DOWNLOADED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Downloaded $successCount of $($assets.Count) assets to: $assetsDir\" -ForegroundColor Green
} else {
    Write-Host "⚠️  PARTIAL SUCCESS" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Downloaded: $successCount of $($assets.Count)" -ForegroundColor Green
    Write-Host "Failed: $($failedAssets.Count)" -ForegroundColor Red
    
    if ($failedAssets.Count -gt 0) {
        Write-Host ""
        Write-Host "Failed assets:" -ForegroundColor Red
        foreach ($failed in $failedAssets) {
            Write-Host "  • $failed" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Show downloaded files
if ($successCount -gt 0) {
    Write-Host "📂 Downloaded Files:" -ForegroundColor Cyan
    Write-Host ""
    Get-ChildItem $assetsDir | ForEach-Object {
        $sizeKB = [math]::Round($_.Length / 1KB, 2)
        Write-Host "  ✓ $($_.Name) - $sizeKB KB" -ForegroundColor Green
    }
    Write-Host ""
    
    # Calculate total size
    $totalSize = (Get-ChildItem $assetsDir | Measure-Object -Property Length -Sum).Sum
    $totalSizeKB = [math]::Round($totalSize / 1KB, 2)
    
    Write-Host "Total size: $totalSizeKB KB" -ForegroundColor Cyan
    
    if ($totalSizeKB -gt 100) {
        Write-Host "⚠️  WARNING: Total size exceeds 100KB (Gmail image limit)" -ForegroundColor Yellow
        Write-Host "   Consider optimizing images before production deployment" -ForegroundColor Yellow
    } else {
        Write-Host "✓ Total size is under 100KB (Gmail-friendly)" -ForegroundColor Green
    }
    
    Write-Host ""
}

# Next steps
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📋 NEXT STEPS:" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. ✅ Optimize images (optional but recommended):" -ForegroundColor Yellow
Write-Host "   • Use TinyPNG: https://tinypng.com/" -ForegroundColor DarkGray
Write-Host "   • Use Squoosh: https://squoosh.app/" -ForegroundColor DarkGray
Write-Host "   • Target: 80-85% compression" -ForegroundColor DarkGray
Write-Host ""
Write-Host "2. ✅ Upload optimized assets to your CDN" -ForegroundColor Yellow
Write-Host "   • Recommended structure: cdn.com/emails/flow-hcm-ats/" -ForegroundColor DarkGray
Write-Host ""
Write-Host "3. ✅ Run CDN URL replacement script:" -ForegroundColor Yellow
Write-Host "   .\update-cdn-urls.ps1" -ForegroundColor White
Write-Host ""
Write-Host "4. ✅ Test production template in email clients" -ForegroundColor Yellow
Write-Host ""

Write-Host "⏰ REMINDER: Figma CDN URLs expire in 7 days!" -ForegroundColor Yellow
Write-Host "   Keep these downloaded files safe for future use." -ForegroundColor Yellow
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "Done! 🎉" -ForegroundColor Green
Write-Host ""

# Offer to open assets folder
$openFolder = Read-Host "Would you like to open the assets folder? (Y/n)"
if ($openFolder -ne "n" -and $openFolder -ne "N") {
    Invoke-Item $assetsDir
    Write-Host "✓ Opened assets folder" -ForegroundColor Green
    Write-Host ""
}