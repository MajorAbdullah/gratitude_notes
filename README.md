# Gratitude Notes

A beautiful and simple Flutter app to help you cultivate gratitude by noting 3 good things daily.

## Features

✨ **Core Features:**
- Write 3 daily gratitude notes
- Daily motivational quotes
- Beautiful calendar view to track your gratitude journey
- Offline-first - all data stored locally
- Dark mode support
- Daily reminders (configurable)

🎁 **Premium Features:**
- Export notes to CSV
- Export notes to Text
- Share individual notes
- Support app development

## Screenshots

(Add screenshots here when publishing to Play Store)

## Technical Stack

- **Framework:** Flutter 3.9.0+
- **State Management:** Riverpod 2.6.1
- **Local Database:** Hive 2.2.3 (NoSQL, offline-first)
- **Architecture:** Clean Architecture with Repository Pattern
- **UI:** Material Design 3

## Project Structure

```
lib/
├── models/              # Data models with Hive adapters
├── services/            # Business logic services
│   ├── database_service.dart
│   ├── motivational_service.dart
│   └── export_service.dart
├── providers/           # Riverpod state management
│   ├── gratitude_provider.dart
│   ├── settings_provider.dart
│   └── theme_provider.dart
├── pages/               # UI screens
│   ├── home_page.dart
│   ├── add_note_page.dart
│   ├── calendar_page.dart
│   └── settings_page.dart
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Android Studio / VS Code
- Android SDK (for Android builds)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd gratitude_notes
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Building for Production

### Android

1. Build APK:
```bash
flutter build apk --release
```

2. Build App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

### Signing the App

Before releasing to Play Store, you need to sign your app:

1. Create a keystore:
```bash
keytool -genkey -v -keystore ~/gratitude-notes-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias gratitude-notes
```

2. Create `android/key.properties`:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=gratitude-notes
storeFile=<path-to-your-keystore>
```

3. Update `android/app/build.gradle.kts` to use the signing config

## State Management

The app uses **Riverpod** for state management with proper lifecycle handling:

- **Providers:** Reactive data streams
- **Repository Pattern:** Clean separation of concerns
- **Hive Box Watchers:** Real-time UI updates

## Database Schema

### GratitudeNote Model
- `id`: String (date-based key)
- `date`: DateTime
- `note1`, `note2`, `note3`: String
- `createdAt`: DateTime
- `updatedAt`: DateTime?

### AppSettings Model
- `isDarkMode`: bool
- `dailyReminder`: bool
- `reminderHour`, `reminderMinute`: int
- `isPremium`: bool
- `premiumPurchaseDate`: DateTime?

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository.

## Roadmap

- [ ] Cloud sync (optional)
- [ ] Multiple gratitude entries per day
- [ ] Mood tracking
- [ ] Statistics and insights
- [ ] Widget support
- [ ] iOS version

---

Made with ❤️ using Flutter
