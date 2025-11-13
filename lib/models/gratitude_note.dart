import 'package:hive/hive.dart';

part 'gratitude_note.g.dart';

@HiveType(typeId: 0)
class GratitudeNote extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String note1;

  @HiveField(3)
  final String note2;

  @HiveField(4)
  final String note3;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  GratitudeNote({
    required this.id,
    required this.date,
    required this.note1,
    required this.note2,
    required this.note3,
    required this.createdAt,
    this.updatedAt,
  });

  GratitudeNote copyWith({
    String? id,
    DateTime? date,
    String? note1,
    String? note2,
    String? note3,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GratitudeNote(
      id: id ?? this.id,
      date: date ?? this.date,
      note1: note1 ?? this.note1,
      note2: note2 ?? this.note2,
      note3: note3 ?? this.note3,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isComplete => note1.isNotEmpty && note2.isNotEmpty && note3.isNotEmpty;

  String toDateString() {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
