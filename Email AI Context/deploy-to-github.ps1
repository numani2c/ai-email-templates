# Generic GitHub CDN Deployment Script for Email Assets
# Works for ANY email template
# Automatically creates organized folder structure

param(
    [string]$RepoUrl = "",
    [string]$TemplateName = "",
    [string]$Branch = "main",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  GitHub CDN Deployment - Email Assets" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# GitHub Authentication Token
# NOTE: Token should be set via environment variable for security
# For automation, set $env:GITHUB_TOKEN before running this script
if ($env:GITHUB_TOKEN) {
    $githubToken = $env:GITHUB_TOKEN
} else {
    Write-Host "⚠️  No GITHUB_TOKEN environment variable found" -ForegroundColor Yellow
    Write-Host "Please enter your GitHub Personal Access Token:" -ForegroundColor Yellow
    $githubToken = Read-Host -AsSecureString | 
                   ConvertFrom-SecureString -AsPlainText
}

# Auto-detect template name if not provided
if ([string]::IsNullOrWhiteSpace($TemplateName)) {
    # Try to get from HTML file
    $htmlFile = Get-ChildItem -Path .. -Filter "*.html" -File | 
                Where-Object { $_.Name -notlike "*-production*" -and 
                              $_.Name -notlike "*-cdn*" -and 
                              $_.Name -notlike "*-preview*" } | 
                Select-Object -First 1
    
    if ($htmlFile) {
        $TemplateName = $htmlFile.BaseName
        Write-Host "📧 Auto-detected template: $TemplateName" -ForegroundColor Cyan
    } else {
        # Fallback to parent folder name
        $parentFolder = Split-Path -Parent (Get-Location)
        $TemplateName = Split-Path -Leaf $parentFolder
        Write-Host "📁 Using folder name as template: $TemplateName" -ForegroundColor Cyan
    }
    Write-Host ""
}

# Configuration
if ([string]::IsNullOrWhiteSpace($RepoUrl)) {
    Write-Host "Enter your GitHub repository URL:" -ForegroundColor Yellow
    Write-Host "Example: https://github.com/username/repo-name" -ForegroundColor Gray
    Write-Host ""
    $RepoUrl = Read-Host "Repository URL"
}

# Remove .git suffix if present
$RepoUrl = $RepoUrl.TrimEnd('.git')

$sourceAssetsFolder = "../assets"
$targetFolder = "email-templates/$TemplateName"
$targetAssetsFolder = "$targetFolder/assets"

# Step 1: Check prerequisites
Write-Host "Step 1: Checking prerequisites..." -ForegroundColor Yellow
Write-Host ""

# Check if Git is installed
try {
    $gitVersion = git --version
    Write-Host "  ✓ Git installed: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Git not found!" -ForegroundColor Red
    Write-Host "    Please install Git: https://git-scm.com/downloads" -ForegroundColor Yellow
    exit 1
}

# Check if assets folder exists
if (-not (Test-Path $sourceAssetsFolder)) {
    Write-Host "  ✗ Assets folder not found: $sourceAssetsFolder" -ForegroundColor Red
    Write-Host "    Expected location: ../assets/" -ForegroundColor Yellow
    exit 1
}

# Count assets
$assetFiles = Get-ChildItem -Path $sourceAssetsFolder -File
$assetCount = $assetFiles.Count

if ($assetCount -eq 0) {
    Write-Host "  ✗ No assets found in folder" -ForegroundColor Red
    exit 1
}

Write-Host "  ✓ Found $assetCount asset files" -ForegroundColor Green
Write-Host ""

# Step 2: Create organized folder structure
Write-Host "Step 2: Creating organized folder structure..." -ForegroundColor Yellow
Write-Host ""

# Create target directory structure
if (-not (Test-Path $targetFolder)) {
    New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
    Write-Host "  ✓ Created: $targetFolder" -ForegroundColor Green
}

if (-not (Test-Path $targetAssetsFolder)) {
    New-Item -ItemType Directory -Path $targetAssetsFolder -Force | Out-Null
    Write-Host "  ✓ Created: $targetAssetsFolder" -ForegroundColor Green
} else {
    Write-Host "  ℹ Folder exists: $targetAssetsFolder" -ForegroundColor Cyan
}

# Copy assets to organized structure
Write-Host "  ℹ Copying assets to organized structure..." -ForegroundColor Cyan

$copiedCount = 0
foreach ($file in $assetFiles) {
    $targetPath = Join-Path $targetAssetsFolder $file.Name
    Copy-Item -Path $file.FullName -Destination $targetPath -Force
    $copiedCount++
}

Write-Host "  ✓ Copied $copiedCount files to $targetAssetsFolder" -ForegroundColor Green
Write-Host ""

# Step 3: Initialize or update repository
Write-Host "Step 3: Repository setup..." -ForegroundColor Yellow
Write-Host ""

$repoExists = Test-Path ".git"

if ($repoExists) {
    Write-Host "  ✓ Git repository already initialized" -ForegroundColor Green
    
    # Check remote
    try {
        $remote = git remote get-url origin 2>$null
        if ($remote) {
            Write-Host "  ✓ Remote configured: origin -> $remote" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ℹ No remote configured" -ForegroundColor Cyan
        Write-Host "    Adding remote origin..." -ForegroundColor Cyan
        git remote add origin $RepoUrl
        Write-Host "  ✓ Remote added" -ForegroundColor Green
    }
} else {
    Write-Host "  ℹ Initializing Git repository..." -ForegroundColor Cyan
    git init
    git remote add origin $RepoUrl
    Write-Host "  ✓ Repository initialized" -ForegroundColor Green
}

Write-Host ""

# Step 4: Configure Git credentials with token
Write-Host "Step 4: Configuring authentication..." -ForegroundColor Yellow
Write-Host ""

# Extract repo owner and name from URL
if ($RepoUrl -match 'github\.com[:/]([^/]+)/([^/]+)') {
    $repoOwner = $matches[1]
    $repoName = $matches[2]
    
    # Configure credential helper to use token
    git config credential.helper store
    
    # Create credentials file entry (this will be used for authentication)
    $credUrl = "https://$($githubToken)@github.com"
    
    Write-Host "  ✓ Authentication configured (using stored token)" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Could not parse repository URL" -ForegroundColor Yellow
}

Write-Host ""

# Step 5: Stage assets
Write-Host "Step 5: Staging assets for commit..." -ForegroundColor Yellow
Write-Host ""

git add "$targetFolder/*"

$stagedCount = (git diff --cached --name-only | Measure-Object).Count

if ($stagedCount -eq 0) {
    Write-Host "  ℹ No changes to commit" -ForegroundColor Cyan
    Write-Host "    Assets may already be up to date" -ForegroundColor Gray
} else {
    Write-Host "  ✓ Staged $stagedCount files" -ForegroundColor Green
}

Write-Host ""

# Step 6: Commit changes
Write-Host "Step 6: Creating commit..." -ForegroundColor Yellow
Write-Host ""

$commitMessage = "Deploy email template: $TemplateName - $assetCount assets"

try {
    git commit -m $commitMessage
    Write-Host "  ✓ Commit created successfully" -ForegroundColor Green
} catch {
    if ($stagedCount -eq 0) {
        Write-Host "  ℹ Nothing to commit (assets already uploaded)" -ForegroundColor Cyan
    } else {
        Write-Host "  ✗ Commit failed" -ForegroundColor Red
        Write-Host "    Error: $_" -ForegroundColor Gray
        exit 1
    }
}

Write-Host ""

# Step 7: Push to GitHub
Write-Host "Step 7: Pushing to GitHub..." -ForegroundColor Yellow
Write-Host ""
Write-Host "  ⚠ This will push to: $RepoUrl" -ForegroundColor Yellow
Write-Host "    Branch: $Branch" -ForegroundColor Gray
Write-Host ""

if (-not $Force) {
    $confirm = Read-Host "Continue with push? (Y/n)"
    if ($confirm -eq "n" -or $confirm -eq "N") {
        Write-Host ""
        Write-Host "  ℹ Push cancelled by user" -ForegroundColor Cyan
        Write-Host "    Assets are committed locally but not uploaded yet" -ForegroundColor Gray
        Write-Host "    Run this script again with -Force to skip confirmation" -ForegroundColor Gray
        exit 0
    }
}

Write-Host ""
Write-Host "  ℹ Pushing to GitHub..." -ForegroundColor Cyan

try {
    # Set up authentication URL with token
    $authUrl = $RepoUrl -replace 'https://github.com', "https://$($githubToken)@github.com"
    
    # Try to push with authentication
    git push $authUrl $Branch 2>&1 | ForEach-Object {
        if ($_ -match "error|fatal") {
            Write-Host "    $_" -ForegroundColor Red
        } else {
            Write-Host "    $_" -ForegroundColor Gray
        }
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "  ✓ Successfully pushed to GitHub!" -ForegroundColor Green
    } else {
        throw "Push failed with exit code $LASTEXITCODE"
    }
} catch {
    Write-Host ""
    Write-Host "  ✗ Push failed" -ForegroundColor Red
    Write-Host "    This usually means:" -ForegroundColor Yellow
    Write-Host "      1. Repository doesn't exist yet (create it first)" -ForegroundColor Gray
    Write-Host "      2. You don't have push permissions" -ForegroundColor Gray
    Write-Host "      3. Branch protection rules prevent push" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    See GITHUB-CDN-GUIDE.md for troubleshooting" -ForegroundColor Yellow
    exit 1
}

# Extract owner/repo for CDN URL display
$cdnBase = ""
if ($RepoUrl -match 'github\.com[:/]([^/]+)/([^/]+)') {
    $cdnBase = "https://raw.githubusercontent.com/$($matches[1])/$($matches[2])/$Branch/$targetFolder/assets/"
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  ✓ DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "📦 Template: $TemplateName" -ForegroundColor White
Write-Host "📁 Folder: $targetFolder/" -ForegroundColor White
Write-Host "🖼️  Assets: $assetCount files" -ForegroundColor White
Write-Host ""
Write-Host "Assets are now available via GitHub CDN:" -ForegroundColor White
Write-Host ""
if ($cdnBase) {
    # Show first few asset examples
    $exampleAssets = $assetFiles | Select-Object -First 3
    foreach ($asset in $exampleAssets) {
        Write-Host "  $($cdnBase)$($asset.Name)" -ForegroundColor Cyan
    }
    if ($assetCount -gt 3) {
        Write-Host "  ... ($($assetCount - 3) more images)" -ForegroundColor Gray
    }
}
Write-Host ""
Write-Host "✅ GitHub CDN Base URL:" -ForegroundColor White
Write-Host "  $cdnBase" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Wait 1-2 minutes for GitHub CDN to propagate" -ForegroundColor Gray
Write-Host "  2. Update HTML file with GitHub CDN URLs" -ForegroundColor Gray
Write-Host "  3. Test email template: Open HTML file in browser" -ForegroundColor Gray
Write-Host "  4. Verify all images load correctly" -ForegroundColor Gray
Write-Host "  5. Send test email to verify in email clients" -ForegroundColor Gray
Write-Host ""
Write-Host "Repository: $RepoUrl" -ForegroundColor Cyan
Write-Host "Branch: $Branch" -ForegroundColor Cyan
Write-Host ""
