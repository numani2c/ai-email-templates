# Email Client Compatibility Guide

## Overview

This document provides a comprehensive reference for email client compatibility issues, rendering engines, feature support, and mitigation strategies. Use this guide when assessing risks for any HTML email template.

**Purpose**:
- Understand email client rendering differences
- Identify feature support levels across clients
- Provide mitigation strategies for common issues
- Enable AI to generate accurate client-specific risk assessments

---

## Support Level Legend

- ✅ **Full Support**: Feature works as designed, no issues expected
- ⚠️ **Partial Support**: Feature works with minor degradation or workarounds needed
- ❌ **No Support**: Feature fails or requires significant fallback
- 🔍 **Requires Testing**: Needs validation before deployment

---

## Email Client Market Share (2024)

| Client | Market Share | Importance |
|--------|--------------|------------|
| Apple Mail (iOS) | ~35% | Critical |
| Gmail (all platforms) | ~30% | Critical |
| Outlook (all versions) | ~10% | Important |
| Apple Mail (macOS) | ~8% | Important |
| Yahoo Mail | ~5% | Moderate |
| Outlook.com | ~3% | Moderate |
| Others | ~9% | Low |

**Testing Priority**: Test on top 4-5 clients covering 80%+ of your audience.

---

## Desktop Email Clients

### Microsoft Outlook (Windows)

#### Outlook 2016 / 2019 / Microsoft 365 (Desktop)
**Rendering Engine**: Microsoft Word (!!!)  
**Market Share**: ~6-8%  
**Overall Risk**: ⚠️ **HIGH**

**Feature Support**:

| Feature | Support | Notes |
|---------|---------|-------|
| `<table>` layout | ✅ | Primary layout method, works well |
| Inline CSS | ✅ | Fully supported |
| `<style>` in `<head>` | ⚠️ | Limited, inline preferred |
| `margin` property | ❌ | Not supported, use `padding` on `<td>` |
| `padding` on `<td>` | ⚠️ | Works but may need MSO conditionals |
| `border-radius` | ❌ | Not supported, corners always square |
| `box-shadow` | ❌ | Not supported |
| Background images | ❌ | Requires VML fallback |
| Web fonts | ❌ | Falls back to system fonts |
| Media queries | ❌ | Not supported, always desktop view |
| `position: absolute` | ❌ | Not supported |
| `float` | ❌ | Not supported |
| Button `<a>` with padding | ⚠️ | Requires VML for bulletproof buttons |
| GIF animations | ✅ | Shows first frame only |

**Common Issues & Solutions**:

1. **Border Radius Not Supported**
   - **Issue**: All `border-radius` ignored, corners square
   - **Solution**: Accept degradation OR use border images
   - **Code**: None needed, just expect square corners

2. **Background Images on `<td>`**
   - **Issue**: `background-image` CSS doesn't work
   - **Solution**: Use VML (Vector Markup Language)
   - **Code**:
   ```html
   <td style="background-color: #1434cb;">
     <!--[if mso]>
     <v:rect xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style="width:600px;height:400px;">
       <v:fill type="frame" src="https://cdn.example.com/bg.jpg" color="#1434cb" />
       <v:textbox style="mso-fit-shape-to-text:true" inset="0,0,0,0">
     <![endif]-->
     <div>
       Your content here
     </div>
     <!--[if mso]>
       </v:textbox>
     </v:rect>
     <![endif]-->
   </td>
   ```

3. **Buttons Need VML**
   - **Issue**: Regular `<a>` buttons don't have proper padding/bg color
   - **Solution**: Bulletproof button pattern
   - **Code**:
   ```html
   <table role="presentation" cellpadding="0" cellspacing="0" border="0">
     <tr>
       <td style="border-radius: 8px; background-color: #f97c00;">
         <!--[if mso]>
         <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" href="URL" style="height:48px;v-text-anchor:middle;width:200px;" arcsize="17%" stroke="f" fillcolor="#f97c00">
           <w:anchorlock/>
           <center style="color:#ffffff;font-family:Arial,sans-serif;font-size:14px;font-weight:bold;">
             Button Text
           </center>
         </v:roundrect>
         <![endif]-->
         <!--[if !mso]><!-->
         <a href="URL" style="display:inline-block;padding:14px 40px;font-family:Arial,sans-serif;font-size:14px;color:#ffffff;text-decoration:none;">
           Button Text
         </a>
         <!--<![endif]-->
       </td>
     </tr>
   </table>
   ```

