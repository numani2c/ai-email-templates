# ==========================================
# Email Asset CDN URL Updater
# ==========================================
# Purpose: Replace GitHub temporary CDN URLs with permanent CDN URLs
# Template: Your Exclusive Invitation - Accelerate Summit
# Brand: i2c Inc.
# ==========================================

param(
    [Parameter(Mandatory=$false)]
    [string]$NewCDNBase = "",
    
    [Parameter(Mandatory=$false)]
    [string]$HtmlFile = "your-exclusive-invitation.html",
    
    [Parameter(Mandatory=$false)]
    [switch]$WhatIf
)

# ==========================================
# Configuration
# ==========================================

$currentCDNBase = "https://raw.githubusercontent.com/numani2c/ai-email-templates/main/your-exclusive-invitation/assets/"

$assetMappings = @(
    @{ Filename = "Accelerate Event Summit Logo.png"; Description = "Header Logo" },
    @{ Filename = "Heading.png"; Description = "Heading Image" },
    @{ Filename = "Date.png"; Description = "Date Icon" },
    @{ Filename = "Location icon.png"; Description = "Location Icon" },
    @{ Filename = "Banner.gif"; Description = "Hero Banner" },
    @{ Filename = "Invite 1.png"; Description = "Invitation Card 1" },
    @{ Filename = "Invite 2.png"; Description = "Invitation Card 2" },
    @{ Filename = "Invite 3.png"; Description = "Invitation Card 3" },
    @{ Filename = "Video.gif"; Description = "Video Thumbnail" },
    @{ Filename = "Image 1.png"; Description = "Gallery Image 1" },
    @{ Filename = "Image 2.png"; Description = "Gallery Image 2" },
    @{ Filename = "center.png"; Description = "Gallery Center" },
    @{ Filename = "Image 4.png"; Description = "Gallery Image 4" },
    @{ Filename = "Image 5.png"; Description = "Gallery Image 5" },
    @{ Filename = "Polygon.svg"; Description = "Bullet Icon" },
    @{ Filename = "Feature 4.png"; Description = "Feature Award 1" },
    @{ Filename = "Feature 5.png"; Description = "Feature Award 2" },
    @{ Filename = "Feature 6.png"; Description = "Feature Award 3" },
    @{ Filename = "Sign.png"; Description = "Signature" },
    @{ Filename = "i2c logo.png"; Description = "Footer Logo" },
    @{ Filename = "Linkedin.png"; Description = "LinkedIn Icon" },
    @{ Filename = "X.png"; Description = "X (Twitter) Icon" },
    @{ Filename = "Instagram.png"; Description = "Instagram Icon" },
    @{ Filename = "Facebook.png"; Description = "Facebook Icon" },
    @{ Filename = "link arrow icon.png"; Description = "Link Arrow Icon" }
)

# ==========================================
# Functions
# ==========================================

function Show-Banner {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  EMAIL ASSET CDN URL UPDATER" -ForegroundColor Cyan
    Write-Host "  Your Exclusive Invitation - Accelerate Summit" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
}

function Get-CDNBaseURL {
    if ($NewCDNBase) {
        return $NewCDNBase
    }
    
    Write-Host "Enter your permanent CDN base URL:" -ForegroundColor Yellow
    Write-Host "Examples:" -ForegroundColor Gray
    Write-Host "  https://cdn.yourcompany.com/emails/accelerate-summit" -ForegroundColor Gray
    Write-Host "  https://assets.yourcompany.com/email-templates/2026/accelerate" -ForegroundColor Gray
    Write-Host ""
    
    $url = Read-Host "CDN Base URL"
    
    # Remove trailing slash if present
    $url = $url.TrimEnd('/')
    
    return $url
}

function Test-HTMLFileExists {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-Host ""
        Write-Host "❌ ERROR: HTML file not found: $FilePath" -ForegroundColor Red
        Write-Host ""
        exit 1
    }
}

