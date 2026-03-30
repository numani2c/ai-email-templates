# ============================================
# CDN URL Replacement Script
# ============================================
# Purpose: Replace temporary Figma CDN URLs with permanent CDN URLs
# Template: Flow HCM-ATS System
# Version: 1.0
# ============================================

param(
    [Parameter(Mandatory=$false)]
    [string]$HtmlFile = "flow-hcm-ats-system-preview.html",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "flow-hcm-ats-system.html",
    
    [Parameter(Mandatory=$false)]
    [string]$CdnBaseUrl = ""
)

# Colors for output
$ColorInfo = "Cyan"
$ColorSuccess = "Green"
$ColorWarning = "Yellow"
$ColorError = "Red"

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
Write-Host "  CDN URL REPLACEMENT SCRIPT" -ForegroundColor $ColorInfo
Write-Host "  Template: Flow HCM-ATS System" -ForegroundColor $ColorInfo
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
Write-Host ""

# Check if HTML file exists
if (-not (Test-Path $HtmlFile)) {
    Write-Host "❌ ERROR: File not found: $HtmlFile" -ForegroundColor $ColorError
    Write-Host ""
    Write-Host "Available HTML files in current directory:" -ForegroundColor $ColorWarning
    Get-ChildItem -Filter "*.html" | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor $ColorWarning }
    Write-Host ""
    exit 1
}

Write-Host "✓ Found template file: $HtmlFile" -ForegroundColor $ColorSuccess
Write-Host ""

# Get CDN Base URL if not provided
if ([string]::IsNullOrWhiteSpace($CdnBaseUrl)) {
    Write-Host "📦 CDN CONFIGURATION" -ForegroundColor $ColorInfo
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
    Write-Host ""
    Write-Host "Enter your CDN base URL (without trailing slash)" -ForegroundColor $ColorInfo
    Write-Host "Example: https://cdn.mycompany.com/emails/flow-hcm-ats" -ForegroundColor $ColorWarning
    Write-Host ""
    $CdnBaseUrl = Read-Host "CDN Base URL"
    Write-Host ""
}

# Validate CDN URL
if ([string]::IsNullOrWhiteSpace($CdnBaseUrl)) {
    Write-Host "❌ ERROR: CDN Base URL is required" -ForegroundColor $ColorError
    exit 1
}

# Remove trailing slash if present
$CdnBaseUrl = $CdnBaseUrl.TrimEnd('/')

Write-Host "Using CDN Base URL: $CdnBaseUrl" -ForegroundColor $ColorSuccess
Write-Host ""

# Define asset mappings
$assetMappings = @(
    @{
        Description = "Header Logo"
        FigmaUrl = "https://www.figma.com/api/mcp/asset/1402048a-41e6-428c-9d85-02abdcc5cf80"
        Filename = "header-logo.png"
        Dimensions = "225×49px"
    },
    @{
        Description = "Footer Logo"
        FigmaUrl = "https://www.figma.com/api/mcp/asset/07bcb12f-e0e9-415a-be33-39e6a97f3fc6"
        Filename = "footer-logo.png"
        Dimensions = "183×42px"
    },
    @{
        Description = "Social Icons"
        FigmaUrl = "https://www.figma.com/api/mcp/asset/90bd17da-1298-4c05-8e71-da29d8f107a3"
        Filename = "social-icons.png"
        Dimensions = "81×19px"
    }
)

Write-Host "📋 ASSET MAPPING SUMMARY" -ForegroundColor $ColorInfo
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
Write-Host ""

