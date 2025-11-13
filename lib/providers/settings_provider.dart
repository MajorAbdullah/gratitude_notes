import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_settings.dart';
import '../services/database_service.dart';

// Provider for the settings box
final settingsBoxProvider = Provider<Box<AppSettings>>((ref) {
  return DatabaseService.getSettingsBox();
});

// Provider for app settings
final appSettingsProvider = StreamProvider<AppSettings>((ref) {
  final box = ref.watch(settingsBoxProvider);

  return Stream.multi((controller) {
    // Helper to get settings
    AppSettings getSettings() {
      return box.get(DatabaseService.settingsKey) ?? AppSettings.getDefault();
    }

    // Emit initial value
    controller.add(getSettings());

    // Listen to changes
    final subscription = box.watch(key: DatabaseService.settingsKey).listen((_) {
      controller.add(getSettings());
    });

    // Cleanup
    controller.onCancel = () => subscription.cancel();
  });
});

// Repository for settings operations
class SettingsRepository {
  final Box<AppSettings> _box;

  SettingsRepository(this._box);

  AppSettings getSettings() {
    return _box.get(DatabaseService.settingsKey) ?? AppSettings.getDefault();
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _box.put(DatabaseService.settingsKey, settings);
  }

  Future<void> toggleDarkMode() async {
    final settings = getSettings();
    settings.isDarkMode = !settings.isDarkMode;
    await settings.save();
  }

  Future<void> toggleDailyReminder() async {
    final settings = getSettings();
    settings.dailyReminder = !settings.dailyReminder;
    await settings.save();
  }

  Future<void> setReminderTime(int hour, int minute) async {
    final settings = getSettings();
    settings.reminderHour = hour;
    settings.reminderMinute = minute;
    await settings.save();
  }

  Future<void> activatePremium() async {
    final settings = getSettings();
    settings.isPremium = true;
    settings.premiumPurchaseDate = DateTime.now();
    await settings.save();
  }

  bool isPremium() {
    return getSettings().isPremium;
  }
}

// Provider for the repository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return SettingsRepository(box);
});
