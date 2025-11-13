import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/gratitude_provider.dart';
import '../services/notification_service.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final repository = ref.watch(gratitudeRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            _buildAppearanceSection(context, settings, ref),
            const Divider(),
            _buildNotificationsSection(context, settings, ref),
            const Divider(),
            _buildPremiumSection(context, settings, ref),
            const Divider(),
            _buildStatisticsSection(context, repository),
            const Divider(),
            _buildAboutSection(context),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, settings, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: settings.isDarkMode,
          onChanged: (value) {
            ref.read(settingsRepositoryProvider).toggleDarkMode();
          },
          secondary: Icon(
            settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context, settings, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        SwitchListTile(
          title: const Text('Daily Reminder'),
          subtitle: const Text('Get reminded to write your gratitude notes'),
          value: settings.dailyReminder,
          onChanged: (value) async {
            final notificationService = NotificationService();

            if (value) {
              // Request permission first
              final granted = await notificationService.requestPermissions();
              if (!granted) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification permission denied'),
                    ),
                  );
                }
                return;
              }

              // Schedule notification
              await notificationService.scheduleDailyReminder(
                hour: settings.reminderHour,
                minute: settings.reminderMinute,
              );
            } else {
              // Cancel notification
              await notificationService.cancelDailyReminder();
            }

            // Update setting
            ref.read(settingsRepositoryProvider).toggleDailyReminder();
          },
          secondary: const Icon(Icons.notifications),
        ),
        if (settings.dailyReminder)
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Reminder Time'),
            subtitle: Text(
              '${settings.reminderHour.toString().padLeft(2, '0')}:${settings.reminderMinute.toString().padLeft(2, '0')}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: settings.reminderHour,
                  minute: settings.reminderMinute,
                ),
              );
              if (time != null) {
                // Update time in settings
                await ref.read(settingsRepositoryProvider).setReminderTime(
                      time.hour,
                      time.minute,
                    );

                // Reschedule notification if enabled
                if (settings.dailyReminder) {
                  final notificationService = NotificationService();
                  await notificationService.scheduleDailyReminder(
                    hour: time.hour,
                    minute: time.minute,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reminder updated to ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    );
                  }
                }
              }
            },
          ),
      ],
    );
  }

  Widget _buildPremiumSection(BuildContext context, settings, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Premium',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        if (settings.isPremium)
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              leading: Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              title: Text(
                'Premium Active',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Thank you for your support!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          )
        else
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Upgrade to Premium',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Premium Features:'),
                  const SizedBox(height: 8),
                  _buildFeatureItem(context, 'Export notes to CSV'),
                  _buildFeatureItem(context, 'Export notes to Text'),
                  _buildFeatureItem(context, 'Share individual notes'),
                  _buildFeatureItem(context, 'Support app development'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _handlePremiumPurchase(context, ref),
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Upgrade Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context, repository) {
    final totalNotes = repository.getTotalNotesCount();
    final completedNotes = repository.getCompletedNotesCount();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.note_alt),
          title: const Text('Total Notes'),
          trailing: Text(
            '$totalNotes',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: const Text('Completed Notes'),
          trailing: Text(
            '$completedNotes',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Version'),
          trailing: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('About Gratitude Notes'),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'Gratitude Notes',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.auto_awesome, size: 48),
              children: [
                const Text(
                  'A simple and beautiful app to help you cultivate gratitude by noting 3 good things daily.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _handlePremiumPurchase(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text(
          'For demonstration purposes, premium will be activated immediately. '
          'In production, this would integrate with Google Play Billing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(settingsRepositoryProvider).activatePremium();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Premium activated! Thank you for your support!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }
}