foreach ($asset in $assetMappings) {
    Write-Host "  $($asset.Description) ($($asset.Dimensions))" -ForegroundColor $ColorInfo
    Write-Host "    → $CdnBaseUrl/$($asset.Filename)" -ForegroundColor $ColorWarning
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
Write-Host ""

# Confirm before proceeding
$confirm = Read-Host "Proceed with URL replacement? (Y/n)"
if ($confirm -eq "n" -or $confirm -eq "N") {
    Write-Host "❌ Cancelled by user" -ForegroundColor $ColorWarning
    exit 0
}

Write-Host ""
Write-Host "🔄 PROCESSING..." -ForegroundColor $ColorInfo
Write-Host ""

# Read HTML content
try {
    $content = Get-Content $HtmlFile -Raw -Encoding UTF8
    Write-Host "✓ Loaded HTML file ($([math]::Round(($content.Length / 1024), 2)) KB)" -ForegroundColor $ColorSuccess
} catch {
    Write-Host "❌ ERROR: Failed to read file: $_" -ForegroundColor $ColorError
    exit 1
}

# Perform replacements
$replacementCount = 0
$replacementLog = @()

foreach ($asset in $assetMappings) {
    $figmaUrl = [regex]::Escape($asset.FigmaUrl)
    $cdnUrl = "$CdnBaseUrl/$($asset.Filename)"
    
    # Count occurrences
    $matches = [regex]::Matches($content, $figmaUrl)
    $count = $matches.Count
    
    if ($count -gt 0) {
        # Perform replacement
        $content = $content -replace $figmaUrl, $cdnUrl
        $replacementCount += $count
        
        $logEntry = @{
            Asset = $asset.Description
            Count = $count
            OldUrl = $asset.FigmaUrl
            NewUrl = $cdnUrl
        }
        $replacementLog += $logEntry
        
        Write-Host "  ✓ Replaced $count occurrence(s) of $($asset.Description)" -ForegroundColor $ColorSuccess
    } else {
        Write-Host "  ⚠ No occurrences found for $($asset.Description)" -ForegroundColor $ColorWarning
    }
}

Write-Host ""

# Update title (remove [PREVIEW] suffix)
if ($content -match '<title>(.*?)\[PREVIEW\](.*?)</title>') {
    $content = $content -replace '<title>(.*?)\[PREVIEW\](.*?)</title>', '<title>$1$2</title>'
    Write-Host "✓ Removed [PREVIEW] suffix from title" -ForegroundColor $ColorSuccess
}

# Remove warning banner
$warningBannerPattern = '(?s)<!-- Warning Banner \(Preview Version\) -->.*?</tr>'
if ($content -match $warningBannerPattern) {
    $content = $content -replace $warningBannerPattern, ''
    Write-Host "✓ Removed preview warning banner" -ForegroundColor $ColorSuccess
}

Write-Host ""

# Save output file
try {
    Set-Content -Path $OutputFile -Value $content -Encoding UTF8 -NoNewline
    Write-Host "✓ Saved production template: $OutputFile" -ForegroundColor $ColorSuccess
} catch {
    Write-Host "❌ ERROR: Failed to save file: $_" -ForegroundColor $ColorError
    exit 1
}

# Output summary
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
Write-Host "  ✓ CONVERSION COMPLETE!" -ForegroundColor $ColorSuccess
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
Write-Host ""
Write-Host "Summary:" -ForegroundColor $ColorInfo
Write-Host "  • Total replacements: $replacementCount" -ForegroundColor $ColorSuccess
Write-Host "  • Input file: $HtmlFile" -ForegroundColor $ColorInfo
Write-Host "  • Output file: $OutputFile" -ForegroundColor $ColorSuccess
Write-Host "  • CDN base URL: $CdnBaseUrl" -ForegroundColor $ColorInfo
Write-Host ""

# Detailed replacement log
Write-Host "Replacement Details:" -ForegroundColor $ColorInfo
foreach ($entry in $replacementLog) {
    Write-Host "  • $($entry.Asset): $($entry.Count) replacement(s)" -ForegroundColor $ColorWarning
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
Write-Host ""

# Next steps
Write-Host "📋 NEXT STEPS:" -ForegroundColor $ColorInfo
Write-Host ""
Write-Host "1. ✅ Open $OutputFile in a browser to verify images load" -ForegroundColor $ColorWarning
Write-Host "2. ✅ Test in email clients (Gmail, Outlook, Apple Mail)" -ForegroundColor $ColorWarning
Write-Host "3. ✅ Deploy to your ESP (Mailchimp, SendGrid, etc.)" -ForegroundColor $ColorWarning
Write-Host ""
Write-Host "⚠️  IMPORTANT REMINDERS:" -ForegroundColor $ColorWarning
Write-Host ""
Write-Host "  • Verify all CDN assets are uploaded and accessible" -ForegroundColor $ColorWarning
Write-Host "  • Test CDN URLs in browser before deploying email" -ForegroundColor $ColorWarning
Write-Host "  • Keep original preview file as backup: $HtmlFile" -ForegroundColor $ColorWarning
Write-Host ""

# Asset checklist
Write-Host "✅ CDN Asset Checklist:" -ForegroundColor $ColorInfo
foreach ($asset in $assetMappings) {
    Write-Host "  [ ] $CdnBaseUrl/$($asset.Filename)" -ForegroundColor $ColorWarning
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $ColorInfo
Write-Host ""

# Offer to open output file
$openFile = Read-Host "Would you like to open the output file now? (Y/n)"
if ($openFile -ne "n" -and $openFile -ne "N") {
    Start-Process $OutputFile
    Write-Host "✓ Opened $OutputFile in default browser" -ForegroundColor $ColorSuccess
    Write-Host ""
}

Write-Host "Done! 🎉" -ForegroundColor $ColorSuccess
Write-Host ""