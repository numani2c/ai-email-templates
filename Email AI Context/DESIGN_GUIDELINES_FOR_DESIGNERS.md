# Email Design Guidelines for Figma → HTML Conversion

## Purpose

This document provides comprehensive guidelines for designers creating email templates in Figma that will be converted to production-ready HTML. Following these guidelines ensures pixel-perfect, responsive conversions with maximum AI compatibility.

---

## 📐 Design Specifications

### Canvas & Artboard Setup

#### Desktop View (Primary)
- **Width:** 600px (fixed)
- **Height:** Auto (based on content)
- **Background:** #f4f4f4 (wrapper) or #ffffff (email content)

**Why 600px?**
- Universal email client standard
- Works across all devices
- Fits small screens without horizontal scroll

#### Mobile View (Optional Preview)
- **Width:** 320px - 375px
- **Purpose:** Visual reference only (not exported)
- Use to test how modules will stack on mobile

---

## 🎨 Layout Structure

### Grid System

**Use 8px Grid:**
- All spacing should be multiples of 8px (8, 16, 24, 32, 40, 48, 56, 64, etc.)
- Maintains consistent rhythm
- Easier for developers to implement

**Container Padding:**
- Desktop: 40-50px left/right
- Mobile: 20px left/right (annotate in design)

**Vertical Spacing:**
- Between sections: 40-64px
- Within sections: 16-32px
- Around text: 8-16px

---

## 📦 Module-Based Layout

### Design in Modules

**Think of your email as stackable blocks:**

```
┌─────────────────────┐
│   MODULE 1: HERO    │  ← 600px wide
├─────────────────────┤
│   MODULE 2: BODY    │  ← 600px wide
├─────────────────────┤
│   MODULE 3: CTA     │  ← 600px wide
├─────────────────────┤
│   MODULE 4: FOOTER  │  ← 600px wide
└─────────────────────┘
```

**Each module should:**
- Be self-contained
- Have clear padding/spacing
- Work independently
- Be named clearly in Figma layers

---

## 🖼️ Images & Graphics

### Critical Image Rules

#### ✅ DO:

**1. Use Explicit Dimensions**
- Every image must have clear width × height
- Example: Logo = 238×40px
- Use whole numbers only (no decimals)

**2. Export-Ready Assets**
- Place images in frames with exact dimensions
- Name descriptively: `hero-background`, `logo-white`, `icon-linkedin`
- Use proper layer names (not "Rectangle 1")

**3. Provide @2x Assets**
- Design at actual size (e.g., 238×40px)
- Export at 2x (e.g., 476×80px)
- Developer will scale down in HTML

**4. For "Background" Images:**
- Create as full-width image layer (600px wide)
- Place content overlay in separate layers above
- Use proper layer stacking
- Annotate: "Background image - overlay content"

#### ❌ DON'T:

- ❌ Use CSS filters/effects (drop shadows, blurs)
- ❌ Rely on blend modes
- ❌ Use absolute positioning randomly
- ❌ Create images with unclear boundaries
- ❌ Use decorative elements that require position: absolute

---

## 🎯 Component Guidelines

### Text & Typography

#### Font Selection
**✅ Use Web-Safe Fonts:**
- **Sans-serif:** Arial, Helvetica, Verdana
- **Serif:** Georgia, Times New Roman
- **Monospace:** Courier New

**⚠️ Custom Fonts:**
If you must use custom fonts:
1. Document the web-safe fallback
2. Example: "Inter → Arial" or "Playfair → Georgia"
3. Expect conversion to use fallback

#### Text Styling
```
Headline:
- Font: Arial Bold
- Size: 28-36px
- Line height: 1.1-1.2 (close to font size)
- Color: High contrast (#000000 or #FFFFFF)
- Letter spacing: -0.5 to -1.5px (optional)

Body Text:
- Font: Arial Regular
- Size: 14-16px
- Line height: 1.5 (24px for 16px font)
- Color: #333333 or similar dark gray
- No letter spacing (or very minimal)

Small Text (Footer):
- Font: Arial Regular
- Size: 12-14px
- Line height: 1.5-1.8
- Color: #666666 or #999999
```

---

### Logos

#### Composite Logos (Multi-Part)

