# Google Play Store Publishing Guide

This guide will help you publish your Gratitude Notes app to the Google Play Store.

## Pre-requisites

1. **Google Play Console Account**
   - Go to [Google Play Console](https://play.google.com/console)
   - Pay the one-time $25 registration fee
   - Complete your account setup

2. **App Assets Ready**
   - App icon (512x512 PNG)
   - Feature graphic (1024x500 PNG)
   - Screenshots (at least 2, max 8)
   - Privacy policy URL (if collecting user data)

## Step 1: Create Signing Key

Generate a keystore for signing your app:

```bash
keytool -genkey -v -keystore ~/gratitude-notes-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias gratitude-notes
```

**IMPORTANT:** Save your keystore file and passwords securely. You cannot recover them if lost!

## Step 2: Configure Signing in Android

1. Create `android/key.properties` (this file is gitignored):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=gratitude-notes
storeFile=/path/to/gratitude-notes-release.jks
```

2. Update `android/app/build.gradle.kts`:

Add before the `android` block:

```kotlin
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

Inside the `android` block, add signingConfigs before `buildTypes`:

```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}
```

Update the release buildType:

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")

        // Enable code shrinking
        isMinifyEnabled = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

## Step 3: Build Release App Bundle

Build the app bundle (AAB) for Play Store:

```bash
flutter build appbundle --release
```

The output will be at: `build/app/outputs/bundle/release/app-release.aab`

## Step 4: Create App in Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app"
3. Fill in the details:
   - App name: **Gratitude Notes**
   - Default language: English (US)
   - App or game: App
   - Free or paid: Free
   - Declarations: Check all boxes after reading

## Step 5: Set Up Store Listing

### App Details
- **App name:** Gratitude Notes
- **Short description:** (80 characters max)
  "Cultivate gratitude daily by noting 3 good things. Offline, simple, beautiful."

- **Full description:** (4000 characters max)
```
Transform your life through the power of gratitude! Gratitude Notes helps you build a positive mindset by encouraging you to write down 3 good things each day.

✨ KEY FEATURES:
• Daily Gratitude Journal - Write 3 things you're grateful for each day
• Motivational Quotes - Get inspired with daily motivational messages
• Beautiful Calendar View - Track your gratitude journey over time
• 100% Offline - All your data stays private on your device
• Dark Mode - Easy on your eyes, day or night
• Daily Reminders - Never miss a day (optional)

🎁 PREMIUM FEATURES:
• Export to CSV - Analyze your gratitude patterns
• Export to Text - Share your journey
• Share Individual Notes - Spread positivity
• Support Development - Help us build more features

📱 WHY GRATITUDE NOTES?
Scientific research shows that practicing gratitude can:
- Improve mental health and happiness
- Reduce stress and anxiety
- Enhance sleep quality
- Strengthen relationships
- Increase resilience

🔒 PRIVACY FIRST:
Your gratitude notes are stored locally on your device. No cloud sync, no data collection, no tracking. Your thoughts remain yours.

💡 SIMPLE & EFFECTIVE:
Based on positive psychology research, the app follows the proven "Three Good Things" exercise. Just 5 minutes a day can make a real difference in your wellbeing.

Start your gratitude journey today!
```

### Graphics
- **App icon:** 512x512 PNG (high-res version of your app icon)
- **Feature graphic:** 1024x500 PNG
- **Phone screenshots:** At least 2, recommended 8
  - Minimum: 320px
  - Maximum: 3840px
  - The maximum dimension can't be more than twice the minimum dimension

### Categorization
- **App category:** Lifestyle
- **Tags:** gratitude, journal, diary, mindfulness, wellness, mental health

### Contact details
- **Email:** Your support email
- **Website:** (Optional)
- **Privacy policy:** Required if collecting user data

## Step 6: Content Rating

1. Go to "Content rating" section
2. Start questionnaire
3. Answer questions honestly (the app should get E for Everyone)
4. Submit for rating

## Step 7: App Content

Complete the following sections:

### Privacy Policy
- If not collecting data: State that in your privacy policy
- Host it on GitHub Pages or your website

### Data Safety
- Declare what data you collect (if any)
- For this app (offline-only):
  - No data collected
  - No data shared
  - Data not encrypted (stored locally)

### Target Audience and Content
- Target age: All ages
- No inappropriate content

### News Apps
- Not applicable

## Step 8: Upload App Bundle

1. Go to "Production" → "Create new release"
2. Upload the AAB file: `build/app/outputs/bundle/release/app-release.aab`
3. Add release notes:

```
Version 1.0.0 - Initial Release

Features:
• Write 3 daily gratitude notes
• Daily motivational quotes
• Beautiful calendar view
• Offline-first design
• Dark mode support
• Daily reminders
• Premium export and sharing features

Start your gratitude journey today!
```

## Step 9: Review and Publish

1. Complete all required sections
2. Review the "Publishing overview" page
3. Click "Send for review"

**Review Time:** Usually 3-7 days for first submission

## Step 10: Post-Launch

### Monitor
- Check Play Console for crashes/ANRs
- Read user reviews
- Monitor ratings

### Update
When releasing updates:
```bash
# Update version in pubspec.yaml
version: 1.0.1+2  # version name + build number

# Build new bundle
flutter build appbundle --release

# Upload to Play Console → Production → Create new release
```

## App Store Optimization (ASO)

### Keywords to Target
- gratitude journal
- daily gratitude
- thankful diary
- positive thinking
- mindfulness app
- wellness journal
- mental health

### Tips
- Respond to user reviews
- Keep updating regularly
- Add seasonal features
- Create promotional graphics
- Run Play Store experiments

## Monetization (Future)

The app includes a premium feature framework. To enable:

1. Set up Google Play Billing in Play Console
2. Create in-app products
3. Update `lib/providers/settings_provider.dart` to integrate real billing
4. Test with test accounts

## Common Issues

### Build Fails
- Ensure all dependencies are up to date
- Check `flutter doctor`
- Clean build: `flutter clean && flutter pub get`

### Upload Rejected
- Check all required sections are complete
- Ensure content rating is done
- Verify privacy policy URL works
- Check app complies with Play Store policies

## Support

For issues or questions:
- Check Flutter documentation: https://docs.flutter.dev
- Play Console help: https://support.google.com/googleplay/android-developer

## Checklist Before Publishing

- [ ] Keystore created and backed up
- [ ] App signed with release key
- [ ] Tested on multiple devices
- [ ] All features working properly
- [ ] Privacy policy created (if needed)
- [ ] Screenshots prepared
- [ ] Feature graphic created
- [ ] App icon ready (512x512)
- [ ] Store listing text written
- [ ] Content rating completed
- [ ] Data safety section filled
- [ ] Release notes written
- [ ] App bundle built and tested

Good luck with your app launch! 🚀