function Update-AssetURLs {
    param(
        [string]$FilePath,
        [string]$OldBase,
        [string]$NewBase,
        [array]$Assets,
        [bool]$DryRun
    )
    
    Write-Host "📄 Reading HTML file: $FilePath" -ForegroundColor White
    $content = Get-Content $FilePath -Raw
    
    $updatedCount = 0
    $notFoundCount = 0
    
    Write-Host ""
    Write-Host "🔄 Processing asset URLs..." -ForegroundColor White
    Write-Host ""
    
    foreach ($asset in $Assets) {
        $filename = $asset.Filename
        $description = $asset.Description
        
        $oldURL = $OldBase + $filename
        $newURL = $NewBase + "/" + $filename
        
        if ($content -match [regex]::Escape($oldURL)) {
            if ($DryRun) {
                Write-Host "  [DRY RUN] Would update: $description" -ForegroundColor Yellow
            } else {
                $content = $content -replace [regex]::Escape($oldURL), $newURL
                Write-Host "  ✓ Updated: $description" -ForegroundColor Green
            }
            $updatedCount++
        } else {
            Write-Host "  ⚠ Not found: $description ($filename)" -ForegroundColor DarkGray
            $notFoundCount++
        }
    }
    
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  SUMMARY" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Assets updated:     $updatedCount" -ForegroundColor Green
    Write-Host "  Assets not found:   $notFoundCount" -ForegroundColor Yellow
    Write-Host "  Total assets:       $($Assets.Count)" -ForegroundColor White
    Write-Host ""
    
    if (-not $DryRun) {
        Write-Host "💾 Saving updated HTML..." -ForegroundColor White
        Set-Content -Path $FilePath -Value $content -NoNewline
        Write-Host ""
        Write-Host "✅ SUCCESS: HTML file updated successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📍 Updated file: $FilePath" -ForegroundColor White
    } else {
        Write-Host "ℹ️  This was a dry run. No files were modified." -ForegroundColor Yellow
        Write-Host "   Run without -WhatIf to apply changes." -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
}

function Show-NextSteps {
    param([string]$CDNBase)
    
    Write-Host "📋 NEXT STEPS:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Upload all assets to your CDN:" -ForegroundColor White
    Write-Host "   From: ./assets/" -ForegroundColor Gray
    Write-Host "   To:   $CDNBase/" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Verify all asset URLs are accessible:" -ForegroundColor White
    Write-Host "   Test: $CDNBase/i2c logo.png" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Test the updated email in browsers and email clients" -ForegroundColor White
    Write-Host ""
    Write-Host "4. Deploy to your Email Service Provider" -ForegroundColor White
    Write-Host ""
}

# ==========================================
# Main Execution
# ==========================================

Show-Banner

# Validate HTML file exists
Test-HTMLFileExists -FilePath $HtmlFile

# Get new CDN base URL
$newCDN = Get-CDNBaseURL

# Confirm settings
Write-Host ""
Write-Host "⚙️  CONFIGURATION:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  HTML File:      $HtmlFile" -ForegroundColor White
Write-Host "  Current CDN:    $currentCDNBase" -ForegroundColor Yellow
Write-Host "  New CDN:        $newCDN/" -ForegroundColor Green
Write-Host "  Total Assets:   $($assetMappings.Count)" -ForegroundColor White
Write-Host ""

if ($WhatIf) {
    Write-Host "  Mode:           DRY RUN (no changes will be made)" -ForegroundColor Yellow
} else {
    Write-Host "  Mode:           LIVE UPDATE" -ForegroundColor Green
}

Write-Host ""

# Confirm before proceeding (skip if -WhatIf)
if (-not $WhatIf) {
    $confirm = Read-Host "Proceed with URL replacement? (Y/N)"
    if ($confirm -ne "Y" -and $confirm -ne "y") {
        Write-Host ""
        Write-Host "❌ Operation cancelled by user." -ForegroundColor Yellow
        Write-Host ""
        exit 0
    }
}

Write-Host ""

# Update asset URLs
Update-AssetURLs `
    -FilePath $HtmlFile `
    -OldBase $currentCDNBase `
    -NewBase $newCDN `
    -Assets $assetMappings `
    -DryRun:$WhatIf

# Show next steps
if (-not $WhatIf) {
    Show-NextSteps -CDNBase $newCDN
}