**If your logo has multiple elements (icon + text):**

```
┌──────┬────────────────────┐
│ Icon │ Banking Payments   │  ← Total: 223px wide
│ 65px │ 158px              │
└──────┴────────────────────┘
```

**In Figma:**
1. Create separate layers for each part
2. Group them together
3. Name: `Logo / Icon` and `Logo / Text`
4. Maintain 8-10px gap between elements
5. **Document dimensions of each part**

**Why?** Email clients need each part as separate images in table cells.

---

### Buttons

#### Bulletproof Button Specs

```
Button Anatomy:
┌─────────────────────────┐
│     Button Text         │  ← Height: 44-48px
│  Padding: 14-16px V     │     Min width: 180px
│  Padding: 32-40px H     │     Font: 14-16px Bold
└─────────────────────────┘
```

**Requirements:**
- **Height:** 44-48px (minimum touch target)
- **Padding:** Vertical 14-16px, Horizontal 32-40px
- **Background:** Solid color (no gradients for primary CTA)
- **Text:** Centered, Bold, High contrast
- **Border Radius:** 4-8px (simple corners work best)
- **No icons:** If icon needed, place separately

**Hover State:** Not applicable in email (optional to design)

---

### Spacing & Alignment

#### Padding Guidelines

```
Module Padding:
┌─────────────────────────────────────┐
│  ↕ 40-64px (top)                    │
│  ↔ 40-50px │  Content   │ ↔ 40-50px │
│  ↕ 40-64px (bottom)                 │
└─────────────────────────────────────┘
```

**Standard Spacing:**
- Module top/bottom: 40-64px
- Module left/right: 40-50px
- Between paragraphs: 16px
- Around images: 16-24px
- Between heading and body: 12-16px

**Mobile Adjustments:**
- Padding reduces to 20-30px on mobile
- Annotate if specific behavior needed

---

## 🌈 Colors

### Color Requirements

#### Use Exact Hex Values
```
✅ GOOD:
Primary Blue: #1434cb
Text Dark: #000823
Background: #f4f4f4

❌ BAD:
Primary Blue: Opacity 95%
Text Dark: Black with 10% transparency
```

**Why?** Opacity/transparency doesn't work reliably in email clients.

#### Color Contrast

**WCAG AA Standards:**
- **Text on background:** Minimum 4.5:1 contrast ratio
- **Large text (18px+):** Minimum 3:1 contrast ratio
- **Test using:** WebAIM Contrast Checker

**Common Combinations:**
```
White text on dark blue: #FFFFFF on #1434cb ✅
Dark text on white: #333333 on #FFFFFF ✅
Gray text on light gray: #999999 on #f4f4f4 ⚠️ (check!)
```

---

## 📱 Responsive Design

### Mobile-First Thinking

#### Design Decisions for Responsive:

**1. Stack-able Modules**
```
Desktop (600px):          Mobile (320px):
┌──────┬──────┐          ┌───────────┐
│ Img  │ Text │    →     │   Image   │
│      │      │          ├───────────┤
└──────┴──────┘          │   Text    │
                         └───────────┘
```

**2. Flexible Images**
- Hero images: Full-width (600px)
- Content images: Max 300px wide (allows 2-column on desktop)
- Icons: 20-40px (fixed size)

**3. Text Sizing**
```
Desktop → Mobile:
Headline: 36px → 24px
Subhead: 18px → 16px
Body: 16px → 16px (stays same)
Small: 12px → 12px (stays same)
```

**Annotate in Figma:**
Add a text note: "Mobile: 24px"

---

## 🔍 Annotation Best Practices

### What to Document in Figma

#### Use Figma Comments or Annotations Frame:

**1. Spacing**
```
"Desktop padding: 50px
 Mobile padding: 20px"
```

**2. Responsive Behavior**
```
"On mobile:
 - Stack columns
 - Logo scales to 200px wide
 - Hide decorative elements"
```

**3. Image Details**
```
"Export at 2x (1200×866px)
 Display at 600×433px
 Format: JPG 80% quality"
```

**4. Hover States (Optional)**
```
"Button hover: #0e289a
 (Note: Limited support in email)"
```

**5. Dynamic Content**
```
"Personalization area:
 - {{first_name}}
 - {{company_name}}
 - {{account_balance}}"
```