4. **Padding Issues**
   - **Issue**: Padding may render inconsistently
   - **Solution**: Use MSO-specific padding or spacer cells
   - **Code**:
   ```html
   <!-- MSO Padding Fix -->
   <td style="padding: 20px; mso-padding-alt: 20px 20px 20px 20px;">
   
   <!-- Or Spacer Cell -->
   <td width="20" style="font-size: 0; line-height: 0;">&nbsp;</td>
   ```

**MSO Conditionals** (Target Outlook Only):
```html
<!--[if mso]>
  Outlook-only code
<![endif]-->

<!--[if !mso]><!-->
  All other email clients
<!--<![endif]-->

<!--[if (gte mso 9)|(IE)]>
  Outlook 2000+ and IE
<![endif]-->
```

**Recommendations**:
- Use table-based layout exclusively
- Inline all CSS
- Provide VML fallbacks for buttons
- Accept border-radius will be square
- Test with Litmus or Email on Acid

---

#### Outlook.com (Web)
**Rendering Engine**: Custom (Microsoft)  
**Market Share**: ~3%  
**Overall Risk**: ⚠️ **LOW-MODERATE**

**Feature Support**:

| Feature | Support | Notes |
|---------|---------|-------|
| `<table>` layout | ✅ | Fully supported |
| Inline CSS | ✅ | Good support |
| `border-radius` | ✅ | Supported |
| Background images | ✅ | Supported |
| Media queries | ✅ | Responsive works |
| Web fonts | ⚠️ | Limited, web-safe fonts recommended |

**Common Issues**:
1. **Class Name Stripping**: May remove or rename classes
   - **Solution**: Use inline styles primarily

2. **Media Query Quirks**: Complex queries may fail
   - **Solution**: Keep media queries simple

**Recommendations**:
- Standard email HTML practices work well
- Prioritize inline styles over classes
- Test responsive behavior

---

### Apple Mail (macOS)
**Rendering Engine**: WebKit  
**Market Share**: ~8%  
**Overall Risk**: ✅ **LOW**

**Feature Support**: Excellent across the board

| Feature | Support | Notes |
|---------|---------|-------|
| All CSS properties | ✅ | Near-complete CSS support |
| `border-radius` | ✅ | Fully supported |
| `box-shadow` | ✅ | Fully supported |
| Background images | ✅ | Fully supported |
| Web fonts | ✅ | Supported (web-safe still recommended) |
| Media queries | ✅ | Responsive works perfectly |
| CSS animations | ✅ | Supported (use sparingly) |
| GIF animations | ✅ | Fully supported |

**Common Issues**: None significant

**Recommendations**:
- Ideal for visual QA and baseline testing
- Use as reference for design accuracy
- Excellent for development preview

---

### Gmail (Web - Desktop)
**Rendering Engine**: Custom (Google)  
**Market Share**: ~15%  
**Overall Risk**: ⚠️ **LOW-MODERATE**

**Feature Support**:

| Feature | Support | Notes |
|---------|---------|-------|
| `<table>` layout | ✅ | Fully supported |
| Inline CSS | ✅ | Good support |
| `<style>` in `<head>` | ✅ | Supported (media queries work!) |
| `border-radius` | ✅ | Supported |
| Background images | ⚠️ | Supported but stripped if images disabled |
| Media queries | ✅ | Responsive works |
| Web fonts | ❌ | Stripped, use web-safe fonts |

**Common Issues**:

1. **102KB Clipping**
   - **Issue**: Emails over 102KB get clipped with "[Message clipped] View entire message" link
   - **Solution**: Keep HTML under 100KB (not counting images)
   - **Check Size**: 
   ```bash
   # Linux/Mac
   wc -c email.html
   
   # Windows PowerShell
   (Get-Item email.html).Length
   ```

2. **Link Color Override**
   - **Issue**: Gmail may change link colors to default blue
   - **Solution**: Use explicit inline color and `!important`
   - **Code**:
   ```html
   <a href="URL" style="color: #f97c00 !important; text-decoration: none;">Link</a>
   ```

