# Email Template Conversion Reference Guide

## 📚 Technical Documentation for Email HTML Development

**⚠️ Note:** This is now a **technical reference guide**, not a copy-paste prompt. 

**For conversions:** Simply provide a Figma URL to the AI and answer interactive questions - no manual prompt copying needed! The AI will guide you through the process automatically.

**This guide contains:** Email HTML best practices, code patterns, client compatibility, and technical specifications used during automated conversions.

---

## 🎯 How Conversions Work Now (Smart Interactive Mode)

**Old Way (Manual):** ❌
1. Copy prompt template
2. Fill in placeholders
3. Paste into AI chat
4. Wait for conversion

**New Way (Automatic):** ✅
1. Provide Figma URL
2. Answer on-screen questions
3. AI converts automatically

**Example:**
```
You: "Convert this Figma email: https://figma.com/design/xyz/..."

AI: "✓ Figma URL detected! Let me gather some details...
     
     1️⃣ Email Type: [1] Marketing [2] Transactional [3] Newsletter
     Your choice: _"
```

See [EMAIL_AI_CONTEXT.md](./EMAIL_AI_CONTEXT.md) for the complete interactive workflow.

---

## 📖 Technical Reference Sections

## Email HTML vs Web HTML

### What's Different

| Feature | Web/React | Email HTML |
|---------|-----------|------------|
| Layout | Flexbox, Grid, CSS | `<table>` nested tables |
| Styling | External CSS, Tailwind | Inline `style=""` attributes |
| Responsiveness | CSS media queries | Limited media queries + fluid tables |
| Images | `<img>` with CSS | `<img>` with width/height attributes |
| Fonts | Google Fonts, custom | Web-safe fonts only (Arial, Georgia) |
| Buttons | `<button>`, CSS styled | Table cells + VML for Outlook |
| Spacing | Margin, padding, gap | Empty `<td>` cells, padding on cells |
| Border radius | `border-radius: 8px` | Works on some clients, square on Outlook |

### What NOT to Use in Email

```html
<!-- ❌ NEVER USE THESE -->
<div>              <!-- Use <table> instead -->
display: flex      <!-- Not supported -->
display: grid      <!-- Not supported -->
position: absolute <!-- Very limited support -->
float              <!-- Unreliable -->
margin             <!-- Use padding on <td> instead -->
<style> in <body>  <!-- Must be in <head> -->
JavaScript         <!-- Never supported -->
External CSS       <!-- Will be stripped -->
```

---

## Email Template Structure

### Base HTML Skeleton

```html
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="x-apple-disable-message-reformatting">
  <meta name="format-detection" content="telephone=no,address=no,email=no,date=no,url=no">
  <title>{{email_title}}</title>
  
  <!--[if mso]>
  <noscript>
    <xml>
      <o:OfficeDocumentSettings>
        <o:AllowPNG/>
        <o:PixelsPerInch>96</o:PixelsPerInch>
      </o:OfficeDocumentSettings>
    </xml>
  </noscript>
  <![endif]-->
  
  <style>
    /* Reset styles */
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
    
    /* Mobile styles */
    @media only screen and (max-width: 600px) {
      .mobile-full { width: 100% !important; }
      .mobile-padding { padding: 20px !important; }
      .mobile-stack { display: block !important; width: 100% !important; }
      .mobile-hide { display: none !important; }
      .mobile-center { text-align: center !important; }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #f4f4f4;">
  <!-- Preview Text (hidden) -->
  <div style="display: none; max-height: 0; overflow: hidden;">
    {{preview_text}}
    &nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;
  </div>
  
  <!-- Email Container -->
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f4f4f4;">
    <tr>
      <td align="center" style="padding: 20px 0;">
        <!-- Inner Container (600px max) -->
        <table role="presentation" width="600" cellpadding="0" cellspacing="0" border="0" class="mobile-full" style="max-width: 600px; background-color: #ffffff;">
          
          <!-- MODULE 1: Header -->
          <!-- MODULE 2: Content -->
          <!-- MODULE 3: Footer -->
          
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

---

## Module-Based Design

### Identify Modules from Figma

When analyzing a Figma email design, identify discrete sections:

```
📧 Email Structure
├── MODULE 1: Header (logo, navigation)
├── MODULE 2: Hero (headline, main image, CTA)
├── MODULE 3: Body Content (text, features)
├── MODULE 4: Cards/Grid (product cards, features)
├── MODULE 5: CTA Section (buttons, actions)
└── MODULE 6: Footer (social links, legal text)
```

### Module Table Pattern

Each module follows this pattern:

```html
<!-- MODULE: [Name] -->
<tr>
  <td style="background-color: #HEXCODE; padding: 40px 50px;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td>
          <!-- Module content here -->
        </td>
      </tr>
    </table>
  </td>
