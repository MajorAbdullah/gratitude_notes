# Gratitude Notes - App Architecture

## Overview

Gratitude Notes is built with Flutter using clean architecture principles, ensuring maintainability, testability, and scalability.

## Architecture Layers

```
┌─────────────────────────────────────────────┐
│           Presentation Layer                │
│  (Pages, Widgets, UI Components)            │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│         State Management Layer              │
│     (Riverpod Providers & Repositories)     │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│            Business Logic Layer             │
│  (Services: Database, Export, Motivation)   │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│              Data Layer                     │
│        (Models, Hive Database)              │
└─────────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── gratitude_note.dart
│   ├── gratitude_note.g.dart (generated)
│   ├── app_settings.dart
│   └── app_settings.g.dart   (generated)
├── services/                 # Business logic services
│   ├── database_service.dart
│   ├── motivational_service.dart
│   └── export_service.dart
├── providers/                # State management
│   ├── gratitude_provider.dart
│   ├── settings_provider.dart
│   └── theme_provider.dart
└── pages/                    # UI screens
    ├── home_page.dart
    ├── add_note_page.dart
    ├── calendar_page.dart
    └── settings_page.dart
```

## Core Components

### 1. Data Layer

#### Models
**GratitudeNote**
- Stores daily gratitude entries
- Uses Hive for persistence
- TypeAdapter generated via build_runner

**AppSettings**
- User preferences
- Theme settings
- Premium status
- Reminder configuration

#### Database Service
- Initializes Hive
- Registers type adapters
- Manages box lifecycle
- Provides access to data boxes

### 2. Business Logic Layer

#### Services
**DatabaseService**
- Hive initialization and configuration
- Box management
- Data persistence setup

**MotivationalService**
- 30+ motivational quotes
- Daily message generation (date-seeded random)
- Consistent messages per day

**ExportService**
- CSV export (premium)
- Text export (premium)
- Individual note sharing (premium)
- Uses system share dialog

### 3. State Management Layer

#### Riverpod Providers

**Provider Pattern Benefits:**
- Compile-time safety
- No runtime errors
- Easy testing
- Automatic disposal
- Reactive updates

**Key Providers:**

1. **gratitudeBoxProvider**
   - Provides access to Hive box
   - Foundation for other providers

2. **allGratitudeNotesProvider** (StreamProvider)
   - Watches Hive box for changes
   - Returns sorted list of all notes
   - Auto-updates UI on data changes

3. **todayGratitudeNoteProvider** (StreamProvider)
   - Returns today's note (if exists)
   - Real-time updates

4. **gratitudeRepositoryProvider**
   - CRUD operations
   - Business logic for notes
   - Data validation

5. **appSettingsProvider** (StreamProvider)
   - User settings
   - Theme preferences
   - Premium status

6. **themeProvider**
   - Dynamic theme switching
   - Light/Dark mode
   - Material Design 3

### 4. Presentation Layer

#### Pages

**HomePage**
- Today's gratitude display
- Motivational quote
- Statistics
- Quick navigation

**AddNotePage**
- Form for 3 gratitude entries
- Validation
- Create/Edit functionality

**CalendarPage**
- Monthly calendar view
- Entry indicators
- Historical data viewing
- Export functionality

**SettingsPage**
- Theme toggle
- Reminder settings
- Premium upgrade
- Statistics

## State Management Flow

```
User Action
    ↓
UI Event (onPressed, etc.)
    ↓
Repository Method Call
    ↓
Hive Database Operation
    ↓
Hive Box Stream Emits
    ↓
Provider Watches Stream
    ↓
Widget Rebuilds
    ↓
UI Updates
```

## Lifecycle Management

### App Lifecycle
1. **main()** - App initialization
2. **DatabaseService.initialize()** - Hive setup
3. **ProviderScope** - State management container
4. **MyApp** - Root widget with theme
5. **HomePage** - Initial route

### Widget Lifecycle
- ConsumerWidget/ConsumerStatefulWidget
- Automatic provider disposal
- Proper mounted checks for async operations
- Stream subscriptions managed by Riverpod

### Database Lifecycle
- Hive initialized at app start
- Boxes remain open during app lifetime
- Auto-saves on changes
- Graceful shutdown on app close

