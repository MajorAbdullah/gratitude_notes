# App Icon Setup Guide

## Quick Start

### Option 1: Use Online Icon Generator (Easiest)

1. **Visit an icon generator**:
   - [AppIcon.co](https://www.appicon.co/) - Free, easy to use
   - [Icon Kitchen](https://icon.kitchen/) - Android Studio's tool
   - [MakeAppIcon](https://makeappicon.com/) - Comprehensive

2. **Design your icon**:
   - Upload or create a 1024x1024 PNG
   - Theme: Gratitude, mindfulness, positivity
   - Colors: Purple (#6B4EFF), Gold, White
   - Keep it simple and recognizable at small sizes

3. **Download and extract** the generated icons

4. **Place the main icon**:
   ```bash
   # Place your 1024x1024 icon here:
   assets/logo/app_icon.png
   ```

5. **Update configuration**:
   Edit `flutter_launcher_icons.yaml`:
   ```yaml
   image_path: "assets/logo/app_icon.png"
   ```

6. **Generate icons**:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

---

## Option 2: Create Icon Manually

### Design Recommendations

**Theme**: Gratitude Notes
- Warm, inviting, positive
- Simple and recognizable
- Works well at 48x48 pixels

**Color Palette**:
- Primary: #6B4EFF (Purple - app's primary color)
- Accent: #FFD700 (Gold - gratitude, positivity)
- Background: White or gradient
- Dark mode variant: Consider darker background

**Symbol Ideas**:

1. **Heart + Pen** ❤️✏️
   - Heart shape with a pen/pencil
   - Represents writing with love

2. **Journal with Heart** 📔❤️
   - Open notebook with heart on page
   - Classic gratitude journal look

3. **Three Dots in Circle** ●●●
   - Three dots representing 3 gratitude notes
   - Minimalist and modern

4. **Sunrise/Sunset** 🌅
   - New day, reflection, positivity
   - Warm gradient background

5. **Thankful Hands** 🙏
   - Praying/thankful hands gesture
   - Simple outline style

6. **"G" Monogram**
   - Stylized "G" for Gratitude
   - With decorative elements (leaves, heart, etc.)

### Design Tools

**Free Tools**:
- [Canva](https://canva.com) - Templates + easy editing
- [Figma](https://figma.com) - Professional design tool
- [GIMP](https://gimp.org) - Free Photoshop alternative
- [Inkscape](https://inkscape.org) - Vector graphics

**AI Generators**:
- [Dall-E](https://labs.openai.com/) - Text to image
- [Midjourney](https://midjourney.com/) - AI art
- [Leonardo.ai](https://leonardo.ai/) - Free AI generator

### Icon Specifications

#### Android
- **Size**: 1024x1024 pixels minimum
- **Format**: PNG with transparency
- **Safe area**: Keep important elements within 80% center
- **Adaptive icon**: Foreground + Background layers
- **Shape**: Will be masked (circle, squircle, etc.)

#### File Structure
```
assets/logo/
├── app_icon.png              # 1024x1024 main icon
├── app_icon_foreground.png   # Foreground layer (adaptive)
└── app_icon_background.png   # Background layer (or use color)
```

---

## Option 3: Temporary Placeholder Icon

### Quick SVG-to-PNG Conversion

Use this CSS/HTML to create a simple icon:

```html
<!DOCTYPE html>
<html>
<head>
    <style>
        #icon {
            width: 1024px;
            height: 1024px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 400px;
        }
    </style>
</head>
<body>
    <div id="icon">✨</div>
    <!-- Right click and save as PNG -->
</body>
</html>
```

Save and screenshot to create a simple placeholder.

---

## Adaptive Icons (Android 8.0+)

### What are Adaptive Icons?

Android 8.0+ uses adaptive icons with two layers:
- **Foreground**: Your logo/icon (transparent PNG)
- **Background**: Solid color or image

### Creating Adaptive Icons

1. **Foreground layer**:
   - 1024x1024 PNG with transparency
   - Logo centered within safe area (66% of canvas)
   - Transparent background

2. **Background layer**:
   - Solid color: Use `adaptive_icon_background: "#6B4EFF"`
   - Or image: 1024x1024 PNG (no transparency needed)

3. **Safe area**:
   - Keep important content in center 66%
   - Outer 17% will be masked on different shapes

### Example Configuration

**Simple (color background)**:
```yaml
flutter_launcher_icons:
  android: true
  adaptive_icon_background: "#6B4EFF"
  adaptive_icon_foreground: "assets/logo/app_icon_foreground.png"
```

**Advanced (image background)**:
```yaml
flutter_launcher_icons:
  android: true
  adaptive_icon_background: "assets/logo/app_icon_background.png"
  adaptive_icon_foreground: "assets/logo/app_icon_foreground.png"
```

---

## Step-by-Step: Adding Your Icon

### 1. Prepare Your Icon
- Create or download 1024x1024 PNG
- Ensure transparent background
- Test at small sizes (48x48) for clarity

### 2. Add to Assets
```bash
# Copy your icon to:
cp your_icon.png assets/logo/app_icon.png

# For adaptive icon:
cp your_foreground.png assets/logo/app_icon_foreground.png
```

### 3. Update Configuration

Edit `flutter_launcher_icons.yaml`:

```yaml
flutter_launcher_icons:
  android: true

  # UNCOMMENT AND USE ONE OF THESE:

  # Option A: Single icon (traditional)
  image_path: "assets/logo/app_icon.png"

  # Option B: Adaptive icon (recommended)
  # adaptive_icon_background: "#6B4EFF"
  # adaptive_icon_foreground: "assets/logo/app_icon_foreground.png"
```

### 4. Generate Icons

```bash
# Install dependencies
flutter pub get

# Generate icons
flutter pub run flutter_launcher_icons

# You should see:
# ✓ Successfully generated launcher icons
```

### 5. Verify

```bash
# Check generated icons
ls -la android/app/src/main/res/mipmap-*/ic_launcher.png

# Build and install
flutter build apk --debug
flutter install
```

### 6. Test on Device

- Install the app
- Check home screen icon
- Test different launcher shapes (circle, squircle, etc.)
- Test dark mode icon appearance

---

## Current Temporary Icon

The app currently uses the default Flutter icon. To replace:

1. Create your icon (follow design recommendations above)
2. Place at `assets/logo/app_icon.png`
3. Update `flutter_launcher_icons.yaml`
4. Run: `flutter pub run flutter_launcher_icons`
5. Rebuild the app

---

## Testing Your Icon

### Visual Checklist

- [ ] Recognizable at 48x48 pixels
- [ ] Clear on light backgrounds
- [ ] Clear on dark backgrounds
- [ ] No important details near edges
- [ ] Looks good as circle (Android adaptive)
- [ ] Looks good as squircle (Android adaptive)
- [ ] Matches app's color scheme
- [ ] Professional appearance

### Device Testing

Test on:
- [ ] Multiple Android versions (8.0+, 12+)
- [ ] Different launcher apps (Nova, Pixel Launcher, etc.)
- [ ] Light and dark system themes
- [ ] Different icon shapes (settings → display)

---

## Icon Design Best Practices

### Do's ✅
- Keep it simple and bold
- Use recognizable symbols
- Ensure good contrast
- Test at small sizes
- Use app's color palette
- Make it unique and memorable

### Don'ts ❌
- Don't use fine details
- Don't use text (unless large)
- Don't make it too complex
- Don't ignore safe areas
- Don't use photos
- Don't copy other apps' icons

---

## Quick Icon Templates

### Template 1: Heart + Pen
```
Background: Purple gradient (#6B4EFF to #8B6EFF)
Foreground: White heart outline with pen
Style: Minimalist, modern
```

### Template 2: Three Sparkles
```
Background: Purple (#6B4EFF)
Foreground: Three gold sparkles (✨) in triangle
Style: Simple, elegant
```

### Template 3: Journal
```
Background: Purple gradient
Foreground: White journal icon with heart bookmark
Style: Classic, warm
```

---

## Resources

### Icon Inspiration
- [Dribbble](https://dribbble.com/search/app-icon)
- [Behance](https://behance.net/search/projects?search=app%20icon)
- [Flaticon](https://flaticon.com) - Free icons for inspiration

### Color Tools
- [Coolors.co](https://coolors.co) - Color palette generator
- [ColorHunt](https://colorhunt.co) - Trending palettes
- [Adobe Color](https://color.adobe.com) - Color wheel

### Design Guidelines
- [Material Design Icons](https://material.io/design/iconography)
- [Android App Icons](https://developer.android.com/guide/practices/ui_guidelines/icon_design_launcher)

---

## Troubleshooting

### Icons Not Updating
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons
flutter build apk
```

### Wrong Icon Showing
- Uninstall app completely
- Reinstall fresh build
- Clear launcher cache (varies by device)

### Icons Look Blurry
- Ensure source is 1024x1024 minimum
- Check PNG is not compressed
- Regenerate with higher quality

---

## Need Help?

If you need a custom icon designed:
1. Provide your requirements (style, colors, symbol)
2. Use Fiverr, Upwork, or 99designs
3. Budget: $10-50 for simple icon
4. Delivery: Usually 1-3 days

Or use the online generators for free!

---

Made with ❤️ for Gratitude Notes