</tr>
```

---

## Common Email Patterns

### 1. Logo Header

```html
<tr>
  <td align="center" style="padding: 30px 0;">
    <img src="{{logo_url}}" alt="Company Name" width="200" height="50" style="display: block; width: 200px; height: auto;">
  </td>
</tr>
```

### 2. Hero Section with Headline

```html
<tr>
  <td style="background-color: #1434cb; padding: 50px; text-align: center;">
    <h1 style="margin: 0; font-family: Arial, sans-serif; font-size: 42px; line-height: 48px; color: #ffffff; font-weight: bold;">
      Your Headline Here
    </h1>
    <p style="margin: 20px 0 0 0; font-family: Arial, sans-serif; font-size: 16px; line-height: 24px; color: #ffffff;">
      Supporting text for the hero section.
    </p>
  </td>
</tr>
```

### 3. Full-Width Image

```html
<tr>
  <td style="padding: 0;">
    <img src="{{image_url}}" alt="Description" width="600" style="display: block; width: 100%; height: auto;">
  </td>
</tr>
```

### 4. Two-Column Layout

```html
<tr>
  <td style="padding: 30px;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <!-- Left Column -->
        <td width="48%" valign="top" class="mobile-stack" style="padding-right: 2%;">
          <p style="margin: 0; font-family: Arial, sans-serif; font-size: 14px; color: #333333;">
            Left column content
          </p>
        </td>
        
        <!-- Right Column -->
        <td width="48%" valign="top" class="mobile-stack" style="padding-left: 2%;">
          <p style="margin: 0; font-family: Arial, sans-serif; font-size: 14px; color: #333333;">
            Right column content
          </p>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

### 5. Bulletproof Button (Works in Outlook)

```html
<tr>
  <td align="center" style="padding: 30px 0;">
    <table role="presentation" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td style="border-radius: 8px; background-color: #f97c00;">
          <!--[if mso]>
          <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="{{button_url}}" style="height:48px;v-text-anchor:middle;width:200px;" arcsize="17%" stroke="f" fillcolor="#f97c00">
            <w:anchorlock/>
            <center style="color:#ffffff;font-family:Arial,sans-serif;font-size:14px;font-weight:bold;">
              Button Text
            </center>
          </v:roundrect>
          <![endif]-->
          <!--[if !mso]><!-->
          <a href="{{button_url}}" target="_blank" style="display: inline-block; padding: 14px 40px; font-family: Arial, sans-serif; font-size: 14px; font-weight: bold; color: #ffffff; text-decoration: none; border-radius: 8px; background-color: #f97c00;">
            Button Text
          </a>
          <!--<![endif]-->
        </td>
      </tr>
    </table>
  </td>
</tr>
```

### 6. Social Icons Row

```html
<tr>
  <td align="center" style="padding: 20px 0;">
    <table role="presentation" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td style="padding: 0 8px;">
          <a href="{{linkedin_url}}" target="_blank">
            <img src="{{linkedin_icon}}" alt="LinkedIn" width="32" height="32" style="display: block;">
          </a>
        </td>
        <td style="padding: 0 8px;">
          <a href="{{twitter_url}}" target="_blank">
            <img src="{{twitter_icon}}" alt="Twitter" width="32" height="32" style="display: block;">
          </a>
        </td>
        <td style="padding: 0 8px;">
          <a href="{{facebook_url}}" target="_blank">
            <img src="{{facebook_icon}}" alt="Facebook" width="32" height="32" style="display: block;">
          </a>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

### 7. Footer with Legal Text

```html
<tr>
  <td style="background-color: #f4f4f4; padding: 30px; text-align: center;">
    <p style="margin: 0; font-family: Arial, sans-serif; font-size: 12px; line-height: 18px; color: #999999;">
      © {{current_year}} Company Name. All rights reserved.<br>
      <a href="{{unsubscribe_url}}" style="color: #999999; text-decoration: underline;">Unsubscribe</a> | 
      <a href="{{privacy_url}}" style="color: #999999; text-decoration: underline;">Privacy Policy</a>
    </p>
    <p style="margin: 10px 0 0 0; font-family: Arial, sans-serif; font-size: 10px; line-height: 16px; color: #bbbbbb;">
      123 Street Address, City, State 12345
    </p>
  </td>
