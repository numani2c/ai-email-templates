# Content Tokens - Email Template Guide

## Overview

This document provides a comprehensive framework for identifying, documenting, and implementing dynamic content tokens in HTML email templates. Use this as a reference when converting Figma email designs to production-ready HTML with personalization capabilities.

**Purpose**: 
- Standardize token naming conventions
- Document token categories and usage patterns
- Provide ESP conversion examples
- Enable AI to generate accurate token documentation for any email template

---

## What Are Content Tokens?

Content tokens are placeholders for dynamic data that gets replaced at send-time by your Email Service Provider (ESP) or template engine. They enable personalization, automation, and content reusability.

**Example**:
```html
<!-- Static Content -->
<p>Hi Customer,</p>

<!-- Dynamic Content with Token -->
<p>Hi {{first_name}},</p>
```

When sent, `{{first_name}}` becomes "Sarah", "John", etc., based on recipient data.

---

## Token Naming Conventions

### Standard Syntax

**Default Format**: `{{token_name}}`

**Rules**:
- Lowercase only
- Use underscores `_` to separate words
- No hyphens, spaces, or camelCase
- Descriptive names (avoid abbreviations)
- Consistent category prefixes

**Examples**:
```
✅ Good: 
- {{first_name}}
- {{hero_image_url}}
- {{cta_button_url}}
- {{current_balance}}
- {{unsubscribe_url}}

❌ Bad:
- {{FirstName}}         // No camelCase
- {{heroImg}}           // No abbreviations
- {{btn-url}}           // No hyphens
- {{CTA}}               // Too abbreviated
```

---

## Token Syntax by ESP

Document templates using default `{{token}}` syntax, then convert to ESP-specific format before deployment:

| ESP | Syntax | Example | Notes |
|-----|--------|---------|-------|
| **Default/Handlebars** | `{{variable}}` | `{{first_name}}` | Most flexible |
| **Mailchimp** | `*\|VARIABLE\|*` | `*\|FNAME\|*` | Uppercase |
| **SendGrid** | `{{variable}}` | `{{first_name}}` | Same as  default |
| **HubSpot** | `{{ contact.property }}` | `{{ contact.firstname }}` | Object notation |
| **Salesforce MC** | `%%variable%%` | `%%FirstName%%` | CamelCase |
| **Klaviyo** | `{{ variable }}` | `{{ person.first_name }}` | Object notation |
| **Braze** | `{{${variable}}}` | `{{${first_name}}}` | Dollar sign |
| **ActiveCampaign** | `%VARIABLE%` | `%FIRSTNAME%` | Uppercase |
| **Campaign Monitor** | `[variable]` | `[firstname]` | Square brackets |
| **Constant Contact** | `$variable$` | `$FIRSTNAME$` | Dollar signs |

**Conversion Script Example**:
```javascript
// Convert default tokens to ESP syntax
function convertToESP(html, espType) {
  const patterns = {
    mailchimp: (token) => `*|${token.toUpperCase()}|*`,
    salesforce: (token) => `%%${toCamelCase(token)}%%`,
    hubspot: (token) => `{{ contact.${token} }}`
  };
  return html.replace(/\{\{(\w+)\}\}/g, (match, token) => 
    patterns[espType](token)
  );
}
```

---

## Token Categories

### 1. Email Metadata Tokens

These tokens control email appearance before opening.

#### `{{email_title}}`
**Type**: String  
**Required**: Yes  
**Usage**: HTML `<title>` tag  
**Max Length**: 70 characters  
**Example**: "Summer Sale - 40% Off Everything"  
**Location**: `<head>` section  

```html
<title>{{email_title}}</title>
```

**Best Practices**:
- Keep under 70 characters
- Include brand name
- Summarize email content

---

#### `{{preview_text}}`
**Type**: String  
**Required**: Yes  
**Usage**: Email preheader/preview text  
**Max Length**: 100-140 characters (client-dependent)  
**Example**: "Limited time offer! Save 40% on summer styles. Free shipping on orders $50+."  
**Location**: Hidden `<div>` after `<body>` tag

```html
<div style="display: none; max-height: 0; overflow: hidden;">
  {{preview_text}}
  &nbsp;&zwnj;&nbsp;&zwnj; <!-- Padding to prevent other text showing -->
</div>
```

