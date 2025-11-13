import 'package:hive_flutter/hive_flutter.dart';
import '../models/gratitude_note.dart';
import '../models/app_settings.dart';

class DatabaseService {
  static const String gratitudeBoxName = 'gratitude_notes';
  static const String settingsBoxName = 'app_settings';
  static const String settingsKey = 'settings';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(GratitudeNoteAdapter());
    Hive.registerAdapter(AppSettingsAdapter());

    // Open boxes
    await Hive.openBox<GratitudeNote>(gratitudeBoxName);
    await Hive.openBox<AppSettings>(settingsBoxName);

    // Initialize default settings if not exists
    final settingsBox = Hive.box<AppSettings>(settingsBoxName);
    if (settingsBox.get(settingsKey) == null) {
      await settingsBox.put(settingsKey, AppSettings.getDefault());
    }
  }

  static Box<GratitudeNote> getGratitudeBox() {
    return Hive.box<GratitudeNote>(gratitudeBoxName);
  }

  static Box<AppSettings> getSettingsBox() {
    return Hive.box<AppSettings>(settingsBoxName);
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
