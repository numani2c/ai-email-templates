#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Update email template to use GitHub CDN URLs
.DESCRIPTION
    This script replaces current asset URLs with GitHub raw URLs
.PARAMETER GitHubUsername
    Your GitHub username
.PARAMETER RepoName
    Repository name (default: email-assets)
.PARAMETER HtmlFile
    HTML file to update (default: your-exclusive-invitation.html)
.EXAMPLE
    .\update-to-github-cdn.ps1 -GitHubUsername "john-doe"
.EXAMPLE
    .\update-to-github-cdn.ps1 -GitHubUsername "john-doe" -RepoName "my-assets"
#>

param(
    [Parameter(Mandatory=$true, HelpMessage="Enter your GitHub username")]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "email-assets",
    
    [Parameter(Mandatory=$false)]
    [string]$HtmlFile = "your-exclusive-invitation.html",
    
    [Parameter(Mandatory=$false)]
    [string]$Branch = "main"
)

# Colors
$cyan = "Cyan"
$green = "Green"
$yellow = "Yellow"
$red = "Red"
$white = "White"

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $cyan
Write-Host "  GitHub CDN URL Updater (TEMPORARY)" -ForegroundColor $cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $cyan
Write-Host ""
Write-Host "⚠️  NOTE: GitHub CDN is a TEMPORARY solution" -ForegroundColor $yellow
Write-Host "    Use this for immediate deployment while production CDN is being set up." -ForegroundColor $yellow
Write-Host "    Plan to migrate to production CDN when available." -ForegroundColor $yellow
Write-Host ""

# Construct GitHub raw URL
$cdnBaseUrl = "https://raw.githubusercontent.com/$GitHubUsername/$RepoName/$Branch/assets"

Write-Host "Configuration:" -ForegroundColor $yellow
Write-Host "  GitHub User:  $GitHubUsername" -ForegroundColor $white
Write-Host "  Repository:   $RepoName" -ForegroundColor $white
Write-Host "  Branch:       $Branch" -ForegroundColor $white
Write-Host "  HTML File:    $HtmlFile" -ForegroundColor $white
Write-Host ""
Write-Host "  CDN Base URL: $cdnBaseUrl" -ForegroundColor $green
Write-Host ""

# Check if HTML file exists
if (-not (Test-Path $HtmlFile)) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $red
    Write-Host "  ❌ ERROR: File not found" -ForegroundColor $red
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $red
    Write-Host ""
    Write-Host "File '$HtmlFile' does not exist in current directory." -ForegroundColor $red
    Write-Host "Current directory: $(Get-Location)" -ForegroundColor $yellow
    Write-Host ""
    exit 1
}

# Confirm with user
Write-Host "This will replace all asset URLs in the HTML file." -ForegroundColor $yellow
Write-Host "A backup will be created automatically." -ForegroundColor $yellow
Write-Host ""
$confirm = Read-Host "Continue? (y/n)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host ""
    Write-Host "Operation cancelled." -ForegroundColor $yellow
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $cyan
Write-Host "  Processing" -ForegroundColor $cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $cyan
Write-Host ""

# Create backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "$HtmlFile.backup_$timestamp"
Write-Host "📦 Creating backup..." -ForegroundColor $cyan
Copy-Item $HtmlFile $backupFile -Force
Write-Host "   ✓ Backup saved: $backupFile" -ForegroundColor $green
Write-Host ""

# Read HTML content
Write-Host "📖 Reading HTML file..." -ForegroundColor $cyan
$content = Get-Content $HtmlFile -Raw
$originalLength = $content.Length
Write-Host "   ✓ File size: $([math]::Round($originalLength/1KB, 2)) KB" -ForegroundColor $green
Write-Host ""

# Define patterns to replace
$patterns = @(
    @{
        Name = "Staging CDN"
        Pattern = "https://staging.i2cinc.org/ai-templates/assets"
    },
    @{
        Name = "Local Assets"
        Pattern = "./assets"
    },
    @{
        Name = "Figma CDN"
        Pattern = "https://www.figma.com/api/mcp/asset"
    }
)

# Track replacements
$totalReplacements = 0
$replacementDetails = @()

Write-Host "🔄 Replacing URLs..." -ForegroundColor $cyan