3. **Web Fonts Stripped**
   - **Issue**: `@import` and `<link>` for web fonts removed
   - **Solution**: Use web-safe fonts (Arial, Georgia, Times, Courier)

**Recommendations**:
- Keep HTML under 100KB
- Use web-safe fonts
- Test with images disabled
- Inline styles + `<style>` for media queries works well

---

### Yahoo Mail (Web)
**Rendering Engine**: Custom  
**Market Share**: ~5%  
**Overall Risk**: ⚠️ **MODERATE**

**Feature Support**:

| Feature | Support | Notes |
|---------|---------|-------|
| `<table>` layout | ✅ | Fully supported |
| Inline CSS | ✅ | Good support |
| Media queries | ✅ | Responsive supported |
| `border-radius` | ✅ | Supported |
| Background images | ⚠️ | Sometimes stripped |

**Common Issues**:

1. **Class Name Modifications**
   - **Issue**: Yahoo prepends random strings to class names
   - **Example**: `.button` becomes `.ymail-button-abc123`
   - **Solution**: Use inline styles as primary styling method

2. **Background Image Stripping**
   - **Issue**: Background images may be removed
   - **Solution**: Provide solid color fallback

3. **Attribute Changes**
   - **Issue**: Yahoo may modify `id` and `class` attributes
   - **Solution**: Don't rely on these for critical functionality

**Recommendations**:
- Inline styles are critical
- Always provide fallback colors for backgrounds
- Test with background images disabled

---

## Mobile Email Clients

### Gmail Mobile App (iOS / Android)
**Rendering Engine**: Custom (Google)  
**Market Share**: ~15%  
**Overall Risk**: ⚠️ **LOW**

**Feature Support**:

| Feature | Support | Notes |
|---------|---------|-------|
| Responsive layout | ✅ | Media queries work |
| Touch targets | ✅ | 44px minimum recommended |
| `border-radius` | ✅ | Supported |
| Background images | ✅ | Supported |

**Common Issues**:

1. **Auto-Scaling Fonts**
   - **Issue**: Gmail may auto-scale fonts on mobile
   - **Solution**: Use viewport meta tag
   - **Code**:
   ```html
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   ```

2. **Touch Target Size**
   - **Issue**: Buttons/links too small to tap
   - **Solution**: Minimum 44px × 44px touch targets
   - **Code**:
   ```html
   <a href="URL" style="display: inline-block; min-width: 44px; min-height: 44px; padding: 12px 24px;">
     Button
   </a>
   ```

**Recommendations**:
- Design for 320px-375px screen widths
- 44px minimum button height
- Test on actual devices (iOS 15+, Android 10+)

---

### Apple Mail (iOS / iPadOS)
**Rendering Engine**: WebKit  
**Market Share**: ~35%  
**Overall Risk**: ✅ **LOW**

**Feature Support**: Excellent

| Feature | Support | Notes |
|---------|---------|-------|
| All modern CSS | ✅ | Near-complete support |
| Responsive layout | ✅ | Media queries work perfectly |
| GIF animations | ✅ | Fully supported |
| Dark mode | ⚠️ | May invert colors automatically |

**Common Issues**:

1. **Dark Mode Auto-Inversion**
   - **Issue**: iOS automatically inverts light backgrounds in dark mode
   - **Solution**: Use dark mode media query to control appearance
   - **Code**:
   ```css
   @media (prefers-color-scheme: dark) {
     /* Prevent auto-inversion */
     .email-wrapper {
       color-scheme: light only;
     }
     /* Or provide dark mode styles */
     body { background-color: #1a1a1a !important; }
     .text { color: #ffffff !important; }
   }
   ```

2. **Auto-Linking**
   - **Issue**: iOS auto-detects phone numbers, addresses, dates
   - **Solution**: Disable with meta tags if needed
   - **Code**:
   ```html
   <meta name="format-detection" content="telephone=no,address=no,email=no,date=no">
   ```

**Recommendations**:
- Excellent rendering, use as mobile baseline
- Consider dark mode styling (optional)
- Test on iPhone and iPad

---

### Outlook Mobile (iOS / Android)
**Rendering Engine**: Custom (Microsoft)  
**Market Share**: ~3-5%  
**Overall Risk**: ⚠️ **LOW-MODERATE**

**Feature Support**:

| Feature | Support | Notes |
|---------|---------|-------|
| Responsive layout | ✅ | Good support |
| `border-radius` | ✅ | Supported |
| Background images | ✅ | Supported |

**Common Issues**:

1. **Font Scaling**
   - **Issue**: May override font sizes for readability
   - **Solution**: Use text-size-adjust
   - **Code**:
   ```css
   body, table, td, a {
     -webkit-text-size-adjust: 100%;
     -ms-text-size-adjust: 100%;
   }
   ```

**Recommendations**:
- Standard practices work well
- Test responsive stacking
- Verify button sizes on actual devices

---

### Samsung Email (Android)
**Rendering Engine**: WebKit-based  
**Market Share**: ~2-3%  
**Overall Risk**: ⚠️ **LOW-MODERATE**

**Feature Support**: Generally good

**Common Issues**:
1. **Variable CSS Support**: Some properties render inconsistently
   - **Solution**: Keep CSS simple, test on device

**Recommendations**:
- Test on Samsung devices if significant audience
- Monitor spacing/padding behavior

---

## Feature-Specific Compatibility

### Border Radius

**Support**:
- ✅ Apple Mail, Gmail, Yahoo, Outlook.com
- ❌ Outlook 2016/2019/365 (Desktop)

**Recommendation**: Use freely, accept square corners in Outlook

**Code**:
```html
<td style="border-radius: 8px; background-color: #f4f4f4;">
  <!-- Square in Outlook, rounded elsewhere -->
</td>
```

---

### Background Images

**Support**:
- ✅ Apple Mail (all), Outlook.com
- ⚠️ Gmail (stripped if images disabled), Yahoo (sometimes stripped)
- ❌ Outlook 2016/2019/365 (needs VML)

**Recommendation**: Always provide color fallback

**Code**:
```html
<!-- Modern clients -->
<td style="background-image: url('https://cdn.example.com/bg.jpg'); background-color: #1434cb; background-size: cover;">
  Content here
</td>

<!-- Outlook VML fallback -->
<!--[if mso]>
<v:rect xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style="width:600px; height:400px;">
  <v:fill type="frame" src="https://cdn.example.com/bg.jpg" color="#1434cb" />
  <v:textbox style="mso-fit-shape-to-text:true" inset="0,0,0,0">
<![endif]-->
    <div>Content</div>
<!--[if mso]>
  </v:textbox>
</v:rect>
<![endif]-->
```

---

### Web Fonts

**Support**:
- ✅ Apple Mail (macOS), Outlook.com (limited)
- ❌ Gmail, Outlook Desktop, Most mobile clients

**Recommendation**: Use web-safe fonts

**Web-Safe Font Stack**:
```css
font-family: Arial, Helvetica, sans-serif; /* Sans-serif */
font-family: Georgia, Times, 'Times New Roman', serif; /* Serif */
font-family: 'Courier New', Courier, monospace; /* Monospace */
font-family: 'Comic Sans MS', cursive; /* Casual (use sparingly!) */
```

---

### Media Queries (Responsive Design)

**Support**:
- ✅ Most clients (Gmail, Apple Mail, Yahoo, Outlook.com, mobile Gmail, mobile Apple Mail)
- ❌ Outlook 2016/2019/365 (Desktop)

**Recommendation**: Use, but ensure desktop view works in Outlook

**Code**:
```html
<style>
  @media only screen and (max-width: 600px) {
    .mobile-full { width: 100% !important; }
    .mobile-stack { display: block !important; width: 100% !important; }
    .mobile-hide { display: none !important; }
    .mobile-padding { padding: 20px !important; }
  }
</style>

<table width="600" class="mobile-full">
  <!-- Responsive -->
</table>
```

---

### GIF Animations

**Support**:
- ✅ Apple Mail, Gmail (web), most mobile clients
- ⚠️ Outlook 2016/2019/365 (shows first frame only)

**Recommendation**: Ensure first frame is meaningful

**Best Practices**:
- First frame should convey main message
- Keep file size under 200KB
- 2-3 seconds loop recommended
- Test fallback (first frame) in Outlook

---

### Buttons

**All Clients**: Use bulletproof button pattern

**Code** (see Outlook Desktop section above for full VML version):
```html
<table role="presentation" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td style="border-radius: 8px; background-color: #f97c00;">
      <a href="URL" style="display: inline-block; padding: 14px 40px; font-family: Arial, sans-serif; font-size: 14px; font-weight: bold; color: #ffffff; text-decoration: none;">
        Button Text
      </a>
    </td>
  </tr>
</table>
```