## Data Flow Patterns

### Read Operation
```dart
// 1. Provider declaration
final todayNoteProvider = StreamProvider<GratitudeNote?>((ref) {
  final box = ref.watch(gratitudeBoxProvider);
  return box.watch().map((_) => /* logic */);
});

// 2. Widget consumption
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(todayNoteProvider);

    return noteAsync.when(
      data: (note) => /* UI with data */,
      loading: () => /* loading state */,
      error: (e, s) => /* error state */,
    );
  }
}
```

### Write Operation
```dart
// 1. Get repository
final repository = ref.read(gratitudeRepositoryProvider);

// 2. Perform operation
await repository.saveNote(note);

// 3. Hive automatically notifies watchers
// 4. UI updates automatically
```

## Offline-First Design

### Why Offline?
- Privacy: data never leaves device
- Speed: instant operations
- Reliability: no network dependency
- Security: no server to hack

### Implementation
- **Hive Database**: NoSQL, fast, local
- **No API calls**: completely offline
- **No authentication**: no user accounts needed
- **Data isolation**: per-device storage

## Premium Feature Architecture

### Current Implementation
```dart
// Settings Repository
bool isPremium() {
  return getSettings().isPremium;
}

// UI Check
if (!settingsRepo.isPremium()) {
  showPremiumDialog();
  return;
}
```

### Future: In-App Purchase Integration
```dart
// 1. Add in_app_purchase configuration
// 2. Create product IDs in Play Console
// 3. Implement purchase flow
// 4. Verify purchases
// 5. Update premium status
```

## Performance Optimizations

1. **Hive**: Fast key-value storage
2. **Lazy Loading**: StreamProviders only active when watched
3. **Efficient Rebuilds**: Riverpod granular updates
4. **Minimal Dependencies**: Small app size
5. **Material Design 3**: Optimized widgets

## Testing Strategy

### Unit Tests
- Services (motivational, export)
- Repository methods
- Model validation

### Widget Tests
- Individual page functionality
- Form validation
- Navigation

### Integration Tests
- End-to-end user flows
- Database operations
- State management

## Security Considerations

1. **Data Storage**: Local only, no cloud sync
2. **No Network**: No data transmitted
3. **Proguard**: Code obfuscation (when enabled)
4. **No Logging**: Sensitive data not logged
5. **Backup**: Android backup rules configured

## Scalability

### Current: Single User
- Local database
- Device-specific data
- No sync

### Future Enhancements
- Optional cloud sync (Firebase)
- Multi-device support
- Backup/restore
- Categories/tags
- Mood tracking
- Analytics/insights

## Dependencies

### Production
- **flutter_riverpod**: State management
- **hive/hive_flutter**: Local database
- **table_calendar**: Calendar UI
- **intl**: Date formatting
- **share_plus**: Sharing functionality
- **csv**: CSV generation
- **in_app_purchase**: Premium features (future)

### Development
- **build_runner**: Code generation
- **hive_generator**: Hive adapters
- **flutter_lints**: Code quality

## Best Practices Implemented

1. ✅ Clean Architecture
2. ✅ Repository Pattern
3. ✅ Provider Pattern for State
4. ✅ Reactive Programming (Streams)
5. ✅ Type Safety (Dart)
6. ✅ Code Generation (build_runner)
7. ✅ Material Design 3
8. ✅ Lifecycle Management
9. ✅ Error Handling
10. ✅ Documentation

## Maintenance Guidelines

### Adding a New Feature
1. Create/update model (if needed)
2. Add service logic
3. Create/update provider
4. Build UI
5. Test thoroughly

### Updating Dependencies
```bash
flutter pub outdated
flutter pub upgrade
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```

### Performance Monitoring
- Use DevTools
- Check frame rendering
- Monitor memory usage
- Profile database operations

## Conclusion

This architecture provides:
- **Maintainability**: Clear separation of concerns
- **Testability**: Each layer independently testable
- **Scalability**: Easy to add features
- **Performance**: Optimized for mobile
- **Reliability**: Offline-first design

The app is production-ready and can be extended for future features while maintaining code quality.