**Best Practices**:
- 100-140 characters optimal
- Expand on subject line
- Include call-to-action
- Add hidden padding characters

---

### 2. Personalization Tokens

User-specific data for personalized greetings and content.

#### `{{first_name}}`
**Type**: String  
**Required**: Recommended  
**Default Fallback**: "there" or "Valued Customer"  
**Usage**: Personalized greetings  
**Max Length**: 50 characters  
**Example**: "Sarah", "John", "María"  

```html
<p>Hi {{first_name}},</p>

<!-- With fallback -->
Hi {{first_name|default:"there"}},
```

**Best Practices**:
- Always provide fallback
- Handle special characters (accents, apostrophes)
- Capitalize properly server-side

---

#### `{{last_name}}`
**Type**: String  
**Required**: Optional  
**Usage**: Formal greetings, full name display  
**Example**: "Johnson", "García"

---

#### `{{full_name}}` / `{{customer_name}}`
**Type**: String  
**Required**: Optional  
**Usage**: Formal communications  
**Example**: "Sarah Johnson"  

```html
<p>Dear {{full_name}},</p>
```

---

#### `{{email_address}}`
**Type**: Email (String)  
**Required**: Optional  
**Usage**: Account information, confirmation emails  
**Example**: "sarah.johnson@example.com"  
**Security**: Never expose in marketing emails

---

#### `{{company_name}}`
**Type**: String  
**Required**: Optional (B2B emails)  
**Usage**: B2B communications  
**Example**: "Acme Corporation"

---

### 3. Account/Transaction Tokens

For transactional emails (receipts, confirmations, notifications).

#### `{{account_number}}` / `{{last_4_digits}}`
**Type**: String  
**Required**: For account emails  
**Format**: Last 4 digits only (security)  
**Example**: "4567"  

```html
<p>Account ending in {{last_4_digits}}</p>
```

**Security**: Never show full account numbers

---

#### `{{transaction_id}}`
**Type**: String/Number  
**Required**: For transaction emails  
**Example**: "TXN-2024-03-18-001" or "291"  

---

#### `{{order_number}}`
**Type**: String/Number  
**Required**: For e-commerce  
**Example**: "ORD-100234"

---

#### `{{amount}}` / `{{balance}}` / `{{total}}`
**Type**: Currency (String)  
**Required**: For financial emails  
**Format**: Pre-formatted with currency symbol  
**Example**: "$512.00 USD", "€45.99 EUR"  

```html
<p>Current Balance: {{current_balance}}</p>
<p>Order Total: {{order_total}}</p>
```

**Best Practices**:
- Format currency server-side
- Include currency code
- Handle international formatting

---

### 4. Date/Time Tokens

#### `{{current_year}}`
**Type**: Integer/String  
**Required**: For copyright  
**Usage**: Footer copyright text  
**Example**: "2024", "2025"  

```html
<p>© {{current_year}} Company Name. All rights reserved.</p>
```

**Dynamic Generation**:
```javascript
// Server-side
{ current_year: new Date().getFullYear() }
```

---

#### `{{current_date}}`
**Type**: Date (String)  
**Required**: Optional  
**Format**: Pre-formatted  
**Example**: "March 18, 2024" or "18/03/2024"

---

#### `{{expiry_date}}` / `{{due_date}}` / `{{delivery_date}}`
**Type**: Date (String)  
**Required**: Context-dependent  
**Example**: "April 15, 2024"

---

### 5. Image Asset Tokens

URLs for hosted images.

#### `{{logo_url}}`
**Type**: URL (String)  
**Required**: Yes  
**Usage**: Header logo  
**Format**: HTTPS absolute URL  
**Example**: "https://cdn.example.com/emails/shared/logo.png"  

```html
<img 
  src="{{logo_url}}" 
  alt="Company Name" 
  width="200" 
  height="50" 
  style="display: block;"
>
```

**Best Practices**:
- Always use HTTPS
- Host on CDN for reliability
- Include alt text
- Set explicit width/height

---

#### `{{hero_image_url}}`
**Type**: URL (String)  
**Usage**: Main hero section image  
**Recommended Size**: 1200px width (@2x for 600px display)  

---

#### Module-Specific Image Tokens

Use clear, descriptive names:

