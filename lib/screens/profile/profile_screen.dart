import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _cycleLengthController;
  late final TextEditingController _periodLengthController;
  late final TextEditingController _medicalConditionsController;
  late final TextEditingController _medicationsController;
  DateTime? _lastPeriodStart;
  bool _isPregnant = false;
  bool _isMenopause = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(authProvider).profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _ageController = TextEditingController(text: profile?.age.toString() ?? '');
    _heightController = TextEditingController(
      text: profile?.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: profile?.weight?.toString() ?? '',
    );
    _cycleLengthController = TextEditingController(
      text: profile?.averageCycleLength.toString() ?? '28',
    );
    _periodLengthController = TextEditingController(
      text: profile?.averagePeriodLength.toString() ?? '5',
    );
    _medicalConditionsController = TextEditingController(
      text: (profile?.medicalConditions ?? []).join('\n'),
    );
    _medicationsController = TextEditingController(
      text: (profile?.medications ?? []).join('\n'),
    );
    _lastPeriodStart = profile?.lastPeriodStart;
    _isPregnant = profile?.isPregnant ?? false;
    _isMenopause = profile?.isMenopause ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _cycleLengthController.dispose();
    _periodLengthController.dispose();
    _medicalConditionsController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final authState = ref.read(authProvider);
      final user = authState.user.value;
      if (user == null) return;

      final profile = authState.profile!;
      final updated = profile.copyWith(
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 25,
        height: double.tryParse(_heightController.text.trim()),
        weight: double.tryParse(_weightController.text.trim()),
        averageCycleLength: int.tryParse(_cycleLengthController.text.trim()) ?? 28,
        averagePeriodLength: int.tryParse(_periodLengthController.text.trim()) ?? 5,
        lastPeriodStart: _lastPeriodStart,
        isPregnant: _isPregnant,
        isMenopause: _isMenopause,
        medicalConditions: _medicalConditionsController.text
            .split('\n')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        medications: _medicationsController.text
            .split('\n')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
      );
      await ref.read(authProvider.notifier).updateProfile(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _lastPeriodStart ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _lastPeriodStart = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Personal Information',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildField(
                      label: 'Name',
                      controller: _nameController,
                      icon: Icons.person_outline,
                      explanation: 'Used to personalize your experience',
                      validator: (v) =>
                          v?.trim().isEmpty == true ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Age',
                      controller: _ageController,
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                      explanation: 'Helps calculate accurate cycle predictions based on age-related patterns',
                      validator: (v) {
                        final age = int.tryParse(v?.trim() ?? '');
                        if (age == null || age < AppConstants.minAge || age > AppConstants.maxAge) {
                          return 'Age must be ${AppConstants.minAge}-${AppConstants.maxAge}';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Height (cm, optional)',
                      controller: _heightController,
                      icon: Icons.straighten,
                      keyboardType: TextInputType.number,
                      explanation: 'Used for general health insights and BMI calculation',
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Weight (kg, optional)',
                      controller: _weightController,
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: TextInputType.number,
                      explanation: 'Used for general health insights and BMI calculation',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Cycle Information',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildField(
                      label: 'Average cycle length (days)',
                      controller: _cycleLengthController,
                      icon: Icons.loop,
                      keyboardType: TextInputType.number,
                      explanation: 'Used to predict your next period and fertile window',
                      validator: (v) {
                        final val = int.tryParse(v?.trim() ?? '');
                        if (val == null || val < AppConstants.minCycleLength || val > AppConstants.maxCycleLength) {
                          return 'Must be ${AppConstants.minCycleLength}-${AppConstants.maxCycleLength} days';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Average period length (days)',
                      controller: _periodLengthController,
                      icon: Icons.calendar_month,
                      keyboardType: TextInputType.number,
                      explanation: 'Used to predict period duration for upcoming cycles',
                      validator: (v) {
                        final val = int.tryParse(v?.trim() ?? '');
                        if (val == null || val < AppConstants.minPeriodLength || val > AppConstants.maxPeriodLength) {
                          return 'Must be ${AppConstants.minPeriodLength}-${AppConstants.maxPeriodLength} days';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      label: 'Last period start date picker',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Last period start date',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.edit_calendar),
                          ),
                          child: Text(
                            _lastPeriodStart != null
                                ? DateFormat.yMMMd().format(_lastPeriodStart!)
                                : 'Not set',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4),
                      child: Text(
                        'Helps calculate your next predicted period date',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Health Status',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Semantics(
                      label: 'Pregnancy status toggle',
                      child: SwitchListTile(
                        title: const Text('Pregnant'),
                        subtitle: const Text('Adjusts predictions to account for pregnancy'),
                        value: _isPregnant,
                        onChanged: (v) {
                          setState(() {
                            _isPregnant = v;
                            if (v) _isMenopause = false;
                          });
                        },
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Semantics(
                      label: 'Menopause status toggle',
                      child: SwitchListTile(
                        title: const Text('Menopause'),
                        subtitle: const Text('Indicates cycle patterns may no longer apply'),
                        value: _isMenopause,
                        onChanged: (v) {
                          setState(() {
                            _isMenopause = v;
                            if (v) _isPregnant = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Medical Information',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMultiLineField(
                      label: 'Medical conditions',
                      controller: _medicalConditionsController,
                      icon: Icons.medical_information_outlined,
                      explanation: 'Optional: Helps provide relevant health insights (one per line)',
                    ),
                    const SizedBox(height: 16),
                    _buildMultiLineField(
                      label: 'Medications',
                      controller: _medicationsController,
                      icon: Icons.medication_outlined,
                      explanation: 'Optional: Some medications may affect cycle patterns (one per line)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Semantics(
              label: 'Save profile button',
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Profile'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? explanation,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: '$label input field',
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              border: const OutlineInputBorder(),
            ),
            validator: validator,
          ),
        ),
        if (explanation != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              explanation,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMultiLineField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? explanation,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: '$label input field',
          child: TextFormField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Icon(icon),
              ),
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ),
        if (explanation != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              explanation,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
