#!/usr/bin/env node

/**
 * ============================================================================
 * CDN URL Updater Script (Node.js)
 * ============================================================================
 * 
 * This script replaces local asset paths in your HTML email template with
 * CDN URLs after you've uploaded the assets to your CDN.
 *
 * Usage:
 *   node update-cdn-urls.js
 *   
 * Or make it executable and run directly:
 *   chmod +x update-cdn-urls.js
 *   ./update-cdn-urls.js
 *
 * The script will prompt you for:
 *   1. CDN base URL (e.g., https://cdn.example.com/email-assets)
 *   2. HTML file to update (default: your-exclusive-invitation.html)
 *
 * ============================================================================
 */

const fs = require('fs');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  cyan: '\x1b[36m',
  yellow: '\x1b[33m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  gray: '\x1b[90m',
  white: '\x1b[37m'
};

function colorize(text, color) {
  return `${colors[color]}${text}${colors.reset}`;
}

function question(prompt) {
  return new Promise((resolve) => {
    rl.question(prompt, resolve);
  });
}

async function main() {
  console.log('');
  console.log(colorize('============================================', 'cyan'));
  console.log(colorize('  CDN URL Updater for Email Templates', 'cyan'));
  console.log(colorize('============================================', 'cyan'));
  console.log('');

  // Get CDN base URL
  console.log(colorize('Enter your CDN base URL:', 'yellow'));
  console.log(colorize('Example: https://cdn.example.com/email-assets', 'gray'));
  console.log('');
  let cdnBaseUrl = await question('CDN Base URL: ');

  // Remove trailing slash
  cdnBaseUrl = cdnBaseUrl.replace(/\/$/, '');

  // Get HTML file path
  console.log('');
  console.log(colorize('Enter the HTML file to update:', 'yellow'));
  console.log(colorize('(Press Enter for default: your-exclusive-invitation.html)', 'gray'));
  console.log('');
  let htmlFile = await question('HTML File: ');

  if (!htmlFile.trim()) {
    htmlFile = 'your-exclusive-invitation.html';
  }

  // Check if file exists
  if (!fs.existsSync(htmlFile)) {
    console.log('');
    console.log(colorize(`✗ Error: File '${htmlFile}' not found!`, 'red'));
    console.log('');
    rl.close();
    process.exit(1);
  }

  console.log('');
  console.log(colorize('============================================', 'cyan'));
  console.log(colorize('  Configuration', 'cyan'));
  console.log(colorize('============================================', 'cyan'));
  console.log(colorize(`CDN Base URL: ${cdnBaseUrl}`, 'green'));
  console.log(colorize(`HTML File:    ${htmlFile}`, 'green'));
  console.log('');
  console.log(colorize("This will replace all './assets/' paths with CDN URLs.", 'yellow'));
  console.log('');
  const confirm = await question('Continue? (y/n): ');

  if (confirm.toLowerCase() !== 'y') {
    console.log('');
    console.log(colorize('Operation cancelled.', 'yellow'));
    console.log('');
    rl.close();
    process.exit(0);
  }

  // Create backup
  const backupFile = `${htmlFile}.backup`;
  console.log('');
  console.log(colorize(`Creating backup: ${backupFile}...`, 'cyan'));
  fs.copyFileSync(htmlFile, backupFile);

  // Read HTML content
  let htmlContent = fs.readFileSync(htmlFile, 'utf8');

  // Count replacements
  const matches = htmlContent.match(/\.\/assets\//g);
  const replacementCount = matches ? matches.length : 0;

  // Replace all local asset paths with CDN URLs
  const updatedContent = htmlContent.replace(/\.\/assets\//g, `${cdnBaseUrl}/`);

  // Write updated content
  fs.writeFileSync(htmlFile, updatedContent, 'utf8');

  console.log('');
  console.log(colorize('============================================', 'green'));
  console.log(colorize('  Update Complete!', 'green'));
  console.log(colorize('============================================', 'green'));
  console.log('');
  console.log(colorize(`✓ Replaced ${replacementCount} asset paths`, 'green'));
  console.log(colorize(`✓ Backup saved as: ${backupFile}`, 'green'));
  console.log(colorize(`✓ Updated file: ${htmlFile}`, 'green'));
  console.log('');
  console.log(colorize('Next steps:', 'cyan'));
  console.log(colorize('1. Review the updated HTML file', 'white'));
  console.log(colorize('2. Test the email in your email client', 'white'));
  console.log(colorize('3. Verify all images load from CDN', 'white'));
  console.log('');

  // Ask if user wants to see examples
  const showExample = await question(colorize('Show example of replaced URLs? (y/n): ', 'yellow'));

  if (showExample.toLowerCase() === 'y') {
    console.log('');
    console.log(colorize('Example replacements:', 'cyan'));
    console.log(colorize('  Before: ./assets/logo.png', 'red'));
    console.log(colorize(`  After:  ${cdnBaseUrl}/logo.png`, 'green'));
    console.log('');
  }

  console.log(colorize('Done!', 'green'));
  console.log('');

  rl.close();
}

// Run the script
main().catch((error) => {
  console.error(colorize('Error:', 'red'), error.message);
  rl.close();
  process.exit(1);
});
