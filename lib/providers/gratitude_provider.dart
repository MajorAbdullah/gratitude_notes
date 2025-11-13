import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/gratitude_note.dart';
import '../services/database_service.dart';

// Provider for the gratitude notes box
final gratitudeBoxProvider = Provider<Box<GratitudeNote>>((ref) {
  return DatabaseService.getGratitudeBox();
});

// Provider for all gratitude notes
final allGratitudeNotesProvider = StreamProvider<List<GratitudeNote>>((ref) {
  final box = ref.watch(gratitudeBoxProvider);

  // Create a stream that emits initial value and then listens to changes
  return Stream.multi((controller) {
    // Emit initial value
    final initialNotes = box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    controller.add(initialNotes);

    // Listen to changes
    final subscription = box.watch().listen((_) {
      final notes = box.values.toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      controller.add(notes);
    });

    // Cleanup
    controller.onCancel = () => subscription.cancel();
  });
});

// Provider for today's gratitude note
final todayGratitudeNoteProvider = StreamProvider<GratitudeNote?>((ref) {
  final box = ref.watch(gratitudeBoxProvider);

  return Stream.multi((controller) {
    // Helper to get today's note
    GratitudeNote? getTodayNote() {
      final today = DateTime.now();
      final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      return box.get(todayKey);
    }

    // Emit initial value
    controller.add(getTodayNote());

    // Listen to changes
    final subscription = box.watch().listen((_) {
      controller.add(getTodayNote());
    });

    // Cleanup
    controller.onCancel = () => subscription.cancel();
  });
});

// Provider for gratitude notes by month
final gratitudeNotesByMonthProvider = Provider.family<List<GratitudeNote>, DateTime>((ref, date) {
  final box = ref.watch(gratitudeBoxProvider);
  final notes = box.values.where((note) {
    return note.date.year == date.year && note.date.month == date.month;
  }).toList();
  notes.sort((a, b) => a.date.compareTo(b.date));
  return notes;
});

// Repository for CRUD operations
class GratitudeRepository {
  final Box<GratitudeNote> _box;

  GratitudeRepository(this._box);

  Future<void> saveNote(GratitudeNote note) async {
    await _box.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  GratitudeNote? getNote(String id) {
    return _box.get(id);
  }

  GratitudeNote? getTodayNote() {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return _box.get(todayKey);
  }

  List<GratitudeNote> getAllNotes() {
    final notes = _box.values.toList();
    notes.sort((a, b) => b.date.compareTo(a.date));
    return notes;
  }

  List<GratitudeNote> getNotesByDateRange(DateTime start, DateTime end) {
    return _box.values.where((note) {
      return note.date.isAfter(start.subtract(const Duration(days: 1))) &&
          note.date.isBefore(end.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  int getTotalNotesCount() {
    return _box.length;
  }

  int getCompletedNotesCount() {
    return _box.values.where((note) => note.isComplete).length;
  }
}

// Provider for the repository
final gratitudeRepositoryProvider = Provider<GratitudeRepository>((ref) {
  final box = ref.watch(gratitudeBoxProvider);
  return GratitudeRepository(box);
});
