import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/providers/auth_provider.dart';
import 'package:radhika/providers/cycle_provider.dart';

class LogPeriodScreen extends ConsumerStatefulWidget {
  const LogPeriodScreen({super.key});

  @override
  ConsumerState<LogPeriodScreen> createState() => _LogPeriodScreenState();
}

class _LogPeriodScreenState extends ConsumerState<LogPeriodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  FlowIntensity _flowIntensity = FlowIntensity.medium;
  bool _spotting = false;
  double _painLevel = 0;
  Mood _mood = Mood.neutral;
  double _energyLevel = 3;
  int _sleepHours = 7;
  bool _exercise = false;
  double _waterIntake = 4;
  Set<Symptom> _selectedSymptoms = {};
  bool _isLoading = false;
  bool _isOngoing = true;

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

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : (_endDate ?? _startDate),
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      helpText: isStart ? 'Select start date' : 'Select end date',
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_isOngoing) {
            _endDate = picked;
          } else if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = picked;
          }
        } else {
          if (picked.isBefore(_startDate)) {
            _endDate = _startDate;
          } else {
            _endDate = picked;
          }
        }
      });
    }
  }

  String _flowLabel(FlowIntensity intensity) {
    switch (intensity) {
      case FlowIntensity.veryLight:
        return 'Very Light';
      case FlowIntensity.light:
        return 'Light';
      case FlowIntensity.medium:
        return 'Medium';
      case FlowIntensity.heavy:
        return 'Heavy';
      case FlowIntensity.veryHeavy:
        return 'Very Heavy';
    }
  }

  IconData _flowIcon(FlowIntensity intensity) {
    switch (intensity) {
      case FlowIntensity.veryLight:
        return Icons.water_drop_outlined;
      case FlowIntensity.light:
        return Icons.water_drop;
      case FlowIntensity.medium:
        return Icons.opacity;
      case FlowIntensity.heavy:
        return Icons.thunderstorm_outlined;
      case FlowIntensity.veryHeavy:
        return Icons.thunderstorm;
    }
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(authProvider);
    final user = authState.user.value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to log data')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(cycleProvider.notifier).addCycleEntry(
            startDate: _startDate,
            endDate: _isOngoing ? _startDate : _endDate,
            flowIntensity: _flowIntensity,
            spotting: _spotting,
            painLevel: _painLevel.round(),
            mood: _mood,
            energyLevel: _energyLevel.round(),
            sleepHours: _sleepHours,
            exercise: _exercise,
            waterIntake: _waterIntake.round(),
            symptoms: _selectedSymptoms.toList(),
            notes: _notesController.text.trim(),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Period logged successfully')),
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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Period'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionLabel(text: 'Dates'),
                  const SizedBox(height: 8),
                  _DateRow(
                    startDate: _startDate,
                    endDate: _isOngoing ? null : _endDate,
                    isOngoing: _isOngoing,
                    onPickStart: () => _pickDate(isStart: true),
                    onPickEnd: () => _pickDate(isStart: false),
                    onToggleOngoing: (v) => setState(() {
                      _isOngoing = v;
                      if (v) _endDate = _startDate;
                    }),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Flow Intensity'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: FlowIntensity.values.map((flow) {
                      final selected = _flowIntensity == flow;
                      return Semantics(
                        label:
                            'Flow intensity: ${_flowLabel(flow)}${selected ? ', selected' : ''}',
                        child: FilterChip(
                          selected: selected,
                          label: Text(_flowLabel(flow)),
                          avatar: Icon(
                            _flowIcon(flow),
                            size: 18,
                          ),
                          onSelected: (_) =>
                              setState(() => _flowIntensity = flow),
                          showCheckmark: false,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Spotting'),
                  const SizedBox(height: 4),
                  Semantics(
                    label:
                        'Spotting toggle, ${_spotting ? 'on' : 'off'}',
                    child: SwitchListTile(
                      title: const Text('Spotting'),
                      subtitle: Text(
                        _spotting
                            ? 'You are experiencing spotting'
                            : 'No spotting',
                      ),
                      value: _spotting,
                      onChanged: (v) => setState(() => _spotting = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Pain Level'),
                  const SizedBox(height: 4),
                  Semantics(
                    label: 'Pain level ${_painLevel.round()} out of 5, ${_painLabel(_painLevel)}',
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
                          label: Text('${_moodEmoji(mood)} ${_moodLabel(mood)}'),
                          onSelected: (_) =>
                              setState(() => _mood = mood),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Energy Level'),
                  const SizedBox(height: 4),
                  Semantics(
                    label:
                        'Energy level ${_energyLevel.round()} out of 5',
                    child: Row(
                      children: [
                        const Text('\u{26A0}\u{FE0F}'),
                        Expanded(
                          child: Slider(
                            value: _energyLevel,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: _energyLevel.round().toString(),
                            onChanged: (v) =>
                                setState(() => _energyLevel = v),
                          ),
                        ),
                        const Text('\u{26A1}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Sleep Hours'),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Sleep hours: $_sleepHours hours',
                    child: DropdownButtonFormField<int>(
                      value: _sleepHours,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      items: List.generate(
                        12,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('${i + 1} ${i == 0 ? 'hour' : 'hours'}'),
                        ),
                      ),
                      onChanged: (v) {
                        if (v != null) setState(() => _sleepHours = v);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Exercise'),
                  const SizedBox(height: 4),
                  Semantics(
                    label: 'Exercise toggle, ${_exercise ? 'on' : 'off'}',
                    child: SwitchListTile(
                      title: const Text('Exercise Today'),
                      subtitle: Text(
                        _exercise
                            ? 'You exercised today'
                            : 'No exercise logged',
                      ),
                      value: _exercise,
                      onChanged: (v) => setState(() => _exercise = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SectionLabel(text: 'Water Intake'),
                  const SizedBox(height: 4),
                  Semantics(
                    label:
                        'Water intake ${_waterIntake.round()} glasses',
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop, size: 20),
                        Expanded(
                          child: Slider(
                            value: _waterIntake,
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: '${_waterIntake.round()} glasses',
                            onChanged: (v) =>
                                setState(() => _waterIntake = v),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${_waterIntake.round()}',
                            textAlign: TextAlign.center,
                          ),
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
                            'Symptom: ${_symptomLabels[symptom]}$selected ? , selected' : ''}',
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
                    label: 'Save period entry',
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _save,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
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

class _DateRow extends StatelessWidget {
  final DateTime startDate;
  final DateTime? endDate;
  final bool isOngoing;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final ValueChanged<bool> onToggleOngoing;

  const _DateRow({
    required this.startDate,
    this.endDate,
    required this.isOngoing,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onToggleOngoing,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                label: 'Start date: ${dateFormat.format(startDate)}. Tap to change',
                child: InkWell(
                  onTap: onPickStart,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(dateFormat.format(startDate)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Semantics(
                label: isOngoing
                    ? 'Still ongoing'
                    : 'End date: ${endDate != null ? dateFormat.format(endDate!) : "Not set"}. Tap to change',
                child: InkWell(
                  onTap: isOngoing ? null : onPickEnd,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_today),
                      enabled: !isOngoing,
                    ),
                    child: Text(
                      isOngoing ? 'Ongoing' : dateFormat.format(endDate ?? startDate),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Period still ongoing toggle, ${isOngoing ? 'on' : 'off'}',
          child: Row(
            children: [
              const Text('Still ongoing'),
              Switch(
                value: isOngoing,
                onChanged: onToggleOngoing,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