```
{{header_logo_url}}
{{footer_logo_url}}
{{hero_background_url}}
{{product_image_url}}
{{feature_icon_1_url}}
{{feature_icon_2_url}}
{{cta_banner_url}}
{{section_divider_url}}
```

**Naming Pattern**: `{{[section]_[element]_[variant]_url}}`

---

### 6. Link/URL Tokens

#### `{{cta_url}}` / `{{button_url}}`
**Type**: URL (String)  
**Required**: For action buttons  
**Usage**: Primary call-to-action  
**Example**: "https://www.example.com/shop-now"  

```html
<a href="{{cta_url}}" target="_blank">Shop Now</a>
```

**Tracking**: Add UTM parameters for analytics:
```
{{cta_url}}?utm_source=email&utm_medium=campaign&utm_campaign=summer-sale
```

---

#### `{{view_online_url}}`
**Type**: URL (String)  
**Required**: Recommended  
**Usage**: "View in browser" link  
**Example**: "https://www.example.com/emails/view/abc123"  

---

#### `{{unsubscribe_url}}`
**Type**: URL (String)  
**Required**: YES (legal requirement)  
**Usage**: Unsubscribe link (CAN-SPAM, GDPR compliant)  
**Example**: "https://www.example.com/unsubscribe/abc123"  

```html
<a href="{{unsubscribe_url}}" style="color: #999;">Unsubscribe</a>
```

**Legal Requirements**:
- Must be visible (not hidden)
- Must be functional
- Single-click unsubscribe (no login required)

---

#### `{{privacy_url}}` / `{{terms_url}}`
**Type**: URL (String)  
**Required**: Recommended  
**Usage**: Footer legal links  
**Example**: "https://www.example.com/privacy"

---

#### Social Media URL Tokens

```
{{linkedin_url}}
{{twitter_url}}
{{facebook_url}}
{{instagram_url}}
{{youtube_url}}
{{tiktok_url}}
```

**Example**:
```html
<a href="{{linkedin_url}}" target="_blank">
  <img src="{{linkedin_icon_url}}" alt="LinkedIn" width="32" height="32">
</a>
```

---

## Token Documentation Template

Use this format when documenting tokens for a specific email:

````markdown
### `{{token_name}}`
**Type**: String | Number | URL | Date | Currency  
**Required**: Yes | No | Recommended  
**Default Fallback**: [value]  
**Usage**: [Description of where/how used]  
**Location**: [Module number or section name]  
**Max Length**: [characters]  
**Format**: [Specific format requirements]  
**Example**: [Example value]  

**HTML Implementation**:
```html
<p>{{token_name}}</p>
```

**Best Practices**:
- [Guideline 1]
- [Guideline 2]

**Security**: [Any security considerations]
````

---

## Token Validation Checklist

Before sending emails, verify:

### Metadata
- [ ] `{{email_title}}` - max 70 chars, includes brand
- [ ] `{{preview_text}}` - 100-140 chars, compelling

### Personalization
- [ ] All personalization tokens have fallback values
- [ ] Names handle special characters correctly
- [ ] Test with empty/null values

### Images
- [ ] All `*_url` tokens use HTTPS
- [ ] CDN hosted (not local paths)
- [ ] Images have alt text
- [ ] Explicit width/height set

