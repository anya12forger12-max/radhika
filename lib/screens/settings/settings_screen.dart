import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/core/theme/app_tokens.dart';
import 'package:radhika/providers/auth_provider.dart';
import 'package:radhika/providers/cycle_provider.dart';
import 'package:radhika/providers/theme_provider.dart';
import 'package:radhika/services/notification_service.dart';
import 'package:radhika/services/storage_service.dart';
import 'package:radhika/screens/settings/privacy_policy_screen.dart';
import 'package:radhika/widgets/core.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);
  bool _reminder3Days = false;
  bool _reminder2Days = false;
  bool _reminder1Day = true;
  bool _reminderToday = false;
  late Future<String> _versionFuture;

  @override
  void initState() {
    super.initState();
    _versionFuture = _loadVersion();
    final userId = ref.read(authProvider).user.value?.uid;
    if (userId != null) {
      final prefs =
          ref.read(storageServiceProvider).getReminderPreferences(userId);
      _reminder3Days = prefs.remind3DaysBefore;
      _reminder2Days = prefs.remind2DaysBefore;
      _reminder1Day = prefs.remind1DayBefore;
      _reminderToday = prefs.remindDayOf;
    }
  }

  Future<String> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version.trim();
      final buildNumber = info.buildNumber.trim();
      if (version.isEmpty) {
        return AppConstants.appVersion;
      }
      return buildNumber.isEmpty ? version : '$version+$buildNumber';
    } on Object {
      return AppConstants.appVersion;
    }
  }

  Future<void> _exportData() async {
    final authState = ref.read(authProvider);
    final user = authState.user.value;
    if (user == null) return;

    final storageService = ref.read(storageServiceProvider);
    final json = await storageService.exportData(user.uid);
    try {
      await Share.share(json, subject: 'Radhika Data Export');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to share')),
        );
      }
    }
  }

  Future<void> _deleteAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'This will permanently delete all your cycle data, predictions, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final authState = ref.read(authProvider);
      final user = authState.user.value;
      if (user != null) {
        final storageService = ref.read(storageServiceProvider);
        await storageService.clearUserData(user.uid);
        ref.invalidate(cycleProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All data deleted')),
          );
        }
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).deleteAccount();
      if (!mounted) return;
      final error = ref.read(authProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).signOut();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    if (time != null) {
      setState(() => _notificationTime = time);
    }
  }

  Future<void> _syncReminders() async {
    final prefs = ReminderPreferences(
      remind3DaysBefore: _reminder3Days,
      remind2DaysBefore: _reminder2Days,
      remind1DayBefore: _reminder1Day,
      remindDayOf: _reminderToday,
    );
    final userId = ref.read(authProvider).user.value?.uid;
    try {
      if (userId != null) {
        await ref
            .read(storageServiceProvider)
            .saveReminderPreferences(userId, prefs);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to persist reminder preferences: $e');
    }
    if (prefs.anyEnabled) {
      try {
        final granted =
            await NotificationService.instance.requestPermissions();
        if (!granted && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Notification permission is denied. Reminders will not be '
                'delivered until you enable notifications for Radhika.',
              ),
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Failed to request notification permissions: $e');
      }
    }
    final prediction = ref.read(cycleProvider).currentPrediction;
    if (prediction == null) return;
    try {
      await NotificationService.instance.reschedulePeriodReminders(
        prefs: prefs,
        predictedDate: prediction.predictedStartDate,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to reschedule reminders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeState = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.screenPadding),
        children: [
          const AppSectionHeader(title: 'Appearance'),
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: 'Theme selector',
                    child: SegmentedButton<ThemeModeSetting>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeModeSetting.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode),
                        ),
                        ButtonSegment(
                          value: ThemeModeSetting.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode),
                        ),
                        ButtonSegment(
                          value: ThemeModeSetting.system,
                          label: Text('System'),
                          icon: Icon(Icons.settings_brightness),
                        ),
                      ],
                      selected: {themeState.setting},
                      onSelectionChanged: (selected) {
                        ref.read(themeProvider.notifier).setThemeMode(selected.first);
                      },
                      showSelectedIcon: false,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spaceXl),
                  Semantics(
                    label: 'Font size slider',
                    child: Row(
                      children: [
                        const Icon(Icons.text_fields, size: AppTokens.iconMd),
                        Expanded(
                          child: Slider(
                            value: themeState.fontSize,
                            min: 0.8,
                            max: 1.5,
                            divisions: 7,
                            label: '${(themeState.fontSize * 100).round()}%',
                            onChanged: (value) {
                              ref.read(themeProvider.notifier).setFontSize(value);
                            },
                          ),
                        ),
                        const Icon(Icons.text_fields, size: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTokens.sectionGap),
          const AppSectionHeader(title: 'Notifications'),
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.cardPadding),
              child: Column(
                children: [
                  AppToggleButton(
                    label: '3 days before',
                    value: _reminder3Days,
                    onChanged: (v) {
                      setState(() => _reminder3Days = v);
                      _syncReminders();
                    },
                  ),
                  const Divider(height: 1),
                  AppToggleButton(
                    label: '2 days before',
                    value: _reminder2Days,
                    onChanged: (v) {
                      setState(() => _reminder2Days = v);
                      _syncReminders();
                    },
                  ),
                  const Divider(height: 1),
                  AppToggleButton(
                    label: '1 day before',
                    value: _reminder1Day,
                    onChanged: (v) {
                      setState(() => _reminder1Day = v);
                      _syncReminders();
                    },
                  ),
                  const Divider(height: 1),
                  AppToggleButton(
                    label: 'Day of period',
                    value: _reminderToday,
                    onChanged: (v) {
                      setState(() => _reminderToday = v);
                      _syncReminders();
                    },
                  ),
                  const Divider(height: 1),
                  Semantics(
                    label: 'Notification time picker',
                    child: ListTile(
                      title: const Text('Notification time'),
                      trailing: Text(
                        _notificationTime.format(context),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTokens.sectionGap),
          const AppSectionHeader(title: 'Data'),
          AppCard(
            child: Column(
              children: [
                Semantics(
                  label: 'Export data button',
                  child: ListTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: const Text('Export Data'),
                    subtitle: const Text('Share your data as JSON'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _exportData,
                  ),
                ),
                const Divider(height: 1),
                Semantics(
                  label: 'Delete all data button',
                  child: ListTile(
                    leading: Icon(Icons.delete_sweep_outlined, color: colors.error),
                    title: Text('Delete All Data', style: TextStyle(color: colors.error)),
                    subtitle: const Text('Remove all local data'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _deleteAllData,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTokens.sectionGap),
          const AppSectionHeader(title: 'Account'),
          AppCard(
            child: Column(
              children: [
                Semantics(
                  label: 'Privacy Policy button',
                  child: ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const PrivacyPolicyScreen(isRequired: false),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Semantics(
                  label: 'Delete account button',
                  child: ListTile(
                    leading: Icon(Icons.person_remove_outlined, color: colors.error),
                    title: Text('Delete Account', style: TextStyle(color: colors.error)),
                    subtitle: const Text('Permanently remove your account'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _deleteAccount,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTokens.sectionGap),
          const AppSectionHeader(title: 'About'),
          AppCard(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('App Name'),
                  trailing: Text(AppConstants.appName),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.tag),
                  title: const Text('Version'),
                  trailing: FutureBuilder<String>(
                    future: _versionFuture,
                    builder: (context, snapshot) {
                      return Text(snapshot.data ?? AppConstants.appVersion);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTokens.spaceXl),
          Semantics(
            label: 'Logout button',
            child: AppDestructiveButton(
              label: 'Logout',
              onPressed: authState.isLoading ? null : _logout,
              isLoading: authState.isLoading,
              semanticLabel: 'Logout button',
            ),
          ),
          const SizedBox(height: AppTokens.space3xl),
        ],
      ),
    );
  }
}