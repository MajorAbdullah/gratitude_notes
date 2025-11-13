import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/gratitude_note.dart';

class ExportService {
  static Future<void> exportToCSV(List<GratitudeNote> notes) async {
    if (notes.isEmpty) {
      throw Exception('No notes to export');
    }

    // Prepare CSV data
    List<List<dynamic>> rows = [];

    // Header
    rows.add(['Date', 'Gratitude 1', 'Gratitude 2', 'Gratitude 3', 'Created At']);

    // Data rows
    for (var note in notes) {
      rows.add([
        DateFormat('yyyy-MM-dd').format(note.date),
        note.note1,
        note.note2,
        note.note3,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(note.createdAt),
      ]);
    }

    // Convert to CSV
    String csv = const ListToCsvConverter().convert(rows);

    // Save to file
    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final path = '${directory.path}/gratitude_notes_$timestamp.csv';
    final file = File(path);
    await file.writeAsString(csv);

    // Share the file
    await Share.shareXFiles(
      [XFile(path)],
      subject: 'My Gratitude Notes',
      text: 'Sharing my gratitude journey!',
    );
  }

  static Future<void> exportToText(List<GratitudeNote> notes) async {
    if (notes.isEmpty) {
      throw Exception('No notes to export');
    }

    // Prepare text content
    StringBuffer buffer = StringBuffer();
    buffer.writeln('MY GRATITUDE JOURNEY');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (var note in notes) {
      buffer.writeln('Date: ${DateFormat('EEEE, MMMM d, yyyy').format(note.date)}');
      buffer.writeln('---');
      buffer.writeln('1. ${note.note1}');
      buffer.writeln('2. ${note.note2}');
      buffer.writeln('3. ${note.note3}');
      buffer.writeln();
      buffer.writeln('=' * 50);
      buffer.writeln();
    }

    // Save to file
    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final path = '${directory.path}/gratitude_notes_$timestamp.txt';
    final file = File(path);
    await file.writeAsString(buffer.toString());

    // Share the file
    await Share.shareXFiles(
      [XFile(path)],
      subject: 'My Gratitude Notes',
      text: 'Sharing my gratitude journey!',
    );
  }

  static Future<void> shareNote(GratitudeNote note) async {
    final text = '''
Date: ${DateFormat('EEEE, MMMM d, yyyy').format(note.date)}

Today I'm grateful for:
1. ${note.note1}
2. ${note.note2}
3. ${note.note3}

#GratitudeNotes #Thankful
''';

    await Share.share(text, subject: 'My Gratitude for Today');
  }
}
