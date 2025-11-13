import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/gratitude_note.dart';
import '../providers/gratitude_provider.dart';

class AddNotePage extends ConsumerStatefulWidget {
  final GratitudeNote? existingNote;

  const AddNotePage({super.key, this.existingNote});

  @override
  ConsumerState<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends ConsumerState<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _note1Controller;
  late TextEditingController _note2Controller;
  late TextEditingController _note3Controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _note1Controller = TextEditingController(text: widget.existingNote?.note1 ?? '');
    _note2Controller = TextEditingController(text: widget.existingNote?.note2 ?? '');
    _note3Controller = TextEditingController(text: widget.existingNote?.note3 ?? '');
  }

  @override
  void dispose() {
    _note1Controller.dispose();
    _note2Controller.dispose();
    _note3Controller.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(gratitudeRepositoryProvider);
      final today = DateTime.now();
      final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final note = GratitudeNote(
        id: todayKey,
        date: DateTime(today.year, today.month, today.day),
        note1: _note1Controller.text.trim(),
        note2: _note2Controller.text.trim(),
        note3: _note3Controller.text.trim(),
        createdAt: widget.existingNote?.createdAt ?? DateTime.now(),
        updatedAt: widget.existingNote != null ? DateTime.now() : null,
      );

      await repository.saveNote(note);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gratitude notes saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving notes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingNote != null ? 'Edit Gratitude' : 'Add Gratitude'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dateFormat.format(today),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'What are you grateful for today?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Write down 3 things you\'re thankful for',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildNoteField(
              controller: _note1Controller,
              label: 'First Gratitude',
              number: 1,
              hint: 'I am grateful for...',
            ),
            const SizedBox(height: 16),
            _buildNoteField(
              controller: _note2Controller,
              label: 'Second Gratitude',
              number: 2,
              hint: 'I am thankful for...',
            ),
            const SizedBox(height: 16),
            _buildNoteField(
              controller: _note3Controller,
              label: 'Third Gratitude',
              number: 3,
              hint: 'I appreciate...',
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveNote,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check),
              label: Text(_isSaving ? 'Saving...' : 'Save Gratitude'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteField({
    required TextEditingController controller,
    required String label,
    required int number,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your gratitude';
            }
            if (value.trim().length < 3) {
              return 'Please enter at least 3 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}