### Links
- [ ] All URLs are absolute (include https://)
- [ ] UTM parameters added for tracking
- [ ] `{{unsubscribe_url}}` present and functional
- [ ] Links tested and working

### Currency/Numbers
- [ ] Currency formatted correctly ($512.00 USD)
- [ ] Numbers have thousands separators if needed
- [ ] Decimal places consistent

### Dates
- [ ] Date format matches locale
- [ ] Timezone considered
- [ ] `{{current_year}}` dynamic

---

## ESP Integration Examples

### Mailchimp
```html
<!-- Token Conversion -->
Hi *|FNAME|*,

Your balance: $*|BALANCE|* USD

<img src="*|LOGO_URL|*" alt="Logo" />

<a href="*|CTA_URL|*">Shop Now</a>

© *|CURRENT_YEAR|* Company Name
<a href="*|UNSUB|*">Unsubscribe</a>
```

### SendGrid (Handlebars)
```html
<!-- Same as default -->
Hi {{first_name}},

Your balance: ${{balance}} USD

<img src="{{logo_url}}" alt="Logo" />

<a href="{{cta_url}}">Shop Now</a>

© {{current_year}} Company Name
<a href="{{{unsubscribe_url}}}">Unsubscribe</a>
```

### HubSpot
```html
<!-- Object notation -->
Hi {{ contact.firstname }},

Your balance: ${{ contact.account_balance }} USD

<img src="{{ content.logo_url }}" alt="Logo" />

<a href="{{ content.cta_url }}">Shop Now</a>

© {{ year }} Company Name
<a href="{{ unsubscribe_link }}">Unsubscribe</a>
```

### Salesforce Marketing Cloud (AMPscript)
```html
<!-- Percentage notation -->
%%[
SET @firstName = AttributeValue("FirstName")
SET @balance = AttributeValue("Balance")
]%%

Hi %%=v(@firstName)=%%,

Your balance: $%%=v(@balance)=%% USD

<img src="%%ImpressionRegion(@logo_url)%%" alt="Logo" />

<a href="%%=RedirectTo(@cta_url)=%%">Shop Now</a>

© %%=Format(Now(),"yyyy")=%% Company Name
```

---

## Testing Tokens

### Test Data Sets

#### Minimal Data (Edge Case)
```json
{
  "first_name": "",
  "last_name": "",
  "email": "test@example.com"
}
```
**Expected**: Fallback values should display

#### Standard Data
```json
{
  "first_name": "Sarah",
  "last_name": "Johnson",
  "email": "sarah@example.com",
  "company_name": "Acme Corp",
  "current_balance": "$512.00 USD"
}
```

#### Special Characters
```json
{
  "first_name": "José",
  "last_name": "O'Brien-García",
  "company_name": "Café & Co."
}
```
**Test**: Characters render correctly

#### Long Values
```json
{
  "first_name": "Christopher-Alexander",
  "company_name": "International Business Solutions Corporation LLC"
}
```
**Test**: Text doesn't break layout

---

## Common Patterns by Email Type

### Transactional (Receipts, Confirmations)
```
{{transaction_id}}
{{order_number}}
{{amount}}
{{transaction_date}}
{{account_number}} (last 4 digits only)
```

### Marketing (Promotions, Newsletters)
```
{{first_name}}
{{hero_image_url}}
{{cta_url}}
{{product_name}}
{{discount_code}}
```

### Account Notifications (Alerts, Updates)
```
{{account_holder_name}}
{{account_number}} (masked)
{{alert_type}}
{{alert_date}}
{{security_url}}
```

### Welcome/Onboarding
```
{{first_name}}
{{company_name}}
{{activation_url}}
{{support_url}}
{{getting_started_guide_url}}
```

---

## Security & Privacy

### Never Include in Email
❌ Full credit card numbers  
❌ Social Security Numbers  
❌ Passwords or PINs  
❌ Full account numbers (show last 4 digits only)  
❌ Security codes (CVV, 2FA codes)

### PII (Personally Identifiable Information)
Tokens containing PII:
- `{{first_name}}`, `{{last_name}}`, `{{email_address}}`
- `{{phone_number}}`, `{{address}}`
- `{{account_number}}`, `{{transaction_id}}`

**Best Practices**:
- Encrypt email content if required by compliance
- Log token usage for audit trail
- Implement data retention policies
- Honor opt-out requests immediately

### GDPR/CAN-SPAM Compliance
- Include `{{unsubscribe_url}}` (required)
- Show physical address (required by CAN-SPAM)
- Provide `{{privacy_url}}` (GDPR)
- Allow `{{data_download_url}}` (GDPR right to access)
- Support `{{delete_account_url}}` (GDPR right to erasure)

---

## References & Resources

- [Email Template Examples](../../email-templates/) - Real implementations
- [Can I Email](https://www.caniemail.com/) - Check token support by client
- [MJML Documentation](https://mjml.io/) - Alternative templating approach
- [Litmus Email Personalization Guide](https://www.litmus.com/blog/a-guide-to-email-personalization/)
- [CAN-SPAM Compliance](https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business)
- [GDPR Email Marketing](https://gdpr.eu/email-encryption/)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2024-03-24 | Rewritten as generic template guide |
| 1.0 | 2024-03-18 | Initial documentation |