foreach ($patternInfo in $patterns) {
    $pattern = $patternInfo.Pattern
    $name = $patternInfo.Name
    
    # Count occurrences (handle special regex characters)
    $escapedPattern = [regex]::Escape($pattern)
    $matches = ([regex]::Matches($content, $escapedPattern)).Count
    
    if ($matches -gt 0) {
        # For Figma CDN, we need special handling (keep the UUID part)
        if ($pattern -eq "https://www.figma.com/api/mcp/asset") {
            Write-Host "   ⚠ Found $matches Figma CDN URLs" -ForegroundColor $yellow
            Write-Host "     (Skipping - requires manual asset mapping)" -ForegroundColor $yellow
        } else {
            # Standard replacement
            $content = $content -replace [regex]::Escape($pattern), $cdnBaseUrl
            $totalReplacements += $matches
            $replacementDetails += @{ Pattern = $name; Count = $matches }
            Write-Host "   ✓ Replaced $matches instance(s) of $name" -ForegroundColor $green
        }
    }
}

Write-Host ""

if ($totalReplacements -eq 0) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $yellow
    Write-Host "  ⚠ WARNING: No URLs to replace" -ForegroundColor $yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $yellow
    Write-Host ""
    Write-Host "The HTML file may already be using different URLs." -ForegroundColor $yellow
    Write-Host "Current patterns searched:" -ForegroundColor $white
    foreach ($p in $patterns) {
        Write-Host "  - $($p.Pattern)" -ForegroundColor $white
    }
    Write-Host ""
    Write-Host "Would you like to see a sample of current URLs? (y/n)" -ForegroundColor $yellow
    $showSample = Read-Host
    
    if ($showSample -eq 'y') {
        Write-Host ""
        $imageMatches = [regex]::Matches($content, 'src="([^"]+)"')
        if ($imageMatches.Count -gt 0) {
            Write-Host "Sample image URLs found (first 5):" -ForegroundColor $cyan
            for ($i = 0; $i -lt [Math]::Min(5, $imageMatches.Count); $i++) {
                Write-Host "  $($i+1). $($imageMatches[$i].Groups[1].Value)" -ForegroundColor $white
            }
        }
    }
    Write-Host ""
    exit 0
}

# Write updated content
Write-Host "💾 Saving updated HTML..." -ForegroundColor $cyan
Set-Content $HtmlFile -Value $content -NoNewline
$newLength = $content.Length
Write-Host "   ✓ File saved: $([math]::Round($newLength/1KB, 2)) KB" -ForegroundColor $green
Write-Host ""

# Success summary
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $green
Write-Host "  ✅ Update Complete!" -ForegroundColor $green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $green
Write-Host ""

Write-Host "Summary:" -ForegroundColor $yellow
Write-Host "  Total replacements: $totalReplacements" -ForegroundColor $green
foreach ($detail in $replacementDetails) {
    Write-Host "    - $($detail.Pattern): $($detail.Count)" -ForegroundColor $white
}
Write-Host "  New CDN:            $cdnBaseUrl" -ForegroundColor $green
Write-Host "  Backup file:        $backupFile" -ForegroundColor $white
Write-Host ""

Write-Host "⚠️  IMPORTANT: GitHub CDN is TEMPORARY" -ForegroundColor $yellow
Write-Host "   This is an interim solution for immediate deployment." -ForegroundColor $yellow
Write-Host "   Migrate to production CDN when available using:" -ForegroundColor $yellow
Write-Host "   .\update-cdn-urls.ps1 or node update-cdn-urls.js" -ForegroundColor $cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor $yellow
Write-Host "  1. Verify assets are uploaded to GitHub repository:" -ForegroundColor $white
Write-Host "     https://github.com/$GitHubUsername/$RepoName" -ForegroundColor $cyan
Write-Host ""
Write-Host "  2. Test the HTML file in your browser:" -ForegroundColor $white
Write-Host "     Open: $HtmlFile" -ForegroundColor $cyan
Write-Host ""
Write-Host "  3. Check that all images load correctly" -ForegroundColor $white
Write-Host ""
Write-Host "  4. Send a test email to yourself" -ForegroundColor $white
Write-Host ""
Write-Host "  5. Plan production CDN migration (see CDN-OPTIONS.md)" -ForegroundColor $yellow
Write-Host ""

# Offer to open file
Write-Host "Would you like to open the HTML file now? (y/n)" -ForegroundColor $yellow
$openFile = Read-Host

if ($openFile -eq 'y' -or $openFile -eq 'Y') {
    Write-Host ""
    Write-Host "Opening $HtmlFile..." -ForegroundColor $cyan
    Start-Process $HtmlFile
}

Write-Host ""
Write-Host "Done! 🚀" -ForegroundColor $green
Write-Host ""
