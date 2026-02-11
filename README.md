# Gratitude Notes

**A daily journaling app to cultivate gratitude, built with Flutter**

Gratitude Notes helps you build a positive daily habit by recording three things you are grateful for each day. It features a beautiful calendar view to track your journey, daily motivational quotes, dark mode support, configurable reminders, and optional premium features for exporting and sharing your notes.

---

## Features

### Core
- Write 3 daily gratitude notes to reflect on your day
- Daily motivational quotes for encouragement
- Calendar view to track your gratitude streak and browse past entries
- Offline-first design with all data stored locally via Hive (NoSQL)
- Dark mode support with theme persistence
- Configurable daily reminders with local notifications
- Onboarding flow for first-time users
- Splash screen with native splash support

### Premium
- Export notes to CSV format
- Export notes to plain text
- Share individual notes directly from the app
- In-app purchase integration for unlocking premium features

---

## Tech Stack

![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2.6-00B0FF?style=for-the-badge)
![Hive](https://img.shields.io/badge/Hive-2.2-FFCA28?style=for-the-badge)
![Material Design 3](https://img.shields.io/badge/Material_Design-3-757575?style=for-the-badge&logo=materialdesign&logoColor=white)

| Component | Technology |
|-----------|-----------|
| Framework | Flutter 3.9+ / Dart SDK ^3.9.0 |
| State Management | flutter_riverpod 2.6.1 |
| Local Database | Hive 2.2.3 + hive_flutter |
| Calendar Widget | table_calendar 3.1.2 |
| Notifications | flutter_local_notifications 18.0.1 |
| Export (CSV) | csv 6.0.0 |
| Sharing | share_plus 10.1.2 |
| In-App Purchases | in_app_purchase 3.2.0 |
| Architecture | Clean Architecture with Repository Pattern |

---

## Getting Started

### Prerequisites

- Flutter SDK 3.9.0 or higher
- Dart SDK ^3.9.0
- Android Studio or VS Code with Flutter extensions
- Android SDK (for Android builds)

### Installation

```bash
# Clone the repository
git clone https://github.com/MajorAbdullah/gratitude_notes.git
cd gratitude_notes

# Install dependencies
flutter pub get

# Generate Hive type adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

---

## Project Structure

```
lib/
├── main.dart                       # App entry point, initialization
├── models/
│   ├── gratitude_note.dart         # GratitudeNote data model with Hive adapter
│   └── app_settings.dart           # AppSettings model (theme, reminders, premium)
├── services/
│   ├── database_service.dart       # Hive database initialization and access
│   ├── motivational_service.dart   # Daily motivational quotes provider
│   ├── export_service.dart         # CSV and text export logic
│   ├── notification_service.dart   # Local notification scheduling
│   └── onboarding_service.dart     # First-launch onboarding state
├── providers/
│   ├── gratitude_provider.dart     # Riverpod provider for gratitude notes
│   ├── settings_provider.dart      # Riverpod provider for app settings
│   └── theme_provider.dart         # Riverpod provider for theme management
└── pages/
    ├── splash_page.dart            # Splash screen
    ├── onboarding_page.dart        # Onboarding flow for new users
    ├── home_page.dart              # Main screen with daily notes
    ├── add_note_page.dart          # Note creation / editing screen
    ├── calendar_page.dart          # Calendar view of past entries
    └── settings_page.dart          # Settings (theme, reminders, premium, export)
```

---

## Usage

1. **Launch the app** -- the onboarding flow guides you through the concept on first launch.
2. **Write your notes** -- tap the add button to record 3 things you are grateful for today.
3. **Browse your history** -- use the calendar view to see which days you have written entries.
4. **Set reminders** -- configure a daily reminder time in Settings to stay consistent.
5. **Export or share** -- premium users can export all notes to CSV/text or share individual entries.

---

## Building for Production

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle (Play Store)

```bash
flutter build appbundle --release
```

### App Signing

Before publishing to the Play Store, create a keystore and configure signing:

```bash
keytool -genkey -v -keystore ~/gratitude-notes-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias gratitude-notes
```

Create `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=gratitude-notes
storeFile=<path-to-your-keystore>
```

Then update `android/app/build.gradle.kts` to reference the signing configuration.

---

## Data Models

### GratitudeNote

| Field | Type | Description |
|-------|------|-------------|
| id | String | Date-based unique key |
| date | DateTime | Entry date |
| note1, note2, note3 | String | The three gratitude notes |
| createdAt | DateTime | Creation timestamp |
| updatedAt | DateTime? | Last modification timestamp |

### AppSettings

| Field | Type | Description |
|-------|------|-------------|
| isDarkMode | bool | Dark theme toggle |
| dailyReminder | bool | Reminder enabled flag |
| reminderHour, reminderMinute | int | Scheduled reminder time |
| isPremium | bool | Premium unlock status |
| premiumPurchaseDate | DateTime? | When premium was purchased |

---

## Roadmap

- [ ] Cloud sync (optional)
- [ ] Multiple gratitude entries per day
- [ ] Mood tracking
- [ ] Statistics and insights
- [ ] Home screen widget support
- [ ] iOS release

---

## License

MIT License -- see the LICENSE file for details.

## Author

**Syed Abdullah Shah** -- [@MajorAbdullah](https://github.com/MajorAbdullah)