</tr>
```

---

## Content Tokens

### Token Syntax by ESP

| ESP | Syntax | Example |
|-----|--------|---------|
| Default/Handlebars | `{{variable}}` | `{{first_name}}` |
| Mailchimp | `*|VARIABLE|*` | `*|FNAME|*` |
| SendGrid | `{{variable}}` | `{{first_name}}` |
| HubSpot | `{{ contact.property }}` | `{{ contact.firstname }}` |
| Salesforce MC | `%%variable%%` | `%%FirstName%%` |
| Klaviyo | `{{ variable }}` | `{{ first_name }}` |

### Common Tokens to Include

```markdown
## Metadata
- {{email_title}} - HTML <title> content
- {{preview_text}} - Preheader text (50-130 chars)

## Personalization
- {{first_name}} - Recipient first name
- {{full_name}} - Recipient full name
- {{company_name}} - Recipient company

## Dynamic Content
- {{current_year}} - Year for copyright
- {{current_date}} - Send date

## Images (hosted URLs)
- {{logo_url}} - Main logo
- {{hero_image_url}} - Hero section image
- {{[section]_image_url}} - Section-specific images

## Links
- {{cta_url}} - Main call-to-action
- {{unsubscribe_url}} - Required unsubscribe link
- {{view_online_url}} - View in browser link
- {{social_[platform]_url}} - Social profile links
```

---

## Image Guidelines

### Export from Figma

1. **Resolution**: Export at 2x (@2x) for retina displays
2. **Format**: 
   - PNG-24 for images with transparency
   - JPG at 80% for photographs
   - SVG NOT recommended (poor email support)
3. **Max Width**: 1200px (displays at 600px)
4. **File Size**: Keep under 200KB per image

### Image HTML Pattern

```html
<!-- Always include width, height, alt, and display:block -->
<img 
  src="{{image_url}}" 
  alt="Descriptive text for accessibility" 
  width="600" 
  height="300" 
  style="display: block; width: 100%; height: auto; max-width: 600px;"
>
```

### Image Hosting Checklist

- [ ] Host on CDN (not email server)
- [ ] Use HTTPS URLs only
- [ ] Include alt text for accessibility
- [ ] Set explicit width/height
- [ ] Test with images disabled

---

## Email Client Compatibility

### Support Levels

| Client | Rendering Engine | Risk Level | Notes |
|--------|-----------------|------------|-------|
| Apple Mail | WebKit | ✅ Low | Best support |
| iOS Mail | WebKit | ✅ Low | Excellent |
| Gmail (Web) | Custom | ⚠️ Low-Mod | 102KB size limit |
| Gmail (App) | Custom | ⚠️ Low-Mod | Same as web |
| Outlook.com | Custom | ⚠️ Moderate | Good responsive support |
| Outlook Desktop | MS Word | ⚠️ High | No border-radius, needs VML |
| Yahoo Mail | Custom | ⚠️ Moderate | May strip background images |
| Samsung Email | WebKit | ⚠️ Low-Mod | Minor spacing issues |

### Outlook-Specific Requirements

1. **VML for Buttons**: Use the bulletproof button pattern with VML fallback
2. **Background Images**: Use VML for background images on `<td>`
3. **MSO Conditionals**: Target Outlook specifically:

```html
<!--[if mso]>
  Outlook-only code here
<![endif]-->

<!--[if !mso]><!-->
  Non-Outlook code here
