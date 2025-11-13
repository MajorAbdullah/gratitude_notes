import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/gratitude_note.dart';
import '../providers/gratitude_provider.dart';
import '../providers/settings_provider.dart';
import '../services/export_service.dart';
import 'add_note_page.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final allNotesAsync = ref.watch(allGratitudeNotesProvider);
    final repository = ref.read(gratitudeRepositoryProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'export_csv' || value == 'export_text') {
                if (!settingsRepo.isPremium()) {
                  _showPremiumDialog();
                  return;
                }

                try {
                  final notes = repository.getAllNotes();
                  if (notes.isEmpty) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No notes to export')),
                      );
                    }
                    return;
                  }

                  if (value == 'export_csv') {
                    await ExportService.exportToCSV(notes);
                  } else {
                    await ExportService.exportToText(notes);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error exporting: $e')),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_csv',
                child: Row(
                  children: [
                    Icon(Icons.file_download),
                    SizedBox(width: 12),
                    Text('Export to CSV'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_text',
                child: Row(
                  children: [
                    Icon(Icons.text_snippet),
                    SizedBox(width: 12),
                    Text('Export to Text'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: allNotesAsync.when(
        data: (notes) {
          final notesMap = <DateTime, List<GratitudeNote>>{};
          for (var note in notes) {
            final date = DateTime(note.date.year, note.date.month, note.date.day);
            if (notesMap[date] == null) {
              notesMap[date] = [];
            }
            notesMap[date]!.add(note);
          }

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  eventLoader: (day) {
                    final normalizedDay = DateTime(day.year, day.month, day.day);
                    return notesMap[normalizedDay] ?? [];
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _buildSelectedDayNotes(notesMap),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSelectedDayNotes(Map<DateTime, List<GratitudeNote>> notesMap) {
    if (_selectedDay == null) {
      return const Center(child: Text('Select a day to view notes'));
    }

    final normalizedDay = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    final dayNotes = notesMap[normalizedDay] ?? [];
    final settingsRepo = ref.read(settingsRepositoryProvider);

    if (dayNotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No notes for ${DateFormat('MMM d, yyyy').format(_selectedDay!)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (isSameDay(_selectedDay, DateTime.now()))
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddNotePage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Today\'s Gratitude'),
              ),
          ],
        ),
      );
    }

    final note = dayNotes.first;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay!),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (note.isComplete)
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  ],
                ),
                const Divider(height: 24),
                _buildNoteItem(context, 1, note.note1),
                const SizedBox(height: 12),
                _buildNoteItem(context, 2, note.note2),
                const SizedBox(height: 12),
                _buildNoteItem(context, 3, note.note3),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isSameDay(_selectedDay, DateTime.now()))
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNotePage(existingNote: note),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    TextButton.icon(
                      onPressed: () async {
                        if (!settingsRepo.isPremium()) {
                          _showPremiumDialog();
                          return;
                        }
                        try {
                          await ExportService.shareNote(note);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error sharing: $e')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteItem(BuildContext context, int number, String note) {
    if (note.isEmpty) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Text('$number'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Not filled',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            '$number',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            note,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          'Export and sharing features are available in the Premium version. '
          'Upgrade to Premium to unlock these features and support the development!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to settings to purchase premium
              // This will be handled in settings page
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}
