# ============================================================================
# CDN URL Updater Script (PowerShell)
# ============================================================================
# 
# This script replaces local asset paths in your HTML email template with
# CDN URLs after you've uploaded the assets to your CDN.
#
# Usage:
#   .\update-cdn-urls.ps1
#
# The script will prompt you for:
#   1. CDN base URL (e.g., https://cdn.example.com/email-assets)
#   2. HTML file to update (default: your-exclusive-invitation.html)
#
# ============================================================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  CDN URL Updater for Email Templates" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Get CDN base URL from user
Write-Host "Enter your CDN base URL:" -ForegroundColor Yellow
Write-Host "Example: https://cdn.example.com/email-assets" -ForegroundColor Gray
Write-Host ""
$cdnBaseUrl = Read-Host "CDN Base URL"

# Remove trailing slash if present
$cdnBaseUrl = $cdnBaseUrl.TrimEnd('/')

# Get HTML file path
Write-Host ""
Write-Host "Enter the HTML file to update:" -ForegroundColor Yellow
Write-Host "(Press Enter for default: your-exclusive-invitation.html)" -ForegroundColor Gray
Write-Host ""
$htmlFile = Read-Host "HTML File"

if ([string]::IsNullOrWhiteSpace($htmlFile)) {
    $htmlFile = "your-exclusive-invitation.html"
}

# Check if file exists
if (-Not (Test-Path $htmlFile)) {
    Write-Host ""
    Write-Host "✗ Error: File '$htmlFile' not found!" -ForegroundColor Red
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Configuration" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "CDN Base URL: $cdnBaseUrl" -ForegroundColor Green
Write-Host "HTML File:    $htmlFile" -ForegroundColor Green
Write-Host ""
Write-Host "This will replace all './assets/' paths with CDN URLs." -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Continue? (y/n)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host ""
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

# Create backup
$backupFile = "$htmlFile.backup"
Write-Host ""
Write-Host "Creating backup: $backupFile..." -ForegroundColor Cyan
Copy-Item $htmlFile $backupFile -Force

# Read the HTML content
$htmlContent = Get-Content $htmlFile -Raw

# Replace all local asset paths with CDN URLs
$updatedContent = $htmlContent -replace '\./assets/', "$cdnBaseUrl/"

# Count replacements
$replacementCount = ([regex]::Matches($htmlContent, '\./assets/')).Count

# Write updated content back to file
$updatedContent | Set-Content $htmlFile -NoNewline

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  Update Complete!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "✓ Replaced $replacementCount asset paths" -ForegroundColor Green
Write-Host "✓ Backup saved as: $backupFile" -ForegroundColor Green
Write-Host "✓ Updated file: $htmlFile" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Review the updated HTML file" -ForegroundColor White
Write-Host "2. Test the email in your email client" -ForegroundColor White
Write-Host "3. Verify all images load from CDN" -ForegroundColor White
Write-Host ""

# Ask if user wants to see a sample of changes
Write-Host "Show example of replaced URLs? (y/n)" -ForegroundColor Yellow
$showExample = Read-Host

if ($showExample -eq 'y' -or $showExample -eq 'Y') {
    Write-Host ""
    Write-Host "Example replacements:" -ForegroundColor Cyan
    Write-Host "  Before: ./assets/logo.png" -ForegroundColor Red
    Write-Host "  After:  $cdnBaseUrl/logo.png" -ForegroundColor Green
    Write-Host ""
}

Write-Host "Done!" -ForegroundColor Green
Write-Host ""