---

## 🎯 Layer Organization

### Proper Layer Naming

#### ✅ Good Layer Structure:
```
📧 Email Template
  📦 Module 1 - Hero
    🖼️ Hero Background
    📝 Headline
    📝 Subheading
    🏷️ Logo / Icon
    🏷️ Logo / Text
  📦 Module 2 - Body
    📝 Greeting
    📝 Body Text
    📝 Sign-off
  📦 Module 3 - CTA
    🔘 Button / Background
    📝 Button / Text
  📦 Module 4 - Footer
    🏷️ Footer Logo
    🔗 Social Icons
    📝 Copyright
```

#### ❌ Bad Layer Names:
- Rectangle 134
- Group 47
- Frame 6
- Ellipse 29

**Why Good Names Matter:**
- AI can identify elements easily
- Developers understand structure
- Easier handoff and maintenance

---

## 🚫 Common Mistakes to Avoid

### Design Anti-Patterns

#### 1. ❌ Complex Layering
```
❌ DON'T:
- 10 overlapping layers
- Blend modes (multiply, overlay)
- Masks with complex shapes

✅ DO:
- Flat, simple layers
- Clear hierarchy
- Export complex graphics as images
```

#### 2. ❌ Inconsistent Spacing
```
❌ DON'T:
- 15px, 23px, 37px, 19px spacing

✅ DO:
- 16px, 24px, 32px, 40px (multiples of 8)
```

#### 3. ❌ Decimal Dimensions
```
❌ DON'T:
- Logo: 237.5 × 39.7px
- Image: 298.3 × 214.8px

✅ DO:
- Logo: 238 × 40px
- Image: 300 × 215px
```

#### 4. ❌ Relying on Figma Features
```
❌ DON'T:
- Auto Layout with complex rules
- Component variants with 10+ states
- Figma-specific effects

✅ DO:
- Simple frames
- Clear positioning
- Export-ready assets
```

#### 5. ❌ Unclear Dimensions
```
❌ DON'T:
- Scaled objects (120% of original)
- Rotated rectangles
- Cropped images without clear bounds

✅ DO:
- Actual size objects
- Straight rectangles
- Properly sized image frames
```

---

## ✅ Pre-Handoff Checklist

### Before Sharing with Developers

#### Design Review:
- [ ] All text uses web-safe fonts (or documented fallbacks)
- [ ] All spacing uses 8px increments
- [ ] All images have exact dimensions (whole numbers)
- [ ] All colors are solid hex values (no transparency)
- [ ] Modules are clearly separated and named
- [ ] Background colors are explicitly defined
- [ ] Mobile responsive behavior is annotated

#### Layer Organization:
- [ ] Layers are named descriptively
- [ ] Image assets are properly sized
- [ ] Logo parts are separated (if applicable)
- [ ] Social icons are individual layers
- [ ] No hidden or overlapping elements

#### Specifications:
- [ ] Document created with module breakdown
- [ ] Spacing annotations added
- [ ] Mobile behavior documented
- [ ] Image export requirements listed
- [ ] Dynamic content areas marked

#### Export Preparation:
- [ ] All image assets identified
- [ ] Asset naming convention documented
- [ ] @2x export sizes calculated
- [ ] File format specified (PNG/JPG)
- [ ] Compression settings noted

---

## 📊 Module Templates

### Common Email Modules

#### 1. Hero Module
```
Structure:
┌─────────────────────────────────┐
│ 🖼️ Background Image (600×400px)│
│  ┌─────────────────────────┐   │
│  │ 🏷️ Logo (238×40px)      │   │
│  │ 📝 Headline              │   │
│  │ 📝 Subheading            │   │
│  │ 🔘 CTA Button (optional) │   │
│  └─────────────────────────┘   │
└─────────────────────────────────┘

Specs:
- Background: 600px width, 350-500px height
- Padding: 50px all sides
- Logo: Top-left, 40-50px from edges
- Headline: 32-40px, Bold, White
- Content should overlay image
```

