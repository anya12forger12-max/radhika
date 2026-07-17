import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/providers/auth_provider.dart';
import 'package:radhika/providers/cycle_provider.dart';

class LogSymptomScreen extends ConsumerStatefulWidget {
  const LogSymptomScreen({super.key});

  @override
  ConsumerState<LogSymptomScreen> createState() => _LogSymptomScreenState();
}

class _LogSymptomScreenState extends ConsumerState<LogSymptomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  double _painLevel = 0;
  Mood _mood = Mood.neutral;
  Set<Symptom> _selectedSymptoms = {};
  bool _isLoading = false;

  final _symptomLabels = {
    Symptom.headache: 'Headache',
    Symptom.nausea: 'Nausea',
    Symptom.acne: 'Acne',
    Symptom.moodSwings: 'Mood Swings',
    Symptom.anxiety: 'Anxiety',
    Symptom.depression: 'Depression',
    Symptom.fatigue: 'Fatigue',
    Symptom.breastTenderness: 'Breast Tenderness',
    Symptom.backPain: 'Back Pain',
    Symptom.cramps: 'Cramps',
    Symptom.bloating: 'Bloating',
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _moodEmoji(Mood mood) {
    switch (mood) {
      case Mood.veryBad:
        return '\u{1F629}';
      case Mood.bad:
        return '\u{1F61E}';
      case Mood.neutral:
        return '\u{1F610}';
      case Mood.good:
        return '\u{1F60A}';
      case Mood.veryGood:
        return '\u{1F929}';
    }
  }

  String _moodLabel(Mood mood) {
    switch (mood) {
      case Mood.veryBad:
        return 'Very Bad';
      case Mood.bad:
        return 'Bad';
      case Mood.neutral:
        return 'Neutral';
      case Mood.good:
        return 'Good';
      case Mood.veryGood:
        return 'Very Good';
    }
  }

  String _painEmoji(double level) {
    final l = level.round();
    switch (l) {
      case 0:
        return '\u{1F60C}';
      case 1:
        return '\u{1F615}';
      case 2:
        return '\u{1F641}';
      case 3:
        return '\u{1F630}';
      case 4:
        return '\u{1F62D}';
      case 5:
        return '\u{1F922}';
      default:
        return '\u{1F610}';
    }
  }

  String _painLabel(double level) {
    final l = level.round();
    switch (l) {
      case 0:
        return 'None';
      case 1:
        return 'Mild';
      case 2:
        return 'Moderate';
      case 3:
        return 'Significant';
      case 4:
        return 'Severe';
      case 5:
        return 'Very Severe';
      default:
        return '';
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      helpText: 'Select date',
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(authProvider);
    final user = authState.user.value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to log symptoms')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(cycleProvider.notifier).addCycleEntry(
            startDate: _selectedDate,
            endDate: _selectedDate,
            painLevel: _painLevel.round(),
            mood: _mood,
            symptoms: _selectedSymptoms.toList(),
            notes: _notesController.text.trim(),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Symptoms logged successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Symptoms'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionLabel(text: 'Date'),
                  const SizedBox(height: 8),
                  Semantics(
                    label:
                        'Date: ${DateFormat('MMM d, yyyy').format(_selectedDate)}. Tap to change',
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('MMM d, yyyy').format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Pain Level'),
                  const SizedBox(height: 4),
                  Semantics(
                    label:
                        'Pain level ${_painLevel.round()} out of 5, ${_painLabel(_painLevel)}',
                    child: Column(
                      children: [
                        Text(
                          '${_painEmoji(_painLevel)} ${_painLabel(_painLevel)}',
                          style: theme.textTheme.titleLarge,
                        ),
                        Slider(
                          value: _painLevel,
                          min: 0,
                          max: 5,
                          divisions: 5,
                          label: _painLevel.round().toString(),
                          onChanged: (v) =>
                              setState(() => _painLevel = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Symptoms'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Symptom.values.map((symptom) {
                      final selected = _selectedSymptoms.contains(symptom);
                      return Semantics(
                        label:
                            'Symptom: ${_symptomLabels[symptom]}${selected ? ', selected' : ''}',
                        child: FilterChip(
                          selected: selected,
                          label: Text(_symptomLabels[symptom]!),
                          onSelected: (v) {
                            setState(() {
                              if (v) {
                                _selectedSymptoms.add(symptom);
                              } else {
                                _selectedSymptoms.remove(symptom);
                              }
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Mood'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Mood.values.map((mood) {
                      final selected = _mood == mood;
                      return Semantics(
                        label:
                            'Mood: ${_moodLabel(mood)}${selected ? ', selected' : ''}',
                        child: ChoiceChip(
                          selected: selected,
                          label: Text(
                              '${_moodEmoji(mood)} ${_moodLabel(mood)}'),
                          onSelected: (_) =>
                              setState(() => _mood = mood),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Notes'),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Additional notes text field',
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      maxLength: 1000,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add any additional notes...',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Semantics(
                    label: 'Save symptom entry',
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _save,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isLoading ? 'Saving...' : 'Save'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
