import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 1)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  bool dailyReminder;

  @HiveField(2)
  int reminderHour;

  @HiveField(3)
  int reminderMinute;

  @HiveField(4)
  bool isPremium;

  @HiveField(5)
  DateTime? premiumPurchaseDate;

  AppSettings({
    this.isDarkMode = false,
    this.dailyReminder = true,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.isPremium = false,
    this.premiumPurchaseDate,
  });

  static AppSettings getDefault() {
    return AppSettings();
  }
}