#### 2. Body Content Module
```
Structure:
┌─────────────────────────────────┐
│  Padding: 40-50px               │
│  ┌───────────────────────────┐  │
│  │ 📝 Greeting (Hi {{name}}) │  │
│  │ 📝 Paragraph text         │  │
│  │ 📝 Paragraph text         │  │
│  │ 📝 Sign-off               │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘

Specs:
- Background: #ffffff
- Text: 16px, #333333
- Line height: 24px
- Paragraph spacing: 16px
```

#### 3. CTA Module
```
Structure:
┌─────────────────────────────────┐
│        Center-aligned            │
│  ┌───────────────────────────┐  │
│  │ 📝 Pre-heading (optional) │  │
│  │ 📝 CTA Headline           │  │
│  │ 🔘 Primary Button         │  │
│  │ 📝 Supporting text        │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘

Specs:
- Padding: 64px top/bottom
- Button: Centered, 200-240px wide
- Button height: 48px
- Button radius: 8px
```

#### 4. Footer Module
```
Structure:
┌─────────────────────────────────┐
│ 🏷️ Logo    [Social Icons] 🔗  │
│ ───────────────────────────────  │
│     📝 Copyright Text            │
│     📝 Unsubscribe Link          │
│     📝 Physical Address          │
└─────────────────────────────────┘

Specs:
- Padding: 40px
- Logo: 150-180px wide
- Social icons: 20×20px, 10-12px spacing
- Text: 12px, #666666
- Links: Underlined
```

---

## 🎨 Design System Integration

### Tokens & Variables

#### Use Figma Variables (if supported):

**Colors:**
```
Primary/Brand: #1434cb
Primary/Hover: #0e289a
Text/Primary: #000823
Text/Secondary: #666666
Background/Main: #ffffff
Background/Offset: #f4f4f4
Border/Light: #e5e5e5
```

**Spacing:**
```
Space/xs: 8px
Space/sm: 16px
Space/md: 24px
Space/lg: 32px
Space/xl: 40px
Space/2xl: 48px
Space/3xl: 64px
```

**Typography:**
```
Heading/H1: Arial Bold 36px / 38px
Heading/H2: Arial Bold 28px / 32px
Heading/H3: Arial Bold 20px / 24px
Body/Large: Arial Regular 18px / 26px
Body/Medium: Arial Regular 16px / 24px
Body/Small: Arial Regular 14px / 20px
```

**Document these in your design file!**

---

## 📖 Example: Complete Module Spec

### Hero Module Detailed Specification

```markdown
## Module 1: Hero Section

### Visual Design
- Background Image: Race car on blue background
- Overlay Content: Logo, Headline, Subheading
- Color: #1434cb (brand blue)

### Dimensions
- Width: 600px
- Height: 433px
- Padding: 50px (top/bottom/left/right)

### Assets Required
1. Background Image
   - Size: 1200×866px (@2x)
   - Display: 600×433px
   - Format: JPG 80%
   - Name: hero-background.jpg

2. Logo Icon
   - Size: 130×80px (@2x)
   - Display: 65×40px
   - Format: PNG-24
   - Name: logo-icon.png

3. Logo Text
   - Size: 316×46px (@2x)
   - Display: 158×23px
   - Format: PNG-24
   - Name: logo-text.png

### Typography
- Headline: Arial Bold, 36px, #ffffff, -1.44px letter-spacing
- Subheading: Arial Regular, 18px, #ffffff

### Spacing
- Logo to headline: 30px
- Headline to subheading: 12px

### Mobile Behavior
- Height: Auto (let content flow)
- Padding: 30px 20px
- Headline: 24px (reduce from 36px)
- Subheading: 16px (stays same)

### Dynamic Content
- None (static content)
```

---

## 🔗 Handoff Documentation

### Provide to Developers

#### 1. Design Specs Document (Markdown or PDF)
```markdown
# Email Template: [Name]

## Overview
- Type: Marketing / Transactional
- Width: 600px
- Modules: 4 (Hero, Body, CTA, Footer)

## Module Breakdown
[Details for each module...]

## Colors
[List all hex codes...]

## Typography
[List all font styles...]

## Assets
[List all images with specs...]
```

#### 2. Figma Link
- Share with "View Only" access
- Add annotations in Figma
- Use Dev Mode if available

#### 3. Asset Exports
- Provide all images in a ZIP file
- Name according to convention
- Include @1x and @2x versions
- Organize in folders by module

