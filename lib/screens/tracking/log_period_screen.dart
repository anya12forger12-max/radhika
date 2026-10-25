import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radhika/core/theme/app_tokens.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/providers/auth_provider.dart';
import 'package:radhika/providers/cycle_provider.dart';
import 'package:radhika/widgets/core.dart';

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
  final Set<Symptom> _selectedSymptoms = {};
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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: child!,
      ),
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
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Period'),
        centerTitle: true,
      ),
      body: AppLoadingOverlay(
        isLoading: _isLoading,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppTokens.screenPadding),
            children: [
              AppSectionLabel(text: 'Dates'),
              const SizedBox(height: AppTokens.spaceSm),
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
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Flow Intensity'),
              const SizedBox(height: AppTokens.spaceSm),
              Wrap(
                spacing: AppTokens.cardGap,
                runSpacing: AppTokens.cardGap,
                children: FlowIntensity.values.map((flow) {
                  final selected = _flowIntensity == flow;
                  return Semantics(
                    label: 'Flow intensity: ${_flowLabel(flow)}${selected ? ', selected' : ''}',
                    child: AppFilterChip(
                      label: _flowLabel(flow),
                      selected: selected,
                      onSelected: (_) => setState(() => _flowIntensity = flow),
                      avatar: Icon(_flowIcon(flow), size: AppTokens.iconSm),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Spotting'),
              const SizedBox(height: AppTokens.spaceXs),
              Semantics(
                label: 'Spotting toggle, ${_spotting ? 'on' : 'off'}',
                child: AppToggleButton(
                  label: 'Spotting',
                  value: _spotting,
                  onChanged: (v) => setState(() => _spotting = v),
                  subtitle: _spotting ? 'You are experiencing spotting' : 'No spotting',
                ),
              ),
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Pain Level'),
              const SizedBox(height: AppTokens.spaceXs),
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
                      onChanged: (v) => setState(() => _painLevel = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Mood'),
              const SizedBox(height: AppTokens.spaceSm),
              Wrap(
                spacing: AppTokens.cardGap,
                runSpacing: AppTokens.cardGap,
                children: Mood.values.map((mood) {
                  final selected = _mood == mood;
                  return Semantics(
                    label: 'Mood: ${_moodLabel(mood)}${selected ? ', selected' : ''}',
                    child: AppChoiceChip(
                      label: '${_moodEmoji(mood)} ${_moodLabel(mood)}',
                      selected: selected,
                      onSelected: (_) => setState(() => _mood = mood),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Energy Level'),
              const SizedBox(height: AppTokens.spaceXs),
              Semantics(
                label: 'Energy level ${_energyLevel.round()} out of 5',
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
                        onChanged: (v) => setState(() => _energyLevel = v),
                      ),
                    ),
                    const Text('\u{26A1}'),
                  ],
                ),
              ),
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Sleep Hours'),
              const SizedBox(height: AppTokens.spaceSm),
              Semantics(
                label: 'Sleep hours: $_sleepHours hours',
                child: AppDropdownField<int>(
                  label: 'Sleep Hours',
                  items: List.generate(
                    12,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1} ${i == 0 ? 'hour' : 'hours'}'),
                    ),
                  ),
                  value: _sleepHours,
                  onChanged: (v) {
                    if (v != null) setState(() => _sleepHours = v);
                  },
                ),
              ),
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Exercise'),
              const SizedBox(height: AppTokens.spaceXs),
              Semantics(
                label: 'Exercise toggle, ${_exercise ? 'on' : 'off'}',
                child: AppToggleButton(
                  label: 'Exercise Today',
                  value: _exercise,
                  onChanged: (v) => setState(() => _exercise = v),
                  subtitle: _exercise ? 'You exercised today' : 'No exercise logged',
                ),
              ),
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Water Intake'),
              const SizedBox(height: AppTokens.spaceXs),
              Semantics(
                label: 'Water intake ${_waterIntake.round()} glasses',
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, size: AppTokens.iconMd),
                    Expanded(
                      child: Slider(
                        value: _waterIntake,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: '${_waterIntake.round()} glasses',
                        onChanged: (v) => setState(() => _waterIntake = v),
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
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Symptoms'),
              const SizedBox(height: AppTokens.spaceSm),
              Wrap(
                spacing: AppTokens.cardGap,
                runSpacing: AppTokens.cardGap,
                children: Symptom.values.map((symptom) {
                  final selected = _selectedSymptoms.contains(symptom);
                  return Semantics(
                    label: 'Symptom: ${_symptomLabels[symptom]}, selected: $selected',
                    child: AppFilterChip(
                      label: _symptomLabels[symptom]!,
                      selected: selected,
                      onSelected: (v) {
                        setState(() {
                          if (v) {
                            _selectedSymptoms.add(symptom);
                          } else {
                            _selectedSymptoms.remove(symptom);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTokens.sectionGap),

              AppSectionLabel(text: 'Notes'),
              const SizedBox(height: AppTokens.spaceSm),
              Semantics(
                label: 'Additional notes text field',
                child: AppMultiLineField(
                  label: 'Notes',
                  controller: _notesController,
                  maxLines: 4,
                  maxLength: 1000,
                  hint: 'Add any additional notes...',
                ),
              ),
              const SizedBox(height: AppTokens.space3xl),

              AppPrimaryButton(
                label: _isLoading ? 'Saving...' : 'Save',
                onPressed: _isLoading ? null : _save,
                isLoading: _isLoading,
                icon: _isLoading ? null : const Icon(Icons.save),
              ),
              const SizedBox(height: AppTokens.spaceMd),
            ],
          ),
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
      header: true,
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
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
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
            const SizedBox(width: AppTokens.cardGap),
            Expanded(
              child: Semantics(
                label: isOngoing
                    ? 'Still ongoing'
                    : 'End date: ${endDate != null ? dateFormat.format(endDate!) : "Not set"}. Tap to change',
                child: InkWell(
                  onTap: isOngoing ? null : onPickEnd,
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
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
        const SizedBox(height: AppTokens.spaceSm),
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