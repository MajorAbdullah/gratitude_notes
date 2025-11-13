# App Icon Setup - Quick Start Guide

## 🎯 Quick Setup (3 Steps)

### Step 1: Create Your Icon

Choose ONE option:

#### Option A: Use the HTML Icon Creator (Easiest!) ⭐
1. Open `assets/logo/create_simple_icon.html` in your web browser
2. Customize the emoji and gradient color
3. Right-click on the large icon → "Save Image As..."
4. Save as `app_icon.png` in the `assets/logo/` folder

#### Option B: Use an Online Generator
- Visit [AppIcon.co](https://www.appicon.co/)
- Upload or design a 1024x1024 icon
- Download and save as `assets/logo/app_icon.png`

#### Option C: Design Your Own
- Create a 1024x1024 PNG in Canva, Figma, or Photoshop
- Use the app's purple color: #6B4EFF
- Save as `assets/logo/app_icon.png`

---

### Step 2: Update Configuration

Edit `flutter_launcher_icons.yaml` and uncomment this line:

```yaml
flutter_launcher_icons:
  android: true
  ios: false

  # UNCOMMENT THIS LINE:
  image_path: "assets/logo/app_icon.png"

  # OR for adaptive icon (recommended):
  # adaptive_icon_background: "#6B4EFF"
  # adaptive_icon_foreground: "assets/logo/app_icon_foreground.png"
```

---

### Step 3: Generate Icons

Run these commands:

```bash
# Get dependencies (if you haven't already)
flutter pub get

# Generate all icon sizes
flutter pub run flutter_launcher_icons

# Rebuild the app
flutter build apk --debug
```

---

## ✅ Verification

After installation, check:
- [ ] Icon appears on home screen
- [ ] Icon looks clear at small size
- [ ] Icon matches app branding
- [ ] Icon works in dark mode

---

## 🎨 Design Recommendations

### App Theme
- **Primary Color**: #6B4EFF (Purple)
- **Style**: Minimal, modern, warm
- **Theme**: Gratitude, positivity, mindfulness

### Symbol Ideas
1. ✨ **Sparkle** - Magic, positivity (current default)
2. ❤️ **Heart** - Love, gratitude
3. 📝 **Note** - Writing, journaling
4. 🙏 **Hands** - Thankfulness, prayer
5. 📔 **Journal** - Classic gratitude journal

### Best Practices
- Keep it simple and recognizable
- Test at 48x48 pixels
- Use high contrast
- Avoid fine details
- Make it unique

---

## 🔧 Troubleshooting

### Icon Not Updating?
```bash
# Clean everything
flutter clean

# Reinstall packages
flutter pub get

# Regenerate icons
flutter pub run flutter_launcher_icons

# Full rebuild
flutter build apk --debug

# Uninstall old app and reinstall
```

### Icon Looks Blurry?
- Ensure source image is at least 1024x1024
- Use PNG format (not JPEG)
- Don't compress the image

### Wrong Icon Showing?
- Uninstall the app completely from device
- Clear launcher cache
- Reinstall with new build

---

## 📚 Full Documentation

For detailed instructions, design guidelines, and advanced options:
- See [assets/logo/APP_ICON_GUIDE.md](assets/logo/APP_ICON_GUIDE.md)
- See [assets/logo/LOGO_GUIDE.md](assets/logo/LOGO_GUIDE.md)

---

## 🚀 Current Status

The app currently uses the **default Flutter icon**.

Once you add your custom icon:
1. Place `app_icon.png` in `assets/logo/`
2. Update `flutter_launcher_icons.yaml`
3. Run `flutter pub run flutter_launcher_icons`
4. Rebuild and install

---

## 💡 Quick Tips

- Use the HTML creator for instant results
- Purple (#6B4EFF) matches the app theme perfectly
- The ✨ sparkle emoji works great as a placeholder
- Adaptive icons look better on modern Android devices
- Test your icon at multiple sizes before finalizing

---

**Ready to create your icon?**
Open `assets/logo/create_simple_icon.html` in your browser and start customizing! 🎨