<!--<![endif]-->
```

---

## Mobile Responsiveness

### CSS Media Query Pattern

```css
@media only screen and (max-width: 600px) {
  /* Full width on mobile */
  .mobile-full { width: 100% !important; }
  
  /* Reduced padding */
  .mobile-padding { padding: 20px !important; }
  
  /* Stack columns vertically */
  .mobile-stack { 
    display: block !important; 
    width: 100% !important; 
    padding-left: 0 !important;
    padding-right: 0 !important;
  }
  
  /* Hide elements on mobile */
  .mobile-hide { display: none !important; }
  
  /* Center text on mobile */
  .mobile-center { text-align: center !important; }
  
  /* Smaller font sizes */
  .mobile-headline { font-size: 32px !important; line-height: 38px !important; }
}
```

### Fluid Table Pattern

```html
<table 
  role="presentation" 
  width="600" 
  cellpadding="0" 
  cellspacing="0" 
  border="0" 
  class="mobile-full" 
  style="max-width: 600px; width: 100%;"
>
```

---

## Deliverables Checklist

When completing an email conversion, provide:

### 1. `[email-name].html`
- [ ] Complete HTML email code
- [ ] All inline styles
- [ ] Mobile responsive classes
- [ ] Content tokens for dynamic data
- [ ] VML fallbacks for Outlook buttons
- [ ] Proper DOCTYPE and meta tags
- [ ] Preview text implementation


### 3. `CONTENT_TOKENS.md`
- [ ] Complete token list
- [ ] Token types (metadata, personalization, images, links)
- [ ] ESP syntax conversion examples
- [ ] Default/fallback values
- [ ] Validation checklist

### 4. `ASSET_EXPORT_PLAN.md`
- [ ] Image inventory with Figma node IDs
- [ ] Export specifications (size, format, quality)
- [ ] File naming convention
- [ ] Hosting requirements
- [ ] Optimization checklist

### 5. `EMAIL_CLIENT_RISKS.md`
- [ ] Client compatibility matrix
- [ ] Feature support levels
- [ ] Known issues and mitigations
- [ ] Testing recommendations
- [ ] Pre-deployment checklist

---

## Testing Checklist

Before deployment:

- [ ] **Litmus or Email on Acid**: Test across 20+ clients
- [ ] **Spam Score**: Check with mail-tester.com
- [ ] **Link Validation**: All links working
- [ ] **Image Loading**: Test with images disabled
- [ ] **Mobile Preview**: Check responsive behavior
- [ ] **Dark Mode**: Test appearance in dark mode
- [ ] **Plain Text**: Include plain text version
- [ ] **File Size**: Under 100KB HTML (Gmail limit)
- [ ] **Token Replacement**: All tokens resolve correctly
- [ ] **Unsubscribe Link**: Working and visible
- [ ] **Subject Line**: Under 50 characters
- [ ] **Preview Text**: 50-130 characters

---

## Example Conversion Flow

### Step 1: Analyze Figma Design
```markdown
1. Open Figma URL
2. Identify email dimensions (should be ~600px wide)
3. Break design into modules (header, body, footer)
4. Note colors, fonts, spacing
5. List all images requiring export
```

### Step 2: Extract Design Details via MCP
```markdown
Use get_design_context or get_screenshot to:
1. Get overall layout structure
2. Extract color palette
3. Note typography (convert to web-safe fonts)
4. Identify spacing patterns
```

### Step 3: Build HTML Structure
```markdown
1. Start with base HTML skeleton
2. Add modules one by one
3. Apply inline styles
4. Add mobile responsive classes
5. Implement VML button fallbacks
```

### Step 4: Add Tokens
```markdown
1. Replace static content with tokens
2. Add image URL tokens
3. Include tracking/link tokens
4. Add personalization tokens
```

```

### Step 6: Test and Validate
```markdown
1. Preview in browser at 600px
2. Test on Litmus/Email on Acid
3. Validate all links
4. Check mobile responsiveness
5. Review Outlook rendering
```

---

## References

- [Email-templates/i2c-brand-rollout/](../email-templates/i2c-brand-rollout/) - Example conversion
- [Can I Email](https://www.caniemail.com/) - CSS support checker
- [Litmus](https://litmus.com/) - Email testing platform
- [Email on Acid](https://www.emailonacid.com/) - Email testing platform
- [MJML](https://mjml.io/) - Email framework (alternative approach)
