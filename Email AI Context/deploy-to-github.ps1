# GitHub CDN Deployment Script - Simplified Version
param(
    [string]$RepoUrl,
    [string]$TemplateName,
    [string]$AssetsPath,
    [string]$Branch = "main"
)

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  GitHub CDN Deployment" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Get GitHub token
if ($env:GITHUB_TOKEN) {
    $token = $env:GITHUB_TOKEN
    Write-Host "✓ Using environment variable GITHUB_TOKEN" -ForegroundColor Green
} else {
    Write-Host "Enter your GitHub Personal Access Token:" -ForegroundColor Yellow
    $secureToken = Read-Host -AsSecureString
    $token = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken))
}

Write-Host ""
Write-Host "Repository: $RepoUrl" -ForegroundColor Cyan
Write-Host "Template: $TemplateName" -ForegroundColor Cyan
Write-Host "Assets: $AssetsPath" -ForegroundColor Cyan
Write-Host "Branch: $Branch" -ForegroundColor Cyan
Write-Host ""

# Create folder structure
$target = "$TemplateName/assets"
Write-Host "Creating folder: $target" -ForegroundColor Yellow
New-Item -ItemType Directory -Path $target -Force | Out-Null

# Copy assets
Write-Host "Copying assets..." -ForegroundColor Yellow
Copy-Item "$AssetsPath\*" -Destination $target -Force
$count = (Get-ChildItem $target -File | Where-Object { $_.Name -notlike ".DS_Store" }).Count
Write-Host "✓ Copied $count files" -ForegroundColor Green
Write-Host ""

# Initialize git if needed
if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    git init
}

# Configure remote
$RepoUrl = $RepoUrl.TrimEnd('.git')
git remote remove origin 2>$null
git remote add origin $RepoUrl
Write-Host "✓ Remote configured" -ForegroundColor Green
Write-Host ""

# Stage and commit
Write-Host "Staging files..." -ForegroundColor Yellow
git add $TemplateName/*
$staged = (git diff --cached --name-only | Measure-Object).Count

if ($staged -gt 0) {
    Write-Host "✓ Staged $staged files" -ForegroundColor Green
    git commit -m "Deploy email template: $TemplateName"
    Write-Host "✓ Committed" -ForegroundColor Green
} else {
    Write-Host "ℹ No changes to commit" -ForegroundColor Cyan
}

Write-Host ""

# Push to GitHub
if ($staged -gt 0) {
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    
    if ($RepoUrl -match 'github\.com[:/]([^/]+)/([^/]+)') {
        $owner = $matches[1]
        $repo = $matches[2]
        $authUrl = "https://${token}@github.com/$owner/$repo.git"
        
        git push $authUrl $Branch 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Successfully pushed!" -ForegroundColor Green
            Write-Host ""
            Write-Host "CDN Base URL:" -ForegroundColor White
            Write-Host "https://raw.githubusercontent.com/$owner/$repo/$Branch/$TemplateName/assets/" -ForegroundColor Green
        } else {
            Write-Host "✗ Push failed" -ForegroundColor Red
            Write-Host "Make sure:" -ForegroundColor Yellow
            Write-Host "  1. Repository exists on GitHub" -ForegroundColor Gray
            Write-Host "  2. Token has push permissions" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "ℹ Nothing to push" -ForegroundColor Cyan
}

Write-Host ""