---

## Testing Checklist

### Pre-Send Testing

#### Code Validation
- [ ] HTML validates (W3C validator)
- [ ] All images use absolute HTTPS URLs
- [ ] All links use absolute URLs
- [ ] No JavaScript included
- [ ] No external CSS (`<link>` tags)
- [ ] File size under 100KB (Gmail)

#### Visual Testing (Litmus/Email on Acid)
- [ ] Outlook 2016/2019/365 (Windows)
- [ ] Outlook.com (Web)
- [ ] Gmail (Web, Desktop)
- [ ] Gmail (Mobile App, iOS/Android)
- [ ] Apple Mail (macOS)
- [ ] Apple Mail (iOS/iPadOS)
- [ ] Yahoo Mail (Web)
- [ ] Dark mode (iOS Mail, Gmail)

#### Functional Testing
- [ ] All links working
- [ ] Unsubscribe link present and functional
- [ ] Images load (test with images disabled)
- [ ] Preview text displays correctly
- [ ] Mobile responsive (320px to 375px)
- [ ] Touch targets minimum 44px
- [ ] Buttons work in Outlook (VML)

#### Spam Testing
- [ ] Check spam score (mail-tester.com)
- [ ] No spam trigger words
- [ ] Proper unsubscribe link
- [ ] Text-to-image ratio balanced
- [ ] Valid SPF/DKIM/DMARC records

---

## Common Pitfalls

### 1. Using `<div>` Instead of `<table>`
❌ **Problem**: Divs with flexbox/grid don't work in most email clients  
✅ **Solution**: Use nested tables for layout

### 2. External CSS or `<style>` Only
❌ **Problem**: Many clients strip `<style>` tags or external CSS  
✅ **Solution**: Inline all critical styles

### 3. Margin for Spacing
❌ **Problem**: Margin poorly supported, especially in Outlook  
✅ **Solution**: Use padding on `<td>` or empty spacer cells

### 4. Missing Alt Text
❌ **Problem**: When images disabled, no context  
✅ **Solution**: Always include descriptive alt text

### 5. Relative URLs
❌ **Problem**: Images/links won't work when email is forwarded  
✅ **Solution**: Always use absolute HTTPS URLs

### 6. No Mobile Optimization
❌ **Problem**: Email unreadable on mobile (35% of users!)  
✅ **Solution**: Use media queries and fluid tables

### 7. Over 102KB HTML
❌ **Problem**: Gmail clips message  
✅ **Solution**: Optimize HTML, use image references not inline images

### 8. Forgetting Unsubscribe Link
❌ **Problem**: Legal violation (CAN-SPAM, GDPR)  
✅ **Solution**: Always include visible unsubscribe link

---

## Quick Reference Table

| Feature | Outlook Desktop | Outlook.com | Gmail | Apple Mail | Yahoo |
|---------|----------------|-------------|-------|------------|-------|
| Table layout | ✅ | ✅ | ✅ | ✅ | ✅ |
| Inline CSS | ✅ | ✅ | ✅ | ✅ | ✅ |
| Border radius | ❌ | ✅ | ✅ | ✅ | ✅ |
| Background images | ❌ (VML) | ✅ | ⚠️ | ✅ | ⚠️ |
| Web fonts | ❌ | ⚠️ | ❌ | ✅ | ❌ |
| Media queries | ❌ | ✅ | ✅ | ✅ | ✅ |
| GIF animations | ⚠️ | ✅ | ✅ | ✅ | ✅ |

---

## Resources

- [Can I Email](https://www.caniemail.com/) - CSS feature support by client
- [Litmus](https://litmus.com/) - Email testing platform
- [Email on Acid](https://www.emailonacid.com/) - Email testing platform
- [Mail-Tester](https://www.mail-tester.com/) - Spam score checker
- [HTML Email Boilerplate](https://htmlemailboilerplate.com/) - Starting template
- [Campaign Monitor CSS Guide](https://www.campaignmonitor.com/css/) - CSS support table

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2024-03-24 | Rewritten as generic compatibility guide |
| 1.0 | 2024-03-18 | Initial documentation |
