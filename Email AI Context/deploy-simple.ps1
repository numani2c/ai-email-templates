param([string]$RepoUrl, [string]$TemplateName = "your-exclusive-invitation", [string]$Branch = "main")

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  GitHub CDN Deployment" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

# Get token from environment variable or prompt
if ($env:GITHUB_TOKEN) {
    $token = $env:GITHUB_TOKEN
} else {
    Write-Host "`n⚠️  GITHUB_TOKEN not set" -ForegroundColor Yellow
    $token = Read-Host "Enter GitHub Personal Access Token" -AsSecureString | 
             ConvertFrom-SecureString -AsPlainText
}
$sourceFolder = "../assets"
$targetFolder = "email-templates/$TemplateName"

Write-Host "`n?? Template: $TemplateName"
Write-Host "?? Creating: $targetFolder/assets/"

# Create folder structure
New-Item -ItemType Directory -Path "$targetFolder/assets" -Force | Out-Null

# Copy assets
Copy-Item "$sourceFolder/*" "$targetFolder/assets/" -Force -Recurse
$count = (Get-ChildItem "$targetFolder/assets").Count
Write-Host "? Copied $count assets"

# Git operations
if (!(Test-Path ".git")) { git init }
git remote remove origin 2>$null
git remote add origin $RepoUrl
git add "$targetFolder/*"
git commit -m "Deploy: $TemplateName"

$authUrl = $RepoUrl -replace 'https://github.com', "https://$token@github.com"
git push $authUrl $Branch --force

Write-Host "`n? Deployed to: $RepoUrl" -ForegroundColor Green
Write-Host "CDN URL: https://raw.githubusercontent.com/numani2c/ai-email-templates/$Branch/$targetFolder/assets/" -ForegroundColor Cyan