#### 4. Responsive Notes
- Document any special mobile behaviors
- List elements that hide/show
- Note any content reordering

---

## 🎓 Learning Resources

### Understanding Email Design Constraints

**Why Email is Different:**
- No modern CSS (Flexbox, Grid)
- Limited JavaScript (none in most clients)
- Image blocking is common
- Inconsistent rendering across clients
- Mobile vs Desktop differences

**Key Principles:**
1. **Simplicity:** Simpler designs convert better
2. **Hierarchy:** Clear visual structure
3. **Accessibility:** High contrast, readable fonts
4. **Performance:** Optimize image sizes
5. **Testing:** Always preview in multiple clients

---

## 📋 Quick Reference Card

### Design Specifications at a Glance

```
┌─────────────────────────────────────────┐
│ EMAIL DESIGN SPECS                      │
├─────────────────────────────────────────┤
│ Canvas Width: 600px                     │
│ Grid: 8px increments                    │
│ Padding: 40-50px (desktop)              │
│         20px (mobile)                   │
├─────────────────────────────────────────┤
│ FONTS (Web-Safe Only):                  │
│ • Arial, Helvetica, Verdana             │
│ • Georgia, Times New Roman              │
├─────────────────────────────────────────┤
│ IMAGES:                                 │
│ • Whole number dimensions               │
│ • Export @2x size                       │
│ • PNG-24 or JPG 80%                     │
├─────────────────────────────────────────┤
│ COLORS:                                 │
│ • Solid hex values only                 │
│ • No transparency/opacity               │
│ • High contrast (4.5:1 minimum)         │
├─────────────────────────────────────────┤
│ BUTTONS:                                │
│ • Height: 44-48px                       │
│ • Padding: 14-16px V, 32-40px H         │
│ • Simple corners (4-8px radius)         │
├─────────────────────────────────────────┤
│ SPACING:                                │
│ • Use 8px grid (8, 16, 24, 32...)       │
│ • Module padding: 40-50px               │
│ • Between modules: 40-64px              │
└─────────────────────────────────────────┘
```

---

## 🆘 Troubleshooting

### Common Design → Code Issues

#### Problem: "Images look stretched in email"
**Cause:** Decimal dimensions or aspect ratio mismatch
**Solution:** Use exact whole number dimensions, maintain aspect ratio

#### Problem: "Spacing doesn't match design"
**Cause:** Inconsistent spacing, hard to replicate in code
**Solution:** Use 8px grid system consistently

#### Problem: "Logo appears broken"
**Cause:** Composite logo not separated
**Solution:** Separate icon and text into individual layers

#### Problem: "Text looks different"
**Cause:** Custom font not available in email
**Solution:** Use web-safe fonts or document fallbacks clearly

#### Problem: "Layout breaks on mobile"
**Cause:** Fixed widths, no responsive annotations
**Solution:** Design with stacking in mind, annotate mobile behavior

---

## ✅ Success Criteria

### Your Design is Ready When:

- [ ] All spacing uses 8px increments
- [ ] All images have whole number dimensions
- [ ] All fonts are web-safe (or fallbacks documented)
- [ ] All colors are solid hex values
- [ ] Modules are clearly separated and named
- [ ] Layers are organized and named properly
- [ ] Mobile behavior is documented
- [ ] Assets are identified and specified
- [ ] Annotations explain any complex behavior
- [ ] Developer handoff document is complete

---

## 🎯 Real-World Example

See `balance-inquiry-2` or `Inside Payment` folders for examples of properly converted emails that followed these guidelines.

**What makes them successful:**
- Clear module structure
- Proper image dimensions
- Web-safe fonts
- Simple, flat design
- Well-organized layers
- Comprehensive documentation

---

## 📞 Support

**Questions about these guidelines?**
- Email: [connect@i2cinc.com](mailto:connect@i2cinc.com)
- Reference: [EMAIL_AI_CONTEXT.md](./EMAIL_AI_CONTEXT.md) for developer/AI context

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-03-25 | Initial design guidelines for Figma to HTML email conversion |

---

**Remember:** The goal is to create beautiful emails that work reliably across all email clients. When in doubt, choose simplicity over complexity! ✨
